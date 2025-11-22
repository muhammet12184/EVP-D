# Electric Vehicle (EV) Specific PIDs and Parameters

## Battery Management System (BMS) PIDs

### High Voltage Battery Parameters

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0001   | Battery State of Charge (SoC)                  | A/2.55                              | %         |
| 0x0002   | Battery State of Health (SoH)                  | A/2.55                              | %         |
| 0x0003   | Battery Pack Voltage                           | (256*A+B)/10                        | V         |
| 0x0004   | Battery Pack Current                           | ((256*A+B)-32768)/10                | A         |
| 0x0005   | Battery Pack Temperature (Average)             | A-40                                | °C        |
| 0x0006   | Battery Pack Temperature (Max)                 | A-40                                | °C        |
| 0x0007   | Battery Pack Temperature (Min)                 | A-40                                | °C        |
| 0x0008   | Battery Available Power (Discharge)            | (256*A+B)/100                       | kW        |
| 0x0009   | Battery Available Power (Charge)               | (256*A+B)/100                       | kW        |
| 0x000A   | Battery Energy Remaining                       | (256*A+B)/100                       | kWh       |
| 0x000B   | Battery Total Energy Capacity                  | (256*A+B)/100                       | kWh       |
| 0x000C   | Battery Insulation Resistance                  | (256*A+B)                           | kΩ        |
| 0x000D   | Battery Cooling System Temperature             | A-40                                | °C        |
| 0x000E   | Battery Heating System Status                  | Bit encoded                         | -         |
| 0x000F   | Battery Thermal Management Request             | A-40                                | °C        |

### Individual Cell Data

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0100   | Number of Battery Cells                        | 256*A+B                             | count     |
| 0x0101   | Cell Voltage 1                                 | (256*A+B)/1000                      | V         |
| 0x0102   | Cell Voltage 2                                 | (256*A+B)/1000                      | V         |
| ...      | ...                                            | ...                                 | ...       |
| 0x01C0   | Cell Voltage 192                               | (256*A+B)/1000                      | V         |
| 0x0200   | Cell Temperature 1                             | A-40                                | °C        |
| 0x0201   | Cell Temperature 2                             | A-40                                | °C        |
| ...      | ...                                            | ...                                 | ...       |
| 0x0240   | Cell Temperature 64                            | A-40                                | °C        |
| 0x0300   | Cell Balance Status                            | Bit encoded (8 cells per byte)     | -         |

### Battery Module Information

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0400   | Number of Battery Modules                      | A                                   | count     |
| 0x0401   | Module 1 Voltage                               | (256*A+B)/10                        | V         |
| 0x0402   | Module 1 Temperature                           | A-40                                | °C        |
| 0x0403   | Module 1 Status                                | Bit encoded                         | -         |
| 0x0410   | Module 2 Voltage                               | (256*A+B)/10                        | V         |
| 0x0411   | Module 2 Temperature                           | A-40                                | °C        |
| 0x0412   | Module 2 Status                                | Bit encoded                         | -         |

## Electric Motor Parameters

### Primary Drive Motor

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0500   | Motor Speed                                    | (256*A+B)-32768                     | rpm       |
| 0x0501   | Motor Torque                                   | ((256*A+B)-32768)/10                | Nm        |
| 0x0502   | Motor Power                                    | ((256*A+B)-32768)/100               | kW        |
| 0x0503   | Motor Temperature (Stator)                     | A-40                                | °C        |
| 0x0504   | Motor Temperature (Rotor)                      | A-40                                | °C        |
| 0x0505   | Motor Temperature (Coolant)                    | A-40                                | °C        |
| 0x0506   | Motor Controller Temperature                   | A-40                                | °C        |
| 0x0507   | Motor Efficiency                               | A/2.55                              | %         |
| 0x0508   | Motor Phase A Current                          | ((256*A+B)-32768)/10                | A         |
| 0x0509   | Motor Phase B Current                          | ((256*A+B)-32768)/10                | A         |
| 0x050A   | Motor Phase C Current                          | ((256*A+B)-32768)/10                | A         |
| 0x050B   | Motor Controller DC Voltage                    | (256*A+B)/10                        | V         |
| 0x050C   | Motor Controller DC Current                    | ((256*A+B)-32768)/10                | A         |
| 0x050D   | Motor Position (Resolver/Encoder)              | (256*A+B)*360/65536                 | degrees   |

