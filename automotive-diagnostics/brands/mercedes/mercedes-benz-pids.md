# Mercedes-Benz Specific PIDs and Diagnostics

## Overview

Mercedes-Benz vehicles use sophisticated diagnostic systems with proprietary extensions beyond standard OBD-II. Modern vehicles use UDS (ISO 14229) over CAN with manufacturer-specific implementations.

## Mercedes-Benz Diagnostic Protocols

### Protocol Evolution
- Pre-1993: Proprietary 38-pin diagnostic connector
- 1993-1995: ISO 9141 (K-Line) with HFM/LH systems
- 1996-2003: ISO 9141-2 / ISO 14230 (KWP2000)
- 2004-2015: ISO 15765 (CAN) with proprietary extensions
- 2016+: Enhanced UDS with DoIP, FlexRay integration

### Diagnostic Connectors
- X11/4: 38-pin (older models)
- X11/16: OBD-II 16-pin (1996+)
- X129/1: Ethernet diagnostic port (2016+)

## Control Module Identification

### Module Naming Convention

| Code | Module Description                    | German Name                    |
|------|---------------------------------------|--------------------------------|
| ME   | Motor Electronics (Engine)            | Motorelektronik                |
| EGS  | Electronic Gear Selector              | Elektronisches Getriebe        |
| ESP  | Electronic Stability Program          | Elektronisches Stabilitäts     |
| SRS  | Supplemental Restraint System         | Airbag                         |
| SAM  | Signal Acquisition Module             | Signal-Ansteuer-Modul          |
| CGW  | Central Gateway                       | Zentrales Gateway              |
| EZS  | Electronic Ignition Switch            | Elektronisches Zündschloss     |
| KI   | Instrument Cluster                    | Kombiinstrument                |

## Live Data Parameters (Actual Values)

### ME - Motor Electronics (Engine Control)

#### Gasoline Engines

| Parameter | Description                          | Formula/Notes                 | Units    |
|-----------|--------------------------------------|-------------------------------|----------|
| B2/3      | Engine speed                         | Value * 1                     | rpm      |
| B2/4      | Engine coolant temperature           | Value - 40                    | °C       |
| B2/5      | Intake air temperature               | Value - 40                    | °C       |
| B2/6      | Battery voltage                      | Value * 0.1                   | V        |
| B3/1      | Lambda control bank 1                | (Value - 128) * 0.78125       | %        |
| B3/2      | Lambda control bank 2                | (Value - 128) * 0.78125       | %        |
| B3/7      | Ignition timing cylinder 1           | (Value - 128) * 0.75          | °KW      |
| B28/1     | Fuel pressure (low)                  | Value * 10                    | kPa      |
| B28/2     | Fuel pressure (high) - DI            | Value * 100                   | kPa      |
| B28/6     | Injection time bank 1                | Value * 0.01                  | ms       |
| B28/7     | Injection time bank 2                | Value * 0.01                  | ms       |
| B5/1      | Air mass actual                      | Value * 0.1                   | kg/h     |
| B5/2      | Air mass specified                   | Value * 0.1                   | kg/h     |
| B11/4     | Camshaft adjustment intake bank 1    | (Value - 128) * 0.5           | °KW      |
| B11/5     | Camshaft adjustment exhaust bank 1   | (Value - 128) * 0.5           | °KW      |
| B11/6     | Camshaft adjustment intake bank 2    | (Value - 128) * 0.5           | °KW      |
| B11/7     | Camshaft adjustment exhaust bank 2   | (Value - 128) * 0.5           | °KW      |

#### Diesel Engines (CDI)

| Parameter | Description                          | Formula/Notes                 | Units    |
|-----------|--------------------------------------|-------------------------------|----------|
| B2/3      | Engine speed                         | Value * 1                     | rpm      |
| B2/4      | Engine coolant temperature           | Value - 40                    | °C       |
| B2/8      | Fuel temperature                     | Value - 40                    | °C       |
| B40/1     | Rail pressure actual                 | Value * 10                    | bar      |
| B40/2     | Rail pressure specified              | Value * 10                    | bar      |
| B40/3     | Injection quantity                   | Value * 0.01                  | mg/str   |
| B40/4     | Start of injection                   | (Value - 128) * 0.5           | °KW      |
| B70/1     | Boost pressure actual                | Value * 10                    | hPa      |
| B70/2     | Boost pressure specified             | Value * 10                    | hPa      |
| B70/5     | EGR rate                             | Value * 1                     | %        |
| B95/1     | DPF differential pressure            | Value * 1                     | mbar     |
| B95/2     | DPF soot load calculated             | Value * 1                     | %        |
| B95/6     | DPF temperature upstream             | (Value * 5) - 40              | °C       |
| B95/7     | DPF temperature downstream           | (Value * 5) - 40              | °C       |

### EGS - Electronic Transmission

#### 7G-Tronic/9G-Tronic Parameters

