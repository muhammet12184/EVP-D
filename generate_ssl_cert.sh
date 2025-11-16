#!/bin/bash

# SSL Sertifikası Oluşturma Script'i
# HTTPS için self-signed sertifika oluşturur

echo "🔒 SSL Sertifikası Oluşturuluyor..."
echo "=================================="

# OpenSSL kurulu mu kontrol et
if ! command -v openssl &> /dev/null
then
    echo "❌ OpenSSL yüklü değil. Lütfen yükleyin:"
    echo "   Ubuntu/Debian: sudo apt-get install openssl"
    echo "   MacOS: brew install openssl"
    exit 1
fi

# Private key oluştur
echo "📝 Private key oluşturuluyor..."
openssl genrsa -out key.pem 2048

# Certificate signing request oluştur
echo "📝 Certificate signing request oluşturuluyor..."
openssl req -new -key key.pem -out csr.pem -subj "/C=TR/ST=Istanbul/L=Istanbul/O=EV Data/CN=localhost"

# Self-signed certificate oluştur (365 gün geçerli)
echo "📝 Self-signed certificate oluşturuluyor..."
openssl x509 -req -days 365 -in csr.pem -signkey key.pem -out cert.pem

# Temizlik
rm csr.pem

echo ""
echo "✅ SSL sertifikaları oluşturuldu!"
echo "   - key.pem: Private key"
echo "   - cert.pem: SSL certificate"
echo ""
echo "⚠️  Bu self-signed bir sertifikadır."
echo "   Production için Let's Encrypt gibi güvenilir bir CA'den sertifika alın."
echo ""
echo "🚀 Uygulamayı HTTPS ile başlatmak için:"
echo "   uvicorn app:app --host 0.0.0.0 --port 8443 --ssl-keyfile ./key.pem --ssl-certfile ./cert.pem"
echo ""
