# Güvenlik Dokümantasyonu

## Genel Bakış

Bu uygulama, EV (Elektrikli Araç) verilerini korumak için kapsamlı güvenlik önlemleri içerir.

## Güvenlik Özellikleri

### 1. Kimlik Doğrulama ve Yetkilendirme
- Kullanıcı adı/şifre tabanlı kimlik doğrulama
- PBKDF2 ile güvenli şifre hash'leme
- Oturum yönetimi

### 2. Brute Force Koruması
- Maksimum başarısız deneme sayısı: 5
- Hesap kilitleme süresi: 5 dakika
- Otomatik kilitleme ve açma

### 3. Rate Limiting
- Dakikada maksimum 60 istek
- Saatte maksimum 1000 istek
- IP bazlı kısıtlama

### 4. Dosya Şifreleme
- Fernet (AES-128) şifreleme
- Otomatik dosya şifreleme
- Güvenli şifre çözme

### 5. Güvenli Dosya Silme
- Çoklu üzerine yazma (3 kez)
- Güvenli silme algoritması

### 6. Input Validation ve Sanitization
- SQL Injection koruması
- XSS koruması
- Path Traversal koruması
- Tehlikeli karakter filtreleme

### 7. Güvenlik Loglama
- Tüm erişim denemeleri loglanır
- Başarısız girişler kaydedilir
- Dosya erişimleri izlenir
- Güvenlik olayları kaydedilir

## Kurulum

1. Gerekli paketleri yükleyin:
```bash
pip install -r requirements.txt
```

2. İlk kullanımda admin kullanıcısı oluşturulacaktır.

3. Uygulamayı çalıştırın:
```bash
python app.py
```

## Güvenlik Dosyaları

Aşağıdaki dosyalar `.gitignore` içinde yer alır ve asla commit edilmemelidir:
- `.encryption_key` - Şifreleme anahtarı
- `.users.json` - Kullanıcı veritabanı
- `*.encrypted` - Şifreli dosyalar
- `security.log` - Güvenlik logları

## Konfigürasyon

`security_config.json` dosyasından güvenlik ayarlarını özelleştirebilirsiniz:

- `max_failed_attempts`: Maksimum başarısız deneme sayısı
- `lockout_duration`: Kilitleme süresi (saniye)
- `encrypt_files`: Otomatik dosya şifreleme (true/false)
- `log_all_access`: Tüm erişimleri logla (true/false)
- `rate_limit`: Rate limiting ayarları

## Güvenlik En İyi Uygulamaları

1. **Güçlü Şifreler**: En az 12 karakter, büyük/küçük harf, sayı ve özel karakter
2. **Düzenli Güncellemeler**: Güvenlik paketlerini düzenli güncelleyin
3. **Log İnceleme**: `security.log` dosyasını düzenli kontrol edin
4. **Dosya İzinleri**: Hassas dosyaların izinlerini kontrol edin (chmod 600)
5. **Yedekleme**: Şifreleme anahtarını güvenli yerde yedekleyin

## Uyarılar

⚠️ **ÖNEMLİ**: 
- Şifreleme anahtarını kaybederseniz, şifreli dosyalarınızı açamazsınız
- `.encryption_key` dosyasını mutlaka yedekleyin
- Bu dosyaları asla git'e commit etmeyin

## Saldırı Senaryolarına Karşı Koruma

✅ **Brute Force**: Rate limiting ve hesap kilitleme
✅ **SQL Injection**: Input sanitization
✅ **XSS**: Karakter filtreleme
✅ **Path Traversal**: Yol validasyonu
✅ **Dosya Erişimi**: Erişim kontrolü ve loglama
✅ **Veri Sızıntısı**: Dosya şifreleme

## Destek

Güvenlik sorunları için lütfen güvenlik ekibiyle iletişime geçin.
