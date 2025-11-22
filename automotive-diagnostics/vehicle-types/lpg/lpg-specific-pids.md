# LPG (Liquefied Petroleum Gas) Vehicle Specific PIDs and Parameters

## LPG System Overview

LPG vehicles typically operate as bi-fuel systems, capable of running on both petrol and LPG. The diagnostic parameters cover both the LPG-specific components and the integration with the base petrol system.

## LPG Fuel System

### LPG Tank and Fuel Level

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4000   | LPG Tank Level                                 | A/2.55                              | %         |
| 0x4001   | LPG Tank Pressure                              | (256*A+B)/10                        | bar       |
| 0x4002   | LPG Tank Temperature                           | A-40                                | °C        |
| 0x4003   | LPG Fuel Quantity                              | (256*A+B)/100                       | liters    |
| 0x4004   | LPG Tank Capacity                              | (256*A+B)/10                        | liters    |
| 0x4005   | LPG Reserve Level Reached                      | 0=No, 1=Yes                         | -         |
| 0x4006   | LPG Multivalve Status                          | Bit encoded                         | -         |
| 0x4007   | LPG Tank Valve Position                        | 0=Closed, 1=Open                    | -         |
| 0x4008   | LPG Fill Valve Status                          | 0=Closed, 1=Open                    | -         |
| 0x4009   | 80% Fill Limiter Status                        | 0=Inactive, 1=Active                | -         |

### LPG Pressure Regulation

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4010   | LPG Rail Pressure                              | (256*A+B)/100                       | bar       |
| 0x4011   | LPG Rail Pressure Setpoint                     | (256*A+B)/100                       | bar       |
| 0x4012   | LPG Reducer/Vaporizer Pressure                 | (256*A+B)/100                       | bar       |
| 0x4013   | LPG Reducer Temperature                        | A-40                                | °C        |
| 0x4014   | LPG Reducer Heating Water Temperature          | A-40                                | °C        |
| 0x4015   | LPG Pressure Sensor 1                          | (256*A+B)/100                       | bar       |
| 0x4016   | LPG Pressure Sensor 2                          | (256*A+B)/100                       | bar       |
| 0x4017   | LPG Differential Pressure                      | ((256*A+B)-32768)/100               | mbar      |
| 0x4018   | LPG System Vacuum                              | (256*A+B)                           | mbar      |

### LPG Injection System

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4020   | LPG Injector 1 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x4021   | LPG Injector 2 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x4022   | LPG Injector 3 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x4023   | LPG Injector 4 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x4024   | LPG Injector 5 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x4025   | LPG Injector 6 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x4026   | LPG Injector 7 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x4027   | LPG Injector 8 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x4028   | LPG Injection Timing                           | (256*A+B)/10                        | °BTDC     |
| 0x4029   | LPG Injector Correction Factor                 | (A-128)/1.28                        | %         |
| 0x402A   | LPG Base Injection Time                        | (256*A+B)/100                       | ms        |

### LPG Injector Calibration

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4030   | LPG Injector 1 Calibration                     | (256*A+B)/1000                      | ms/ms     |
| 0x4031   | LPG Injector 2 Calibration                     | (256*A+B)/1000                      | ms/ms     |
| 0x4032   | LPG Injector 3 Calibration                     | (256*A+B)/1000                      | ms/ms     |
| 0x4033   | LPG Injector 4 Calibration                     | (256*A+B)/1000                      | ms/ms     |
| 0x4034   | LPG Injector 5 Calibration                     | (256*A+B)/1000                      | ms/ms     |
| 0x4035   | LPG Injector 6 Calibration                     | (256*A+B)/1000                      | ms/ms     |
| 0x4036   | LPG Injector 7 Calibration                     | (256*A+B)/1000                      | ms/ms     |
| 0x4037   | LPG Injector 8 Calibration                     | (256*A+B)/1000                      | ms/ms     |

## Fuel Selection and Switching

