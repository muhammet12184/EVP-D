"""
Güvenlik Yardımcı Araçları
Çeşitli güvenlik kontrolleri ve yardımcı fonksiyonlar
"""

import re
import hashlib
import secrets
import logging
from typing import List, Optional
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)

class SecurityValidator:
    """Güvenlik doğrulama sınıfı"""
    
    # Tehlikeli pattern'ler (SQL injection, XSS vb.)
    DANGEROUS_PATTERNS = [
        r"<script[^>]*>.*?</script>",
        r"javascript:",
        r"onerror\s*=",
        r"onload\s*=",
        r"onclick\s*=",
        r"<iframe",
        r"eval\s*\(",
        r"<object",
        r"<embed",
        r"union.*select",
        r"drop.*table",
        r"insert.*into",
        r"delete.*from",
        r"update.*set",
        r"exec\s*\(",
        r"execute\s*\(",
        r"\.\./",
        r"\.\.\\",
    ]
    
    @staticmethod
    def validate_input(input_string: str, max_length: int = 1000) -> bool:
        """
        Input string'i güvenlik açısından doğrula
        
        Args:
            input_string: Kontrol edilecek string
            max_length: Maksimum uzunluk
        
        Returns:
            Güvenliyse True, tehlikeliyse False
        """
        if not input_string:
            return True
        
        # Uzunluk kontrolü (DoS önleme)
        if len(input_string) > max_length:
            logger.warning(f"Input çok uzun: {len(input_string)} karakter")
            return False
        
        # Tehlikeli pattern kontrolü
        for pattern in SecurityValidator.DANGEROUS_PATTERNS:
            if re.search(pattern, input_string, re.IGNORECASE):
                logger.warning(f"Tehlikeli pattern tespit edildi: {pattern}")
                return False
        
        return True
    
    @staticmethod
    def sanitize_filename(filename: str) -> str:
        """
        Dosya adını güvenli hale getir
        
        Args:
            filename: Temizlenecek dosya adı
        
        Returns:
            Güvenli dosya adı
        """
        # Sadece alfanumerik karakterler, tire, alt çizgi ve nokta
        sanitized = re.sub(r'[^a-zA-Z0-9._-]', '_', filename)
        
        # Path traversal önleme
        sanitized = sanitized.replace('..', '_')
        
        # Başında nokta ile başlamasın (hidden file)
        if sanitized.startswith('.'):
            sanitized = '_' + sanitized[1:]
        
        return sanitized
    
    @staticmethod
    def validate_email(email: str) -> bool:
        """Email formatını doğrula"""
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(pattern, email))
    
    @staticmethod
    def validate_ip_address(ip: str) -> bool:
        """IP adresi formatını doğrula"""
        pattern = r'^(\d{1,3}\.){3}\d{1,3}$'
        if not re.match(pattern, ip):
            return False
        
        # Her okteti kontrol et
        for octet in ip.split('.'):
            if int(octet) > 255:
                return False
        
        return True
    
    @staticmethod
    def generate_secure_token(length: int = 32) -> str:
        """Güvenli rastgele token oluştur"""
        return secrets.token_urlsafe(length)
    
    @staticmethod
    def hash_data(data: str, salt: str = None) -> str:
        """
        Veriyi hash'le (SHA-256)
        
        Args:
            data: Hash'lenecek veri
            salt: Opsiyonel salt değeri
        
        Returns:
            Hexadecimal hash string
        """
        if salt:
            data = data + salt
        return hashlib.sha256(data.encode()).hexdigest()


