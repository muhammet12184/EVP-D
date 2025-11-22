# BMW Specific PIDs and Diagnostics

## Overview

BMW vehicles use advanced diagnostic systems with extensive proprietary protocols. Modern BMWs primarily use FlexRay and CAN-FD networks with UDS protocol, while maintaining backwards compatibility with older protocols.

## BMW Diagnostic Protocols

### Protocol History
- Pre-1988: BMW proprietary (20-pin connector)
- 1988-1995: ADS (BMW diagnostic interface)
- 1995-2001: DS2 protocol (Diagnosis System 2)
- 2001-2007: GT1 era (K-CAN, PT-CAN, MOST)
- 2008-2016: ISTA/D, ISTA/P introduction
- 2017+: ISTA+ unified platform, Ethernet diagnostics

### Network Architecture
- K-CAN: Body electronics (100 kbps)
- PT-CAN: Powertrain (500 kbps)
- F-CAN: Chassis/safety (500 kbps)
- FlexRay: Advanced driver assistance
- MOST: Multimedia/infotainment
- Ethernet: Programming, ADAS (100 Mbps)

## Status Information (ISTA Status)

### DME/DDE - Engine Control

#### N-Series Gasoline Engines

| Status            | Description                      | Formula/Notes              | Units    |
|-------------------|----------------------------------|----------------------------|----------|
| DREHZAHL         | Engine speed                     | Direct value               | rpm      |
| LAST             | Engine load                      | Value * 0.1                | %        |
| TEMP_MOT         | Engine temperature               | Value - 48                 | °C       |
| TEMP_ANS         | Intake air temperature           | Value - 48                 | °C       |
| UBATT            | Battery voltage                  | Value * 0.1                | V        |
| LUFTMASSE        | Air mass flow                    | Value * 0.1                | kg/h     |
| DROS_KLAPPE      | Throttle position                | Value * 0.1                | %        |
| LAMB_VORKAT_1    | Pre-cat lambda bank 1            | Value * 0.001              | ratio    |
| LAMB_VORKAT_2    | Pre-cat lambda bank 2            | Value * 0.001              | ratio    |
| ZUNDWINKEL       | Ignition timing                  | Value * 0.75 - 48          | °BTDC    |
| EINSPRITZ_MS     | Injection time                   | Value * 0.01               | ms       |
| KRAFTST_DRUCK    | Fuel pressure (GDI)              | Value * 10                 | bar      |

#### Valvetronic Parameters

| Status            | Description                      | Formula/Notes              | Units    |
|-------------------|----------------------------------|----------------------------|----------|
| VVT_HUB_IST      | Valvetronic actual position      | Value * 0.01               | mm       |
| VVT_HUB_SOLL     | Valvetronic target position      | Value * 0.01               | mm       |
| VVT_SERVO_POS    | Valvetronic motor position       | Value * 1                  | steps    |
| VVT_ADAPTATION   | Valvetronic adaptation           | Encoded values             | -        |
| VVT_NOTLAUF      | Valvetronic emergency mode       | 0=No, 1=Yes                | -        |

#### VANOS Parameters

| Status            | Description                      | Formula/Notes              | Units    |
|-------------------|----------------------------------|----------------------------|----------|
| VANOS_EIN_IST_1  | Intake VANOS actual bank 1       | Value * 0.1                | °CA      |
| VANOS_EIN_SOLL_1 | Intake VANOS target bank 1       | Value * 0.1                | °CA      |
| VANOS_AUS_IST_1  | Exhaust VANOS actual bank 1      | Value * 0.1                | °CA      |
| VANOS_AUS_SOLL_1 | Exhaust VANOS target bank 1      | Value * 0.1                | °CA      |
| VANOS_EIN_IST_2  | Intake VANOS actual bank 2       | Value * 0.1                | °CA      |
| VANOS_EIN_SOLL_2 | Intake VANOS target bank 2       | Value * 0.1                | °CA      |

### DDE - Diesel Engine Control

| Status            | Description                      | Formula/Notes              | Units    |
|-------------------|----------------------------------|----------------------------|----------|
| RAIL_IST         | Rail pressure actual             | Value * 10                 | bar      |
| RAIL_SOLL        | Rail pressure target             | Value * 10                 | bar      |
| MENGE_EIN        | Injection quantity               | Value * 0.01               | mg/hub   |
| BEGINN_EIN       | Injection timing                 | Value * 0.1 - 78           | °BTDC    |
| LADEDRUCK_IST    | Boost pressure actual            | Value * 10                 | mbar     |
| LADEDRUCK_SOLL   | Boost pressure target            | Value * 10                 | mbar     |
| AGR_RATE         | EGR rate                         | Value * 0.1                | %        |
| DPF_BELADUNG     | DPF soot load                    | Value * 0.1                | g        |
| DPF_TEMP_VOR     | DPF temperature before           | Value * 5 - 50             | °C       |
| DPF_TEMP_NACH    | DPF temperature after            | Value * 5 - 50             | °C       |

