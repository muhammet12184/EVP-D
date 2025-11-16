# 🔒 Güvenlik Politikası

## Desteklenen Versiyonlar

Aşağıdaki versiyonlar için güvenlik güncellemeleri sağlanmaktadır:

| Versiyon | Destekleniyor |
| ------- | ------------- |
| 1.0.x   | ✅            |
| < 1.0   | ❌            |

## Güvenlik Zaafiyeti Bildirimi

### Bildirme Süreci

Bir güvenlik zaafiyeti keşfettiyseniz, lütfen aşağıdaki adımları izleyin:

1. **AÇIK ISSUE OLUŞTURMAYIN** - Güvenlik zafiyetlerini herkese açık olarak paylaşmayın
2. Email gönderin: security@yourdomain.com
3. Şu bilgileri ekleyin:
   - Zaafiyetin detaylı açıklaması
   - Tekrar üretme adımları
   - Potansiyel etki analizi
   - Varsa çözüm önerisi

### Yanıt Süresi

- **İlk yanıt:** 48 saat içinde
- **Durum güncellemesi:** 7 gün içinde
- **Düzeltme:** Kritikliğe bağlı olarak 30 gün içinde

### PGP Anahtarı

Hassas bilgileri şifrelemek için PGP anahtarımızı kullanabilirsiniz:

```
[PGP Public Key buraya eklenecek]
```

## Güvenlik Kontrol Listesi

### Deployment Öncesi

- [ ] Tüm varsayılan şifreleri değiştirin
- [ ] SECRET_KEY ve ENCRYPTION_KEY'i güvenli rastgele değerlerle değiştirin
- [ ] .env dosyasını git'e eklemeyin
- [ ] SSL/TLS sertifikası yapılandırın (Let's Encrypt)
- [ ] Firewall kurallarını ayarlayın
- [ ] Rate limiting ayarlarını production için optimize edin
- [ ] Log dosyalarının yazılabilir olduğundan emin olun
- [ ] Backup stratejisi oluşturun

### Düzenli Kontroller

- [ ] Haftalık: Log dosyalarını inceleyin
- [ ] Aylık: Bağımlılıkları güncelleyin (`pip list --outdated`)
- [ ] Aylık: Güvenlik taraması çalıştırın (`bandit -r .`)
- [ ] Üç Aylık: Penetrasyon testi yapın
- [ ] Üç Aylık: Backup'ları test edin

## Bilinen Güvenlik Kısıtlamaları

1. **In-Memory Rate Limiting**: Şu anki rate limiting implementasyonu memory-based. Production'da Redis kullanın.
2. **Self-Signed SSL**: Development için self-signed sertifika kullanılıyor. Production'da güvenilir CA'den sertifika alın.
3. **SQLite Kullanımı**: Gelecekte kullanıcı yönetimi için PostgreSQL gibi production-ready veritabanı kullanın.

## Güvenlik En İyi Uygulamaları

### 1. Şifre Yönetimi

```python
# ✅ İyi
from passlib.context import CryptContext
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
hashed = pwd_context.hash(password)

# ❌ Kötü
hashed = hashlib.md5(password.encode()).hexdigest()
```

### 2. SQL Injection Önleme

```python
# ✅ İyi - Pydantic validation
class Query(BaseModel):
    vehicle: str
    
    @validator('vehicle')
    def sanitize(cls, v):
        return re.sub(r'[^a-zA-Z0-9\s]', '', v)

# ❌ Kötü - Direkt string interpolation
query = f"SELECT * FROM vehicles WHERE name = '{user_input}'"
```

### 3. XSS Önleme

```python
# ✅ İyi - Input sanitization
def sanitize_input(text):
    dangerous = ['<', '>', '"', "'", '\\', ';']
    for char in dangerous:
        text = text.replace(char, '')
    return text

# ❌ Kötü - Raw input kullanımı
return {"message": user_input}
```

### 4. Token Güvenliği

```python
# ✅ İyi
SECRET_KEY = os.getenv("SECRET_KEY")
if not SECRET_KEY:
    raise ValueError("SECRET_KEY bulunamadı!")

# ❌ Kötü
SECRET_KEY = "my-secret-key"
```

## Güvenlik Araçları

### Otomatik Güvenlik Taraması

```bash
# Python bağımlılık zafiyet taraması
pip install safety
safety check

# Kod güvenlik taraması
pip install bandit
bandit -r . -f json -o security_report.json

# Secret taraması
pip install detect-secrets
detect-secrets scan
```

### Docker Güvenlik Taraması

```bash
# Docker image zafiyet taraması
docker scan ev-battery-api

# Trivy ile tarama
trivy image ev-battery-api
```

## İhlal Durumunda Yapılacaklar

Bir güvenlik ihlali durumunda:

1. **Hemen**: Etkilenen sistemleri izole edin
2. **1 saat içinde**: Güvenlik ekibini bilgilendirin
3. **24 saat içinde**: İhlal kapsamını belirleyin
4. **48 saat içinde**: Düzeltme planı oluşturun
5. **7 gün içinde**: Etkilenen kullanıcıları bilgilendirin
6. **30 gün içinde**: Post-mortem raporu yayınlayın

## Yasal Uyarı

Bu yazılım güvenlik özellikleri ile gelir ancak %100 güvenlik garanti edilemez. Kullanımdan doğan zararlardan yazarlar sorumlu tutulamaz.

## Teşekkürler

Güvenlik açığı bildiren araştırmacılar:

- [İsimler buraya eklenecek]

## Son Güncelleme

Bu güvenlik politikası en son 2025-11-16 tarihinde güncellenmiştir.
