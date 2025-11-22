# Volkswagen Group (VAG) Specific PIDs and Protocols

## Overview

Volkswagen Group vehicles (Volkswagen, Audi, SEAT, Škoda, Porsche, Bentley, Lamborghini) use specific protocols and measuring blocks that extend beyond standard OBD-II.

## VAG Protocols

### KWP1281 (Older Vehicles)
- Baud Rate: 9600, 10400
- K-Line based
- Used until ~2000

### KWP2000 (ISO 14230)
- Enhanced diagnostics
- Used ~2000-2008

### CAN-TP2.0
- Proprietary VW transport protocol
- 500 kbps CAN

### UDS on CAN (Current)
- ISO 14229 based
- Used 2008+

## Measuring Value Blocks (MVB)

### Engine - Gasoline (Groups 000-099)

| Group | Field | Description                          | Formula/Notes                  | Units    |
|-------|-------|--------------------------------------|--------------------------------|----------|
| 001   | 1     | Engine Speed                         | A*256+B                        | rpm      |
| 001   | 2     | Engine Load                          | A/2.55                         | %        |
| 001   | 3     | Throttle Position                    | A/2.55                         | %        |
| 001   | 4     | Ignition Timing Angle                | (A-128)/2                      | °BTDC    |
| 002   | 1     | Engine Speed                         | A*256+B                        | rpm      |
| 002   | 2     | Engine Load                          | A/2.55                         | %        |
| 002   | 3     | Injection Time                       | (A*256+B)/100                  | ms       |
| 002   | 4     | Intake Air Mass                      | (A*256+B)/10                   | g/s      |
| 003   | 1     | Engine Speed                         | A*256+B                        | rpm      |
| 003   | 2     | Intake Air Mass                      | (A*256+B)/10                   | g/s      |
| 003   | 3     | Throttle Angle (Drive By Wire)       | A/2.55                         | %        |
| 003   | 4     | Ignition Timing Angle                | (A-128)/2                      | °BTDC    |
| 004   | 1     | Engine Speed                         | A*256+B                        | rpm      |
| 004   | 2     | Battery Voltage                      | A/100                          | V        |
| 004   | 3     | Coolant Temperature                  | A-40                           | °C       |
| 004   | 4     | Intake Air Temperature               | A-40                           | °C       |
| 005   | 1     | Engine Speed                         | A*256+B                        | rpm      |
| 005   | 2     | Engine Load                          | A/2.55                         | %        |
| 005   | 3     | Vehicle Speed                        | A                              | km/h     |
| 005   | 4     | System Status                        | Text                           | -        |
| 006   | 1     | Engine Speed                         | A*256+B                        | rpm      |
| 006   | 2     | Engine Load                          | A/2.55                         | %        |
| 006   | 3     | Lambda Control                       | (A-128)/128                    | %        |
| 006   | 4     | System Status                        | Text                           | -        |

### Engine - Diesel TDI (Groups 000-099)

| Group | Field | Description                          | Formula/Notes                  | Units    |
|-------|-------|--------------------------------------|--------------------------------|----------|
| 001   | 1     | Engine Speed                         | A*256+B/4                      | rpm      |
| 001   | 2     | Injection Quantity                   | (A*256+B)/100                  | mg/stroke|
| 001   | 3     | Injection Duration                   | (A-128)/4                      | °        |
| 001   | 4     | Coolant Temperature                  | A/2.55-50                      | °C       |
| 002   | 1     | Engine Speed                         | A*256+B/4                      | rpm      |
| 002   | 2     | Accelerator Position                 | A/2.55                         | %        |
| 002   | 3     | Operating Mode                       | Text                           | -        |
| 002   | 4     | Glow Status                          | Text                           | -        |
| 003   | 1     | Engine Speed                         | A*256+B/4                      | rpm      |
| 003   | 2     | Intake Air Mass (specified)          | (A*256+B)/10                   | mg/stroke|
| 003   | 3     | Intake Air Mass (actual)             | (A*256+B)/10                   | mg/stroke|
| 003   | 4     | EGR Duty Cycle                       | A/2.55                         | %        |
| 004   | 1     | Engine Speed                         | A*256+B/4                      | rpm      |
| 004   | 2     | Injection Start (specified)          | (A-128)/2.56                   | °BTDC    |
| 004   | 3     | Injection Duration                   | (A*256+B)/100                  | ms       |
| 004   | 4     | Synchronization Adjustment           | (A-128)/2.56                   | °        |
| 011   | 1     | Engine Speed                         | A*256+B/4                      | rpm      |
| 011   | 2     | Injection Quantity                   | (A*256+B)/100                  | mg/stroke|
| 011   | 3     | Main Injection Timing                | (A-128)/2.56                   | °BTDC    |
| 011   | 4     | Boost Pressure (actual)              | (A*256+B)/1000                 | bar      |

