# OBD-II Standard PIDs (SAE J1979)

## Mode 01 - Current Data

### Engine and Fuel System PIDs

| PID  | Description                                          | Formula/Notes                                    | Units     |
|------|------------------------------------------------------|--------------------------------------------------|-----------|
| 0x00 | PIDs supported [01 - 20]                             | Bit encoded                                      | -         |
| 0x01 | Monitor status since DTCs cleared                    | Bit encoded                                      | -         |
| 0x02 | Freeze DTC                                           | -                                                | -         |
| 0x03 | Fuel system status                                   | Bit encoded                                      | -         |
| 0x04 | Calculated engine load                               | A/2.55                                           | %         |
| 0x05 | Engine coolant temperature                           | A-40                                             | °C        |
| 0x06 | Short term fuel trim—Bank 1                          | (A-128)/1.28                                     | %         |
| 0x07 | Long term fuel trim—Bank 1                           | (A-128)/1.28                                     | %         |
| 0x08 | Short term fuel trim—Bank 2                          | (A-128)/1.28                                     | %         |
| 0x09 | Long term fuel trim—Bank 2                           | (A-128)/1.28                                     | %         |
| 0x0A | Fuel pressure (gauge pressure)                       | 3*A                                              | kPa       |
| 0x0B | Intake manifold absolute pressure                    | A                                                | kPa       |
| 0x0C | Engine speed                                         | (256*A+B)/4                                      | rpm       |
| 0x0D | Vehicle speed                                        | A                                                | km/h      |
| 0x0E | Timing advance                                       | A/2-64                                           | ° BTDC    |
| 0x0F | Intake air temperature                               | A-40                                             | °C        |
| 0x10 | Mass air flow sensor air flow rate                   | (256*A+B)/100                                    | g/s       |
| 0x11 | Throttle position                                    | A/2.55                                           | %         |
| 0x12 | Commanded secondary air status                       | Bit encoded                                      | -         |
| 0x13 | Oxygen sensors present (in 2 banks)                  | Bit encoded                                      | -         |
| 0x14 | Oxygen Sensor 1 (Bank 1) - Voltage & Trim           | A/200 (voltage), (B-128)/1.28 (trim)            | V, %      |
| 0x15 | Oxygen Sensor 2 (Bank 1) - Voltage & Trim           | A/200 (voltage), (B-128)/1.28 (trim)            | V, %      |
| 0x16 | Oxygen Sensor 3 (Bank 1) - Voltage & Trim           | A/200 (voltage), (B-128)/1.28 (trim)            | V, %      |
| 0x17 | Oxygen Sensor 4 (Bank 1) - Voltage & Trim           | A/200 (voltage), (B-128)/1.28 (trim)            | V, %      |
| 0x18 | Oxygen Sensor 5 (Bank 2) - Voltage & Trim           | A/200 (voltage), (B-128)/1.28 (trim)            | V, %      |
| 0x19 | Oxygen Sensor 6 (Bank 2) - Voltage & Trim           | A/200 (voltage), (B-128)/1.28 (trim)            | V, %      |
| 0x1A | Oxygen Sensor 7 (Bank 2) - Voltage & Trim           | A/200 (voltage), (B-128)/1.28 (trim)            | V, %      |
| 0x1B | Oxygen Sensor 8 (Bank 2) - Voltage & Trim           | A/200 (voltage), (B-128)/1.28 (trim)            | V, %      |
| 0x1C | OBD standards this vehicle conforms to               | Bit encoded                                      | -         |
| 0x1D | Oxygen sensors present (in 4 banks)                  | Bit encoded                                      | -         |
| 0x1E | Auxiliary input status                               | Bit encoded                                      | -         |
| 0x1F | Run time since engine start                          | 256*A+B                                          | seconds   |

### Extended PIDs (0x20 - 0x40)

