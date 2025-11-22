# Diesel Engine Specific PIDs and Parameters

## Common Rail Fuel System

### High Pressure Fuel System

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0F23   | Fuel Rail Pressure (diesel)                    | 10*(256*A+B)                        | kPa       |
| 0x0F24   | Fuel Rail Pressure Setpoint                    | 10*(256*A+B)                        | kPa       |
| 0x0F25   | Fuel Rail Pressure Control                     | (A-128)/1.28                        | %         |
| 0x0F26   | Fuel Pressure Regulator Control                | A/2.55                              | %         |
| 0x0F27   | Fuel Pressure Regulator Position               | A/2.55                              | %         |
| 0x0F28   | High Pressure Pump Current                     | (256*A+B)/100                       | A         |
| 0x0F29   | Fuel Volume Control Valve Position             | A/2.55                              | %         |
| 0x0F2A   | Fuel Metering Unit Position                    | A/2.55                              | %         |
| 0x0F2B   | Low Pressure Fuel Pump Pressure                | A*3                                 | kPa       |
| 0x0F2C   | Fuel Temperature (at rail)                     | A-40                                | °C        |
| 0x0F2D   | Fuel Temperature (return)                      | A-40                                | °C        |
| 0x0F2E   | Fuel Filter Differential Pressure              | (256*A+B)/10                        | kPa       |

### Fuel Injection System

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0F30   | Injection Timing (Main)                        | (256*A+B)/128-210                   | °BTDC     |
| 0x0F31   | Injection Timing (Pilot 1)                     | (256*A+B)/128-210                   | °BTDC     |
| 0x0F32   | Injection Timing (Pilot 2)                     | (256*A+B)/128-210                   | °BTDC     |
| 0x0F33   | Injection Timing (Post 1)                      | (256*A+B)/128-210                   | °ATDC     |
| 0x0F34   | Injection Timing (Post 2)                      | (256*A+B)/128-210                   | °ATDC     |
| 0x0F35   | Injection Quantity (Main)                      | (256*A+B)/100                       | mg/stroke |
| 0x0F36   | Injection Quantity (Pilot 1)                   | A/10                                | mg/stroke |
| 0x0F37   | Injection Quantity (Pilot 2)                   | A/10                                | mg/stroke |
| 0x0F38   | Injection Quantity (Post 1)                    | A/10                                | mg/stroke |
| 0x0F39   | Injection Quantity (Post 2)                    | A/10                                | mg/stroke |
| 0x0F3A   | Injector 1 Correction                          | (A-128)/1.28                        | %         |
| 0x0F3B   | Injector 2 Correction                          | (A-128)/1.28                        | %         |
| 0x0F3C   | Injector 3 Correction                          | (A-128)/1.28                        | %         |
| 0x0F3D   | Injector 4 Correction                          | (A-128)/1.28                        | %         |
| 0x0F3E   | Injector 5 Correction                          | (A-128)/1.28                        | %         |
| 0x0F3F   | Injector 6 Correction                          | (A-128)/1.28                        | %         |

### Injector Diagnostics

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0F40   | Injector 1 Voltage                             | (256*A+B)/100                       | V         |
| 0x0F41   | Injector 1 Pulse Width                         | (256*A+B)                           | μs        |
| 0x0F42   | Injector 1 Return Flow                         | (256*A+B)/100                       | ml/min    |
| 0x0F43   | Injector 1 Leakage Rate                        | A/10                                | ml/min    |
| 0x0F44   | Injector Balance Rate Cylinder 1               | ((256*A+B)-32768)/100               | mm³/stroke|
| 0x0F45   | Injector Balance Rate Cylinder 2               | ((256*A+B)-32768)/100               | mm³/stroke|
| 0x0F46   | Injector Balance Rate Cylinder 3               | ((256*A+B)-32768)/100               | mm³/stroke|
| 0x0F47   | Injector Balance Rate Cylinder 4               | ((256*A+B)-32768)/100               | mm³/stroke|

## Turbocharger System

