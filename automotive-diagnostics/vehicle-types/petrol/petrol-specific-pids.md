# Petrol/Gasoline Engine Specific PIDs and Parameters

## Fuel System

### Port Fuel Injection

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2000   | Fuel Injector 1 Pulse Width                    | (256*A+B)/100                       | ms        |
| 0x2001   | Fuel Injector 2 Pulse Width                    | (256*A+B)/100                       | ms        |
| 0x2002   | Fuel Injector 3 Pulse Width                    | (256*A+B)/100                       | ms        |
| 0x2003   | Fuel Injector 4 Pulse Width                    | (256*A+B)/100                       | ms        |
| 0x2004   | Fuel Injector 5 Pulse Width                    | (256*A+B)/100                       | ms        |
| 0x2005   | Fuel Injector 6 Pulse Width                    | (256*A+B)/100                       | ms        |
| 0x2006   | Fuel Injector 7 Pulse Width                    | (256*A+B)/100                       | ms        |
| 0x2007   | Fuel Injector 8 Pulse Width                    | (256*A+B)/100                       | ms        |
| 0x2008   | Fuel Injector Base Pulse Width                 | (256*A+B)/100                       | ms        |
| 0x2009   | Fuel Injector Timing                           | (256*A+B)/10-360                    | °BTDC     |
| 0x200A   | Fuel Pump Duty Cycle                           | A/2.55                              | %         |
| 0x200B   | Fuel Pump Current                              | (256*A+B)/100                       | A         |
| 0x200C   | Fuel Pump Voltage                              | A/10                                | V         |

### Direct Injection (GDI)

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2020   | High Pressure Fuel Pump Pressure               | 10*(256*A+B)                        | kPa       |
| 0x2021   | High Pressure Fuel Pump Current                | (256*A+B)/100                       | A         |
| 0x2022   | Fuel Rail Pressure (GDI)                       | 10*(256*A+B)                        | kPa       |
| 0x2023   | Fuel Rail Pressure Setpoint (GDI)              | 10*(256*A+B)                        | kPa       |
| 0x2024   | GDI Injector 1 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x2025   | GDI Injector 2 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x2026   | GDI Injector 3 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x2027   | GDI Injector 4 Pulse Width                     | (256*A+B)/100                       | ms        |
| 0x2028   | GDI Injection Timing (Main)                    | (256*A+B)/10                        | °BTDC     |
| 0x2029   | GDI Injection Timing (Split)                   | (256*A+B)/10                        | °BTDC     |
| 0x202A   | Number of GDI Injection Events                 | A                                   | count     |

### Fuel Adaptation/Learning

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2040   | Long Term Fuel Trim Bank 1 (Idle)              | (A-128)/1.28                        | %         |
| 0x2041   | Long Term Fuel Trim Bank 1 (Part Load)         | (A-128)/1.28                        | %         |
| 0x2042   | Long Term Fuel Trim Bank 1 (Full Load)         | (A-128)/1.28                        | %         |
| 0x2043   | Long Term Fuel Trim Bank 2 (Idle)              | (A-128)/1.28                        | %         |
| 0x2044   | Long Term Fuel Trim Bank 2 (Part Load)         | (A-128)/1.28                        | %         |
| 0x2045   | Long Term Fuel Trim Bank 2 (Full Load)         | (A-128)/1.28                        | %         |
| 0x2046   | Fuel System Status Bank 1                      | Bit encoded                         | -         |
| 0x2047   | Fuel System Status Bank 2                      | Bit encoded                         | -         |
| 0x2048   | Alcohol Content in Fuel                        | A/2.55                              | %         |

## Ignition System

