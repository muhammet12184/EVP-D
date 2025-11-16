# 🚀 Hızlı Başlangıç Rehberi

## 5 Dakikada Başlayın!

### 1. Bağımlılıkları Yükleyin

```bash
pip install -r requirements.txt
```

### 2. Güvenlik Anahtarlarını Oluşturun

```bash
# SECRET_KEY için
python -c "import secrets; print('SECRET_KEY=' + secrets.token_urlsafe(32))" > .env

# ENCRYPTION_KEY için
python -c "from cryptography.fernet import Fernet; print('ENCRYPTION_KEY=' + Fernet.generate_key().decode())" >> .env
```

### 3. Uygulamayı Başlatın

```bash
python app.py
```

API şu adreste çalışıyor: http://localhost:8000

### 4. İlk Girişinizi Yapın

```bash
curl -X POST "http://localhost:8000/login" \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "Admin123!"
  }'
```

Yanıt:
```json
{
  "access_token": "eyJhbGc...",
  "token_type": "bearer",
  "expires_in": 1800
}
```

### 5. Veri Çekin

```bash
# Token'ı bir değişkene kaydedin
TOKEN="your_access_token_here"

# Batarya verilerini çekin
curl -X GET "http://localhost:8000/battery-data" \
  -H "Authorization: Bearer $TOKEN"
```

## 🐳 Docker ile Başlatma

```bash
# Docker image oluştur
docker-compose build

# Uygulamayı başlat
docker-compose up -d

# Logları izle
docker-compose logs -f
```

## 🔒 HTTPS ile Başlatma (Production)

```bash
# 1. SSL sertifikası oluştur
./generate_ssl_cert.sh

# 2. HTTPS ile başlat
uvicorn app:app --host 0.0.0.0 --port 8443 \
  --ssl-keyfile ./key.pem --ssl-certfile ./cert.pem
```

## 🧪 Güvenlik Testlerini Çalıştırın

```bash
# İlk önce uygulamayı başlatın
python app.py

# Başka bir terminalde testleri çalıştırın
pip install colorama requests
python test_security.py
```

## 📝 API Endpoints

| Endpoint | Method | Auth | Açıklama |
|----------|--------|------|----------|
| `/` | GET | ❌ | API durumu |
| `/login` | POST | ❌ | Kullanıcı girişi |
| `/battery-data` | GET | ✅ | Batarya verileri |
| `/battery-data/encrypted` | GET | ✅ | Şifreli veriler |
| `/vehicles` | GET | ✅ | Araç listesi |
| `/health` | GET | ❌ | Sağlık kontrolü |

## 💡 İpuçları

### Dosya Şifreleme

```python
from file_encryption import backup_and_encrypt_csv

# CSV'yi yedekle ve şifrele
encrypted = backup_and_encrypt_csv('/workspace/ev_unified_professional.csv')
```

### Yeni Kullanıcı Ekle

```python
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
hashed = pwd_context.hash("YeniSifre123!")

# app.py içindeki users_db dict'ine ekleyin:
users_db["yeni_kullanici"] = {
    "username": "yeni_kullanici",
    "hashed_password": hashed,
    "role": "user"
}
```

### API Dokümantasyonu

Otomatik API dokümantasyonu:
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## ⚠️ Önemli Notlar

1. **Varsayılan şifreyi değiştirin!**
   - Kullanıcı: admin
   - Şifre: Admin123!

2. **Production'da mutlaka yapın:**
   - .env dosyasını git'e eklemeyin
   - Güvenilir CA'den SSL sertifikası alın
   - Firewall kurallarını ayarlayın
   - Düzenli backup alın

3. **Performans optimizasyonu:**
   - Production'da Redis kullanın (rate limiting için)
   - PostgreSQL kullanın (kullanıcı yönetimi için)
   - Nginx reverse proxy kullanın

## 🆘 Sorun Giderme

### "ModuleNotFoundError"
```bash
pip install -r requirements.txt
```

### "Port already in use"
```bash
# Portu değiştirin
uvicorn app:app --port 8001
```

### "Permission denied: security.log"
```bash
# Log dizinine yazma izni verin
chmod 755 .
```

### Rate limit'e takıldım
```bash
# 1 dakika bekleyin veya app.py'de limit'i artırın
# @limiter.limit("20/minute") -> @limiter.limit("100/minute")
```

## 📚 Daha Fazla Bilgi

- [README.md](README.md) - Detaylı dokümantasyon
- [SECURITY.md](SECURITY.md) - Güvenlik politikası
- [API Docs](http://localhost:8000/docs) - İnteraktif API dokümantasyonu

## 🤝 Destek

Sorun mu yaşıyorsunuz?
- GitHub Issues
- Email: support@yourdomain.com

---

**Hazırsınız! 🎉**

Uygulama güvenli şekilde çalışıyor. API'yi kullanmaya başlayabilirsiniz!