### Single Turbo Parameters

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0F70   | Turbocharger RPM                               | 256*A+B*10                          | rpm       |
| 0x0F71   | Turbocharger Boost Pressure                    | (256*A+B)/10                        | kPa       |
| 0x0F72   | Turbocharger Boost Pressure Setpoint           | (256*A+B)/10                        | kPa       |
| 0x0F73   | VGT (Variable Geometry Turbo) Position         | A/2.55                              | %         |
| 0x0F74   | VGT Position Setpoint                          | A/2.55                              | %         |
| 0x0F75   | Wastegate Position                             | A/2.55                              | %         |
| 0x0F76   | Turbocharger Temperature (Inlet)               | (256*A+B)/10-40                     | °C        |
| 0x0F77   | Turbocharger Temperature (Outlet)              | (256*A+B)/10-40                     | °C        |
| 0x0F78   | Compressor Outlet Temperature                  | A-40                                | °C        |
| 0x0F79   | Intercooler Temperature (Inlet)                | A-40                                | °C        |
| 0x0F7A   | Intercooler Temperature (Outlet)               | A-40                                | °C        |
| 0x0F7B   | Intercooler Efficiency                         | A/2.55                              | %         |

### Twin Turbo Parameters

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0F80   | Turbo 1 (Low Pressure) RPM                     | 256*A+B*10                          | rpm       |
| 0x0F81   | Turbo 2 (High Pressure) RPM                    | 256*A+B*10                          | rpm       |
| 0x0F82   | Turbo 1 Boost Pressure                         | (256*A+B)/10                        | kPa       |
| 0x0F83   | Turbo 2 Boost Pressure                         | (256*A+B)/10                        | kPa       |
| 0x0F84   | Turbo 1 VGT Position                           | A/2.55                              | %         |
| 0x0F85   | Turbo 2 VGT Position                           | A/2.55                              | %         |

## EGR (Exhaust Gas Recirculation) System

### EGR Valve and Flow

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0F90   | EGR Valve Position                             | A/2.55                              | %         |
| 0x0F91   | EGR Valve Position Setpoint                    | A/2.55                              | %         |
| 0x0F92   | EGR Mass Flow Rate                             | (256*A+B)/10                        | kg/h      |
| 0x0F93   | EGR Temperature (Inlet)                        | (256*A+B)/10-40                     | °C        |
| 0x0F94   | EGR Temperature (Outlet)                       | (256*A+B)/10-40                     | °C        |
| 0x0F95   | EGR Cooler Temperature (Inlet)                 | A-40                                | °C        |
| 0x0F96   | EGR Cooler Temperature (Outlet)                | A-40                                | °C        |
| 0x0F97   | EGR Cooler Efficiency                          | A/2.55                              | %         |
| 0x0F98   | EGR Differential Pressure                      | (256*A+B)-32768                     | Pa        |
| 0x0F99   | Low Pressure EGR Valve Position                | A/2.55                              | %         |
| 0x0F9A   | High Pressure EGR Valve Position               | A/2.55                              | %         |

## DPF (Diesel Particulate Filter) System

### DPF Sensors and Status

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0FA0   | DPF Differential Pressure                      | (256*A+B)/10                        | kPa       |
| 0x0FA1   | DPF Soot Load (Calculated)                     | A/2.55                              | %         |
| 0x0FA2   | DPF Soot Load (Measured)                       | A/2.55                              | %         |
| 0x0FA3   | DPF Temperature (Inlet)                        | (256*A+B)/10-40                     | °C        |
| 0x0FA4   | DPF Temperature (Middle)                       | (256*A+B)/10-40                     | °C        |
| 0x0FA5   | DPF Temperature (Outlet)                       | (256*A+B)/10-40                     | °C        |
| 0x0FA6   | DPF Regeneration Status                        | 0=Off, 1=Active, 2=Passive          | -         |
| 0x0FA7   | DPF Regeneration Type                          | 0=None, 1=Passive, 2=Active, 3=Forced | -       |
| 0x0FA8   | Distance Since Last Regen                      | 256*A+B                             | km        |
| 0x0FA9   | Time Since Last Regen                          | 256*A+B                             | minutes   |
| 0x0FAA   | Number of Regenerations                        | 256*A+B                             | count     |
| 0x0FAB   | DPF Ash Load                                   | A/2.55                              | %         |
| 0x0FAC   | DPF Service Life Remaining                     | A/2.55                              | %         |