### Ignition Timing and Control

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2100   | Ignition Timing Cylinder 1                     | (256*A+B)/10-64                     | °BTDC     |
| 0x2101   | Ignition Timing Cylinder 2                     | (256*A+B)/10-64                     | °BTDC     |
| 0x2102   | Ignition Timing Cylinder 3                     | (256*A+B)/10-64                     | °BTDC     |
| 0x2103   | Ignition Timing Cylinder 4                     | (256*A+B)/10-64                     | °BTDC     |
| 0x2104   | Ignition Timing Cylinder 5                     | (256*A+B)/10-64                     | °BTDC     |
| 0x2105   | Ignition Timing Cylinder 6                     | (256*A+B)/10-64                     | °BTDC     |
| 0x2106   | Ignition Timing Cylinder 7                     | (256*A+B)/10-64                     | °BTDC     |
| 0x2107   | Ignition Timing Cylinder 8                     | (256*A+B)/10-64                     | °BTDC     |
| 0x2108   | Base Ignition Timing                           | (256*A+B)/10-64                     | °BTDC     |
| 0x2109   | Total Ignition Advance                         | (256*A+B)/10-64                     | °BTDC     |
| 0x210A   | Knock Retard Cylinder 1                        | A/10                                | °         |
| 0x210B   | Knock Retard Cylinder 2                        | A/10                                | °         |
| 0x210C   | Knock Retard Cylinder 3                        | A/10                                | °         |
| 0x210D   | Knock Retard Cylinder 4                        | A/10                                | °         |

### Ignition Coil Diagnostics

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2120   | Ignition Coil 1 Primary Current                | (256*A+B)/100                       | A         |
| 0x2121   | Ignition Coil 1 Dwell Time                     | (256*A+B)/100                       | ms        |
| 0x2122   | Ignition Coil 1 Charge Time                    | (256*A+B)/100                       | ms        |
| 0x2123   | Ignition Coil 1 Burn Time                      | (256*A+B)                           | μs        |
| 0x2124   | Ignition Coil 1 Primary Voltage                | A/10                                | V         |
| 0x2125   | Ignition Coil 1 Secondary Voltage              | 256*A+B                             | V         |
| 0x2126   | Misfire Count Cylinder 1                       | 256*A+B                             | count     |
| 0x2127   | Misfire Count Cylinder 2                       | 256*A+B                             | count     |
| 0x2128   | Misfire Count Cylinder 3                       | 256*A+B                             | count     |
| 0x2129   | Misfire Count Cylinder 4                       | 256*A+B                             | count     |

## Variable Valve Timing (VVT)

### Camshaft Control

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2200   | Intake Cam Position Bank 1                     | (256*A+B)/10-180                    | °         |
| 0x2201   | Intake Cam Position Bank 2                     | (256*A+B)/10-180                    | °         |
| 0x2202   | Exhaust Cam Position Bank 1                    | (256*A+B)/10-180                    | °         |
| 0x2203   | Exhaust Cam Position Bank 2                    | (256*A+B)/10-180                    | °         |
| 0x2204   | Intake Cam Target Position Bank 1              | (256*A+B)/10-180                    | °         |
| 0x2205   | Intake Cam Target Position Bank 2              | (256*A+B)/10-180                    | °         |
| 0x2206   | Exhaust Cam Target Position Bank 1             | (256*A+B)/10-180                    | °         |
| 0x2207   | Exhaust Cam Target Position Bank 2             | (256*A+B)/10-180                    | °         |
| 0x2208   | VVT Solenoid Duty Cycle Bank 1 Intake          | A/2.55                              | %         |
| 0x2209   | VVT Solenoid Duty Cycle Bank 1 Exhaust         | A/2.55                              | %         |
| 0x220A   | VVT Solenoid Duty Cycle Bank 2 Intake          | A/2.55                              | %         |
| 0x220B   | VVT Solenoid Duty Cycle Bank 2 Exhaust         | A/2.55                              | %         |

### Variable Valve Lift

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2220   | Valve Lift Amount Bank 1                       | A/10                                | mm        |
| 0x2221   | Valve Lift Amount Bank 2                       | A/10                                | mm        |
| 0x2222   | Valve Lift Target Bank 1                       | A/10                                | mm        |
| 0x2223   | Valve Lift Target Bank 2                       | A/10                                | mm        |
| 0x2224   | Valve Lift Mode                                | 0=Low, 1=High, 2=Transition         | -         |
| 0x2225   | VTEC Solenoid Status                           | 0=Off, 1=On                         | -         |
| 0x2226   | VTEC Oil Pressure Switch                       | 0=Low, 1=High                       | -         |