### EGS - Electronic Transmission

#### 8HP ZF Transmission

| Status            | Description                      | Formula/Notes              | Units    |
|-------------------|----------------------------------|----------------------------|----------|
| GETRIEBE_TEMP    | Transmission temperature         | Value - 50                 | °C       |
| TURBINEN_DZ      | Turbine speed                    | Direct value               | rpm      |
| ABTRIEB_DZ       | Output shaft speed               | Direct value               | rpm      |
| GANG_IST         | Current gear                     | Direct value               | -        |
| GANG_ZIEL        | Target gear                      | Direct value               | -        |
| KUPPLUNG_A-F     | Clutch pressure A-F              | Value * 0.1                | bar      |
| WANDLER_KUPPLUNG | Torque converter lockup          | Value * 1                  | %        |
| SPORT_MODUS      | Sport mode active                | 0=No, 1=Yes                | -        |

### DSC - Dynamic Stability Control

| Status            | Description                      | Formula/Notes              | Units    |
|-------------------|----------------------------------|----------------------------|----------|
| FZGE_V           | Vehicle speed                    | Value * 0.1                | km/h     |
| LENKWINKEL       | Steering wheel angle             | Value * 0.1                | °        |
| GIERRATE         | Yaw rate                         | Value * 0.01               | °/s      |
| QUERBESCHL       | Lateral acceleration             | Value * 0.01               | g        |
| BREMSDRUCK       | Brake pressure                   | Value * 1                  | bar      |
| RAD_V_VL         | Wheel speed front left           | Value * 0.1                | km/h     |
| RAD_V_VR         | Wheel speed front right          | Value * 0.1                | km/h     |
| RAD_V_HL         | Wheel speed rear left            | Value * 0.1                | km/h     |
| RAD_V_HR         | Wheel speed rear right           | Value * 0.1                | km/h     |

## Service Functions (BMW ISTA)

### CBS - Condition Based Service

| Service Item          | Reset ID | Scope                            |
|-----------------------|----------|----------------------------------|
| Engine Oil            | 00       | Reset counter + date             |
| Microfilter           | 01       | Reset counter + date             |
| Spark Plugs           | 02       | Reset counter                    |
| Front Brakes          | 03       | Reset counter                    |
| Rear Brakes           | 04       | Reset counter                    |
| Brake Fluid           | 05       | Reset date (2 years)             |
| Diesel Particulate    | 06       | Reset counter + regeneration     |
| Fuel Filter (Diesel)  | 07       | Reset counter                    |
| Air Filter            | 08       | Reset counter                    |
| DEF/AdBlue            | 09       | Reset level + quality            |

### Vehicle Order (FA/VO) Coding

#### Reading FA (Factory Equipment)
1. Connect to CAS/FEM module
2. Read vehicle order
3. Decode option codes
4. Verify against build sheet

#### Common Option Codes
| Code | Description                          |
|------|--------------------------------------|
| 1CA  | Selection COP relevant vehicles      |
| 2PA  | Locking wheel bolts                  |
| 302  | Alarm system                         |
| 316  | Automatic trunk lid                  |
| 3AG  | Reversing camera                     |
| 431  | Interior mirror with auto dimming    |
| 5AC  | High beam assistant                  |
| 609  | Navigation system Professional       |
| 6FL  | USB/Audio interface                  |
| 6NF  | Music interface for smartphone       |
| 6WA  | Instrument cluster extended          |

## Adaptations and Programming

### DME/DDE Adaptations

#### Throttle Adaptation
```
Service Function → Engine Electronics → Throttle Valve Adaptation
- Ignition ON, Engine OFF
- Clear adaptations
- Perform adaptation
- Verify learned values
```

#### Injector Quantity Compensation (Diesel)
```
Test Plan → Engine → Adjustment → Injector Quantity Compensation
- Read current values
- Replace injector if needed
- Enter new IMA/ISA codes
- Perform adaptation
```

### Transmission Adaptations

#### Clutch Learning (Automatic)
```
Service Function → Transmission → Teaching Process
- ATF at operating temperature
- Perform driving cycle
- Monitor adaptation values
- Values saved automatically
```

### Steering Angle Sensor

#### Calibration Procedure
```
Service Function → Chassis → Steering Angle Sensor Calibration
- Wheels straight ahead
- Engine running
- Clear offset
- Turn lock to lock
- Return to center
- Save calibration
```

## Component Activations

### Engine Components

| Component              | Activation Test              | Expected Response       |
|------------------------|------------------------------|-------------------------|
| Fuel injectors         | Cylinder cutout test         | RPM fluctuation         |
| Ignition coils         | Spark duration test          | Misfire detection       |
| VANOS solenoids        | Min/max position test        | Camshaft movement       |
| Valvetronic motor      | Emergency run position       | Fixed valve lift        |
| Electric water pump    | Speed control 0-100%         | Flow/temperature change |
| Fuel pumps (HPFP)      | Pressure test                | Rail pressure increase  |
| Turbo wastegate        | Open/close test              | Boost pressure change   |