### DPF Regeneration Control

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0FB0   | Post Injection Quantity (Regen)                | (256*A+B)/100                       | mg/stroke |
| 0x0FB1   | Post Injection Timing (Regen)                  | (256*A+B)/10                        | °ATDC     |
| 0x0FB2   | Exhaust Temperature Target (Regen)             | (256*A+B)                           | °C        |
| 0x0FB3   | HC Doser Injection Rate                        | (256*A+B)/100                       | g/s       |
| 0x0FB4   | Regen Inhibit Status                           | Bit encoded                         | -         |
| 0x0FB5   | Regen Request Status                           | 0=None, 1=Driver, 2=Automatic       | -         |

## SCR (Selective Catalytic Reduction) System

### AdBlue/DEF System

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0FC0   | AdBlue/DEF Level                               | A/2.55                              | %         |
| 0x0FC1   | AdBlue/DEF Temperature                         | A-40                                | °C        |
| 0x0FC2   | AdBlue/DEF Quality                             | A/2.55                              | %         |
| 0x0FC3   | AdBlue/DEF Consumption Rate                    | (256*A+B)/100                       | ml/100km  |
| 0x0FC4   | AdBlue/DEF Injection Rate                      | (256*A+B)/100                       | g/s       |
| 0x0FC5   | AdBlue/DEF Pressure                            | (256*A+B)/10                        | kPa       |
| 0x0FC6   | AdBlue/DEF Pump Status                         | Bit encoded                         | -         |
| 0x0FC7   | AdBlue/DEF Heater Status                       | 0=Off, 1=On, 2=Fault                | -         |
| 0x0FC8   | AdBlue/DEF Tank Heater Temperature             | A-40                                | °C        |
| 0x0FC9   | AdBlue/DEF Line Heater Status                  | Bit encoded                         | -         |

### SCR Catalyst

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0FD0   | SCR Catalyst Temperature (Inlet)               | (256*A+B)/10-40                     | °C        |
| 0x0FD1   | SCR Catalyst Temperature (Outlet)              | (256*A+B)/10-40                     | °C        |
| 0x0FD2   | SCR Efficiency                                 | A/2.55                              | %         |
| 0x0FD3   | SCR NOx Conversion Rate                        | A/2.55                              | %         |
| 0x0FD4   | SCR Ammonia Slip                               | (256*A+B)                           | ppm       |
| 0x0FD5   | SCR Catalyst Loading                           | A/2.55                              | %         |

### NOx Sensors

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0FE0   | NOx Sensor 1 (Pre-SCR) Concentration           | (256*A+B)                           | ppm       |
| 0x0FE1   | NOx Sensor 2 (Post-SCR) Concentration          | (256*A+B)                           | ppm       |
| 0x0FE2   | NOx Sensor 1 Temperature                       | A-40                                | °C        |
| 0x0FE3   | NOx Sensor 2 Temperature                       | A-40                                | °C        |
| 0x0FE4   | NOx Sensor 1 Status                            | Bit encoded                         | -         |
| 0x0FE5   | NOx Sensor 2 Status                            | Bit encoded                         | -         |
| 0x0FE6   | NOx Reduction Efficiency                       | A/2.55                              | %         |

## Glow Plug System

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1000   | Glow Plug Relay Status                         | 0=Off, 1=On                         | -         |
| 0x1001   | Glow Plug Relay Voltage                        | A/10                                | V         |
| 0x1002   | Glow Plug 1 Current                            | A/10                                | A         |
| 0x1003   | Glow Plug 2 Current                            | A/10                                | A         |
| 0x1004   | Glow Plug 3 Current                            | A/10                                | A         |
| 0x1005   | Glow Plug 4 Current                            | A/10                                | A         |
| 0x1006   | Glow Plug 5 Current                            | A/10                                | A         |
| 0x1007   | Glow Plug 6 Current                            | A/10                                | A         |
| 0x1008   | Glow Plug Control Module Temperature           | A-40                                | °C        |
| 0x1009   | Pre-Heat Time                                  | A*100                               | ms        |
| 0x100A   | Post-Heat Time                                 | 256*A+B                             | seconds   |

## Air Intake System