### Secondary Drive Motor (if equipped)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0510   | Motor 2 Speed                                  | (256*A+B)-32768                     | rpm       |
| 0x0511   | Motor 2 Torque                                 | ((256*A+B)-32768)/10                | Nm        |
| 0x0512   | Motor 2 Power                                  | ((256*A+B)-32768)/100               | kW        |
| 0x0513   | Motor 2 Temperature (Stator)                   | A-40                                | °C        |

## Charging System Parameters

### AC Charging (Type 1/Type 2)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0600   | AC Charge Port Status                          | Bit encoded                         | -         |
| 0x0601   | AC Charging Current (per phase)                | (256*A+B)/10                        | A         |
| 0x0602   | AC Charging Voltage (per phase)                | (256*A+B)/10                        | V         |
| 0x0603   | AC Charging Power                              | (256*A+B)/100                       | kW        |
| 0x0604   | On-Board Charger Temperature                   | A-40                                | °C        |
| 0x0605   | AC Charge Time Remaining                       | 256*A+B                             | minutes   |
| 0x0606   | AC Charge Energy Delivered                     | (256*A+B)/100                       | kWh       |
| 0x0607   | AC Charge Efficiency                           | A/2.55                              | %         |
| 0x0608   | Pilot Signal Duty Cycle                        | A/2.55                              | %         |
| 0x0609   | Proximity Pilot Status                         | Encoded value                       | -         |

### DC Fast Charging (CCS/CHAdeMO)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0620   | DC Charge Port Status                          | Bit encoded                         | -         |
| 0x0621   | DC Charging Current                            | (256*A+B)/10                        | A         |
| 0x0622   | DC Charging Voltage                            | (256*A+B)/10                        | V         |
| 0x0623   | DC Charging Power                              | (256*A+B)/100                       | kW        |
| 0x0624   | DC Charge Time Remaining                       | 256*A+B                             | minutes   |
| 0x0625   | DC Charge Energy Delivered                     | (256*A+B)/100                       | kWh       |
| 0x0626   | Maximum DC Charge Current Available            | (256*A+B)/10                        | A         |
| 0x0627   | Maximum DC Charge Voltage Available            | (256*A+B)/10                        | V         |
| 0x0628   | DC Charge Communication Protocol               | 0=CCS, 1=CHAdeMO, 2=Tesla          | -         |
| 0x0629   | DC Charge Cable Temperature                    | A-40                                | °C        |
| 0x062A   | DC Charge Connector Temperature                | A-40                                | °C        |

## Power Electronics

### Inverter/Converter Parameters

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0700   | Inverter Temperature (IGBT)                    | A-40                                | °C        |
| 0x0701   | Inverter Temperature (Capacitor)               | A-40                                | °C        |
| 0x0702   | Inverter Temperature (Heatsink)                | A-40                                | °C        |
| 0x0703   | Inverter Input Voltage                         | (256*A+B)/10                        | V         |
| 0x0704   | Inverter Input Current                         | ((256*A+B)-32768)/10                | A         |
| 0x0705   | Inverter Efficiency                            | A/2.55                              | %         |
| 0x0706   | DC-DC Converter Temperature                    | A-40                                | °C        |
| 0x0707   | DC-DC Converter Output Voltage (12V)           | A/10                                | V         |
| 0x0708   | DC-DC Converter Output Current                 | A/10                                | A         |
| 0x0709   | DC-DC Converter Status                         | Bit encoded                         | -         |

## Thermal Management System