| PID  | Description                                          | Formula/Notes                                    | Units     |
|------|------------------------------------------------------|--------------------------------------------------|-----------|
| 0x20 | PIDs supported [21 - 40]                             | Bit encoded                                      | -         |
| 0x21 | Distance traveled with MIL on                        | 256*A+B                                          | km        |
| 0x22 | Fuel Rail Pressure (relative to manifold vacuum)     | 0.079*(256*A+B)                                  | kPa       |
| 0x23 | Fuel Rail Gauge Pressure (diesel, gas direct inject) | 10*(256*A+B)                                     | kPa       |
| 0x24 | O2S1_WR_lambda(1) - Voltage & Current               | ((256*A+B)/32768)*2 (lambda), ((256*C+D)/256)-128 | ratio, mA |
| 0x25 | O2S2_WR_lambda(1) - Voltage & Current               | Same as 0x24                                      | ratio, mA |
| 0x26 | O2S3_WR_lambda(1) - Voltage & Current               | Same as 0x24                                      | ratio, mA |
| 0x27 | O2S4_WR_lambda(1) - Voltage & Current               | Same as 0x24                                      | ratio, mA |
| 0x28 | O2S5_WR_lambda(2) - Voltage & Current               | Same as 0x24                                      | ratio, mA |
| 0x29 | O2S6_WR_lambda(2) - Voltage & Current               | Same as 0x24                                      | ratio, mA |
| 0x2A | O2S7_WR_lambda(2) - Voltage & Current               | Same as 0x24                                      | ratio, mA |
| 0x2B | O2S8_WR_lambda(2) - Voltage & Current               | Same as 0x24                                      | ratio, mA |
| 0x2C | Commanded EGR                                        | A/2.55                                           | %         |
| 0x2D | EGR Error                                            | (A-128)/1.28                                     | %         |
| 0x2E | Commanded evaporative purge                          | A/2.55                                           | %         |
| 0x2F | Fuel Tank Level Input                                | A/2.55                                           | %         |
| 0x30 | Warm-ups since codes cleared                         | A                                                | count     |
| 0x31 | Distance traveled since codes cleared                | 256*A+B                                          | km        |
| 0x32 | Evap. System Vapor Pressure                          | (256*A+B)/4 (signed)                             | Pa        |
| 0x33 | Absolute Barometric Pressure                         | A                                                | kPa       |
| 0x34 | O2S1_WR_lambda(1) - Equivalence Ratio & Current    | ((256*A+B)/32768)*2, ((256*C+D)/256)-128        | ratio, mA |
| 0x35 | O2S2_WR_lambda(1) - Equivalence Ratio & Current    | Same as 0x34                                      | ratio, mA |
| 0x36 | O2S3_WR_lambda(1) - Equivalence Ratio & Current    | Same as 0x34                                      | ratio, mA |
| 0x37 | O2S4_WR_lambda(1) - Equivalence Ratio & Current    | Same as 0x34                                      | ratio, mA |
| 0x38 | O2S5_WR_lambda(2) - Equivalence Ratio & Current    | Same as 0x34                                      | ratio, mA |
| 0x39 | O2S6_WR_lambda(2) - Equivalence Ratio & Current    | Same as 0x34                                      | ratio, mA |
| 0x3A | O2S7_WR_lambda(2) - Equivalence Ratio & Current    | Same as 0x34                                      | ratio, mA |
| 0x3B | O2S8_WR_lambda(2) - Equivalence Ratio & Current    | Same as 0x34                                      | ratio, mA |
| 0x3C | Catalyst Temperature: Bank 1, Sensor 1               | (256*A+B)/10-40                                  | °C        |
| 0x3D | Catalyst Temperature: Bank 2, Sensor 1               | (256*A+B)/10-40                                  | °C        |
| 0x3E | Catalyst Temperature: Bank 1, Sensor 2               | (256*A+B)/10-40                                  | °C        |
| 0x3F | Catalyst Temperature: Bank 2, Sensor 2               | (256*A+B)/10-40                                  | °C        |

### Additional PIDs (0x40 - 0x60)