### Transmission (Groups 000-099)

| Group | Field | Description                          | Formula/Notes                  | Units    |
|-------|-------|--------------------------------------|--------------------------------|----------|
| 005   | 1     | Engine Speed                         | A*256+B                        | rpm      |
| 005   | 2     | Vehicle Speed                        | A*1.39                         | km/h     |
| 005   | 3     | ATF Temperature                      | A-40                           | °C       |
| 005   | 4     | Current Gear                         | A                              | gear     |

### ABS/ESP (Groups 001-010)

| Group | Field | Description                          | Formula/Notes                  | Units    |
|-------|-------|--------------------------------------|--------------------------------|----------|
| 001   | 1     | Speed Sensor Front Left              | A*1.39                         | km/h     |
| 001   | 2     | Speed Sensor Front Right             | A*1.39                         | km/h     |
| 001   | 3     | Speed Sensor Rear Left               | A*1.39                         | km/h     |
| 001   | 4     | Speed Sensor Rear Right              | A*1.39                         | km/h     |
| 002   | 1     | Longitudinal Acceleration            | (A-128)/1.28                   | m/s²     |
| 002   | 2     | Lateral Acceleration                 | (A-128)/1.28                   | m/s²     |
| 002   | 3     | Yaw Rate                             | (A-128)/2.56                   | °/s      |
| 002   | 4     | Rotation Rate                        | Text                           | -        |
| 003   | 1     | Brake Pressure                       | (A*256+B)/100                  | bar      |
| 003   | 2     | Steering Angle                       | (A*256+B-32768)/10             | °        |
| 003   | 3     | Lateral Acceleration                 | (A-128)/1.28                   | m/s²     |
| 003   | 4     | Rotation Rate                        | (A-128)/2.56                   | °/s      |

## Advanced Measuring Blocks

### Fuel System Adaptation

| Group | Field | Description                          | Formula/Notes                  | Units    |
|-------|-------|--------------------------------------|--------------------------------|----------|
| 032   | 1     | Idle Speed Learning Value            | (A-128)/10                     | %        |
| 032   | 2     | Part Load Learning Value             | (A-128)/10                     | %        |
| 033   | 1     | Lambda Control Bank 1                | (A-128)/128                    | %        |
| 033   | 2     | Lambda Sensor Voltage Bank 1         | A/200                          | V        |
| 034   | 1     | Lambda Control Bank 2                | (A-128)/128                    | %        |
| 034   | 2     | Lambda Sensor Voltage Bank 2         | A/200                          | V        |

### Turbocharger

| Group | Field | Description                          | Formula/Notes                  | Units    |
|-------|-------|--------------------------------------|--------------------------------|----------|
| 115   | 1     | Engine Speed                         | A*256+B                        | rpm      |
| 115   | 2     | Engine Load                          | A/2.55                         | %        |
| 115   | 3     | Boost Pressure (specified)           | (A*256+B)/1000                 | bar      |
| 115   | 4     | Boost Pressure (actual)              | (A*256+B)/1000                 | bar      |

## Long Coding

### Example: Central Electronics (09)
```
Byte 0: Equipment
  Bit 0: Xenon Headlights
  Bit 1: Fog Lights
  Bit 2: Cornering Lights
  Bit 3: LED Daytime Running Lights
  
Byte 1: Country/Region
  00: Germany
  01: Rest of World
  02: USA
  03: Canada
  
Byte 2: Features
  Bit 0: Coming Home
  Bit 1: Leaving Home
  Bit 2: Footwell Lights
  Bit 3: Door Warning Lights
```

## Adaptation Channels

### Common Adaptation Channels

| Channel | Description                              | Module    | Value Range    |
|---------|------------------------------------------|-----------|----------------|
| 00      | Reset All Adaptations                    | Various   | -              |
| 01      | Service Interval - Distance              | 17-Dash   | 0-50000 km     |
| 02      | Service Interval - Time                  | 17-Dash   | 0-365 days     |
| 03      | Tank Characteristic                      | 17-Dash   | 32-255         |
| 04      | Language                                 | Various   | 0-9            |
| 05      | Distance Impulse Number                  | 17-Dash   | Various        |
| 10      | Access/Start Authorization               | Various   | 0-1            |
| 30      | Tank Characteristic                      | 17-Dash   | 32-255         |
| 50      | ESP Operation                            | 03-ABS    | 0-1            |
| 60      | Steering Angle Sensor Calibration        | 03-ABS    | -              |

### Engine Specific Adaptations

