"""
AWS Lambda function to process vehicle data from IoT Core
"""
import json
import boto3
from datetime import datetime

dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table('VehicleData')

def lambda_handler(event, context):
    """
    Process vehicle data from IoT Core
    
    Event structure:
    {
        "topic": "vehicles/{vehicle_id}/data",
        "payload": {
            "timestamp": "...",
            "data": {...}
        }
    }
    """
    try:
        # Extract vehicle ID from topic
        topic = event.get('topic', '')
        vehicle_id = topic.split('/')[1] if '/' in topic else 'unknown'
        
        # Parse payload
        payload = json.loads(event.get('payload', '{}'))
        
        # Store in DynamoDB
        item = {
            'vehicle_id': vehicle_id,
            'timestamp': payload.get('timestamp', datetime.utcnow().isoformat()),
            'data': payload.get('data', {}),
            'ttl': int(datetime.utcnow().timestamp()) + 86400 * 30  # 30 days TTL
        }
        
        table.put_item(Item=item)
        
        # Process data for alerts (low battery, high temperature, etc.)
        process_alerts(vehicle_id, payload.get('data', {}))
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Data processed successfully',
                'vehicle_id': vehicle_id
            })
        }
    
    except Exception as e:
        print(f"Error processing vehicle data: {e}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': str(e)
            })
        }

def process_alerts(vehicle_id: str, data: dict):
    """Process data and send alerts if needed"""
    # Check battery SOC for EVs
    if 'battery_soc' in data:
        soc = data['battery_soc']
        if soc < 20:
            send_alert(vehicle_id, 'low_battery', f'Battery SOC is low: {soc}%')
    
    # Check battery temperature
    if 'battery_temp' in data:
        temp = data['battery_temp']
        if temp > 45:
            send_alert(vehicle_id, 'high_temperature', f'Battery temperature is high: {temp}°C')
    
    # Check fuel level for ICE vehicles
    if 'fuel_level' in data:
        fuel = data['fuel_level']
        if fuel < 15:
            send_alert(vehicle_id, 'low_fuel', f'Fuel level is low: {fuel}%')

def send_alert(vehicle_id: str, alert_type: str, message: str):
    """Send alert via SNS or push notification"""
    # In production, send to SNS topic or push notification service
    print(f"Alert for {vehicle_id}: {alert_type} - {message}")
