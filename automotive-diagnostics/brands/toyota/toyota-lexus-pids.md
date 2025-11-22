# Toyota/Lexus Specific PIDs and Diagnostics

## Overview

Toyota and Lexus vehicles use various diagnostic protocols including proprietary Toyota protocols alongside standard OBD-II. Modern vehicles primarily use ISO 14229 (UDS) over CAN.

## Toyota Diagnostic Protocols

### Protocol Evolution
- Pre-1996: Toyota proprietary protocols
- 1996-2003: ISO 9141-2 (K-Line)
- 2004-2007: ISO 14230-4 (KWP2000)
- 2008+: ISO 15765-4 (CAN)
- 2018+: Enhanced UDS with DoIP support

## Enhanced PIDs (Mode $21)

### Engine Data - Gasoline

| PID  | Description                                 | Formula/Notes                    | Units     |
|------|---------------------------------------------|----------------------------------|-----------|
| 00   | Fuel System Status                          | Bit encoded                      | -         |
| 01   | Calculated Load Value                       | A/2.55                           | %         |
| 02   | Engine Coolant Temperature                  | A-40                             | °C        |
| 03   | Fuel Injection Volume                       | (256*A+B)/100                    | ml        |
| 04   | Intake Air Amount                           | (256*A+B)/10                     | g/rev     |
| 05   | Air-Fuel Ratio                              | (256*A+B)/1000+10                | ratio     |
| 06   | Ignition Timing                             | (A-128)/2                        | °BTDC     |
| 10   | MAF Sensor                                  | (256*A+B)/100                    | g/s       |
| 11   | Throttle Position (Main)                    | A/2.55                           | %         |
| 12   | Throttle Position (Sub)                     | A/2.55                           | %         |
| 13   | Vehicle Speed                               | A                                | km/h      |
| 14   | Battery Voltage                             | A/10                             | V         |
| 15   | Atmospheric Pressure                        | A                                | kPa       |

### Engine Data - Diesel

| PID  | Description                                 | Formula/Notes                    | Units     |
|------|---------------------------------------------|----------------------------------|-----------|
| 30   | Fuel Injection Quantity                     | (256*A+B)/100                    | mm³/st    |
| 31   | Injection Timing                            | (256*A+B)/100-64                 | °BTDC     |
| 32   | Common Rail Pressure                        | (256*A+B)*10                     | MPa       |
| 33   | Boost Pressure                              | (256*A+B)/10                     | kPa       |
| 34   | EGR Valve Position                          | A/2.55                           | %         |
| 35   | EGR Temperature                             | (256*A+B)/10-40                  | °C        |
| 36   | DPF Differential Pressure                   | (256*A+B)                        | kPa       |
| 37   | DPF Temperature Input                       | (256*A+B)-40                     | °C        |
| 38   | DPF Temperature Output                      | (256*A+B)-40                     | °C        |
| 39   | NOx Sensor 1                                | (256*A+B)                        | ppm       |
| 3A   | NOx Sensor 2                                | (256*A+B)                        | ppm       |

### Hybrid System Data

| PID  | Description                                 | Formula/Notes                    | Units     |
|------|---------------------------------------------|----------------------------------|-----------|
| 60   | HV Battery SOC                              | A/2                              | %         |
| 61   | HV Battery Voltage                          | (256*A+B)/10                     | V         |
| 62   | HV Battery Current                          | (256*A+B-32768)/100              | A         |
| 63   | HV Battery Temperature (Max)                | A-40                             | °C        |
| 64   | HV Battery Temperature (Min)                | A-40                             | °C        |
| 65   | Motor Generator 1 (MG1) Speed               | (256*A+B)-10000                  | rpm       |
| 66   | Motor Generator 2 (MG2) Speed               | (256*A+B)-10000                  | rpm       |
| 67   | MG1 Temperature                             | A-40                             | °C        |
| 68   | MG2 Temperature                             | A-40                             | °C        |
| 69   | Inverter Temperature                        | A-40                             | °C        |
| 6A   | HV Battery Block Voltages (1-14)            | Custom encoding                  | V         |
| 6B   | HV Battery Fan Speed                        | A                                | level     |
| 6C   | HV Battery Cooling Pump                     | 0=Off, 1=On                      | -         |

### CVT Transmission Data

| PID  | Description                                 | Formula/Notes                    | Units     |
|------|---------------------------------------------|----------------------------------|-----------|
| 80   | CVT Fluid Temperature                       | A-40                             | °C        |
| 81   | Primary Pulley Speed                        | (256*A+B)                        | rpm       |
| 82   | Secondary Pulley Speed                      | (256*A+B)                        | rpm       |
| 83   | CVT Ratio                                   | (256*A+B)/1000                   | ratio     |
| 84   | Line Pressure                               | (256*A+B)/10                     | kPa       |
| 85   | Primary Pressure                            | (256*A+B)/10                     | kPa       |
| 86   | Secondary Pressure                          | (256*A+B)/10                     | kPa       |

