"""
Güvenli EV Batarya Veri API'si
Elektrikli araç batarya verilerini güvenli bir şekilde yöneten web uygulaması
"""

from fastapi import FastAPI, Depends, HTTPException, status, Request
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from fastapi.middleware.trustedhost import TrustedHostMiddleware
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded
import jwt
from datetime import datetime, timedelta
from typing import Optional, List, Dict
import csv
import os
from passlib.context import CryptContext
from pydantic import BaseModel, validator
import re
import logging
from cryptography.fernet import Fernet
import json
import secrets

# Güvenlik yapılandırması
SECRET_KEY = os.getenv("SECRET_KEY", secrets.token_urlsafe(32))
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
ENCRYPTION_KEY = os.getenv("ENCRYPTION_KEY", Fernet.generate_key())

# Şifreleme objesi
fernet = Fernet(ENCRYPTION_KEY)

# Logging yapılandırması - Güvenlik olaylarını kaydet
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('security.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# Şifre hashleme
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Rate limiter - DDoS koruması
limiter = Limiter(key_func=get_remote_address)
app = FastAPI(
    title="EV Battery Data API",
    description="Güvenli Elektrikli Araç Batarya Veri API'si",
    version="1.0.0"
)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# CORS güvenlik ayarları
app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://yourdomain.com"],  # Sadece güvenilir domain'ler
    allow_credentials=True,
    allow_methods=["GET", "POST"],  # Sadece gerekli methodlar
    allow_headers=["Authorization", "Content-Type"],
    max_age=600,
)

# Host güvenliği
app.add_middleware(
    TrustedHostMiddleware, 
    allowed_hosts=["localhost", "127.0.0.1", "*.yourdomain.com"]
)

# Güvenlik başlıkları middleware
@app.middleware("http")
async def add_security_headers(request: Request, call_next):
    response = await call_next(request)
    response.headers["X-Content-Type-Options"] = "nosniff"
    response.headers["X-Frame-Options"] = "DENY"
    response.headers["X-XSS-Protection"] = "1; mode=block"
    response.headers["Strict-Transport-Security"] = "max-age=31536000; includeSubDomains"
    response.headers["Content-Security-Policy"] = "default-src 'self'"
    response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
    response.headers["Permissions-Policy"] = "geolocation=(), microphone=(), camera=()"
    return response

# Şüpheli aktivite izleme
@app.middleware("http")
async def log_suspicious_activity(request: Request, call_next):
    client_ip = request.client.host
    user_agent = request.headers.get("user-agent", "unknown")
    
    # Şüpheli patternleri kontrol et
    suspicious_patterns = [
        r"<script", r"javascript:", r"onerror=", r"onload=",
        r"\.\.\/", r"union.*select", r"drop.*table"
    ]
    
    request_str = str(request.url) + str(request.headers)
    for pattern in suspicious_patterns:
        if re.search(pattern, request_str, re.IGNORECASE):
            logger.warning(f"Suspicious activity detected from {client_ip}: {pattern}")
            logger.warning(f"User-Agent: {user_agent}")
            logger.warning(f"URL: {request.url}")
    
    response = await call_next(request)
    return response

# Pydantic modelleri - Input validation
class UserLogin(BaseModel):
    username: str
    password: str
    
    @validator('username')
    def validate_username(cls, v):
        if not re.match(r'^[a-zA-Z0-9_]{3,20}$', v):
            raise ValueError('Geçersiz kullanıcı adı formatı')
        return v
    
    @validator('password')
    def validate_password(cls, v):
        if len(v) < 8:
            raise ValueError('Şifre en az 8 karakter olmalı')
        if not re.search(r'[A-Z]', v):
            raise ValueError('Şifre en az bir büyük harf içermeli')
        if not re.search(r'[a-z]', v):
            raise ValueError('Şifre en az bir küçük harf içermeli')
        if not re.search(r'[0-9]', v):
            raise ValueError('Şifre en az bir rakam içermeli')
        return v

