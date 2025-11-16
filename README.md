# 🔒 EV Battery Data API - Güvenli Web Uygulaması

Elektrikli araç batarya verilerini güvenli bir şekilde yöneten profesyonel web API'si.

## 🛡️ Güvenlik Özellikleri

### 1. **Authentication & Authorization**
- JWT (JSON Web Token) tabanlı kimlik doğrulama
- Güvenli şifre hashleme (bcrypt)
- Token süre sonu kontrolü
- Role-based access control (RBAC) altyapısı

### 2. **Rate Limiting & DDoS Koruması**
- IP bazlı rate limiting
- Brute force saldırı önleme
- Otomatik IP bloklama
- Her endpoint için özel limit ayarları

### 3. **Input Validation & Sanitization**
- SQL injection koruması
- XSS (Cross-Site Scripting) önleme
- Path traversal saldırı engelleme
- Tehlikeli karakter filtreleme
- Pydantic model validation

### 4. **Dosya Şifreleme**
- AES-256 şifreleme
- Fernet symmetric encryption
- Otomatik yedekleme ve şifreleme
- Güvenli anahtar yönetimi

### 5. **Güvenlik Headers**
- X-Content-Type-Options: nosniff
- X-Frame-Options: DENY
- X-XSS-Protection
- Strict-Transport-Security (HSTS)
- Content-Security-Policy (CSP)
- Referrer-Policy

### 6. **Logging & Monitoring**
- Güvenlik olayları loglaması
- Başarısız giriş denemeleri kaydı
- Şüpheli aktivite tespiti
- Audit trail (denetim izi)

### 7. **CORS Kontrolü**
- Whitelist tabanlı domain kontrolü
- Sadece izin verilen origin'lere erişim
- Güvenli credential yönetimi

## 📦 Kurulum

### Gereksinimler
- Python 3.8+
- pip

### Adımlar

1. **Bağımlılıkları yükleyin:**
```bash
pip install -r requirements.txt
```

2. **Çevre değişkenlerini ayarlayın:**
```bash
cp .env.example .env
# .env dosyasını düzenleyin ve kendi değerlerinizi girin
```

3. **Güvenlik anahtarlarını oluşturun:**
```python
# SECRET_KEY için
python -c "import secrets; print(secrets.token_urlsafe(32))"

# ENCRYPTION_KEY için
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
```

4. **Uygulamayı başlatın:**
```bash
# Development
python app.py

# Production (HTTPS ile)
uvicorn app:app --host 0.0.0.0 --port 8443 --ssl-keyfile ./key.pem --ssl-certfile ./cert.pem
```

## 🚀 Kullanım

### 1. Giriş Yapma (Login)

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
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 1800
}
```

### 2. Batarya Verilerini Getirme

```bash
curl -X GET "http://localhost:8000/battery-data" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 3. Belirli Bir Araç Markasının Verilerini Getirme

```bash
curl -X GET "http://localhost:8000/battery-data?vehicle_brand=Tesla" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 4. Şifrelenmiş Veri Getirme

```bash
curl -X GET "http://localhost:8000/battery-data/encrypted" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 5. Desteklenen Araç Listesi

```bash
curl -X GET "http://localhost:8000/vehicles" \
  -H "Authorization: Bearer YOUR_ACCESS_TOKEN"
```

### 6. Health Check

```bash
curl -X GET "http://localhost:8000/health"
```

## 🔧 Dosya Şifreleme Aracı

CSV dosyanızı şifrelemek için:

```python
from file_encryption import backup_and_encrypt_csv

# CSV'yi yedekle ve şifrele
encrypted_file = backup_and_encrypt_csv('/workspace/ev_unified_professional.csv')
print(f"Şifrelenmiş dosya: {encrypted_file}")
```

## 📊 API Endpoints

| Endpoint | Method | Rate Limit | Auth | Açıklama |
|----------|--------|------------|------|----------|
| `/` | GET | 10/min | ❌ | API durumu |
| `/login` | POST | 5/min | ❌ | Kullanıcı girişi |
| `/battery-data` | GET | 20/min | ✅ | Batarya verileri |
| `/battery-data/encrypted` | GET | 10/min | ✅ | Şifreli veriler |
| `/vehicles` | GET | 20/min | ✅ | Araç listesi |
| `/health` | GET | 30/min | ❌ | Sağlık kontrolü |

## 🔐 Varsayılan Kullanıcı

**⚠️ ÖNEMLİ:** Production'da mutlaka değiştirin!

- **Kullanıcı adı:** admin
- **Şifre:** Admin123!

Yeni kullanıcı eklemek için:

```python
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
hashed_password = pwd_context.hash("YourPassword123!")
print(hashed_password)
```

## 📁 Proje Yapısı

```
/workspace/
├── app.py                          # Ana FastAPI uygulaması
├── security_utils.py               # Güvenlik araçları
├── file_encryption.py              # Dosya şifreleme modülü
├── requirements.txt                # Python bağımlılıkları
├── .env.example                    # Örnek çevre değişkenleri
├── README.md                       # Bu dosya
├── ev_unified_professional.csv     # EV batarya verileri
├── security.log                    # Güvenlik logları
└── security_audit.log              # Audit logları
```

## 🔒 Güvenlik Best Practices

### Production için öneriler:

1. **HTTPS Kullanın**
   - SSL/TLS sertifikası alın
   - Let's Encrypt ücretsiz sertifika sunar

2. **Güçlü Şifreler**
   - Minimum 12 karakter
   - Büyük/küçük harf, rakam ve özel karakter

3. **Çevre Değişkenleri**
   - SECRET_KEY'i asla kodda tutmayın
   - .env dosyasını git'e eklemeyin

4. **Firewall Kuralları**
   - Sadece gerekli portları açın
   - IP whitelist kullanın

5. **Regular Updates**
   - Bağımlılıkları düzenli güncelleyin
   - Güvenlik yamalarını takip edin

6. **Backup**
   - Düzenli yedekleme yapın
   - Yedekleri şifreleyerek saklayın

7. **Monitoring**
   - Log dosyalarını düzenli kontrol edin
   - Anormal aktiviteleri izleyin

## 🐛 Güvenlik Zaafiyeti Bildirimi

Bir güvenlik zaafiyeti bulduysanız, lütfen sorumlu bir şekilde bildirin:
- Email: security@yourdomain.com
- PGP Key: [Your PGP Key]

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## 🤝 Katkıda Bulunma

Pull request'ler memnuniyetle karşılanır. Büyük değişiklikler için lütfen önce bir issue açın.

## ⚠️ Yasal Uyarı

Bu yazılım "OLDUĞU GİBİ" sağlanmaktadır. Kullanımdan kaynaklanan herhangi bir zarardan yazarlar sorumlu tutulamaz.

## 📞 İletişim

Sorularınız için:
- GitHub Issues
- Email: support@yourdomain.com

---

**🔒 Güvenlik = Sürekli İyileştirme**

Bu API, endüstri standardı güvenlik önlemleri ile geliştirilmiştir.