| PID  | Description                                          | Formula/Notes                                    | Units     |
|------|------------------------------------------------------|--------------------------------------------------|-----------|
| 0x40 | PIDs supported [41 - 60]                             | Bit encoded                                      | -         |
| 0x41 | Monitor status this drive cycle                      | Bit encoded                                      | -         |
| 0x42 | Control module voltage                               | (256*A+B)/1000                                   | V         |
| 0x43 | Absolute load value                                  | (256*A+B)/2.55                                   | %         |
| 0x44 | Fuel–Air commanded equivalence ratio                | (256*A+B)/32768                                  | ratio     |
| 0x45 | Relative throttle position                           | A/2.55                                           | %         |
| 0x46 | Ambient air temperature                              | A-40                                             | °C        |
| 0x47 | Absolute throttle position B                         | A/2.55                                           | %         |
| 0x48 | Absolute throttle position C                         | A/2.55                                           | %         |
| 0x49 | Accelerator pedal position D                         | A/2.55                                           | %         |
| 0x4A | Accelerator pedal position E                         | A/2.55                                           | %         |
| 0x4B | Accelerator pedal position F                         | A/2.55                                           | %         |
| 0x4C | Commanded throttle actuator                          | A/2.55                                           | %         |
| 0x4D | Time run with MIL on                                 | 256*A+B                                          | minutes   |
| 0x4E | Time since trouble codes cleared                     | 256*A+B                                          | minutes   |
| 0x4F | Maximum values (various sensors)                     | A,B,C,D for different parameters                 | various   |
| 0x50 | Maximum value for air flow rate from MAF sensor      | 10*A                                             | g/s       |
| 0x51 | Fuel Type                                            | Lookup table                                     | -         |
| 0x52 | Ethanol fuel %                                       | A/2.55                                           | %         |
| 0x53 | Absolute Evap system Vapor Pressure                  | (256*A+B)/200                                    | kPa       |
| 0x54 | Evap system vapor pressure                           | (256*A+B)-32768                                  | Pa        |
| 0x55 | Short term secondary O2 sensor trim bank 1 and 3    | (A-128)/1.28, (B-128)/1.28                       | %         |
| 0x56 | Long term secondary O2 sensor trim bank 1 and 3     | (A-128)/1.28, (B-128)/1.28                       | %         |
| 0x57 | Short term secondary O2 sensor trim bank 2 and 4    | (A-128)/1.28, (B-128)/1.28                       | %         |
| 0x58 | Long term secondary O2 sensor trim bank 2 and 4     | (A-128)/1.28, (B-128)/1.28                       | %         |
| 0x59 | Fuel rail absolute pressure                          | 10*(256*A+B)                                     | kPa       |
| 0x5A | Relative accelerator pedal position                  | A/2.55                                           | %         |
| 0x5B | Hybrid battery pack remaining life                   | A/2.55                                           | %         |
| 0x5C | Engine oil temperature                               | A-40                                             | °C        |
| 0x5D | Fuel injection timing                                | (256*A+B)/128-210                                | °         |
| 0x5E | Engine fuel rate                                     | (256*A+B)/20                                     | L/h       |
| 0x5F | Emission requirements to which vehicle is designed   | Bit encoded                                      | -         |

### PIDs 0x60 - 0x80

