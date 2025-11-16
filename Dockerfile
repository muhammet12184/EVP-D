# Güvenli Python Docker Image
FROM python:3.11-slim

# Security: Non-root user oluştur
RUN groupadd -r appuser && useradd -r -g appuser appuser

# Çalışma dizini
WORKDIR /app

# Güvenlik güncellemeleri
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    openssl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Requirements'ı kopyala ve yükle
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

# Uygulama dosyalarını kopyala
COPY app.py .
COPY security_utils.py .
COPY file_encryption.py .
COPY ev_unified_professional.csv .

# Dizin sahipliğini değiştir
RUN chown -R appuser:appuser /app

# Non-root user'a geç (Security best practice)
USER appuser

# Port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD python -c "import requests; requests.get('http://localhost:8000/health')" || exit 1

# Uygulamayı başlat
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]