## Turbocharger (Petrol Specific)

### Turbo Control

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2300   | Turbo Boost Pressure Actual                    | (256*A+B)/10                        | kPa       |
| 0x2301   | Turbo Boost Pressure Target                    | (256*A+B)/10                        | kPa       |
| 0x2302   | Wastegate Duty Cycle                           | A/2.55                              | %         |
| 0x2303   | Turbo Speed Sensor                             | 256*A+B*10                          | rpm       |
| 0x2304   | Compressor Outlet Temperature                  | A-40                                | °C        |
| 0x2305   | Intercooler Efficiency                         | A/2.55                              | %         |
| 0x2306   | Blow-off Valve Position                        | A/2.55                              | %         |
| 0x2307   | Anti-lag System Active                         | 0=Off, 1=Active                     | -         |
| 0x2308   | Overboost Time Remaining                       | A                                   | seconds   |

## Knock Detection

### Knock Sensor Data

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2400   | Knock Sensor 1 Voltage                         | (256*A+B)/1000                      | V         |
| 0x2401   | Knock Sensor 2 Voltage                         | (256*A+B)/1000                      | V         |
| 0x2402   | Knock Sensor 1 Frequency                       | 256*A+B                             | Hz        |
| 0x2403   | Knock Sensor 2 Frequency                       | 256*A+B                             | Hz        |
| 0x2404   | Knock Intensity Cylinder 1                     | A                                   | 0-255     |
| 0x2405   | Knock Intensity Cylinder 2                     | A                                   | 0-255     |
| 0x2406   | Knock Intensity Cylinder 3                     | A                                   | 0-255     |
| 0x2407   | Knock Intensity Cylinder 4                     | A                                   | 0-255     |
| 0x2408   | Knock Window Start                             | (256*A+B)/10                        | °ATDC     |
| 0x2409   | Knock Window End                               | (256*A+B)/10                        | °ATDC     |
| 0x240A   | Knock Control Learning Value                   | (A-128)/1.28                        | °         |

## Lambda/O2 Sensors (Petrol Specific)

### Wideband O2 Sensors

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2500   | Lambda Bank 1 Sensor 1                         | (256*A+B)/32768                     | ratio     |
| 0x2501   | Lambda Bank 1 Sensor 2                         | (256*A+B)/32768                     | ratio     |
| 0x2502   | Lambda Bank 2 Sensor 1                         | (256*A+B)/32768                     | ratio     |
| 0x2503   | Lambda Bank 2 Sensor 2                         | (256*A+B)/32768                     | ratio     |
| 0x2504   | O2 Sensor Heater Current B1S1                  | (256*A+B)/100                       | A         |
| 0x2505   | O2 Sensor Heater Current B1S2                  | (256*A+B)/100                       | A         |
| 0x2506   | O2 Sensor Heater Current B2S1                  | (256*A+B)/100                       | A         |
| 0x2507   | O2 Sensor Heater Current B2S2                  | (256*A+B)/100                       | A         |
| 0x2508   | O2 Sensor Temperature B1S1                     | (256*A+B)/10-40                     | °C        |
| 0x2509   | O2 Sensor Temperature B1S2                     | (256*A+B)/10-40                     | °C        |

## Emission Control (Petrol Specific)

### Catalytic Converter

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2600   | Catalyst Temperature Bank 1                    | (256*A+B)/10-40                     | °C        |
| 0x2601   | Catalyst Temperature Bank 2                    | (256*A+B)/10-40                     | °C        |
| 0x2602   | Catalyst Efficiency Bank 1                     | A/2.55                              | %         |
| 0x2603   | Catalyst Efficiency Bank 2                     | A/2.55                              | %         |
| 0x2604   | Catalyst Space Velocity                        | 256*A+B                             | 1/h       |
| 0x2605   | Catalyst O2 Storage Capacity                   | A/2.55                              | %         |

