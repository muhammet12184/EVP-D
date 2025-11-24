# Mimari Dokümantasyon

## Genel Mimari

Super Mobility uygulaması mikroservis mimarisi kullanarak geliştirilmiştir:

```
┌─────────────────┐
│  Flutter App    │
│  (Mobile)       │
└────────┬────────┘
         │
         ├─────────────────┐
         │                 │
┌────────▼────────┐  ┌──────▼──────┐
│  Go Backend API │  │  AI Services │
│  (REST)         │  │  (Python)    │
└────────┬────────┘  └─────────────┘
         │
         ├─────────────────┐
         │                 │
┌────────▼────────┐  ┌──────▼──────┐
│   MongoDB       │  │    Redis    │
│   (Database)    │  │   (Cache)   │
└─────────────────┘  └─────────────┘
         │
┌────────▼────────┐
│  AWS IoT Core   │
│  (Vehicle Data) │
└─────────────────┘
```

## Servisler

### 1. Flutter Mobil Uygulama
- **Dil**: Dart
- **Framework**: Flutter 3.0+
- **State Management**: Riverpod
- **Mimari**: Feature-based (Clean Architecture)

### 2. Go Backend API
- **Dil**: Go 1.21+
- **Framework**: Gin
- **Veritabanı**: MongoDB
- **Cache**: Redis
- **Authentication**: JWT

### 3. Python AI Services
- **Dil**: Python 3.11+
- **Framework**: FastAPI
- **ML Libraries**: TensorFlow, PyTorch
- **Özellikler**: Duygu analizi, bağlamsal zeka, persona engine

### 4. AWS IoT Core
- **Protokol**: MQTT
- **Kullanım**: Araç verilerinin gerçek zamanlı iletişimi
- **Güvenlik**: X.509 sertifikaları

## Veri Akışı

### EV Batarya Verisi
```
Vehicle → OBD-II/EV API → AWS IoT Core → Go Backend → MongoDB
                                              ↓
                                         Flutter App
```

### AI Komut İşleme
```
User Voice/Text → Flutter App → Go Backend → Python AI Services
                                              ↓
                                         Response → Flutter App
```

### İmece Yardım Talebi
```
User Request → Flutter App → Go Backend → MongoDB
                                      ↓
                              Nearby Users (Push Notification)
```

## Güvenlik

- **Authentication**: JWT tokens
- **Authorization**: Role-based access control (RBAC)
- **Data Encryption**: TLS/SSL for all communications
- **IoT Security**: X.509 certificates for device authentication
- **API Security**: Rate limiting, CORS, input validation

## Ölçeklenebilirlik

- **Horizontal Scaling**: Docker containers, Kubernetes ready
- **Caching**: Redis for frequently accessed data
- **Database**: MongoDB sharding support
- **Load Balancing**: Nginx/HAProxy ready

## Deployment

- **Development**: Docker Compose
- **Production**: Kubernetes (recommended) or AWS ECS
- **CI/CD**: GitHub Actions / GitLab CI ready