### Fuel Mode Control

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4040   | Current Fuel Mode                              | 0=Petrol, 1=LPG, 2=Transition       | -         |
| 0x4041   | Fuel Switch Position                           | 0=Petrol, 1=LPG, 2=Auto             | -         |
| 0x4042   | Automatic Switching Enabled                    | 0=No, 1=Yes                         | -         |
| 0x4043   | LPG Start Enabled                              | 0=No, 1=Yes                         | -         |
| 0x4044   | Switch to LPG Temperature Threshold            | A-40                                | °C        |
| 0x4045   | Switch to LPG RPM Threshold                    | 256*A+B                             | rpm       |
| 0x4046   | Time Since Fuel Switch                         | 256*A+B                             | seconds   |
| 0x4047   | Fuel Switch Inhibit Reasons                    | Bit encoded                         | -         |
| 0x4048   | Emergency Fuel Switch Active                   | 0=No, 1=Yes                         | -         |

## Temperature Management

### LPG System Temperatures

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4050   | LPG Temperature at Injectors                   | A-40                                | °C        |
| 0x4051   | LPG Filter Temperature                         | A-40                                | °C        |
| 0x4052   | LPG ECU Temperature                            | A-40                                | °C        |
| 0x4053   | Vaporizer Water Inlet Temperature              | A-40                                | °C        |
| 0x4054   | Vaporizer Water Outlet Temperature             | A-40                                | °C        |
| 0x4055   | LPG Temperature Sensor 1                       | A-40                                | °C        |
| 0x4056   | LPG Temperature Sensor 2                       | A-40                                | °C        |
| 0x4057   | Ambient Temperature for LPG System             | A-40                                | °C        |

## LPG Fuel Trim and Adaptation

### Short Term Fuel Trim (LPG Mode)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4060   | LPG STFT Bank 1                                | (A-128)/1.28                        | %         |
| 0x4061   | LPG STFT Bank 2                                | (A-128)/1.28                        | %         |
| 0x4062   | LPG STFT Cylinder 1                            | (A-128)/1.28                        | %         |
| 0x4063   | LPG STFT Cylinder 2                            | (A-128)/1.28                        | %         |
| 0x4064   | LPG STFT Cylinder 3                            | (A-128)/1.28                        | %         |
| 0x4065   | LPG STFT Cylinder 4                            | (A-128)/1.28                        | %         |
| 0x4066   | LPG STFT Cylinder 5                            | (A-128)/1.28                        | %         |
| 0x4067   | LPG STFT Cylinder 6                            | (A-128)/1.28                        | %         |

### Long Term Fuel Trim (LPG Mode)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4070   | LPG LTFT Bank 1                                | (A-128)/1.28                        | %         |
| 0x4071   | LPG LTFT Bank 2                                | (A-128)/1.28                        | %         |
| 0x4072   | LPG LTFT at Idle                               | (A-128)/1.28                        | %         |
| 0x4073   | LPG LTFT at Partial Load                       | (A-128)/1.28                        | %         |
| 0x4074   | LPG LTFT at Full Load                          | (A-128)/1.28                        | %         |
| 0x4075   | LPG Global Adaptation Factor                   | (256*A+B)/1000                      | factor    |
| 0x4076   | LPG Adaptation Status                          | 0=Not adapted, 1=Adapted            | -         |

## Safety Systems

### LPG Safety Valves and Sensors

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4080   | LPG Solenoid Valve Status                      | 0=Closed, 1=Open                    | -         |
| 0x4081   | LPG Safety Valve Status                        | 0=Closed, 1=Open                    | -         |
| 0x4082   | LPG Excess Flow Valve Status                   | 0=Normal, 1=Tripped                 | -         |
| 0x4083   | LPG Leak Detection Status                      | 0=OK, 1=Leak detected               | -         |
| 0x4084   | LPG System Pressure Test Result                | 0=Pass, 1=Fail                      | -         |
| 0x4085   | LPG Emergency Shutoff Active                   | 0=No, 1=Yes                         | -         |
| 0x4086   | Crash Detection LPG Shutoff                    | 0=No, 1=Yes                         | -         |
| 0x4087   | LPG System Interlock Status                    | Bit encoded                         | -         |

## Performance Metrics (LPG Mode)

### Engine Performance on LPG

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4090   | Engine Power on LPG                            | (256*A+B)/10                        | kW        |
| 0x4091   | Engine Torque on LPG                           | (256*A+B)-32768                     | Nm        |
| 0x4092   | LPG Consumption Rate                           | (256*A+B)/100                       | L/100km   |
| 0x4093   | LPG Instantaneous Consumption                  | (256*A+B)/100                       | L/h       |
| 0x4094   | Distance on LPG This Trip                      | 256*A+B                             | km        |
| 0x4095   | Total Distance on LPG                          | (A<<24)+(B<<16)+(C<<8)+D            | km        |
| 0x4096   | LPG System Efficiency                          | A/2.55                              | %         |
| 0x4097   | Petrol/LPG Consumption Ratio                   | (256*A+B)/1000                      | ratio     |