### Cooling System

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0800   | Coolant Temperature (Battery Inlet)            | A-40                                | °C        |
| 0x0801   | Coolant Temperature (Battery Outlet)           | A-40                                | °C        |
| 0x0802   | Coolant Temperature (Motor Inlet)              | A-40                                | °C        |
| 0x0803   | Coolant Temperature (Motor Outlet)             | A-40                                | °C        |
| 0x0804   | Coolant Flow Rate                              | A/10                                | L/min     |
| 0x0805   | Coolant Pump Speed                             | 256*A+B                             | rpm       |
| 0x0806   | Coolant Pump Power                             | A                                   | W         |
| 0x0807   | Radiator Fan Speed                             | A/2.55                              | %         |
| 0x0808   | Chiller Temperature                            | A-40                                | °C        |
| 0x0809   | Heat Exchanger Efficiency                      | A/2.55                              | %         |

### Cabin Climate Control

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0820   | Cabin Temperature Setpoint                     | A/2                                 | °C        |
| 0x0821   | Cabin Temperature Actual                       | A-40                                | °C        |
| 0x0822   | Heat Pump Power Consumption                    | (256*A+B)/10                        | W         |
| 0x0823   | Heat Pump COP (Coefficient of Performance)     | A/10                                | ratio     |
| 0x0824   | PTC Heater Power                               | (256*A+B)/10                        | W         |
| 0x0825   | A/C Compressor Speed                           | 256*A+B                             | rpm       |
| 0x0826   | A/C Compressor Power                           | (256*A+B)/10                        | W         |

## Regenerative Braking

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0900   | Regenerative Braking Level                     | A                                   | 0-5       |
| 0x0901   | Regenerative Braking Power                     | ((256*A+B)-32768)/100               | kW        |
| 0x0902   | Regenerative Braking Torque                    | ((256*A+B)-32768)/10                | Nm        |
| 0x0903   | Energy Recovered This Trip                     | (256*A+B)/100                       | kWh       |
| 0x0904   | Energy Recovered Total                         | (256*A+B+C*65536+D*16777216)/100    | kWh       |
| 0x0905   | Brake Blend Status                             | Bit encoded                         | -         |
| 0x0906   | Friction Brake Pressure                        | (256*A+B)/10                        | bar       |

## Energy Management

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0A00   | Trip Energy Consumption                        | (256*A+B)/100                       | kWh       |
| 0x0A01   | Average Energy Consumption                     | (256*A+B)/10                        | Wh/km     |
| 0x0A02   | Instantaneous Energy Consumption               | ((256*A+B)-32768)/10                | W         |
| 0x0A03   | Range Estimate                                 | 256*A+B                             | km        |
| 0x0A04   | Efficiency Score                               | A/2.55                              | %         |
| 0x0A05   | Auxiliary Power Consumption                    | (256*A+B)/10                        | W         |
| 0x0A06   | HVAC Power Consumption                         | (256*A+B)/10                        | W         |
| 0x0A07   | Total System Efficiency                        | A/2.55                              | %         |

## Safety Systems

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0B00   | High Voltage Interlock Status                  | Bit encoded                         | -         |
| 0x0B01   | Ground Fault Detection Status                  | 0=OK, 1=Fault                       | -         |
| 0x0B02   | Emergency Disconnect Status                    | 0=Connected, 1=Disconnected         | -         |
| 0x0B03   | Crash Detection Status                         | Bit encoded                         | -         |
| 0x0B04   | Isolation Monitoring Status                    | 0=OK, 1=Warning, 2=Fault            | -         |
| 0x0B05   | High Voltage Contactor Status                  | Bit encoded                         | -         |
| 0x0B06   | Precharge Circuit Status                       | 0=Open, 1=Precharging, 2=Closed    | -         |

## Vehicle Dynamics (EV Specific)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0C00   | Torque Vectoring Front/Rear Distribution       | A/2.55                              | % front   |
| 0x0C01   | Torque Vectoring Left/Right Distribution       | A/2.55                              | % left    |
| 0x0C02   | One Pedal Driving Mode                         | 0=Off, 1=Low, 2=Normal, 3=High      | -         |
| 0x0C03   | Creep Mode Status                              | 0=Off, 1=On                         | -         |
| 0x0C04   | Launch Control Status                          | 0=Off, 1=Armed, 2=Active            | -         |
| 0x0C05   | Traction Control Intervention (per wheel)      | Bit encoded                         | -         |