| Parameter | Description                          | Formula/Notes                 | Units    |
|-----------|--------------------------------------|-------------------------------|----------|
| Y3/8n2    | Transmission oil temperature         | Value - 40                    | °C       |
| Y3/8n3    | Torque converter lockup clutch       | Value * 1                     | %        |
| Y3/8n4    | Current gear                         | Direct value                  | gear     |
| Y3/8n5    | Target gear                          | Direct value                  | gear     |
| B27/5     | Turbine speed                        | Value * 1                     | rpm      |
| B27/6     | Output speed                         | Value * 1                     | rpm      |
| P2/1      | Working pressure                     | Value * 10                    | kPa      |
| P2/2      | Modulating pressure                  | Value * 10                    | kPa      |
| S1-S6     | Shift solenoid states                | 0=Off, 1=On                   | -        |

### ESP - Electronic Stability Program

| Parameter | Description                          | Formula/Notes                 | Units    |
|-----------|--------------------------------------|-------------------------------|----------|
| C1/1      | Vehicle speed                        | Value * 0.625                 | km/h     |
| C1/2      | Steering angle                       | (Value - 2048) * 0.1          | °        |
| C1/3      | Lateral acceleration                 | (Value - 128) * 0.01          | g        |
| C1/4      | Yaw rate                             | (Value - 128) * 0.01          | °/s      |
| C1/5      | Brake pressure                       | Value * 1                     | bar      |
| C4/1-4    | Wheel speed sensors 1-4              | Value * 0.04                  | km/h     |
| C30/1     | ASR intervention counter             | Direct value                  | count    |
| C30/2     | ESP intervention counter             | Direct value                  | count    |
| C30/3     | ABS intervention counter             | Direct value                  | count    |

## Adaptations and Coding

### ME - Engine Adaptations

| Adaptation | Description                         | Value Range      | Notes           |
|------------|-------------------------------------|------------------|-----------------|
| HFM_ADP    | Air mass adaptation                 | 0.75 - 1.25      | Multiplicative  |
| LAM_ADP_1  | Lambda adaptation bank 1            | -25% to +25%     | Additive        |
| LAM_ADP_2  | Lambda adaptation bank 2            | -25% to +25%     | Additive        |
| ZYL_ZW_1-8 | Cylinder timing correction 1-8      | -5° to +5°       | Cylinder balance|
| DKP_ADP    | Throttle position adaptation        | Learned values   | Auto-learn      |

### EGS - Transmission Adaptations

| Adaptation | Description                         | Value Range      | Notes           |
|------------|-------------------------------------|------------------|-----------------|
| NAG_ADP    | Clutch fill adaptations             | Learned values   | Per clutch      |
| GNG_ADP    | Gear engagement adaptations         | Learned values   | Per gear        |
| KUP_ADP    | Torque converter adaptation         | Learned values   | Lock-up point   |
| OEL_ADP    | Oil aging adaptation                | 0-100%           | Service life    |

## SCN Coding (Software Calibration Number)

### SCN Coding Process
1. Connect to Mercedes-Benz server (XENTRY)
2. Read vehicle VIN and current coding
3. Server provides updated SCN based on:
   - VIN-specific options
   - Regional requirements
   - Latest software updates
4. Download and flash new calibration

### Common SCN Coding Changes

| System | SCN Type | Purpose                              |
|--------|----------|--------------------------------------|
| ME     | Variant  | Engine variant, emissions standard   |
| EGS    | Update   | Shift characteristics, TCM software  |
| ESP    | Initial  | Vehicle dynamics calibration         |
| SAM    | Retrofit | Add equipment (lights, sensors)      |
| KOMBI  | Display  | Language, units, display options     |

## Actuations (Component Activation)

### Engine Actuations

| Component                    | Test Description             | Expected Result        |
|------------------------------|------------------------------|------------------------|
| Fuel injectors 1-8           | Sequential cutout            | RPM drop, roughness    |
| Ignition coils 1-8           | Sequential cutout            | RPM drop, misfire      |
| Throttle valve               | Sweep 0-100%                 | Smooth movement        |
| Camshaft adjusters           | Min/Max position             | ±20-50° range          |
| Fuel pump                    | ON/OFF control               | Pressure change        |
| EVAP canister purge          | 0-100% duty cycle            | Idle quality change    |
| Secondary air pump           | ON/OFF                       | Audible operation      |
| Radiator fans                | Low/High speed               | Fan activation         |

### Transmission Actuations

| Component                    | Test Description             | Expected Result        |
|------------------------------|------------------------------|------------------------|
| Shift solenoids 1-6          | Individual ON/OFF            | Pressure change        |
| Pressure control solenoids   | 0-100% duty cycle            | Pressure regulation    |
| Torque converter clutch      | Lock/Unlock                  | RPM change             |
| Park lock                    | Engage/Release               | Mechanical movement    |

## Special Functions

### DAS (Drive Authorization System)

#### Key Programming Procedure
1. All keys must be present
2. EZS learns key transponders
3. ME/EGS learn EZS
4. Rolling code synchronization
5. Transport mode deactivation