## Emissions (LPG Mode)

### Lambda Control on LPG

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x40A0   | Lambda Value on LPG Bank 1                     | (256*A+B)/32768                     | ratio     |
| 0x40A1   | Lambda Value on LPG Bank 2                     | (256*A+B)/32768                     | ratio     |
| 0x40A2   | Lambda Target on LPG                           | (256*A+B)/32768                     | ratio     |
| 0x40A3   | O2 Sensor Voltage B1S1 (LPG)                   | (256*A+B)/1000                      | V         |
| 0x40A4   | O2 Sensor Voltage B1S2 (LPG)                   | (256*A+B)/1000                      | V         |
| 0x40A5   | O2 Sensor Voltage B2S1 (LPG)                   | (256*A+B)/1000                      | V         |
| 0x40A6   | O2 Sensor Voltage B2S2 (LPG)                   | (256*A+B)/1000                      | V         |

### Emission Levels on LPG

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x40B0   | HC Emissions on LPG                            | 256*A+B                             | ppm       |
| 0x40B1   | CO Emissions on LPG                            | (256*A+B)/100                       | %         |
| 0x40B2   | CO2 Emissions on LPG                           | (256*A+B)/10                        | %         |
| 0x40B3   | NOx Emissions on LPG                           | 256*A+B                             | ppm       |
| 0x40B4   | Catalyst Efficiency on LPG                     | A/2.55                              | %         |

## LPG System Diagnostics

### Component Status

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x40C0   | LPG ECU Status                                 | Bit encoded                         | -         |
| 0x40C1   | LPG Pressure Sensor Status                     | 0=OK, 1=Fault                       | -         |
| 0x40C2   | LPG Temperature Sensor Status                  | 0=OK, 1=Fault                       | -         |
| 0x40C3   | LPG Level Sensor Status                        | 0=OK, 1=Fault                       | -         |
| 0x40C4   | LPG Injector Driver Status                     | Bit encoded                         | -         |
| 0x40C5   | LPG MAP Sensor Reading                         | (256*A+B)                           | kPa       |
| 0x40C6   | LPG System Communication Status                | 0=OK, 1=Error                       | -         |
| 0x40C7   | LPG System Self-Test Result                    | 0=Pass, 1=Fail                      | -         |

### Fault Counters

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x40D0   | LPG Misfire Count Cylinder 1                   | 256*A+B                             | count     |
| 0x40D1   | LPG Misfire Count Cylinder 2                   | 256*A+B                             | count     |
| 0x40D2   | LPG Misfire Count Cylinder 3                   | 256*A+B                             | count     |
| 0x40D3   | LPG Misfire Count Cylinder 4                   | 256*A+B                             | count     |
| 0x40D4   | LPG System Error Count                         | 256*A+B                             | count     |
| 0x40D5   | Fuel Switch Failure Count                      | 256*A+B                             | count     |
| 0x40D6   | LPG Start Failure Count                        | 256*A+B                             | count     |

## Advanced LPG Features

### Sequential Gas Injection (SGI)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x40E0   | SGI Phase Shift Cylinder 1                     | (256*A+B)/10                        | °         |
| 0x40E1   | SGI Phase Shift Cylinder 2                     | (256*A+B)/10                        | °         |
| 0x40E2   | SGI Phase Shift Cylinder 3                     | (256*A+B)/10                        | °         |
| 0x40E3   | SGI Phase Shift Cylinder 4                     | (256*A+B)/10                        | °         |
| 0x40E4   | SGI Overlap Time                               | (256*A+B)/100                       | ms        |
| 0x40E5   | SGI End of Injection Timing                    | (256*A+B)/10                        | °ATDC     |

