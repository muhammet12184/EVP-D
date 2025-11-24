# Deployment Dokümantasyonu

## Development Ortamı

### Gereksinimler
- Docker & Docker Compose
- Go 1.21+
- Python 3.11+
- Flutter SDK 3.0+

### Hızlı Başlangıç

1. **Environment dosyasını oluşturun:**
```bash
cp .env.example .env
# .env dosyasını düzenleyin
```

2. **Docker ile tüm servisleri başlatın:**
```bash
cd infrastructure
docker-compose up -d
```

3. **Servisleri kontrol edin:**
```bash
# Backend API
curl http://localhost:8080/health

# AI Services
curl http://localhost:8000/health
```

## Production Ortamı

### AWS Deployment

#### 1. Backend API (ECS/Fargate)

```bash
# Docker image build
cd backend
docker build -t super-mobility-backend:latest .

# Push to ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
docker tag super-mobility-backend:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/super-mobility-backend:latest
docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/super-mobility-backend:latest
```

#### 2. AI Services (ECS/Fargate)

```bash
cd ai-services
docker build -t super-mobility-ai:latest .
# Similar ECR push process
```

#### 3. AWS IoT Core Setup

1. IoT Thing oluşturun
2. Policy'leri yapılandırın (`infrastructure/aws-iot-policy.json`)
3. Certificates oluşturun ve cihazlara dağıtın

#### 4. MongoDB Atlas

1. MongoDB Atlas cluster oluşturun
2. Connection string'i environment variable olarak ekleyin

#### 5. Redis (ElastiCache)

1. ElastiCache Redis cluster oluşturun
2. Endpoint'i environment variable olarak ekleyin

### Kubernetes Deployment

```bash
# Apply configurations
kubectl apply -f k8s/namespace.yaml
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/secrets.yaml
kubectl apply -f k8s/backend-deployment.yaml
kubectl apply -f k8s/ai-services-deployment.yaml
kubectl apply -f k8s/services.yaml
```

## CI/CD Pipeline

### GitHub Actions Örneği

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Build and deploy
        run: |
          make docker-build
          # Deploy to production
```

## Monitoring

### Health Checks
- Backend: `GET /health`
- AI Services: `GET /health`

### Logging
- Backend: Structured logging (JSON format)
- AI Services: Python logging with log levels
- Centralized: CloudWatch / ELK Stack

### Metrics
- Prometheus metrics endpoints
- Grafana dashboards

## Scaling

### Horizontal Scaling
- Backend: Stateless design, scale pods as needed
- AI Services: Scale based on request queue
- Database: MongoDB replica sets

### Auto-scaling
- CPU threshold: 70%
- Memory threshold: 80%
- Min replicas: 2
- Max replicas: 10