class RateLimitTracker:
    """
    Rate limiting için basit bir tracker
    (Production'da Redis gibi bir cache kullanın)
    """
    
    def __init__(self):
        self.requests = {}  # {ip: [(timestamp, count), ...]}
        self.blocked_ips = {}  # {ip: unblock_time}
    
    def is_rate_limited(self, ip: str, max_requests: int = 100, window_minutes: int = 1) -> bool:
        """
        IP adresi rate limit'e takıldı mı kontrol et
        
        Args:
            ip: IP adresi
            max_requests: Maksimum istek sayısı
            window_minutes: Zaman penceresi (dakika)
        
        Returns:
            Rate limit'e takıldıysa True
        """
        now = datetime.now()
        
        # Bloklu IP kontrolü
        if ip in self.blocked_ips:
            if now < self.blocked_ips[ip]:
                logger.warning(f"Bloklu IP erişim denemesi: {ip}")
                return True
            else:
                del self.blocked_ips[ip]
        
        # Eski kayıtları temizle
        self._cleanup_old_requests(window_minutes)
        
        # İstek sayısını kontrol et
        if ip not in self.requests:
            self.requests[ip] = []
        
        # Mevcut zaman penceresindeki istekleri say
        window_start = now - timedelta(minutes=window_minutes)
        recent_requests = [
            req_time for req_time in self.requests[ip]
            if req_time > window_start
        ]
        
        if len(recent_requests) >= max_requests:
            # Rate limit aşıldı - IP'yi geçici olarak blokla
            self.blocked_ips[ip] = now + timedelta(minutes=5)
            logger.warning(f"Rate limit aşıldı, IP bloklandı: {ip}")
            return True
        
        # İsteği kaydet
        self.requests[ip].append(now)
        return False
    
    def _cleanup_old_requests(self, window_minutes: int):
        """Eski istek kayıtlarını temizle"""
        cutoff = datetime.now() - timedelta(minutes=window_minutes * 2)
        
        for ip in list(self.requests.keys()):
            self.requests[ip] = [
                req_time for req_time in self.requests[ip]
                if req_time > cutoff
            ]
            
            # Boş listeyi sil
            if not self.requests[ip]:
                del self.requests[ip]


class SecurityAuditor:
    """Güvenlik olaylarını izle ve raporla"""
    
    def __init__(self, log_file: str = 'security_audit.log'):
        self.log_file = log_file
        self._setup_logger()
    
    def _setup_logger(self):
        """Audit logger'ı ayarla"""
        self.audit_logger = logging.getLogger('security_audit')
        self.audit_logger.setLevel(logging.INFO)
        
        handler = logging.FileHandler(self.log_file)
        handler.setFormatter(
            logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
        )
        self.audit_logger.addHandler(handler)
    
    def log_event(self, event_type: str, details: dict):
        """
        Güvenlik olayını logla
        
        Args:
            event_type: Olay tipi (login, failed_login, suspicious_activity, vb.)
            details: Olay detayları
        """
        details['event_type'] = event_type
        details['timestamp'] = datetime.now().isoformat()
        
        self.audit_logger.info(f"{event_type}: {details}")
    
    def log_failed_login(self, username: str, ip: str, user_agent: str):
        """Başarısız giriş denemesini logla"""
        self.log_event('failed_login', {
            'username': username,
            'ip': ip,
            'user_agent': user_agent
        })
    
    def log_successful_login(self, username: str, ip: str):
        """Başarılı girişi logla"""
        self.log_event('successful_login', {
            'username': username,
            'ip': ip
        })
    
    def log_suspicious_activity(self, activity: str, ip: str, details: dict = None):
        """Şüpheli aktiviteyi logla"""
        log_details = {
            'activity': activity,
            'ip': ip
        }
        if details:
            log_details.update(details)
        
        self.log_event('suspicious_activity', log_details)
    
    def log_data_access(self, username: str, resource: str, action: str):
        """Veri erişimini logla"""
        self.log_event('data_access', {
            'username': username,
            'resource': resource,
            'action': action
        })


# Global instances
security_validator = SecurityValidator()
rate_limiter = RateLimitTracker()
security_auditor = SecurityAuditor()


if __name__ == "__main__":
    # Test ve örnekler
    logging.basicConfig(level=logging.INFO)
    
    print("Güvenlik Araçları Test")
    print("=" * 50)
    
    # Input validation test
    test_inputs = [
        "normal_input",
        "<script>alert('xss')</script>",
        "'; DROP TABLE users; --",
        "../../../etc/passwd",
    ]
    
    print("\nInput Validation:")
    for inp in test_inputs:
        is_safe = security_validator.validate_input(inp)
        status = "✓ Güvenli" if is_safe else "✗ Tehlikeli"
        print(f"  {status}: {inp[:50]}")
    
    # Filename sanitization test
    print("\nFilename Sanitization:")
    test_filenames = [
        "normal_file.txt",
        "../../../etc/passwd",
        "file<script>.txt",
        ".hidden_file.txt"
    ]
    
    for filename in test_filenames:
        sanitized = security_validator.sanitize_filename(filename)
        print(f"  {filename} -> {sanitized}")
    
    # Token generation
    print("\nSecure Token Generation:")
    token = security_validator.generate_secure_token()
    print(f"  Token: {token}")
    
    # Audit logging
    print("\nSecurity Audit Logging:")
    security_auditor.log_failed_login("admin", "192.168.1.100", "Mozilla/5.0")
    security_auditor.log_suspicious_activity("XSS attempt", "192.168.1.100")
    print(f"  ✓ Olaylar {security_auditor.log_file} dosyasına yazıldı")