### Direct Injection LPG Systems

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x40F0   | LPG DI Rail Pressure                           | 256*A+B                             | bar       |
| 0x40F1   | LPG DI Pump Pressure                           | 256*A+B                             | bar       |
| 0x40F2   | LPG DI Pump Current                            | (256*A+B)/100                       | A         |
| 0x40F3   | LPG DI Injector Voltage                        | (256*A+B)/10                        | V         |
| 0x40F4   | LPG DI Pre-injection Quantity                  | (256*A+B)/100                       | mg        |
| 0x40F5   | LPG DI Main-injection Quantity                 | (256*A+B)/10                        | mg        |
| 0x40F6   | LPG DI Post-injection Quantity                 | (256*A+B)/100                       | mg        |

## System Specific DTCs

### LPG System DTCs

| DTC      | Description                                    |
|----------|------------------------------------------------|
| P1400    | LPG System Malfunction                         |
| P1401    | LPG Pressure Sensor Circuit                    |
| P1402    | LPG Temperature Sensor Circuit                 |
| P1403    | LPG Level Sensor Circuit                       |
| P1404    | LPG Solenoid Valve Circuit                     |
| P1405    | LPG Reducer Temperature Too Low                |
| P1406    | LPG Reducer Temperature Too High               |
| P1410    | LPG Injector 1 Circuit                         |
| P1411    | LPG Injector 2 Circuit                         |
| P1412    | LPG Injector 3 Circuit                         |
| P1413    | LPG Injector 4 Circuit                         |
| P1420    | LPG Fuel Switch Malfunction                    |
| P1421    | LPG System Pressure Too Low                    |
| P1422    | LPG System Pressure Too High                   |
| P1423    | LPG System Leak Detected                       |

## Manufacturer-Specific LPG Systems

### BRC Gas Equipment

| PID/DID  | Description                                    | Protocol        |
|----------|------------------------------------------------|-----------------|
| BRC_01   | Sequent Plug&Drive Calibration                 | BRC Protocol    |
| BRC_02   | Just Heavy Calibration                         | BRC Protocol    |
| BRC_03   | Sequent 56 Calibration                         | BRC Protocol    |

### Prins VSI System

| PID/DID  | Description                                    | Protocol        |
|----------|------------------------------------------------|-----------------|
| PRINS_01 | VSI DI System Status                           | Prins Protocol  |
| PRINS_02 | Vapourizer Temperature                         | Prins Protocol  |
| PRINS_03 | Fuel Selection Mode                            | Prins Protocol  |

### STAG System

| PID/DID  | Description                                    | Protocol        |
|----------|------------------------------------------------|-----------------|
| STAG_01  | STAG 300 Premium Status                        | STAG Protocol   |
| STAG_02  | Injector Opening Times                         | STAG Protocol   |
| STAG_03  | Reducer Pressure                               | STAG Protocol   |

### Landi Renzo

| PID/DID  | Description                                    | Protocol        |
|----------|------------------------------------------------|-----------------|
| LR_01    | OMEGAS Direct Injection Status                 | Landi Protocol  |
| LR_02    | EVO System Parameters                          | Landi Protocol  |
| LR_03    | DI System Rail Pressure                        | Landi Protocol  |

## Bi-Fuel Operation Statistics

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4100   | Total Fuel Switches Count                      | (256*A+B)                           | count     |
| 0x4101   | Petrol Operation Time                          | (A<<16)+(B<<8)+C                    | hours     |
| 0x4102   | LPG Operation Time                             | (A<<16)+(B<<8)+C                    | hours     |
| 0x4103   | Petrol Consumption Total                       | (A<<16)+(B<<8)+C                    | liters    |
| 0x4104   | LPG Consumption Total                          | (A<<16)+(B<<8)+C                    | liters    |
| 0x4105   | Cost Savings on LPG                            | (256*A+B)                           | currency  |
| 0x4106   | CO2 Reduction on LPG                           | (256*A+B)                           | kg        |

## Service and Maintenance

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x4200   | LPG Filter Service Due                         | 256*A+B                             | km        |
| 0x4201   | LPG Injector Service Due                       | 256*A+B                             | km        |
| 0x4202   | LPG System Calibration Due                     | 256*A+B                             | days      |
| 0x4203   | LPG Tank Inspection Due                        | 256*A+B                             | days      |
| 0x4204   | LPG Reducer Service Counter                    | 256*A+B                             | hours     |
| 0x4205   | LPG System Software Version                    | ASCII encoded                       | -         |
| 0x4206   | LPG System Hardware Version                    | ASCII encoded                       | -         |