| PID  | Description                                          | Formula/Notes                                    | Units     |
|------|------------------------------------------------------|--------------------------------------------------|-----------|
| 0x60 | PIDs supported [61 - 80]                             | Bit encoded                                      | -         |
| 0x61 | Driver's demand engine - percent torque              | A-125                                            | %         |
| 0x62 | Actual engine - percent torque                       | A-125                                            | %         |
| 0x63 | Engine reference torque                              | 256*A+B                                          | Nm        |
| 0x64 | Engine percent torque data                           | A-125 for each byte                              | %         |
| 0x65 | Auxiliary input/output supported                     | Bit encoded                                      | -         |
| 0x66 | Mass air flow sensor                                 | 5 bytes of data                                  | various   |
| 0x67 | Engine coolant temperature                           | 3 bytes for different sensors                    | °C        |
| 0x68 | Intake air temperature sensor                        | 7 bytes for different sensors                    | °C        |
| 0x69 | Commanded EGR and EGR Error                          | 7 bytes of data                                  | various   |
| 0x6A | Commanded Diesel intake air flow control             | 5 bytes of data                                  | various   |
| 0x6B | Exhaust gas recirculation temperature                | 5 bytes of data                                  | °C        |
| 0x6C | Commanded throttle actuator control and position     | 5 bytes of data                                  | %         |
| 0x6D | Fuel pressure control system                         | 6 bytes of data                                  | kPa, %    |
| 0x6E | Injection pressure control system                    | 5 bytes of data                                  | kPa, %    |
| 0x6F | Turbocharger compressor inlet pressure               | 3 bytes of data                                  | kPa       |
| 0x70 | Boost pressure control                               | 10 bytes of data                                 | kPa, %    |
| 0x71 | Variable Geometry turbo (VGT) control                | 6 bytes of data                                  | %         |
| 0x72 | Wastegate control                                    | 5 bytes of data                                  | %         |
| 0x73 | Exhaust pressure                                     | 5 bytes of data                                  | kPa       |
| 0x74 | Turbocharger RPM                                     | 5 bytes of data                                  | rpm       |
| 0x75 | Turbocharger temperature                             | 7 bytes of data                                  | °C        |
| 0x76 | Turbocharger temperature                             | 7 bytes of data                                  | °C        |
| 0x77 | Charge air cooler temperature (CACT)                 | 6 bytes of data                                  | °C        |
| 0x78 | Exhaust Gas temperature (EGT) Bank 1                 | 9 bytes of data                                  | °C        |
| 0x79 | Exhaust Gas temperature (EGT) Bank 2                 | 9 bytes of data                                  | °C        |
| 0x7A | Diesel particulate filter (DPF) differential pressure| 5 bytes of data                                  | kPa       |
| 0x7B | Diesel particulate filter (DPF)                      | 7 bytes of data                                  | kPa       |
| 0x7C | Diesel particulate filter (DPF) temperature          | 9 bytes of data                                  | °C        |
| 0x7D | NOx NTE control area status                          | 1 byte                                           | -         |
| 0x7E | PM NTE control area status                           | 1 byte                                           | -         |
| 0x7F | Engine run time                                      | 13 bytes of data                                 | seconds   |

### PIDs 0x80 - 0xA0

| PID  | Description                                          | Formula/Notes                                    | Units     |
|------|------------------------------------------------------|--------------------------------------------------|-----------|
| 0x80 | PIDs supported [81 - A0]                             | Bit encoded                                      | -         |
| 0x81 | Engine run time for AECD                             | 21 bytes of data                                 | seconds   |
| 0x82 | Engine run time for AECD                             | 21 bytes of data                                 | seconds   |
| 0x83 | NOx sensor                                           | 11 bytes of data                                 | ppm       |
| 0x84 | Manifold surface temperature                         | A-40                                             | °C        |
| 0x85 | NOx reagent system                                   | 10 bytes of data                                 | various   |
| 0x86 | Particulate matter (PM) sensor                       | 5 bytes of data                                  | mg/m³     |
| 0x87 | Intake manifold absolute pressure                    | 5 bytes of data                                  | kPa       |
| 0x88 | SCR Induce System                                    | 13 bytes of data                                 | various   |
| 0x89 | Run Time for AECD #11-#15                            | 41 bytes of data                                 | seconds   |
| 0x8A | Run Time for AECD #16-#20                            | 41 bytes of data                                 | seconds   |
| 0x8B | Diesel Aftertreatment                                | 7 bytes of data                                  | various   |
| 0x8C | O2 Sensor (wide range)                               | 17 bytes of data                                 | various   |
| 0x8D | Throttle Position G                                  | A/2.55                                           | %         |
| 0x8E | Engine Friction - Percent Torque                     | A-125                                            | %         |
| 0x8F | PM Sensor Bank 1 & 2                                 | 13 bytes of data                                 | mg/m³     |
| 0x90 | WWH-OBD Vehicle OBD System Info                      | 3 bytes of data                                  | -         |
| 0x91 | WWH-OBD Vehicle OBD System Info                      | 5 bytes of data                                  | -         |
| 0x92 | Fuel System Control                                  | A                                                | -         |
| 0x93 | WWH-OBD Vehicle OBD Counters                         | 3 bytes of data                                  | -         |
| 0x94 | NOx Warning And Inducement System                    | 12 bytes of data                                 | various   |
| 0x95-0x97 | Reserved by ISO/SAE                              | -                                                | -         |
| 0x98 | Exhaust Gas Temperature Sensor                       | 17 bytes of data                                 | °C        |
| 0x99 | Exhaust Gas Temperature Sensor                       | 17 bytes of data                                 | °C        |
| 0x9A | Hybrid/EV Vehicle System Data, Battery, Voltage     | 8 bytes of data                                  | various   |
| 0x9B | Diesel Exhaust Fluid Sensor Data                     | 4 bytes of data                                  | various   |
| 0x9C | O2 Sensor Data                                       | 17 bytes of data                                 | various   |
| 0x9D | Engine Fuel Rate                                     | 17 bytes of data                                 | g/s       |
| 0x9E | Engine Exhaust Flow Rate                             | 9 bytes of data                                  | kg/h      |
| 0x9F | Fuel System Percentage Use                           | 17 bytes of data                                 | %         |

