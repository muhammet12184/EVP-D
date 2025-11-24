# AWS Infrastructure

Bu klasör AWS bulut altyapısı konfigürasyonlarını içerir.

## Yapı

- `iot-core/`: AWS IoT Core konfigürasyonları
- `cloudformation/`: CloudFormation şablonları
- `lambda/`: Lambda fonksiyonları

## Kurulum

### 1. AWS IoT Core Setup

```bash
# IoT Policy oluştur
aws iot create-policy \
  --policy-name VehiclePolicy \
  --policy-document file://iot-core/policy.json

# Thing Type oluştur
aws iot create-thing-type \
  --thing-type-name Vehicle \
  --thing-type-properties file://iot-core/thing-type.json
```

### 2. CloudFormation Stack Deploy

```bash
aws cloudformation create-stack \
  --stack-name super-app-infra \
  --template-body file://cloudformation/main.yaml \
  --parameters ParameterKey=Environment,ParameterValue=dev
```

### 3. Lambda Function Deploy

```bash
cd lambda/functions
zip -r vehicle-data-processor.zip vehicle-data-processor.py
aws lambda create-function \
  --function-name vehicle-data-processor \
  --runtime python3.11 \
  --role arn:aws:iam::ACCOUNT:role/lambda-execution-role \
  --handler vehicle-data-processor.lambda_handler \
  --zip-file fileb://vehicle-data-processor.zip
```

## IoT Topics

- `vehicles/{vehicle_id}/data` - Vehicle data updates
- `vehicles/{vehicle_id}/commands` - Commands to vehicle
- `vehicles/{vehicle_id}/alerts` - Vehicle alerts

## Gereksinimler

- AWS CLI configured
- Appropriate IAM permissions
- AWS IoT Core endpoint
