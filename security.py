"""
Güvenlik Modülü - Dosya ve Uygulama Güvenliği
Hacker saldırılarına karşı koruma sağlar
"""

import hashlib
import hmac
import os
import json
import time
import secrets
from datetime import datetime, timedelta
from pathlib import Path
from typing import Optional, Dict, List, Tuple
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.backends import default_backend
import base64


class SecurityManager:
    """Ana güvenlik yöneticisi sınıfı"""
    
    def __init__(self, config_path: str = "security_config.json"):
        self.config_path = config_path
        self.config = self._load_config()
        self.encryption_key = self._get_or_create_key()
        self.cipher = Fernet(self.encryption_key)
        self.failed_attempts = {}
        self.access_log = []
        
    def _load_config(self) -> Dict:
        """Güvenlik konfigürasyonunu yükle"""
        default_config = {
            "max_failed_attempts": 5,
            "lockout_duration": 300,  # 5 dakika
            "session_timeout": 3600,  # 1 saat
            "require_authentication": True,
            "encrypt_files": True,
            "log_all_access": True,
            "allowed_ips": [],  # Boş liste = tüm IP'ler
            "rate_limit": {
                "requests_per_minute": 60,
                "requests_per_hour": 1000
            }
        }
        
        if os.path.exists(self.config_path):
            try:
                with open(self.config_path, 'r') as f:
                    user_config = json.load(f)
                    default_config.update(user_config)
            except Exception as e:
                print(f"Konfigürasyon yüklenirken hata: {e}")
        
        return default_config
    
    def _get_or_create_key(self) -> bytes:
        """Şifreleme anahtarı oluştur veya yükle"""
        key_file = ".encryption_key"
        
        if os.path.exists(key_file):
            with open(key_file, 'rb') as f:
                return f.read()
        else:
            # Yeni anahtar oluştur
            key = Fernet.generate_key()
            with open(key_file, 'wb') as f:
                f.write(key)
            # Dosya izinlerini kısıtla (sadece sahibi okuyabilsin)
            os.chmod(key_file, 0o600)
            return key
    
    def check_rate_limit(self, identifier: str) -> bool:
        """Rate limiting kontrolü"""
        now = time.time()
        rate_config = self.config.get("rate_limit", {})
        
        if not hasattr(self, 'request_times'):
            self.request_times = {}
        
        if identifier not in self.request_times:
            self.request_times[identifier] = []
        
        # Eski istekleri temizle
        self.request_times[identifier] = [
            t for t in self.request_times[identifier] 
            if now - t < 3600  # Son 1 saat
        ]
        
        # Rate limit kontrolü
        recent_requests = [
            t for t in self.request_times[identifier]
            if now - t < 60  # Son 1 dakika
        ]
        
        if len(recent_requests) >= rate_config.get("requests_per_minute", 60):
            return False
        
        if len(self.request_times[identifier]) >= rate_config.get("requests_per_hour", 1000):
            return False
        
        self.request_times[identifier].append(now)
        return True
    
    def check_brute_force(self, identifier: str) -> bool:
        """Brute force saldırı kontrolü"""
        if identifier not in self.failed_attempts:
            return True
        
        attempts = self.failed_attempts[identifier]
        max_attempts = self.config.get("max_failed_attempts", 5)
        lockout_duration = self.config.get("lockout_duration", 300)
        
        # Süresi dolmuş denemeleri temizle
        attempts = [
            t for t in attempts 
            if time.time() - t < lockout_duration
        ]
        self.failed_attempts[identifier] = attempts
        
        if len(attempts) >= max_attempts:
            return False
        
        return True
    
    def record_failed_attempt(self, identifier: str):
        """Başarısız deneme kaydı"""
        if identifier not in self.failed_attempts:
            self.failed_attempts[identifier] = []
        self.failed_attempts[identifier].append(time.time())
        self._log_security_event("FAILED_AUTH", identifier)
    
    def record_successful_auth(self, identifier: str):
        """Başarılı kimlik doğrulama kaydı"""
        if identifier in self.failed_attempts:
            del self.failed_attempts[identifier]
        self._log_security_event("SUCCESS_AUTH", identifier)
    
    def authenticate(self, username: str, password: str) -> bool:
        """Kullanıcı kimlik doğrulama"""
        identifier = f"{username}_{self._get_client_ip()}"
        
        # Rate limit kontrolü
        if not self.check_rate_limit(identifier):
            self._log_security_event("RATE_LIMIT_EXCEEDED", identifier)
            return False
        
        # Brute force kontrolü
        if not self.check_brute_force(identifier):
            self._log_security_event("ACCOUNT_LOCKED", identifier)
            return False
        
        # Basit hash tabanlı kimlik doğrulama (gerçek uygulamada veritabanı kullanılmalı)
        stored_hash = self._get_user_hash(username)
        if stored_hash:
            password_hash = self._hash_password(password, stored_hash['salt'])
            if hmac.compare_digest(password_hash, stored_hash['hash']):
                self.record_successful_auth(identifier)
                return True
        
        self.record_failed_attempt(identifier)
        return False
    
    def _get_user_hash(self, username: str) -> Optional[Dict]:
        """Kullanıcı hash'ini al (gerçek uygulamada veritabanından)"""
        users_file = ".users.json"
        if os.path.exists(users_file):
            try:
                with open(users_file, 'r') as f:
                    users = json.load(f)
                    return users.get(username)
            except:
                pass
        return None
    
    def _hash_password(self, password: str, salt: bytes = None) -> bytes:
        """Şifreyi hash'le"""
        if salt is None:
            salt = secrets.token_bytes(32)
        
        kdf = PBKDF2HMAC(
            algorithm=hashes.SHA256(),
            length=32,
            salt=salt,
            iterations=100000,
            backend=default_backend()
        )
        key = base64.urlsafe_b64encode(kdf.derive(password.encode()))
        return key
    
    def create_user(self, username: str, password: str) -> bool:
        """Yeni kullanıcı oluştur"""
        users_file = ".users.json"
        users = {}
        
        if os.path.exists(users_file):
            try:
                with open(users_file, 'r') as f:
                    users = json.load(f)
            except:
                pass
        
        if username in users:
            return False
        
        salt = secrets.token_bytes(32)
        password_hash = self._hash_password(password, salt)
        
        users[username] = {
            'hash': base64.b64encode(password_hash).decode(),
            'salt': base64.b64encode(salt).decode(),
            'created': datetime.now().isoformat()
        }
        
        with open(users_file, 'w') as f:
            json.dump(users, f, indent=2)
        
        os.chmod(users_file, 0o600)
        return True
    
    def encrypt_file(self, file_path: str) -> bool:
        """Dosyayı şifrele"""
        try:
            with open(file_path, 'rb') as f:
                data = f.read()
            
            encrypted_data = self.cipher.encrypt(data)
            
            encrypted_path = f"{file_path}.encrypted"
            with open(encrypted_path, 'wb') as f:
                f.write(encrypted_data)
            
            # Orijinal dosyayı güvenli şekilde sil
            self._secure_delete(file_path)
            
            self._log_security_event("FILE_ENCRYPTED", file_path)
            return True
        except Exception as e:
            self._log_security_event("ENCRYPTION_ERROR", f"{file_path}: {str(e)}")
            return False
    
    def decrypt_file(self, encrypted_path: str, output_path: str) -> bool:
        """Dosyanın şifresini çöz"""
        try:
            with open(encrypted_path, 'rb') as f:
                encrypted_data = f.read()
            
            decrypted_data = self.cipher.decrypt(encrypted_data)
            
            with open(output_path, 'wb') as f:
                f.write(decrypted_data)
            
            self._log_security_event("FILE_DECRYPTED", encrypted_path)
            return True
        except Exception as e:
            self._log_security_event("DECRYPTION_ERROR", f"{encrypted_path}: {str(e)}")
            return False
    
    def _secure_delete(self, file_path: str):
        """Dosyayı güvenli şekilde sil"""
        try:
            # Dosyayı rastgele veriyle üzerine yaz
            with open(file_path, 'ba+', buffering=0) as f:
                length = f.tell()
                f.seek(0)
                for _ in range(3):  # 3 kez üzerine yaz
                    f.write(secrets.token_bytes(length))
                    f.flush()
                    os.fsync(f.fileno())
            os.remove(file_path)
        except:
            pass
    
    def validate_file_access(self, file_path: str, user: str) -> bool:
        """Dosya erişim izni kontrolü"""
        # Dosya var mı kontrol et
        if not os.path.exists(file_path):
            return False
        
        # Güvenlik loglama
        if self.config.get("log_all_access", True):
            self._log_access(file_path, user)
        
        return True
    
    def sanitize_input(self, user_input: str) -> str:
        """Kullanıcı girdisini temizle (SQL injection, XSS vb. koruması)"""
        # Tehlikeli karakterleri temizle
        dangerous_chars = ['<', '>', '"', "'", '&', ';', '|', '`', '$', '(', ')']
        sanitized = user_input
        
        for char in dangerous_chars:
            sanitized = sanitized.replace(char, '')
        
        # Path traversal koruması
        sanitized = sanitized.replace('..', '')
        sanitized = sanitized.replace('/', '')
        sanitized = sanitized.replace('\\', '')
        
        return sanitized.strip()
    
    def _get_client_ip(self) -> str:
        """İstemci IP adresini al (basitleştirilmiş)"""
        # Gerçek uygulamada request'ten alınmalı
        return "127.0.0.1"
    
    def _log_security_event(self, event_type: str, details: str):
        """Güvenlik olayını logla"""
        log_entry = {
            "timestamp": datetime.now().isoformat(),
            "event": event_type,
            "details": details,
            "ip": self._get_client_ip()
        }
        
        self.access_log.append(log_entry)
        
        # Log dosyasına yaz
        log_file = "security.log"
        with open(log_file, 'a') as f:
            f.write(json.dumps(log_entry) + '\n')
    
    def _log_access(self, file_path: str, user: str):
        """Dosya erişimini logla"""
        self._log_security_event("FILE_ACCESS", f"{user}:{file_path}")
    
    def get_security_status(self) -> Dict:
        """Güvenlik durumunu al"""
        return {
            "failed_attempts_count": len(self.failed_attempts),
            "locked_accounts": [
                ident for ident, attempts in self.failed_attempts.items()
                if len(attempts) >= self.config.get("max_failed_attempts", 5)
            ],
            "total_access_logs": len(self.access_log),
            "encryption_enabled": self.config.get("encrypt_files", True)
        }


# Global güvenlik yöneticisi instance'ı
_security_manager = None

def get_security_manager() -> SecurityManager:
    """Güvenlik yöneticisini al"""
    global _security_manager
    if _security_manager is None:
        _security_manager = SecurityManager()
    return _security_manager