#### Emergency Start
- Special procedure when key not recognized
- Requires security code calculation
- Time-limited operation

### Diesel Particulate Filter

#### Forced Regeneration
1. Engine at operating temperature
2. Fuel level > 25%
3. No DPF-related faults
4. Initiate via XENTRY
5. Drive at highway speeds
6. Monitor temperatures

#### DPF Reset After Replacement
1. Clear adaptations
2. Reset soot load counter
3. Reset ash load counter
4. Reset differential pressure offset
5. Perform forced regeneration

### Service Reset Functions

| Service Type          | Reset Method                         | Interval Reset    |
|-----------------------|--------------------------------------|-------------------|
| Engine Oil            | ASSYST PLUS reset via cluster        | Days and km       |
| Transmission Fluid    | EGS adaptation reset                 | km/months         |
| Brake Fluid           | Maintenance computer                 | 2 years           |
| Cabin Filter          | Maintenance computer                 | km/months         |
| Engine Air Filter     | Maintenance computer                 | km based          |
| Spark Plugs           | Maintenance counter                  | km based          |
| DEF/AdBlue            | ME system reset                      | Refill based      |

## Communication Networks

### CAN Bus Architecture

| Network      | Speed    | Connected Modules                    |
|--------------|----------|--------------------------------------|
| CAN-C (PT)   | 500 kbps | Engine, Trans, ESP, SRS              |
| CAN-B (Body) | 83 kbps  | SAM-F/R, Door modules, Seats         |
| CAN-D (Diag) | 500 kbps | Diagnostic gateway                   |
| MOST         | 25 Mbps  | COMAND, Audio, Telephone             |
| FlexRay      | 10 Mbps  | Active suspension, safety systems    |
| LIN          | 20 kbps  | Mirrors, wipers, sensors             |

### Gateway Security

| Access Level | Requirements                | Permissions              |
|--------------|----------------------------|--------------------------|
| Level 1      | Standard OBD-II            | Emissions data only      |
| Level 2      | Mercedes diagnostic tool   | Read all data            |
| Level 3      | Online authentication      | Programming, coding      |
| Level 4      | Developer mode             | Engineering access       |

## Model-Specific Features

### AMG Models
- Additional performance parameters
- Race timer functionality
- Launch control settings
- Drift mode parameters (C63, E63)
- Track telemetry data

### S-Class / Maybach
- MAGIC BODY CONTROL data
- Rear axle steering parameters
- Executive rear seat diagnostics
- Perfume atomizer control
- Massage seat diagnostics

### G-Class
- Three differential lock status
- Low range transfer case
- Off-road telemetry
- Tire pressure for off-road

### EQ Electric Models
- HV battery cell voltages
- Thermal management data
- Charging system diagnostics
- Energy consumption analysis
- Recuperation settings

## Diagnostic Trouble Codes

### Mercedes-Specific DTC Format
- P-codes: Powertrain (standard + manufacturer)
- B-codes: Body systems
- C-codes: Chassis systems
- U-codes: Network communication
- Format: Letter + 4 digits (e.g., P2004)

### Common Mercedes DTCs

#### Engine
| Code  | Description                                    |
|-------|------------------------------------------------|
| P0170 | Fuel trim malfunction (bank 1)                 |
| P0173 | Fuel trim malfunction (bank 2)                 |
| P0410 | Secondary air injection system                 |
| P2004 | Intake manifold runner control stuck           |
| P2029 | Fuel fired heater performance                  |

#### Transmission
| Code  | Description                                    |
|-------|------------------------------------------------|
| P0715 | Turbine speed sensor circuit                   |
| P0720 | Output speed sensor circuit                    |
| P0730 | Incorrect gear ratio                           |
| P2767 | Turbine speed sensor B circuit no signal       |

#### Network
| Code  | Description                                    |
|-------|------------------------------------------------|
| U0100 | Lost communication with ECM/PCM                |
| U0140 | Lost communication with body control module    |
| U0164 | Lost communication with HVAC module            |
| U0428 | Invalid data received from steering module     |

## Advanced Diagnostics

### Cylinder Balance Test
```
Actual values → Group 015
- Displays contribution of each cylinder
- Values in mm³/stroke or % deviation
- ±3 mm³/stroke is acceptable
```

### Compression Test (Electronic)
```
Actual values → Group 020
- Relative compression per cylinder
- Reference cylinder = 100%
- All cylinders should be within 10%
```

### Smooth Running Values
```
Actual values → Group 016
- Crankshaft acceleration per cylinder
- Lower values = better combustion
- Compare cylinder to cylinder
```

## Programming and Flashing

### Flash Programming Requirements
- Stable 13V+ battery voltage
- Battery charger connected
- All doors closed
- Key in position 2
- No active DTCs in target module
- Stable communication link

### Recovery Mode
- Boot mode for corrupted modules
- Requires special cable/procedure
- Direct memory access
- Emergency flash capability