### Chassis Components

| Component              | Activation Test              | Expected Response       |
|------------------------|------------------------------|-------------------------|
| DSC pump motor         | Pump test                    | Audible operation       |
| DSC inlet valves       | Individual test              | Pressure change         |
| DSC outlet valves      | Individual test              | Pressure release        |
| Steering assist motor  | Current test                 | Steering feel change    |
| EDC dampers            | Soft/hard test               | Damping change          |
| Air suspension         | Height adjustment            | Vehicle height change   |
| Active stabilizer      | Bar adjustment               | Roll resistance change  |

## Advanced Diagnostics

### DME Shadow Memory

#### Reading Shadow Codes
- Stores faults that don't set CEL
- Environmental conditions when fault occurred
- Freeze frame data for each event
- Up to 20 shadow codes stored

### Smooth Running Detection

| Cylinder | Threshold Value | Status                    |
|----------|-----------------|---------------------------|
| 1-6/8    | < 1.5           | Good                      |
| 1-6/8    | 1.5 - 3.0       | Marginal                  |
| 1-6/8    | > 3.0           | Poor (misfire likely)     |

### Fuel System Status

#### High Pressure Test (GDI)
```
Status → DME → Fuel Pressure
- Monitor at idle: 50-70 bar
- Monitor at WOT: 150-200 bar
- Pressure drop test: < 10 bar/10 min
```

## Coding Examples

### FRM - Footwell Module

#### Lighting Functions
```
Parameter: XENON_VL_ENABLE
Values: nicht_aktiv (0x00), aktiv (0x01)
Function: Enable xenon headlight coding

Parameter: TAGFAHRLICHT_ECE
Values: nicht_aktiv, aktiv
Function: Daytime running lights

Parameter: WELCOME_LIGHT_TIME
Values: 0-240 seconds
Function: Welcome light duration
```

### KOMBI - Instrument Cluster

#### Display Options
```
Parameter: BC_DIGITAL_V
Values: nicht_aktiv, aktiv
Function: Digital speed display

Parameter: SPORT_DISPLAYS
Values: nicht_aktiv, aktiv
Function: Sport displays (power/torque)

Parameter: VARIABLE_TACHOMETER
Values: nicht_aktiv, aktiv
Function: Variable redline display
```

## Model-Specific Features

### M Performance Models
- Launch control activation
- M Drive mode configuration
- Differential lock settings
- Engine sound enhancement
- Track data recording

### Electric/Hybrid (BMW i)
- High voltage battery status
- Cell voltage monitoring
- Isolation resistance
- Charging system diagnostics
- Electric motor parameters
- Thermal management data

### 7 Series / X7 Executive
- Rear seat entertainment
- Executive lounge features
- Air suspension diagnostics
- Soft-close door systems
- Gesture control calibration

## Diagnostic Trouble Codes

### BMW-Specific DTC Format
- 4-digit hex codes (e.g., 29DC)
- Shadow codes (no MIL illumination)
- Network codes (FlexRay, MOST)
- Manufacturer-specific P-codes

### Common BMW Fault Codes

#### Engine (N20/N55/B58)
| Code | Description                                   |
|------|-----------------------------------------------|
| 29DC | Cylinder misfire, several cylinders           |
| 29CE | Misfire detection, cylinder 1                 |
| 30FF | Turbocharger, boost pressure too low         |
| 2C7C | Charging pressure control deviation           |
| 2DED | Valvetronic motor, activation                |

#### Transmission (8HP)
| Code | Description                                   |
|------|-----------------------------------------------|
| 4F85 | Ratio monitoring, gearshift 4-5              |
| 4F8D | Ratio monitoring, gearshift 5-6              |
| 5088 | EGS internal fault                           |
| CF17 | Mechatronics emergency operation             |

#### Chassis (DSC)
| Code | Description                                   |
|------|-----------------------------------------------|
| 5E20 | Steering angle sensor, internal              |
| 5DF0 | Lateral acceleration sensor                   |
| 5E24 | Yaw rate sensor                              |
| 6131 | Battery voltage low                          |

## Programming and Flashing

### Integration Level (I-Step)
- Determines software compatibility
- Must match across all modules
- Updated with vehicle programming
- Check before any module replacement

### Flash Programming Requirements
- Stable power supply (charger connected)
- Minimum 70% battery charge
- All doors closed
- Vehicle in park
- Key in position 2
- No active critical faults

### TAL (Technical Application List)
- Process all required measures
- Software updates
- Recall campaigns
- Quality improvements
- Must complete in sequence

## Security Features

### CAS (Car Access System)
- Key learning procedures
- ISN (Individual Serial Number) synchronization
- Transport mode activation/deactivation
- Anti-theft alarm coding

### FEM/BDC (Front Electronic Module)
- Enhanced security over CAS
- Requires online authentication
- Key programming via ISTA
- Secure gateway functions