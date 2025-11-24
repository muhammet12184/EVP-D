# API Dokümantasyonu

## Base URL
- Development: `http://localhost:8080`
- Production: `https://api.supermobility.app`

## Authentication

Tüm protected endpoint'ler için JWT token gereklidir:

```
Authorization: Bearer <token>
```

## Endpoints

### Authentication

#### Register
```http
POST /api/v1/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"
}
```

#### Login
```http
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

### EV Management

#### Get Battery State
```http
GET /api/v1/ev/battery-state
Authorization: Bearer <token>
```

#### Initiate Plug & Charge
```http
POST /api/v1/ev/plug-and-charge/initiate
Authorization: Bearer <token>
Content-Type: application/json

{
  "vehicle_id": "ev_123",
  "station_id": "station_456",
  "connector_id": "connector_789"
}
```

#### Get Range Estimate
```http
GET /api/v1/ev/range-estimate
Authorization: Bearer <token>
```

### ICE Management

#### Get OBD Data
```http
GET /api/v1/ice/obd-data
Authorization: Bearer <token>
```

#### Get Fuel Stations
```http
GET /api/v1/ice/fuel-stations?lat=41.0082&lng=28.9784&fuel_type=gasoline&radius=10
Authorization: Bearer <token>
```

### AI Services

#### Explain Trouble Code
```http
POST /api/v1/ai/mechanic/explain-trouble-code
Authorization: Bearer <token>
Content-Type: application/json

{
  "dtc_code": "P0420"
}
```

#### Analyze Emotion
```http
POST /api/v1/ai/assistant/analyze-emotion
Authorization: Bearer <token>
Content-Type: application/json

{
  "image_data": "base64_encoded_image",
  "audio_data": "base64_encoded_audio",
  "text": "I'm feeling stressed"
}
```

### İmece (Community Help)

#### Create Help Request
```http
POST /api/v1/imece/help-requests
Authorization: Bearer <token>
Content-Type: application/json

{
  "type": "flat_tire",
  "description": "Lastik patladı, yardım lazım",
  "latitude": 41.0082,
  "longitude": 28.9784
}
```

#### Get Nearby Help Requests
```http
GET /api/v1/imece/help-requests/nearby?lat=41.0082&lng=28.9784&radius=5
Authorization: Bearer <token>
```

### Finance

#### Get Wallet
```http
GET /api/v1/finance/wallet
Authorization: Bearer <token>
```

#### Process Payment
```http
POST /api/v1/finance/payment
Authorization: Bearer <token>
Content-Type: application/json

{
  "amount": 150.00,
  "description": "Şarj İstasyonu",
  "category": "charging"
}
```

### Gamification

#### Get Leaderboard
```http
GET /api/v1/gamification/leaderboard
Authorization: Bearer <token>
```

#### Get Eco Coins
```http
GET /api/v1/gamification/eco-coins
Authorization: Bearer <token>
```