### Mass Air Flow and Boost Control

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1100   | MAF Sensor 1 (Pre-turbo)                       | (256*A+B)/10                        | g/s       |
| 0x1101   | MAF Sensor 2 (Post-turbo)                      | (256*A+B)/10                        | g/s       |
| 0x1102   | Calculated Air Mass                            | (256*A+B)/10                        | g/s       |
| 0x1103   | Air/Fuel Ratio Actual                          | (256*A+B)/1000                      | ratio     |
| 0x1104   | Air/Fuel Ratio Commanded                       | (256*A+B)/1000                      | ratio     |
| 0x1105   | Boost Pressure Control Valve                   | A/2.55                              | %         |
| 0x1106   | Intake Manifold Runner Position                | A/2.55                              | %         |
| 0x1107   | Swirl Flap Position                            | A/2.55                              | %         |
| 0x1108   | Charge Air Cooler Bypass Valve                 | 0=Closed, 1=Open                    | -         |

## Exhaust System

### Exhaust Temperature Management

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1200   | Exhaust Temperature Bank 1 Sensor 1            | (256*A+B)/10-40                     | °C        |
| 0x1201   | Exhaust Temperature Bank 1 Sensor 2            | (256*A+B)/10-40                     | °C        |
| 0x1202   | Exhaust Temperature Bank 1 Sensor 3            | (256*A+B)/10-40                     | °C        |
| 0x1203   | Exhaust Temperature Bank 2 Sensor 1            | (256*A+B)/10-40                     | °C        |
| 0x1204   | Exhaust Temperature Bank 2 Sensor 2            | (256*A+B)/10-40                     | °C        |
| 0x1205   | Exhaust Temperature Bank 2 Sensor 3            | (256*A+B)/10-40                     | °C        |
| 0x1206   | Exhaust Brake Position                         | A/2.55                              | %         |
| 0x1207   | Exhaust Brake Pressure                         | (256*A+B)/10                        | kPa       |

## Engine Oil System (Diesel Specific)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1300   | Oil Level                                      | A/2.55                              | %         |
| 0x1301   | Oil Quality/Dilution                           | A/2.55                              | %         |
| 0x1302   | Oil Change Interval Remaining                  | 256*A+B                             | km        |
| 0x1303   | Oil Pressure (Gallery)                         | (256*A+B)/10                        | kPa       |
| 0x1304   | Oil Pressure (Turbo Feed)                      | (256*A+B)/10                        | kPa       |
| 0x1305   | Oil Temperature (Gallery)                      | A-40                                | °C        |
| 0x1306   | Oil Temperature (Sump)                         | A-40                                | °C        |
| 0x1307   | Oil Cooler Temperature Delta                   | A/2                                 | °C        |

## Cylinder Pressure Monitoring (Advanced Diesels)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1400   | Cylinder 1 Peak Pressure                       | (256*A+B)                           | bar       |
| 0x1401   | Cylinder 2 Peak Pressure                       | (256*A+B)                           | bar       |
| 0x1402   | Cylinder 3 Peak Pressure                       | (256*A+B)                           | bar       |
| 0x1403   | Cylinder 4 Peak Pressure                       | (256*A+B)                           | bar       |
| 0x1404   | Cylinder 1 Peak Pressure Angle                 | (256*A+B)/10                        | °ATDC     |
| 0x1405   | Cylinder 2 Peak Pressure Angle                 | (256*A+B)/10                        | °ATDC     |
| 0x1406   | Cylinder 3 Peak Pressure Angle                 | (256*A+B)/10                        | °ATDC     |
| 0x1407   | Cylinder 4 Peak Pressure Angle                 | (256*A+B)/10                        | °ATDC     |
| 0x1408   | IMEP (Indicated Mean Effective Pressure)       | (256*A+B)/10                        | bar       |

## Diesel Specific DTCs

### Common Rail System DTCs

| DTC      | Description                                    |
|----------|------------------------------------------------|
| P0087    | Fuel Rail/System Pressure - Too Low            |
| P0088    | Fuel Rail/System Pressure - Too High           |
| P0089    | Fuel Pressure Regulator 1 Performance          |
| P0090    | Fuel Pressure Regulator 1 Control Circuit      |
| P0091    | Fuel Pressure Regulator 1 Control Circuit Low  |
| P0092    | Fuel Pressure Regulator 1 Control Circuit High |
| P0093    | Fuel System Leak Detected - Large Leak         |
| P0094    | Fuel System Leak Detected - Small Leak         |
| P0201-6  | Injector Circuit Malfunction - Cylinder 1-6    |
| P0261-96 | Injector Circuit Low/High - Cylinder 1-6       |