## Active Test Functions

### Engine Systems

| Test ID | Description                               | Parameters                       |
|---------|-------------------------------------------|----------------------------------|
| 01      | Fuel Injector Cut (Sequential)            | Cylinder 1-8                     |
| 02      | Ignition Cut (Sequential)                 | Cylinder 1-8                     |
| 03      | EVAP System Leak Test                     | Pump ON/OFF                      |
| 04      | Fuel Pump Control                         | ON/OFF, Duty %                   |
| 05      | VVT Control                               | Advance/Retard angle             |
| 06      | EGR Valve Control                         | Position %                       |
| 07      | Throttle Control                          | Position %                       |
| 08      | ISC (Idle Speed Control)                  | Target RPM                       |

### Hybrid Systems

| Test ID | Description                               | Parameters                       |
|---------|-------------------------------------------|----------------------------------|
| 20      | HV Battery Fan Control                    | Speed level 0-3                  |
| 21      | HV Cooling Pump Control                   | ON/OFF                           |
| 22      | MG1 Zero Point Calibration                | Execute                          |
| 23      | MG2 Zero Point Calibration                | Execute                          |
| 24      | HV System Shutdown                        | Execute                          |
| 25      | HV Interlock Check                        | Test                             |

## Data List Parameters

### Engine Control Module (ECM)

| Parameter                        | Normal Range              | Units     |
|----------------------------------|---------------------------|-----------|
| Engine Speed                     | 650-750 (idle)            | rpm       |
| Coolant Temperature              | 80-95 (operating)         | °C        |
| Intake Air Temperature           | Ambient to +40°C          | °C        |
| Mass Air Flow                    | 2-6 (idle)                | g/s       |
| Short Term Fuel Trim B1          | -10 to +10                | %         |
| Long Term Fuel Trim B1           | -10 to +10                | %         |
| O2 Sensor B1S1                   | 0.1-0.9 (switching)       | V         |
| O2 Sensor B1S2                   | 0.6-0.8 (steady)          | V         |
| Fuel Pressure                    | 250-450                   | kPa       |
| EVAP Pressure                    | -10 to +10                | Pa        |

### Hybrid Control Module

| Parameter                        | Normal Range              | Units     |
|----------------------------------|---------------------------|-----------|
| HV Battery SOC                   | 40-80                     | %         |
| HV Battery Voltage               | 200-250                   | V         |
| HV Battery Current               | -100 to +100              | A         |
| HV Insulation Resistance         | >1000                     | kΩ        |
| Inverter Coolant Temperature     | 40-60                     | °C        |
| DC/DC Converter Output           | 13.5-14.5                 | V         |

## Freeze Frame Data (Enhanced)

### Toyota Specific Freeze Frame

| Item | Description                               | Storage Condition             |
|------|-------------------------------------------|-------------------------------|
| 1    | Engine Speed                              | At DTC set                    |
| 2    | Vehicle Speed                             | At DTC set                    |
| 3    | Calculated Load                           | At DTC set                    |
| 4    | Coolant Temperature                       | At DTC set                    |
| 5    | Fuel System Status                        | At DTC set                    |
| 6    | Short Term Fuel Trim                      | At DTC set                    |
| 7    | Long Term Fuel Trim                       | At DTC set                    |
| 8    | Intake Manifold Pressure                  | At DTC set                    |
| 9    | Total Mileage                             | At DTC set                    |
| 10   | Total Engine Run Time                     | At DTC set                    |

## Health Check Functions

### Automatic Inspection Mode

| System              | Tests Performed                          |
|---------------------|------------------------------------------|
| Engine              | Compression, Injectors, Ignition, Sensors |
| Transmission        | Shift Solenoids, Speed Sensors, Pressure  |
| ABS/VSC             | Wheel Sensors, Pump Motor, Solenoids      |
| SRS (Airbag)        | Squib Resistance, Sensors, Warning Light  |
| A/C                 | Compressor, Sensors, Actuators            |
| Hybrid              | HV Battery, Inverter, Motor Generators    |

## Module Addresses and Communication

### CAN IDs (Toyota/Lexus)

| Module                          | Request ID | Response ID | Bus      |
|---------------------------------|------------|-------------|----------|
| Engine ECM                      | 0x7E0      | 0x7E8       | CAN-C    |
| Transmission                    | 0x7E1      | 0x7E9       | CAN-C    |
| ABS/VSC/TRC                     | 0x7B0      | 0x7B8       | CAN-C    |
| SRS Airbag                      | 0x780      | 0x788       | CAN-B    |
| Body Control (BCM)              | 0x750      | 0x758       | CAN-B    |
| Combination Meter               | 0x7C0      | 0x7C8       | CAN-B    |
| Hybrid Control                  | 0x7E2      | 0x7EA       | CAN-HV   |
| Battery Monitor                 | 0x7E3      | 0x7EB       | CAN-HV   |
| Power Management                | 0x7C4      | 0x7CC       | CAN-C    |

### Gateway Configuration