### EVAP System

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2620   | EVAP Purge Valve Duty Cycle                    | A/2.55                              | %         |
| 0x2621   | EVAP Canister Pressure                         | (256*A+B)-32768                     | Pa        |
| 0x2622   | EVAP Canister Temperature                      | A-40                                | °C        |
| 0x2623   | EVAP System Vapor Pressure                     | (256*A+B)/4                         | Pa        |
| 0x2624   | EVAP Leak Detection Pump Pressure              | (256*A+B)                           | Pa        |
| 0x2625   | Fuel Tank Pressure                             | (256*A+B)-32768                     | Pa        |
| 0x2626   | Fuel Tank Temperature                          | A-40                                | °C        |

### Secondary Air Injection

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2640   | Secondary Air Pump Status                      | 0=Off, 1=On                         | -         |
| 0x2641   | Secondary Air Pump Current                     | (256*A+B)/100                       | A         |
| 0x2642   | Secondary Air Flow Rate                        | (256*A+B)/10                        | g/s       |
| 0x2643   | Secondary Air Valve Position                   | A/2.55                              | %         |
| 0x2644   | Secondary Air Pressure                         | (256*A+B)                           | kPa       |

## Cylinder Deactivation

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2700   | Cylinder Deactivation Status                   | Bit encoded (1 bit per cylinder)    | -         |
| 0x2701   | Active Fuel Management Mode                    | 0=V8, 1=V4, 2=Transition            | -         |
| 0x2702   | Oil Pressure for Deactivation                  | (256*A+B)/10                        | kPa       |
| 0x2703   | Deactivation Solenoid 1 Status                 | 0=Off, 1=On                         | -         |
| 0x2704   | Deactivation Solenoid 2 Status                 | 0=Off, 1=On                         | -         |
| 0x2705   | Deactivation Solenoid 3 Status                 | 0=Off, 1=On                         | -         |
| 0x2706   | Deactivation Solenoid 4 Status                 | 0=Off, 1=On                         | -         |

## Start-Stop System

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2800   | Start-Stop Status                              | 0=Engine On, 1=Engine Off, 2=Restarting | -    |
| 0x2801   | Start-Stop Inhibit Reasons                     | Bit encoded                         | -         |
| 0x2802   | Engine Stop Counter                            | 256*A+B                             | count     |
| 0x2803   | Total Engine Off Time                          | 256*A+B                             | seconds   |
| 0x2804   | Enhanced Starter Motor Temperature              | A-40                                | °C        |
| 0x2805   | Battery State for Start-Stop                   | A/2.55                              | %         |
| 0x2806   | Brake Vacuum for Start-Stop                    | (256*A+B)                           | kPa       |

## Atkinson/Miller Cycle Engines

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2900   | Effective Compression Ratio                    | A/10                                | ratio     |
| 0x2901   | Intake Valve Closing Angle                     | (256*A+B)/10                        | °ABDC     |
| 0x2902   | Expansion Ratio                                | A/10                                | ratio     |
| 0x2903   | Atkinson Cycle Mode Active                     | 0=No, 1=Yes                         | -         |
| 0x2904   | Engine Efficiency Mode                         | 0=Power, 1=Normal, 2=Eco            | -         |

## Performance Metrics

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2A00   | Engine Power Output                            | (256*A+B)/10                        | kW        |
| 0x2A01   | Engine Torque Output                           | (256*A+B)-32768                     | Nm        |
| 0x2A02   | BMEP (Brake Mean Effective Pressure)           | (256*A+B)/10                        | bar       |
| 0x2A03   | Volumetric Efficiency                          | A/2.55                              | %         |
| 0x2A04   | Thermal Efficiency                             | A/2.55                              | %         |
| 0x2A05   | Specific Fuel Consumption                      | (256*A+B)/10                        | g/kWh     |
| 0x2A06   | Air/Fuel Ratio (Stoichiometric)               | (256*A+B)/1000                      | ratio     |

## Advanced Engine Management