## Manufacturer-Specific EV PIDs

### Tesla Model S/X/3/Y

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x0222   | Battery Brick Voltages (96 values)             | Custom encoding                     | V         |
| 0x0282   | Battery Module Temperatures                    | Custom encoding                     | °C        |
| 0x0302   | Drive Unit Power                               | Custom encoding                     | kW        |
| 0x0332   | Supercharger Authentication                    | Custom protocol                     | -         |

### Nissan Leaf

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x5B3    | HV Battery Available Energy                    | ((B<<8)+C)/100                      | kWh       |
| 0x5BC    | LBC Data (incl. Gids)                          | Custom encoding                     | -         |
| 0x5C0    | Battery Temperature Sensors                    | Custom encoding                     | °C        |

### BMW i3/i8/iX

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x6F1_DID_D001 | HV Battery Capacity                     | UDS DID                             | kWh       |
| 0x6F1_DID_D002 | HV Battery SoH                          | UDS DID                             | %         |
| 0x6F1_DID_D003 | Cell Voltage Deviation                  | UDS DID                             | mV        |

### Volkswagen ID.3/ID.4/e-Golf

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1E3D   | HV Battery Net Capacity                        | MEB Platform specific               | kWh       |
| 0x1E3E   | HV Battery Gross Capacity                      | MEB Platform specific               | kWh       |
| 0x1E40   | Charging Curve Limitation                      | Temperature/SoC based               | kW        |

### Hyundai/Kia (Ioniq 5, EV6, Kona EV)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x220101 | Battery Management System Data                 | E-GMP Platform                      | Various   |
| 0x220102 | Cell Voltage Monitoring                        | E-GMP Platform                      | V         |
| 0x220103 | Temperature Distribution                       | E-GMP Platform                      | °C        |
| 0x220104 | V2L (Vehicle to Load) Status                   | E-GMP Platform                      | -         |

## Extended EV Diagnostics

### Battery Degradation Metrics

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1000   | Total Battery Charge Cycles                    | 256*A+B                             | count     |
| 0x1001   | Total Energy Throughput                        | (A<<24)+(B<<16)+(C<<8)+D            | kWh       |
| 0x1002   | Calendar Aging Factor                          | A/2.55                              | %         |
| 0x1003   | Cycling Aging Factor                           | A/2.55                              | %         |
| 0x1004   | Maximum Cell Voltage Difference                | (256*A+B)                           | mV        |
| 0x1005   | Cell Resistance Average                        | (256*A+B)/100                       | mΩ        |
| 0x1006   | Cell Resistance Deviation                      | A                                   | %         |

### Predictive Maintenance

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x1100   | Battery Service Life Remaining                 | 256*A+B                             | days      |
| 0x1101   | Motor Bearing Life Remaining                   | A/2.55                              | %         |
| 0x1102   | Coolant Service Due                            | 256*A+B                             | km        |
| 0x1103   | Brake Fluid Service Due                        | 256*A+B                             | days      |
| 0x1104   | Cabin Air Filter Life                          | A/2.55                              | %         |
| 0x1105   | Battery Coolant Quality                        | A                                   | 0-10      |

## Communication Protocols

### CAN Bus IDs (Common)
```
0x6F1 - Battery Management System
0x6F2 - Motor Controller
0x6F3 - On-Board Charger
0x6F4 - DC-DC Converter
0x6F5 - Thermal Management
0x6F6 - Vehicle Control Unit
```

### Diagnostic Request/Response IDs
```
Physical Addressing:
0x7E0 -> 0x7E8 (ECU 1)
0x7E1 -> 0x7E9 (ECU 2)

Functional Addressing:
0x7DF -> 0x7E8-0x7EF (Broadcast)
```