class BatteryDataQuery(BaseModel):
    vehicle_brand: Optional[str] = None
    parameter_name: Optional[str] = None
    
    @validator('vehicle_brand', 'parameter_name')
    def sanitize_input(cls, v):
        if v is not None:
            # XSS ve injection saldırılarını önle
            dangerous_chars = ['<', '>', '"', "'", '\\', ';', '&', '|', '$', '`']
            for char in dangerous_chars:
                if char in v:
                    raise ValueError(f'Geçersiz karakter: {char}')
        return v

# Kullanıcı veritabanı (gerçek uygulamada veritabanı kullanın)
users_db = {
    "admin": {
        "username": "admin",
        "hashed_password": pwd_context.hash("Admin123!"),
        "role": "admin"
    }
}

# HTTP Bearer token
security = HTTPBearer()

def create_access_token(data: dict):
    """JWT token oluştur"""
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

def verify_token(credentials: HTTPAuthorizationCredentials = Depends(security)):
    """JWT token doğrula"""
    try:
        token = credentials.credentials
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str = payload.get("sub")
        if username is None:
            logger.warning("Token doğrulama başarısız: username yok")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Geçersiz kimlik bilgileri"
            )
        return username
    except jwt.ExpiredSignatureError:
        logger.warning("Token süresi dolmuş")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token süresi dolmuş"
        )
    except jwt.JWTError:
        logger.warning("Token doğrulama hatası")
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token doğrulama başarısız"
        )

def read_csv_secure():
    """CSV dosyasını güvenli şekilde oku"""
    try:
        csv_path = '/workspace/ev_unified_professional.csv'
        
        # Dosya varlığını kontrol et
        if not os.path.exists(csv_path):
            logger.error(f"CSV dosyası bulunamadı: {csv_path}")
            raise HTTPException(status_code=404, detail="Veri dosyası bulunamadı")
        
        # Dosya izinlerini kontrol et
        if not os.access(csv_path, os.R_OK):
            logger.error(f"CSV dosyası okunamıyor: {csv_path}")
            raise HTTPException(status_code=403, detail="Dosya erişim hatası")
        
        data = []
        with open(csv_path, 'r', encoding='utf-8') as file:
            csv_reader = csv.DictReader(file, delimiter=';')
            for row in csv_reader:
                data.append(row)
        
        logger.info(f"CSV dosyası başarıyla okundu: {len(data)} satır")
        return data
    
    except Exception as e:
        logger.error(f"CSV okuma hatası: {str(e)}")
        raise HTTPException(status_code=500, detail="Veri okuma hatası")

def encrypt_data(data: str) -> str:
    """Veriyi şifrele"""
    return fernet.encrypt(data.encode()).decode()

def decrypt_data(encrypted_data: str) -> str:
    """Şifreli veriyi çöz"""
    return fernet.decrypt(encrypted_data.encode()).decode()

# API Endpoints

@app.get("/")
@limiter.limit("10/minute")
async def root(request: Request):
    """API durumu"""
    return {
        "status": "online",
        "message": "EV Battery Data API - Güvenli",
        "version": "1.0.0"
    }

@app.post("/login")
@limiter.limit("5/minute")  # Brute force koruması
async def login(request: Request, user: UserLogin):
    """Kullanıcı girişi - JWT token al"""
    try:
        # Kullanıcı kontrolü
        if user.username not in users_db:
            logger.warning(f"Başarısız giriş denemesi: {user.username} - Kullanıcı bulunamadı")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Yanlış kullanıcı adı veya şifre"
            )
        
        # Şifre kontrolü
        db_user = users_db[user.username]
        if not pwd_context.verify(user.password, db_user["hashed_password"]):
            logger.warning(f"Başarısız giriş denemesi: {user.username} - Yanlış şifre")
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Yanlış kullanıcı adı veya şifre"
            )
        
        # Token oluştur
        access_token = create_access_token(
            data={"sub": user.username, "role": db_user["role"]}
        )
        
        logger.info(f"Başarılı giriş: {user.username}")
        
        return {
            "access_token": access_token,
            "token_type": "bearer",
            "expires_in": ACCESS_TOKEN_EXPIRE_MINUTES * 60
        }
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Login hatası: {str(e)}")
        raise HTTPException(status_code=500, detail="Giriş işlemi başarısız")