### Combustion Analysis

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x2B00   | Combustion Pressure Peak Cylinder 1            | (256*A+B)                           | bar       |
| 0x2B01   | Combustion Pressure Peak Cylinder 2            | (256*A+B)                           | bar       |
| 0x2B02   | Combustion Pressure Peak Cylinder 3            | (256*A+B)                           | bar       |
| 0x2B03   | Combustion Pressure Peak Cylinder 4            | (256*A+B)                           | bar       |
| 0x2B04   | 50% Mass Fraction Burned Location              | (256*A+B)/10                        | °ATDC     |
| 0x2B05   | Combustion Duration                            | (256*A+B)/10                        | °CA       |
| 0x2B06   | COV of IMEP                                    | A/10                                | %         |

## Manufacturer-Specific Petrol PIDs

### Toyota/Lexus

| PID/DID  | Description                                    | Access Method   |
|----------|------------------------------------------------|-----------------|
| 0x21_61  | Fuel Injection Volume                          | Mode 21         |
| 0x21_62  | Ignition Timing Advance                        | Mode 21         |
| 0x21_63  | Idle Speed Control                             | Mode 21         |
| 0x21_89  | VVT-i Actual Angle                             | Mode 21         |

### Honda/Acura

| PID/DID  | Description                                    | Protocol        |
|----------|------------------------------------------------|-----------------|
| 0x11_20  | VTEC Oil Pressure                              | Honda Protocol  |
| 0x11_21  | VTEC Solenoid Command                          | Honda Protocol  |
| 0x11_B1  | Air/Fuel Ratio Sensor                          | Honda Protocol  |

### Ford EcoBoost

| PID/DID       | Description                               | Module          |
|---------------|-------------------------------------------|-----------------|
| 0x22F401      | Turbo Boost Actual                        | PCM             |
| 0x22F402      | Turbo Boost Desired                       | PCM             |
| 0x22F421      | CAC Temperature                           | PCM             |
| 0x22F440      | Knock Sensor Data                         | PCM             |

### GM Performance

| PID/DID       | Description                               | Protocol        |
|---------------|-------------------------------------------|-----------------|
| 0x1134        | Spark Advance                             | GMLAN           |
| 0x1135        | Knock Retard                              | GMLAN           |
| 0x119E        | Fuel Rail Pressure (DI)                   | GMLAN           |
| 0x11A2        | Camshaft Position                         | GMLAN           |

### BMW N-Series Engines

| PID/DID       | Description                               | Access          |
|---------------|-------------------------------------------|-----------------|
| 0x2901        | Valvetronic Motor Position                | ISTA-D          |
| 0x2902        | Valvetronic Target Position               | ISTA-D          |
| 0x2903        | VANOS Intake Actual                       | ISTA-D          |
| 0x2904        | VANOS Exhaust Actual                      | ISTA-D          |

### VAG (VW/Audi) TSI/TFSI

| Group    | Description                                    | Measuring Block |
|----------|------------------------------------------------|-----------------|
| 001      | Engine Speed, Load, Temperature                | MVB             |
| 002      | Injection Time, Air Mass                       | MVB             |
| 003      | Throttle Angle, Ignition Timing                | MVB             |
| 020      | Knock Control Cylinder 1-4                     | MVB             |
| 115      | Boost Pressure Actual/Specified                | MVB             |

## Hybrid Petrol Specific

| PID/DID  | Description                                    | Formula/Notes                        | Units     |
|----------|------------------------------------------------|--------------------------------------|-----------|
| 0x3000   | ICE/Electric Power Split                       | A/2.55                              | % ICE     |
| 0x3001   | Engine Auto Stop Request                       | 0=No, 1=Yes                         | -         |
| 0x3002   | Engine Auto Start Request                      | 0=No, 1=Yes                         | -         |
| 0x3003   | Hybrid System Mode                             | 0=EV, 1=Hybrid, 2=Engine Only       | -         |
| 0x3004   | Energy Recovery This Trip                      | (256*A+B)/100                       | kWh       |
| 0x3005   | Engine Warm-up Status for Hybrid               | A/2.55                              | %         |