### DPF/SCR System DTCs

| DTC      | Description                                    |
|----------|------------------------------------------------|
| P2002    | DPF Efficiency Below Threshold Bank 1          |
| P2003    | DPF Efficiency Below Threshold Bank 2          |
| P2452    | DPF Pressure Sensor A Circuit                  |
| P2453    | DPF Pressure Sensor A Performance              |
| P244A    | DPF Differential Pressure Too Low              |
| P244B    | DPF Differential Pressure Too High             |
| P20EE    | SCR NOx Catalyst Efficiency Below Threshold    |
| P20E8    | Reductant Pressure Too Low                     |
| P20E9    | Reductant Pressure Too High                    |
| P203F    | Reductant Level Too Low                        |
| P204F    | Reductant System Performance                   |

### Turbocharger DTCs

| DTC      | Description                                    |
|----------|------------------------------------------------|
| P0045    | Turbo/Super Charger Boost Control A Circuit    |
| P0046    | Turbo/Super Charger Boost Control A Range      |
| P0047    | Turbo/Super Charger Boost Control A Low        |
| P0048    | Turbo/Super Charger Boost Control A High       |
| P0234    | Turbocharger Overboost Condition               |
| P0299    | Turbocharger Underboost Condition              |
| P2262    | Turbo Boost Pressure Not Detected              |
| P2263    | Turbo/Super Charger Boost System Performance   |

## Manufacturer-Specific Diesel PIDs

### Volkswagen TDI

| PID/DID  | Description                                    | Measuring Block |
|----------|------------------------------------------------|-----------------|
| Group 001| Injection Quantity                             | MVB 001         |
| Group 002| Engine Speed, Load, Coolant Temp               | MVB 002         |
| Group 003| EGR, Intake Air Mass                           | MVB 003         |
| Group 004| Injection Timing                               | MVB 004         |
| Group 011| Fuel Pressure, Rail Pressure                   | MVB 011         |

### BMW Diesel

| PID/DID       | Description                               | Access          |
|---------------|-------------------------------------------|-----------------|
| 0x1279        | DDE Rail Pressure Actual                  | KWP2000         |
| 0x127A        | DDE Rail Pressure Setpoint                | KWP2000         |
| 0x127B        | DDE Injection Quantity                    | KWP2000         |
| 0x127C        | DDE EGR Rate                              | KWP2000         |

### Mercedes-Benz CDI

| PID/DID       | Description                               | Protocol        |
|---------------|-------------------------------------------|-----------------|
| 0x07E0_22F40B | Actual Rail Pressure                      | UDS             |
| 0x07E0_22F40C | Desired Rail Pressure                     | UDS             |
| 0x07E0_22F423 | Actual Injection Quantity                 | UDS             |
| 0x07E0_22F450 | DPF Soot Load                             | UDS             |

### Ford Power Stroke

| PID/DID       | Description                               | Module          |
|---------------|-------------------------------------------|-----------------|
| 0x0640        | ICP (Injection Control Pressure)          | PCM             |
| 0x0641        | ICP Voltage                               | PCM             |
| 0x0642        | IPR (Injection Pressure Regulator)        | PCM             |
| 0x0643        | FICM Main Power                           | FICM            |
| 0x0644        | FICM Logic Power                          | FICM            |

## Diesel Hybrid Specific

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1500   | Electric Motor Assist Torque                   | ((256*A+B)-32768)/10                | Nm        |
| 0x1501   | Battery SOC (48V System)                       | A/2.55                              | %         |
| 0x1502   | Electric Turbo Speed                           | 256*A+B*10                          | rpm       |
| 0x1503   | Electric Turbo Power                           | (256*A+B)/10                        | W         |
| 0x1504   | Regenerative Braking Energy (Diesel)           | (256*A+B)/100                       | kWh       |
| 0x1505   | Stop/Start Events Counter                      | 256*A+B                             | count     |