### PIDs 0xA0 - 0xC0

| PID  | Description                                          | Formula/Notes                                    | Units     |
|------|------------------------------------------------------|--------------------------------------------------|-----------|
| 0xA0 | PIDs supported [A1 - C0]                             | Bit encoded                                      | -         |
| 0xA1 | NOx Sensor Corrected Data                            | 17 bytes of data                                 | ppm       |
| 0xA2 | Cylinder Fuel Rate                                   | 17 bytes of data                                 | mg/stroke |
| 0xA3 | Evap System Vapor Pressure                           | 9 bytes of data                                  | Pa        |
| 0xA4 | Transmission Actual Gear                             | (256*A+B)/1000, (256*C+D)/1000                   | ratio     |
| 0xA5 | Commanded Diesel Exhaust Fluid Dosing                | A/2.55, B/2.55                                   | %         |
| 0xA6 | Odometer                                             | (A*2^24+B*2^16+C*2^8+D)/10                       | km        |
| 0xA7 | NOx Sensor Concentration                             | 11 bytes of data                                 | ppm       |
| 0xA8 | NOx Sensor Corrected Concentration                   | 11 bytes of data                                 | ppm       |
| 0xA9 | ABS Disable Switch State                             | Bit encoded                                      | -         |
| 0xAA-0xBF | Reserved for future expansion                   | -                                                | -         |

## Other OBD-II Modes

### Mode 02 - Freeze Frame Data
- Same PIDs as Mode 01, but showing data at the time a DTC was set

### Mode 03 - Request Trouble Codes
- Returns stored diagnostic trouble codes (DTCs)

### Mode 04 - Clear Trouble Codes
- Clears all stored DTCs and related data

### Mode 05 - Oxygen Sensor Monitoring Test Results
- Test results for oxygen sensor monitoring (non-CAN only)

### Mode 06 - On-Board Monitoring Test Results
- Test results for continuously and non-continuously monitored systems

### Mode 07 - Pending Trouble Codes
- Shows DTCs detected during current or last driving cycle

### Mode 08 - Control Operation of On-Board Systems
- Special test modes and bi-directional controls

### Mode 09 - Request Vehicle Information
| PID  | Description                                          |
|------|------------------------------------------------------|
| 0x00 | Supported PIDs                                       |
| 0x01 | VIN Message Count                                    |
| 0x02 | Vehicle Identification Number (VIN)                  |
| 0x03 | Calibration ID message count                         |
| 0x04 | Calibration ID                                       |
| 0x05 | CVN Message Count                                    |
| 0x06 | Calibration Verification Numbers (CVN)               |
| 0x07 | In-use performance tracking message count            |
| 0x08 | In-use performance tracking                          |
| 0x09 | ECU name message count                               |
| 0x0A | ECU name                                             |
| 0x0B | In-use performance tracking                          |

### Mode 0A (10) - Permanent Trouble Codes
- Emission-related DTCs that cannot be cleared by Mode 04

## Notes on Data Format
- A, B, C, D represent bytes returned in the response
- Formulas show how to convert raw bytes to meaningful values
- Bit encoded values need to be interpreted based on specific bit positions
- Not all PIDs are supported by all vehicles
- Always check PID 0x00, 0x20, 0x40, etc. for supported PIDs first