@app.get("/battery-data")
@limiter.limit("20/minute")
async def get_battery_data(
    request: Request,
    username: str = Depends(verify_token),
    vehicle_brand: Optional[str] = None
):
    """Batarya verilerini güvenli şekilde getir"""
    try:
        logger.info(f"Veri isteği - Kullanıcı: {username}, Marka: {vehicle_brand}")
        
        data = read_csv_secure()
        
        # Vehicle brand filtreleme
        if vehicle_brand:
            # Input sanitization
            vehicle_brand = re.sub(r'[^a-zA-Z0-9\s]', '', vehicle_brand)
            filtered_data = [row for row in data if vehicle_brand.lower() in row.get('Name', '').lower()]
            data = filtered_data
        
        logger.info(f"Veri başarıyla sunuldu - {len(data)} kayıt")
        
        return {
            "status": "success",
            "count": len(data),
            "data": data
        }
    
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Veri getirme hatası: {str(e)}")
        raise HTTPException(status_code=500, detail="Veri işleme hatası")

@app.get("/battery-data/encrypted")
@limiter.limit("10/minute")
async def get_encrypted_battery_data(
    request: Request,
    username: str = Depends(verify_token)
):
    """Şifrelenmiş batarya verilerini getir"""
    try:
        logger.info(f"Şifreli veri isteği - Kullanıcı: {username}")
        
        data = read_csv_secure()
        encrypted_data = encrypt_data(json.dumps(data))
        
        logger.info("Şifreli veri başarıyla sunuldu")
        
        return {
            "status": "success",
            "encrypted_data": encrypted_data,
            "note": "Veriyi çözmek için decrypt endpoint'ini kullanın"
        }
    
    except Exception as e:
        logger.error(f"Şifreleme hatası: {str(e)}")
        raise HTTPException(status_code=500, detail="Veri şifreleme hatası")

@app.get("/vehicles")
@limiter.limit("20/minute")
async def get_vehicles(
    request: Request,
    username: str = Depends(verify_token)
):
    """Desteklenen araç listesini getir"""
    try:
        data = read_csv_secure()
        
        # Araç markalarını çıkar
        vehicles = set()
        for row in data:
            name = row.get('Name', '')
            if '===' in name:
                vehicle = name.replace('===', '').strip()
                if vehicle:
                    vehicles.add(vehicle)
        
        return {
            "status": "success",
            "count": len(vehicles),
            "vehicles": sorted(list(vehicles))
        }
    
    except Exception as e:
        logger.error(f"Araç listesi hatası: {str(e)}")
        raise HTTPException(status_code=500, detail="Araç listesi alınamadı")

@app.get("/health")
@limiter.limit("30/minute")
async def health_check(request: Request):
    """Sağlık kontrolü"""
    try:
        # CSV dosyası erişim kontrolü
        csv_exists = os.path.exists('/workspace/ev_unified_professional.csv')
        
        return {
            "status": "healthy" if csv_exists else "degraded",
            "timestamp": datetime.utcnow().isoformat(),
            "csv_accessible": csv_exists
        }
    except Exception as e:
        logger.error(f"Health check hatası: {str(e)}")
        return {
            "status": "unhealthy",
            "error": str(e)
        }

if __name__ == "__main__":
    import uvicorn
    
    # Güvenli SSL/TLS ile başlat (production için)
    # uvicorn.run(
    #     app,
    #     host="0.0.0.0",
    #     port=8443,
    #     ssl_keyfile="./key.pem",
    #     ssl_certfile="./cert.pem"
    # )
    
    # Development için
    logger.info("API başlatılıyor - Development mode")
    uvicorn.run(app, host="127.0.0.1", port=8000)