| Channel | Description                              | Engine Type | Value Range    |
|---------|------------------------------------------|-------------|----------------|
| 01      | Injection Quantity Balance Cyl 1         | TDI         | -3.0 to +3.0   |
| 02      | Injection Quantity Balance Cyl 2         | TDI         | -3.0 to +3.0   |
| 03      | Injection Quantity Balance Cyl 3         | TDI         | -3.0 to +3.0   |
| 04      | Injection Quantity Balance Cyl 4         | TDI         | -3.0 to +3.0   |
| 10      | Fuel Adaptation at Idle                  | Gasoline    | -10% to +10%   |
| 11      | Fuel Adaptation at Part Load             | Gasoline    | -10% to +10%   |

## Security Access (Login Codes)

### Common Login Codes

| Module              | Code  | Purpose                           |
|---------------------|-------|-----------------------------------|
| Engine              | 12233 | Basic Settings                    |
| Engine              | 13861 | Cruise Control Activation         |
| Airbag              | 75201 | Component Protection Reset        |
| Central Electronics | 31347 | Convenience Features              |
| Steering            | 19249 | Steering Limit Stop Reset         |
| ABS/ESP             | 40168 | Basic Settings                    |
| Gateway             | 20103 | Installation List Update          |

## Module Addresses

### Standard CAN Addresses

| Address | Module                                  | Protocol    |
|---------|------------------------------------------|-------------|
| 01      | Engine Control Module                    | CAN/KWP     |
| 02      | Transmission Control Module              | CAN/KWP     |
| 03      | ABS/ESP Brake Control                    | CAN/KWP     |
| 08      | HVAC/Climate Control                     | CAN/KWP     |
| 09      | Central Electronics                      | CAN         |
| 15      | Airbag                                   | CAN/KWP     |
| 16      | Steering Column Electronics              | CAN         |
| 17      | Instrument Cluster                       | CAN/KWP     |
| 19      | CAN Gateway                              | CAN         |
| 44      | Steering Assist                          | CAN         |
| 46      | Central Module Comfort System            | CAN         |
| 56      | Radio/Navigation                         | CAN         |
| 5F      | Information Electronics (MIB)            | CAN         |

### Extended Addresses (Newer Vehicles)

| Address | Module                                  | Platform    |
|---------|------------------------------------------|-------------|
| A5      | Front Camera                             | MQB/MLB     |
| 13      | Adaptive Cruise Control                  | MQB/MLB     |
| 20      | High Beam Assist                         | MQB/MLB     |
| 6C      | Rear Camera                              | MQB/MLB     |
| 76      | Parking Aid                              | MQB/MLB     |

## Special Functions

### Service Reset Procedures

#### Oil Service Reset
1. Access module 17 (Instrument Cluster)
2. Go to Adaptation
3. Select channel 02 (Service Interval)
4. Enter new value (e.g., 15000 for 15,000 km)
5. Save adaptation

#### DPF Regeneration
1. Access module 01 (Engine)
2. Go to Basic Settings
3. Select group 070
4. Activate regeneration
5. Monitor until complete

#### Throttle Body Adaptation
1. Turn ignition ON (engine OFF)
2. Access module 01 (Engine)
3. Go to Basic Settings
4. Select group 060
5. Wait for "ADP OK" message

## Common Diagnostic Trouble Codes (VAG Specific)

### Engine DTCs

| Code    | Description                             |
|---------|------------------------------------------|
| 00768   | Random/Multiple Cylinder Misfire Detected|
| 00769   | Cylinder 1 Misfire Detected              |
| 00770   | Cylinder 2 Misfire Detected              |
| 00771   | Cylinder 3 Misfire Detected              |
| 00772   | Cylinder 4 Misfire Detected              |
| 16486   | Mass Air Flow Sensor (G70) Signal Too Low|
| 16487   | Mass Air Flow Sensor (G70) Signal Too High|
| 16395   | Bank 1 Camshaft A Position - Timing Over-Advanced|
| 16555   | Fuel Rail Pressure Sensor (G247) Malfunction|

### Transmission DTCs

| Code    | Description                             |
|---------|------------------------------------------|
| 17134   | Gear 1 Incorrect Ratio                  |
| 17135   | Gear 2 Incorrect Ratio                  |
| 17136   | Gear 3 Incorrect Ratio                  |
| 17137   | Gear 4 Incorrect Ratio                  |
| 18221   | Clutch Temperature Too High              |

## Platform Specific Information

### MQB Platform
- Used from 2012+
- Golf 7/8, Passat B8, Tiguan 2
- Enhanced UDS protocol
- Virtual cockpit support

### MLB Platform
- Longitudinal engine layout
- Audi A4/A5/A6/A7/A8/Q5/Q7
- Advanced driver assistance

### MEB Platform
- Electric vehicle platform
- ID.3, ID.4, ID.5, ID.Buzz
- High voltage diagnostics
- OTA update capable