| CAN Bus | Speed    | Modules                              |
|---------|----------|--------------------------------------|
| CAN-C   | 500 kbps | Powertrain, Chassis                  |
| CAN-B   | 125 kbps | Body, Comfort                        |
| CAN-HV  | 500 kbps | Hybrid, High Voltage                 |
| CAN-MM  | 125 kbps | Multimedia, Navigation               |

## Initialization Procedures

### Zero Point Calibration

#### Steering Angle Sensor
1. Turn ignition ON
2. Turn steering wheel full left, then full right
3. Return to center
4. Clear memory using scan tool
5. Perform test drive with turns

#### Yaw Rate/G Sensor
1. Vehicle on level ground
2. Ignition ON, engine OFF
3. Clear memory using scan tool
4. Wait 60 seconds
5. Verify calibration complete

#### Throttle Body
1. Ignition ON, engine OFF
2. Clear DTCs
3. Wait 40 seconds
4. Start engine
5. Verify idle speed stable

## Service Functions

### Maintenance Reset

| System                | Procedure                                     |
|-----------------------|-----------------------------------------------|
| Oil Life              | Mode 04 → Clear codes → Special function 01   |
| Tire Pressure         | Hold TPMS button 3 seconds with ignition ON  |
| DPF Service           | Special regeneration via scan tool            |
| HV Battery Service    | Reset via Techstream only                     |

### Coding and Customization

| Feature                        | Byte | Bit | Values                  |
|--------------------------------|------|-----|-------------------------|
| Auto Door Lock                 | 01   | 0   | 0=Off, 1=On             |
| Lock on Shift from Park        | 01   | 1   | 0=Off, 1=On             |
| Unlock on Shift to Park        | 01   | 2   | 0=Off, 1=On             |
| Key Unlock Mode                | 01   | 3-4 | 00=All, 01=Driver       |
| Interior Light Delay           | 02   | 0-2 | 000=0s to 111=30s       |
| Headlight Auto Off Delay       | 02   | 3-5 | 000=0s to 111=90s       |
| Seat Belt Warning              | 03   | 0   | 0=On, 1=Off             |
| DRL (Daytime Running Lights)   | 03   | 1   | 0=Off, 1=On             |

## Common Toyota/Lexus DTCs

### Engine System

| DTC    | Description                                      |
|--------|--------------------------------------------------|
| P0011  | "A" Camshaft Position - Timing Over-Advanced    |
| P0012  | "A" Camshaft Position - Timing Over-Retarded    |
| P0171  | System Too Lean (Bank 1)                         |
| P0300  | Random/Multiple Cylinder Misfire Detected        |
| P0420  | Catalyst Efficiency Below Threshold (Bank 1)     |
| P0441  | EVAP System Incorrect Purge Flow                |
| P0505  | Idle Control System Malfunction                  |

### Hybrid System

| DTC    | Description                                      |
|--------|--------------------------------------------------|
| P0A0F  | Engine Failed to Start                           |
| P0A78  | Drive Motor "A" Inverter Performance             |
| P0A94  | DC/DC Converter Performance                      |
| P3004  | Battery Block Voltage Variance                   |
| P3011  | Battery Block 1 Weak Cell                        |
| P3125  | Inverter Cooling System Malfunction              |

### VSC/ABS System

| DTC    | Description                                      |
|--------|--------------------------------------------------|
| C0200  | Wheel Speed Sensor "A" Malfunction               |
| C0210  | Wheel Speed Sensor "B" Malfunction               |
| C1201  | Engine Control System Malfunction                |
| C1310  | Open in ABS Motor Relay Circuit                  |
| C1391  | Abnormal Voltage in Yaw Rate Sensor Circuit     |

## Special Features

### Toyota Safety Sense Calibration

| System                        | Requirements                          |
|-------------------------------|---------------------------------------|
| Pre-Collision System          | Target placement, clear weather       |
| Lane Departure Alert          | Road test with clear lane markings    |
| Automatic High Beam           | Night time calibration required       |
| Radar Cruise Control          | Front radar alignment tool            |

### Hybrid Battery Testing

| Test                          | Specification                         |
|-------------------------------|---------------------------------------|
| Block Voltage Variation       | <0.3V between blocks                  |
| Internal Resistance          | <30mΩ per cell                        |
| Capacity Test                 | >70% of new capacity                  |
| Cooling Performance           | ΔT <5°C across battery                |

## Model-Specific Information

### Prius (Gen 3/4)
- HV Battery: 201.6V nominal
- MG1 Max Speed: 10,000 rpm
- MG2 Max Speed: 17,000 rpm

### Camry Hybrid
- HV Battery: 244.8V nominal
- Power Split Device oil temp monitoring
- E-CVT specific diagnostics

### Land Cruiser/4Runner
- Transfer case diagnostics
- Crawl control parameters
- KDSS (Kinetic Dynamic Suspension) data

### Lexus LS/LC
- Air suspension diagnostics
- Multi-stage hybrid parameters
- 10-speed transmission data