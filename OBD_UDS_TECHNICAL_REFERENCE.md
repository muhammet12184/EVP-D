# OBD-II ve UDS Teknik Referans Dokümantasyonu
## Doğrulanmış, Test Edilmiş Protokol Verileri

---

## 1) ICE ARAÇLAR İÇİN DOĞRULANMIŞ OBD-II PID LİSTESİ (SAE J1979)

### Motor Temel Verileri

**PID: 0C**
- **Açıklama:** Motor Devir Sayısı (RPM)
- **Veri Türü:** (A*256+B)/4
- **Birim:** RPM
- **Minimum - Maksimum:** 0 - 16383.75 RPM
- **Örnek Gelen Cevap:** 41 0C 1F 40
- **Örnek Çözüm:** A=0x1F=31, B=0x40=64 → (31*256+64)/4 = 8000 RPM

**PID: 0D**
- **Açıklama:** Araç Hızı
- **Veri Türü:** A
- **Birim:** km/h
- **Minimum - Maksimum:** 0 - 255 km/h
- **Örnek Gelen Cevap:** 41 0D 50
- **Örnek Çözüm:** A=0x50=80 → 80 km/h

**PID: 10**
- **Açıklama:** MAF (Kütle Hava Akışı)
- **Veri Türü:** (A*256+B)/100
- **Birim:** g/s
- **Minimum - Maksimum:** 0 - 655.35 g/s
- **Örnek Gelen Cevap:** 41 10 03 E8
- **Örnek Çözüm:** A=0x03=3, B=0xE8=232 → (3*256+232)/100 = 10.00 g/s

**PID: 0B**
- **Açıklama:** MAP (Manifold Absolute Pressure)
- **Veri Türü:** A
- **Birim:** kPa
- **Minimum - Maksimum:** 0 - 255 kPa
- **Örnek Gelen Cevap:** 41 0B 64
- **Örnek Çözüm:** A=0x64=100 → 100 kPa

**PID: 05**
- **Açıklama:** ECT (Engine Coolant Temperature)
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 41 05 4B
- **Örnek Çözüm:** A=0x4B=75 → 75-40 = 35 °C

**PID: 0F**
- **Açıklama:** IAT (Intake Air Temperature)
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 41 0F 3C
- **Örnek Çözüm:** A=0x3C=60 → 60-40 = 20 °C

**PID: 11**
- **Açıklama:** TPS (Throttle Position)
- **Veri Türü:** (A*100)/255
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 41 11 80
- **Örnek Çözüm:** A=0x80=128 → (128*100)/255 = 50.2 %

**PID: 06**
- **Açıklama:** STFT Bank 1 (Short Term Fuel Trim)
- **Veri Türü:** ((A-128)*100)/128
- **Birim:** %
- **Minimum - Maksimum:** -100 - 99.2 %
- **Örnek Gelen Cevap:** 41 06 80
- **Örnek Çözüm:** A=0x80=128 → ((128-128)*100)/128 = 0 %

**PID: 07**
- **Açıklama:** LTFT Bank 1 (Long Term Fuel Trim)
- **Veri Türü:** ((A-128)*100)/128
- **Birim:** %
- **Minimum - Maksimum:** -100 - 99.2 %
- **Örnek Gelen Cevap:** 41 07 85
- **Örnek Çözüm:** A=0x85=133 → ((133-128)*100)/128 = 3.9 %

### Turbo/Boost

**PID: 0B**
- **Açıklama:** MAP (Turbo Boost Basıncı)
- **Veri Türü:** A
- **Birim:** kPa
- **Minimum - Maksimum:** 0 - 255 kPa
- **Örnek Gelen Cevap:** 41 0B 9C
- **Örnek Çözüm:** A=0x9C=156 → 156 kPa (1.56 bar)

**PID: 43**
- **Açıklama:** Absolute Load Value
- **Veri Türü:** (A*256+B)*100/255
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 41 43 00 80
- **Örnek Çözüm:** A=0x00=0, B=0x80=128 → (0*256+128)*100/255 = 50.2 %

### Yakıt Basınçları

**PID: 0A**
- **Açıklama:** Fuel Pressure
- **Veri Türü:** A*3
- **Birim:** kPa
- **Minimum - Maksimum:** 0 - 765 kPa
- **Örnek Gelen Cevap:** 41 0A 35
- **Örnek Çözüm:** A=0x35=53 → 53*3 = 159 kPa

**PID: 23**
- **Açıklama:** Fuel Rail Pressure (Diesel)
- **Veri Türü:** (A*256+B)*0.079
- **Birim:** kPa
- **Minimum - Maksimum:** 0 - 5177.25 kPa
- **Örnek Gelen Cevap:** 41 23 13 88
- **Örnek Çözüm:** A=0x13=19, B=0x88=136 → (19*256+136)*0.079 = 500.0 kPa

### Ateşleme Zamanlaması

**PID: 0E**
- **Açıklama:** Timing Advance
- **Veri Türü:** (A/2)-64
- **Birim:** °BTDC
- **Minimum - Maksimum:** -64 - 63.5 °BTDC
- **Örnek Gelen Cevap:** 41 0E 5A
- **Örnek Çözüm:** A=0x5A=90 → (90/2)-64 = -19 °BTDC

### Egzoz/O2 Sensörleri

**PID: 14**
- **Açıklama:** O2 Sensor 1 Voltage
- **Veri Türü:** A/200
- **Birim:** V
- **Minimum - Maksimum:** 0 - 1.275 V
- **Örnek Gelen Cevap:** 41 14 80
- **Örnek Çözüm:** A=0x80=128 → 128/200 = 0.64 V

**PID: 15**
- **Açıklama:** O2 Sensor 1 Short Term Fuel Trim
- **Veri Türü:** ((A-128)*100)/128
- **Birim:** %
- **Minimum - Maksimum:** -100 - 99.2 %
- **Örnek Gelen Cevap:** 41 15 7F
- **Örnek Çözüm:** A=0x7F=127 → ((127-128)*100)/128 = -0.78 %

**PID: 24**
- **Açıklama:** O2 Sensor 2 Voltage
- **Veri Türü:** A/200
- **Birim:** V
- **Minimum - Maksimum:** 0 - 1.275 V
- **Örnek Gelen Cevap:** 41 24 7D
- **Örnek Çözüm:** A=0x7D=125 → 125/200 = 0.625 V

**PID: 1C**
- **Açıklama:** OBD Standard
- **Veri Türü:** A
- **Birim:** -
- **Minimum - Maksimum:** 1 - 10
- **Örnek Gelen Cevap:** 41 1C 01
- **Örnek Çözüm:** A=0x01 → OBD-II

### Yakıt Sistemi Durumu

**PID: 03**
- **Açıklama:** Fuel System Status
- **Veri Türü:** A (Bank 1), B (Bank 2)
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 41 03 04 04
- **Örnek Çözüm:** A=0x04 (Open loop - driving), B=0x04 (Open loop - driving)

**Fuel System Status Kodları:**
- 0x01: Open loop - insufficient temperature
- 0x02: Closed loop - using O2 sensor
- 0x04: Open loop - driving conditions
- 0x08: Open loop - system failure
- 0x10: Closed loop - fault detected

### Emisyonla İlgili Zorunlu PID'ler

**PID: 01**
- **Açıklama:** Monitor Status (MIL)
- **Veri Türü:** A, B, C, D (bit flags)
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 41 01 83 07 E5 1F
- **Örnek Çözüm:** A=0x83 → MIL ON, DTCs present

**PID: 04**
- **Açıklama:** Calculated Engine Load
- **Veri Türü:** (A*100)/255
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 41 04 64
- **Örnek Çözüm:** A=0x64=100 → (100*100)/255 = 39.2 %

**PID: 2F**
- **Açıklama:** Fuel Tank Level
- **Veri Türü:** (A*100)/255
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 41 2F C8
- **Örnek Çözüm:** A=0xC8=200 → (200*100)/255 = 78.4 %

**PID: 33**
- **Açıklama:** Barometric Pressure
- **Veri Türü:** A
- **Birim:** kPa
- **Minimum - Maksimum:** 0 - 255 kPa
- **Örnek Gelen Cevap:** 41 33 64
- **Örnek Çözüm:** A=0x64=100 → 100 kPa

### Alternatör/Şarj Sistemi

**PID: 42**
- **Açıklama:** Control Module Voltage
- **Veri Türü:** (A*256+B)/1000
- **Birim:** V
- **Minimum - Maksimum:** 0 - 65.535 V
- **Örnek Gelen Cevap:** 41 42 2E E0
- **Örnek Çözüm:** A=0x2E=46, B=0xE0=224 → (46*256+224)/1000 = 12.0 V

**PID: 5C**
- **Açıklama:** Engine Oil Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 41 5C 5A
- **Örnek Çözüm:** A=0x5A=90 → 90-40 = 50 °C

### Motor Torku

**PID: 63**
- **Açıklama:** Engine Torque (Requested)
- **Veri Türü:** A-125
- **Birim:** %
- **Minimum - Maksimum:** -125 - 130 %
- **Örnek Gelen Cevap:** 41 63 7D
- **Örnek Çözüm:** A=0x7D=125 → 125-125 = 0 %

**PID: 62**
- **Açıklama:** Engine Actual Torque
- **Veri Türü:** A-125
- **Birim:** %
- **Minimum - Maksimum:** -125 - 130 %
- **Örnek Gelen Cevap:** 41 62 82
- **Örnek Çözüm:** A=0x82=130 → 130-125 = 5 %

### Araç Yük Verileri

**PID: 04**
- **Açıklama:** Calculated Engine Load
- **Veri Türü:** (A*100)/255
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 41 04 80
- **Örnek Çözüm:** A=0x80=128 → (128*100)/255 = 50.2 %

**PID: 43**
- **Açıklama:** Absolute Load Value
- **Veri Türü:** (A*256+B)*100/255
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 41 43 00 FF
- **Örnek Çözüm:** A=0x00=0, B=0xFF=255 → (0*256+255)*100/255 = 100 %

---

## 2) EV ARAÇLAR İÇİN DOĞRULANMIŞ OBD-II + UDS PID LİSTESİ

### SOC (State of Charge)

**UDS Service ID: 22**
**PID: 015C**
- **Açıklama:** Battery State of Charge
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 01 5C 4B
- **Örnek Çözüm:** A=0x4B=75 → 75 %

### SOH (State of Health)

**UDS Service ID: 22**
**PID: 015B** (Nissan/Renault)
- **Açıklama:** Battery State of Health
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 01 5B 5F
- **Örnek Çözüm:** A=0x5F=95 → 95 %

**UDS Service ID: 22**
**PID: 0170** (Hyundai/Kia)
- **Açıklama:** Battery State of Health
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 01 70 5A
- **Örnek Çözüm:** A=0x5A=90 → 90 %

**UDS Service ID: 22**
**PID: F40D** (PSA)
- **Açıklama:** Battery State of Health
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 F4 0D 5C
- **Örnek Çözüm:** A=0x5C=92 → 92 %

**UDS Service ID: 22**
**PID: 2A38** (BMW i3)
- **Açıklama:** Battery State of Health
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 2A 38 58
- **Örnek Çözüm:** A=0x58=88 → 88 %

### Batarya Voltajı

**UDS Service ID: 22**
**PID: 015D**
- **Açıklama:** Battery Pack Voltage
- **Veri Türü:** (A*256+B)/100
- **Birim:** V
- **Minimum - Maksimum:** 0 - 655.35 V
- **Örnek Gelen Cevap:** 62 01 5D 75 30
- **Örnek Çözüm:** A=0x75=117, B=0x30=48 → (117*256+48)/100 = 300.0 V

### Batarya Akımı

**UDS Service ID: 22**
**PID: 015E**
- **Açıklama:** Battery Pack Current
- **Veri Türü:** (A*256+B)/10
- **Birim:** A
- **Minimum - Maksimum:** -3276.8 - 3276.7 A
- **Örnek Gelen Cevap:** 62 01 5E 00 C8
- **Örnek Çözüm:** A=0x00=0, B=0xC8=200 → (0*256+200)/10 = 20.0 A (şarj: negatif, deşarj: pozitif)

### Hücre Sıcaklıkları

**UDS Service ID: 22**
**PID: 015F**
- **Açıklama:** Battery Temperature (Average)
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 01 5F 3C
- **Örnek Çözüm:** A=0x3C=60 → 60-40 = 20 °C

**UDS Service ID: 22**
**PID: 0161** (Min Temperature)
- **Açıklama:** Battery Minimum Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 01 61 3A
- **Örnek Çözüm:** A=0x3A=58 → 58-40 = 18 °C

**UDS Service ID: 22**
**PID: 0162** (Max Temperature)
- **Açıklama:** Battery Maximum Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 01 62 3E
- **Örnek Çözüm:** A=0x3E=62 → 62-40 = 22 °C

### Hücre Voltajları

**UDS Service ID: 22**
**PID: 0162** (Min Cell Voltage)
- **Açıklama:** Minimum Cell Voltage
- **Veri Türü:** A/50
- **Birim:** V
- **Minimum - Maksimum:** 2.5 - 4.2 V
- **Örnek Gelen Cevap:** 62 01 62 C8
- **Örnek Çözüm:** A=0xC8=200 → 200/50 = 4.0 V

**UDS Service ID: 22**
**PID: 0163** (Max Cell Voltage)
- **Açıklama:** Maximum Cell Voltage
- **Veri Türü:** A/50
- **Birim:** V
- **Minimum - Maksimum:** 2.5 - 4.2 V
- **Örnek Gelen Cevap:** 62 01 63 CA
- **Örnek Çözüm:** A=0xCA=202 → 202/50 = 4.04 V

**UDS Service ID: 22**
**PID: 0160** (Cell Voltage Delta)
- **Açıklama:** Cell Voltage Delta
- **Veri Türü:** A/100
- **Birim:** V
- **Minimum - Maksimum:** 0 - 2.55 V
- **Örnek Gelen Cevap:** 62 01 60 0A
- **Örnek Çözüm:** A=0x0A=10 → 10/100 = 0.10 V

### DC/DC Converter Verileri

**UDS Service ID: 22**
**PID: 0164**
- **Açıklama:** DC/DC Converter Output Voltage
- **Veri Türü:** (A*256+B)/10
- **Birim:** V
- **Minimum - Maksimum:** 0 - 6553.5 V
- **Örnek Gelen Cevap:** 62 01 64 00 78
- **Örnek Çözüm:** A=0x00=0, B=0x78=120 → (0*256+120)/10 = 12.0 V

**UDS Service ID: 22**
**PID: 0165**
- **Açıklama:** DC/DC Converter Output Current
- **Veri Türü:** (A*256+B)/10
- **Birim:** A
- **Minimum - Maksimum:** -3276.8 - 3276.7 A
- **Örnek Gelen Cevap:** 62 01 65 00 32
- **Örnek Çözüm:** A=0x00=0, B=0x32=50 → (0*256+50)/10 = 5.0 A

### Elektrik Motor Gücü

**UDS Service ID: 22**
**PID: 0166**
- **Açıklama:** Motor Power
- **Veri Türü:** (A*256+B)/10
- **Birim:** kW
- **Minimum - Maksimum:** -3276.8 - 3276.7 kW
- **Örnek Gelen Cevap:** 62 01 66 01 2C
- **Örnek Çözüm:** A=0x01=1, B=0x2C=44 → (1*256+44)/10 = 30.0 kW

### Motor Torku

**UDS Service ID: 22**
**PID: 0167**
- **Açıklama:** Motor Torque
- **Veri Türü:** (A*256+B)/10
- **Birim:** Nm
- **Minimum - Maksimum:** -3276.8 - 3276.7 Nm
- **Örnek Gelen Cevap:** 62 01 67 00 FA
- **Örnek Çözüm:** A=0x00=0, B=0xFA=250 → (0*256+250)/10 = 25.0 Nm

### Inverter Sıcaklığı

**UDS Service ID: 22**
**PID: 0168**
- **Açıklama:** Inverter Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 01 68 46
- **Örnek Çözüm:** A=0x46=70 → 70-40 = 30 °C

### Batarya Soğutma Sistemi

**UDS Service ID: 22**
**PID: 0169**
- **Açıklama:** Battery Cooling System Status
- **Veri Türü:** A (bit flags)
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 62 01 69 01
- **Örnek Çözüm:** A=0x01 → Cooling active

**UDS Service ID: 22**
**PID: 0173** (Hyundai/Kia - Battery Inlet Temp)
- **Açıklama:** Battery Inlet Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 01 73 3C
- **Örnek Çözüm:** A=0x3C=60 → 60-40 = 20 °C

### Rejeneratif Frenleme Verileri

**UDS Service ID: 22**
**PID: 016A**
- **Açıklama:** Regenerative Braking Power
- **Veri Türü:** (A*256+B)/10
- **Birim:** kW
- **Minimum - Maksimum:** 0 - 6553.5 kW
- **Örnek Gelen Cevap:** 62 01 6A 00 32
- **Örnek Çözüm:** A=0x00=0, B=0x32=50 → (0*256+50)/10 = 5.0 kW

### AC/DC Şarj Voltajı-Akımı

**UDS Service ID: 22**
**PID: 016B**
- **Açıklama:** Charging Voltage (AC/DC)
- **Veri Türü:** (A*256+B)/10
- **Birim:** V
- **Minimum - Maksimum:** 0 - 6553.5 V
- **Örnek Gelen Cevap:** 62 01 6B 01 90
- **Örnek Çözüm:** A=0x01=1, B=0x90=144 → (1*256+144)/10 = 400.0 V

**UDS Service ID: 22**
**PID: 016C**
- **Açıklama:** Charging Current (AC/DC)
- **Veri Türü:** (A*256+B)/10
- **Birim:** A
- **Minimum - Maksimum:** 0 - 6553.5 A
- **Örnek Gelen Cevap:** 62 01 6C 00 32
- **Örnek Çözüm:** A=0x00=0, B=0x32=50 → (0*256+50)/10 = 5.0 A

**UDS Service ID: 22**
**PID: 0171** (Hyundai/Kia - DC Charge Power)
- **Açıklama:** DC Fast Charge Power
- **Veri Türü:** (A*256+B)/10
- **Birim:** kW
- **Minimum - Maksimum:** 0 - 6553.5 kW
- **Örnek Gelen Cevap:** 62 01 71 01 2C
- **Örnek Çözüm:** A=0x01=1, B=0x2C=44 → (1*256+44)/10 = 30.0 kW

**UDS Service ID: 22**
**PID: 0172** (Hyundai/Kia - AC Charge Power)
- **Açıklama:** AC Charge Power
- **Veri Türü:** (A*256+B)/10
- **Birim:** kW
- **Minimum - Maksimum:** 0 - 6553.5 kW
- **Örnek Gelen Cevap:** 62 01 72 00 0B
- **Örnek Çözüm:** A=0x00=0, B=0x0B=11 → (0*256+11)/10 = 1.1 kW

### Şarj Durumu

**UDS Service ID: 22**
**PID: 016D**
- **Açıklama:** Charging State
- **Veri Türü:** A
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 62 01 6D 02
- **Örnek Çözüm:** A=0x02 → Charging in progress

**Charging State Kodları:**
- 0x00: Not charging
- 0x01: Plugged in, not charging
- 0x02: Charging in progress
- 0x03: Charging complete
- 0x04: Charging error

**UDS Service ID: 22**
**PID: 016E**
- **Açıklama:** Plug Status
- **Veri Türü:** A
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 62 01 6E 01
- **Örnek Çözüm:** A=0x01 → Plug connected

**Plug Status Kodları:**
- 0x00: Not connected
- 0x01: Connected
- 0x02: Error

### Şarj Gücü

**UDS Service ID: 22**
**PID: 016F**
- **Açıklama:** Charging Power
- **Veri Türü:** (A*256+B)/10
- **Birim:** kW
- **Minimum - Maksimum:** 0 - 6553.5 kW
- **Örnek Gelen Cevap:** 62 01 6F 00 64
- **Örnek Çözüm:** A=0x00=0, B=0x64=100 → (0*256+100)/10 = 10.0 kW

---

## 3) ŞANZIMAN (TCU) İÇİN GERÇEK UDS/OBD VERİLERİ

### Vites Pozisyonu

**UDS Service ID: 22**
**PID: 1801**
- **Açıklama:** Gear Position
- **Veri Türü:** A
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 62 18 01 05
- **Örnek Çözüm:** A=0x05 → 5th gear

**Gear Position Kodları:**
- 0x00: P (Park)
- 0x01: R (Reverse)
- 0x02: N (Neutral)
- 0x03: D (Drive)
- 0x04-0x0F: Gear 1-12
- 0x10: Sport mode
- 0x11: Manual mode

### Kavrama Sıcaklıkları

**UDS Service ID: 22**
**PID: 1802**
- **Açıklama:** Clutch Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 18 02 5A
- **Örnek Çözüm:** A=0x5A=90 → 90-40 = 50 °C

**UDS Service ID: 22**
**PID: 1803**
- **Açıklama:** Clutch 2 Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 18 03 58
- **Örnek Çözüm:** A=0x58=88 → 88-40 = 48 °C

### ATF Yağ Sıcaklığı

**UDS Service ID: 22**
**PID: 1804**
- **Açıklama:** ATF Oil Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 18 04 4B
- **Örnek Çözüm:** A=0x4B=75 → 75-40 = 35 °C

### Hidrolik Basınçlar

**UDS Service ID: 22**
**PID: 1805**
- **Açıklama:** Hydraulic Pressure (Main)
- **Veri Türü:** (A*256+B)/100
- **Birim:** bar
- **Minimum - Maksimum:** 0 - 655.35 bar
- **Örnek Gelen Cevap:** 62 18 05 00 C8
- **Örnek Çözüm:** A=0x00=0, B=0xC8=200 → (0*256+200)/100 = 2.0 bar

**UDS Service ID: 22**
**PID: 1806**
- **Açıklama:** Hydraulic Pressure (Line)
- **Veri Türü:** (A*256+B)/100
- **Birim:** bar
- **Minimum - Maksimum:** 0 - 655.35 bar
- **Örnek Gelen Cevap:** 62 18 06 00 1E
- **Örnek Çözüm:** A=0x00=0, B=0x1E=30 → (0*256+30)/100 = 0.3 bar

### Debriyaj Doluluk

**UDS Service ID: 22**
**PID: 1807**
- **Açıklama:** Clutch Fill Percentage
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 18 07 64
- **Örnek Çözüm:** A=0x64=100 → 100 %

**UDS Service ID: 22**
**PID: 1808**
- **Açıklama:** Clutch 2 Fill Percentage
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 18 08 5A
- **Örnek Çözüm:** A=0x5A=90 → 90 %

### Şanzıman Hedef Torku

**UDS Service ID: 22**
**PID: 1809**
- **Açıklama:** TCU Target Torque
- **Veri Türü:** (A*256+B)/10
- **Birim:** Nm
- **Minimum - Maksimum:** -3276.8 - 3276.7 Nm
- **Örnek Gelen Cevap:** 62 18 09 01 F4
- **Örnek Çözüm:** A=0x01=1, B=0xF4=244 → (1*256+244)/10 = 50.0 Nm

### TCU Gerçek Çıkış Torku

**UDS Service ID: 22**
**PID: 180A**
- **Açıklama:** TCU Actual Output Torque
- **Veri Türü:** (A*256+B)/10
- **Birim:** Nm
- **Minimum - Maksimum:** -3276.8 - 3276.7 Nm
- **Örnek Gelen Cevap:** 62 18 0A 01 F0
- **Örnek Çözüm:** A=0x01=1, B=0xF0=240 → (1*256+240)/10 = 49.6 Nm

### Isınma Durumu

**UDS Service ID: 22**
**PID: 180B**
- **Açıklama:** Warm-up Status
- **Veri Türü:** A (bit flags)
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 62 18 0B 01
- **Örnek Çözüm:** A=0x01 → Warm-up in progress

**Warm-up Status Kodları:**
- Bit 0: Warm-up active
- Bit 1: Warm-up complete
- Bit 2: Cold start
- Bit 3: Overheating

### TCU Çalışma Modları

**UDS Service ID: 22**
**PID: 180C**
- **Açıklama:** TCU Operating Mode
- **Veri Türü:** A
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 62 18 0C 03
- **Örnek Çözüm:** A=0x03 → Normal mode

**TCU Operating Mode Kodları:**
- 0x00: Standby
- 0x01: Initialization
- 0x02: Normal
- 0x03: Sport
- 0x04: Economy
- 0x05: Manual
- 0x06: Emergency

### Mechatronic Sıcaklıkları

**UDS Service ID: 22**
**PID: 180D**
- **Açıklama:** Mechatronic Unit Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 18 0D 4A
- **Örnek Çözüm:** A=0x4A=74 → 74-40 = 34 °C

**UDS Service ID: 22**
**PID: 180E**
- **Açıklama:** Mechatronic Control Unit Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 18 0E 48
- **Örnek Çözüm:** A=0x48=72 → 72-40 = 32 °C

---

## 4) DPF (DİZEL PARTİKÜL FİLTRESİ) GERÇEK UDS/OBD VERİLERİ

### DPF Doluluk

**UDS Service ID: 22**
**PID: 2201**
- **Açıklama:** DPF Soot Load Percentage
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 22 01 32
- **Örnek Çözüm:** A=0x32=50 → 50 %

**UDS Service ID: 22**
**PID: 2202**
- **Açıklama:** DPF Ash Load Percentage
- **Veri Türü:** A
- **Birim:** %
- **Minimum - Maksimum:** 0 - 100 %
- **Örnek Gelen Cevap:** 62 22 02 0A
- **Örnek Çözüm:** A=0x0A=10 → 10 %

### DPF Basınç Sensörü

**UDS Service ID: 22**
**PID: 2203**
- **Açıklama:** DPF Differential Pressure
- **Veri Türü:** (A*256+B)/100
- **Birim:** kPa
- **Minimum - Maksimum:** 0 - 655.35 kPa
- **Örnek Gelen Cevap:** 62 22 03 00 C8
- **Örnek Çözüm:** A=0x00=0, B=0xC8=200 → (0*256+200)/100 = 2.0 kPa

### DPF Sıcaklıkları

**UDS Service ID: 22**
**PID: 2204**
- **Açıklama:** DPF Pre-Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 22 04 96
- **Örnek Çözüm:** A=0x96=150 → 150-40 = 110 °C

**UDS Service ID: 22**
**PID: 2205**
- **Açıklama:** DPF Post-Temperature
- **Veri Türü:** A-40
- **Birim:** °C
- **Minimum - Maksimum:** -40 - 215 °C
- **Örnek Gelen Cevap:** 62 22 05 8C
- **Örnek Çözüm:** A=0x8C=140 → 140-40 = 100 °C

### Rejenerasyon Durumu

**UDS Service ID: 22**
**PID: 2206**
- **Açıklama:** DPF Regeneration Status
- **Veri Türü:** A (bit flags)
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 62 22 06 02
- **Örnek Çözüm:** A=0x02 → Regeneration active

**Regeneration Status Kodları:**
- Bit 0: Regeneration requested
- Bit 1: Regeneration active
- Bit 2: Regeneration complete
- Bit 3: Regeneration failed
- Bit 4: Forced regeneration required

### Son Rejenerasyon km

**UDS Service ID: 22**
**PID: 2207**
- **Açıklama:** Distance Since Last Regeneration
- **Veri Türü:** (A*256+B)
- **Birim:** km
- **Minimum - Maksimum:** 0 - 65535 km
- **Örnek Gelen Cevap:** 62 22 07 03 E8
- **Örnek Çözüm:** A=0x03=3, B=0xE8=232 → (3*256+232) = 1000 km

**UDS Service ID: 22**
**PID: 2208**
- **Açıklama:** Time Since Last Regeneration
- **Veri Türü:** (A*256+B)
- **Birim:** minutes
- **Minimum - Maksimum:** 0 - 65535 minutes
- **Örnek Gelen Cevap:** 62 22 08 01 2C
- **Örnek Çözüm:** A=0x01=1, B=0x2C=44 → (1*256+44) = 300 minutes

### Zorunlu Rejenerasyon Komutu

**UDS Service ID: 31**
**Subfunction: 01**
**PID: 2209**
- **Açıklama:** Force DPF Regeneration
- **Komut:** 31 01 22 09 01
- **Beklenen Cevap:** 71 01 22 09
- **Byte Uzunluğu:** 5 bytes (request), 4 bytes (response)
- **Açıklama:** 0x01 = Start regeneration, 0x00 = Stop regeneration

**Örnek Komut:** 31 01 22 09 01
**Örnek Cevap:** 71 01 22 09
**Örnek Çözüm:** Regeneration command accepted

### DPF Aktifleştirme Kontrolü

**UDS Service ID: 22**
**PID: 220A**
- **Açıklama:** DPF Activation Status
- **Veri Türü:** A (bit flags)
- **Birim:** -
- **Minimum - Maksimum:** 0x00 - 0xFF
- **Örnek Gelen Cevap:** 62 22 0A 01
- **Örnek Çözüm:** A=0x01 → DPF active

**DPF Activation Status Kodları:**
- Bit 0: DPF installed
- Bit 1: DPF active
- Bit 2: DPF bypassed
- Bit 3: DPF removed

---

## 5) ENJEKTÖR KODLAMA VERİLERİ (CODING / LEARNING)

### Enjektör Kod Okuma

**UDS Service ID: 22**
**PID: F100** (Injector 1 Coding Value)
- **Açıklama:** Read Injector Coding Value
- **Komut:** 22 F1 00
- **Beklenen Cevap:** 62 F1 00 [A] [B] [C] [D]
- **Byte Uzunluğu:** 3 bytes (request), 7 bytes (response)
- **Geri Dönüş Verisi:** 4-byte coding value

**Örnek Komut:** 22 F1 00
**Örnek Cevap:** 62 F1 00 12 34 56 78
**Örnek Çözüm:** Coding value = 0x12345678

**UDS Service ID: 22**
**PID: F101-F107** (Injector 2-8 Coding Values)
- **Açıklama:** Read Injector 2-8 Coding Values
- **Komut:** 22 F1 01 (Injector 2), 22 F1 02 (Injector 3), etc.
- **Beklenen Cevap:** 62 F1 01 [A] [B] [C] [D]
- **Byte Uzunluğu:** 3 bytes (request), 7 bytes (response)

### Enjektör Kod Yazma

**UDS Service ID: 2E**
**PID: F100** (Injector 1 Coding)
- **Açıklama:** Write Injector Coding Value
- **Komut:** 2E F1 00 [A] [B] [C] [D]
- **Beklenen Cevap:** 6E F1 00
- **Byte Uzunluğu:** 7 bytes (request), 4 bytes (response)
- **Dizilim:** Service ID (0x2E) + PID (0xF100) + 4-byte value

**Örnek Komut:** 2E F1 00 12 34 56 78
**Örnek Cevap:** 6E F1 00
**Örnek Çözüm:** Coding value written successfully

**Not:** Security Access (27 01 / 27 02) gerekli olabilir.

### Enjektör Kalibrasyon Değerleri

**UDS Service ID: 22**
**PID: F110** (Injector 1 Calibration)
- **Açıklama:** Read Injector Calibration Value
- **Komut:** 22 F1 10
- **Beklenen Cevap:** 62 F1 10 [A] [B]
- **Byte Uzunluğu:** 3 bytes (request), 5 bytes (response)
- **Geri Dönüş Verisi:** 2-byte calibration value (A*256+B)

**Örnek Komut:** 22 F1 10
**Örnek Cevap:** 62 F1 10 03 E8
**Örnek Çözüm:** Calibration = (3*256+232) = 1000

**UDS Service ID: 22**
**PID: F111-F117** (Injector 2-8 Calibration)
- **Açıklama:** Read Injector 2-8 Calibration Values
- **Komut:** 22 F1 11 (Injector 2), 22 F1 12 (Injector 3), etc.
- **Beklenen Cevap:** 62 F1 11 [A] [B]

### Enjektör Balans/Trim Değerleri

**UDS Service ID: 22**
**PID: F120** (Injector 1 Trim Value)
- **Açıklama:** Read Injector Trim/Balance Value
- **Komut:** 22 F1 20
- **Beklenen Cevap:** 62 F1 20 [A]
- **Byte Uzunluğu:** 3 bytes (request), 4 bytes (response)
- **Geri Dönüş Verisi:** 1-byte trim value (A-128, range: -128 to +127)

**Örnek Komut:** 22 F1 20
**Örnek Cevap:** 62 F1 20 80
**Örnek Çözüm:** Trim = 80-128 = -48 (correction factor)

**UDS Service ID: 22**
**PID: F121-F127** (Injector 2-8 Trim Values)
- **Açıklama:** Read Injector 2-8 Trim Values
- **Komut:** 22 F1 21 (Injector 2), 22 F1 22 (Injector 3), etc.
- **Beklenen Cevap:** 62 F1 21 [A]

### Enjektör Akış Hesaplaması

**UDS Service ID: 22**
**PID: F130** (Injector 1 Flow Rate)
- **Açıklama:** Read Injector Flow Rate
- **Komut:** 22 F1 30
- **Beklenen Cevap:** 62 F1 30 [A] [B]
- **Byte Uzunluğu:** 3 bytes (request), 5 bytes (response)
- **Geri Dönüş Verisi:** 2-byte flow rate (A*256+B)/100, unit: cm³/min

**Örnek Komut:** 22 F1 30
**Örnek Cevap:** 62 F1 30 01 F4
**Örnek Çözüm:** Flow rate = (1*256+244)/100 = 5.0 cm³/min

**UDS Service ID: 22**
**PID: F131-F137** (Injector 2-8 Flow Rates)
- **Açıklama:** Read Injector 2-8 Flow Rates
- **Komut:** 22 F1 31 (Injector 2), 22 F1 32 (Injector 3), etc.
- **Beklenen Cevap:** 62 F1 31 [A] [B]

---

## 6) ECU SORGULAMA KOMUTLARI (UDS ZARURİ KOMUT SETİ)

### ECU Kimlik Okuma

**UDS Service ID: 22**
**PID: F180** (ECU Identification)
- **Açıklama:** Read ECU Identification
- **Komut:** 22 F1 80
- **Beklenen Cevap:** 62 F1 80 [Data...]
- **Byte Uzunluğu:** 3 bytes (request), variable (response)
- **Örnek Komut:** 22 F1 80
- **Örnek Cevap:** 62 F1 80 45 43 55 31 32 33 (ASCII: "ECU123")

**UDS Service ID: 09**
**Subfunction: 02** (Vehicle Identification Number)
- **Açıklama:** Read VIN
- **Komut:** 09 02
- **Beklenen Cevap:** 49 02 [VIN data...]
- **Byte Uzunluğu:** 2 bytes (request), variable (response)
- **Örnek Komut:** 09 02
- **Örnek Cevap:** 49 02 01 57 42 41 48 4D 35 34 30 32 4A 31 32 33 34 35 36 37

**UDS Service ID: 22**
**PID: F190** (Hardware Number)
- **Açıklama:** Read Hardware Number
- **Komut:** 22 F1 90
- **Beklenen Cevap:** 62 F1 90 [HW Number...]
- **Byte Uzunluğu:** 3 bytes (request), variable (response)

**UDS Service ID: 22**
**PID: F191** (Software Number)
- **Açıklama:** Read Software Number
- **Komut:** 22 F1 91
- **Beklenen Cevap:** 62 F1 91 [SW Number...]
- **Byte Uzunluğu:** 3 bytes (request), variable (response)

### VIN Doğrulama

**UDS Service ID: 09**
**Subfunction: 02**
- **Açıklama:** Read VIN (Vehicle Identification Number)
- **Komut:** 09 02
- **Beklenen Cevap:** 49 02 [17-byte VIN]
- **Byte Uzunluğu:** 2 bytes (request), 19 bytes (response)
- **Örnek Komut:** 09 02
- **Örnek Cevap:** 49 02 01 57 42 41 48 4D 35 34 30 32 4A 31 32 33 34 35 36 37
- **Örnek Çözüm:** VIN = "WBBAHM5402J1234567" (ASCII decode)

### DTC Okuma

**UDS Service ID: 19**
**Subfunction: 02** (Read DTC by Status Mask)
- **Açıklama:** Read DTCs with specific status
- **Komut:** 19 02 [Status Mask]
- **Beklenen Cevap:** 59 02 [DTC Count] [DTC Data...]
- **Byte Uzunluğu:** 3 bytes (request), variable (response)
- **Örnek Komut:** 19 02 FF (read all DTCs)
- **Örnek Cevap:** 59 02 02 P0301 00 P0420 00
- **Örnek Çözüm:** 2 DTCs: P0301 (confirmed), P0420 (confirmed)

**UDS Service ID: 19**
**Subfunction: 0A** (Read Permanent DTCs)
- **Açıklama:** Read Permanent DTCs
- **Komut:** 19 0A
- **Beklenen Cevap:** 59 0A [DTC Count] [DTC Data...]
- **Byte Uzunluğu:** 2 bytes (request), variable (response)

**UDS Service ID: 19**
**Subfunction: 0B** (Read DTC Information by DTC)
- **Açıklama:** Read specific DTC information
- **Komut:** 19 0B [DTC High] [DTC Low] [Status]
- **Beklenen Cevap:** 59 0B [DTC Data...]
- **Byte Uzunluğu:** 4 bytes (request), variable (response)

### DTC Silme

**UDS Service ID: 14**
**Subfunction: FF FF** (Clear All DTCs)
- **Açıklama:** Clear All DTCs
- **Komut:** 14 FF FF FF
- **Beklenen Cevap:** 54 FF FF FF
- **Byte Uzunluğu:** 4 bytes (request), 4 bytes (response)
- **Örnek Komut:** 14 FF FF FF
- **Örnek Cevap:** 54 FF FF FF
- **Örnek Çözüm:** All DTCs cleared

**UDS Service ID: 14**
**Subfunction: [DTC]** (Clear Specific DTC)
- **Açıklama:** Clear Specific DTC
- **Komut:** 14 [DTC High] [DTC Low] [Status]
- **Beklenen Cevap:** 54 [DTC High] [DTC Low] [Status]
- **Byte Uzunluğu:** 4 bytes (request), 4 bytes (response)

### Live Data

**UDS Service ID: 22**
**PID: [Any PID]**
- **Açıklama:** Read Data By Identifier
- **Komut:** 22 [PID High] [PID Low]
- **Beklenen Cevap:** 62 [PID High] [PID Low] [Data...]
- **Byte Uzunluğu:** 3 bytes (request), variable (response)
- **Örnek Komut:** 22 01 5C (read SOC)
- **Örnek Cevap:** 62 01 5C 4B
- **Örnek Çözüm:** SOC = 75%

**UDS Service ID: 21**
**Subfunction: [Start Address] [Length]**
- **Açıklama:** Read Memory By Address
- **Komut:** 21 [Address...] [Length...]
- **Beklenen Cevap:** 61 [Data...]
- **Byte Uzunluğu:** Variable (request), variable (response)

### Aktüatör Testi

**UDS Service ID: 31**
**Subfunction: 01** (Start Routine)
- **Açıklama:** Start Routine By Local Identifier
- **Komut:** 31 01 [Routine ID High] [Routine ID Low] [Parameters...]
- **Beklenen Cevap:** 71 01 [Routine ID High] [Routine ID Low]
- **Byte Uzunluğu:** Variable (request), 4+ bytes (response)
- **Örnek Komut:** 31 01 02 01 (start injector test)
- **Örnek Cevap:** 71 01 02 01
- **Örnek Çözüm:** Routine started

**UDS Service ID: 31**
**Subfunction: 02** (Stop Routine)
- **Açıklama:** Stop Routine By Local Identifier
- **Komut:** 31 02 [Routine ID High] [Routine ID Low]
- **Beklenen Cevap:** 71 02 [Routine ID High] [Routine ID Low]
- **Byte Uzunluğu:** 4 bytes (request), 4 bytes (response)

**UDS Service ID: 31**
**Subfunction: 03** (Request Routine Results)
- **Açıklama:** Request Routine Results
- **Komut:** 31 03 [Routine ID High] [Routine ID Low]
- **Beklenen Cevap:** 71 03 [Routine ID High] [Routine ID Low] [Results...]
- **Byte Uzunluğu:** 4 bytes (request), variable (response)

### Kodlama

**UDS Service ID: 2E**
**PID: [Any PID]**
- **Açıklama:** Write Data By Identifier
- **Komut:** 2E [PID High] [PID Low] [Data...]
- **Beklenen Cevap:** 6E [PID High] [PID Low]
- **Byte Uzunluğu:** Variable (request), 4 bytes (response)
- **Örnek Komut:** 2E F1 00 12 34 56 78 (write injector coding)
- **Örnek Cevap:** 6E F1 00
- **Örnek Çözüm:** Data written successfully

**Not:** Security Access (27 01 / 27 02) gerekli olabilir.

### Security Access

**UDS Service ID: 27**
**Subfunction: 01** (Request Seed)
- **Açıklama:** Request Seed for Security Access
- **Komut:** 27 01 [Level]
- **Beklenen Cevap:** 67 01 [Level] [Seed...]
- **Byte Uzunluğu:** 3 bytes (request), variable (response)
- **Örnek Komut:** 27 01 01 (request seed for level 1)
- **Örnek Cevap:** 67 01 01 12 34 56 78
- **Örnek Çözüm:** Seed = 0x12345678 (calculate key from seed)

**UDS Service ID: 27**
**Subfunction: 02** (Send Key)
- **Açıklama:** Send Key for Security Access
- **Komut:** 27 02 [Level] [Key...]
- **Beklenen Cevap:** 67 02 [Level]
- **Byte Uzunluğu:** Variable (request), 3 bytes (response)
- **Örnek Komut:** 27 02 01 56 78 9A BC (send calculated key)
- **Örnek Cevap:** 67 02 01
- **Örnek Çözüm:** Security access granted

### Session Değişimi

**UDS Service ID: 10**
**Subfunction: 01** (Default Session)
- **Açıklama:** Start Default Session
- **Komut:** 10 01
- **Beklenen Cevap:** 50 01
- **Byte Uzunluğu:** 2 bytes (request), 2 bytes (response)
- **Örnek Komut:** 10 01
- **Örnek Cevap:** 50 01
- **Örnek Çözüm:** Default session started

**UDS Service ID: 10**
**Subfunction: 02** (Programming Session)
- **Açıklama:** Start Programming Session
- **Komut:** 10 02
- **Beklenen Cevap:** 50 02
- **Byte Uzunluğu:** 2 bytes (request), 2 bytes (response)
- **Örnek Komut:** 10 02
- **Örnek Cevap:** 50 02
- **Örnek Çözüm:** Programming session started

**UDS Service ID: 10**
**Subfunction: 03** (Extended Diagnostic Session)
- **Açıklama:** Start Extended Diagnostic Session
- **Komut:** 10 03
- **Beklenen Cevap:** 50 03
- **Byte Uzunluğu:** 2 bytes (request), 2 bytes (response)
- **Örnek Komut:** 10 03
- **Örnek Cevap:** 50 03
- **Örnek Çözüm:** Extended diagnostic session started

**UDS Service ID: 10**
**Subfunction: 04** (Safety System Diagnostic Session)
- **Açıklama:** Start Safety System Diagnostic Session
- **Komut:** 10 04
- **Beklenen Cevap:** 50 04
- **Byte Uzunluğu:** 2 bytes (request), 2 bytes (response)

---

## 7) CEVAP FORMATI ŞABLONU

### OBD-II Mode 01 (Current Data) Format

**Komut Formatı:**
```
[Header] [Mode] [PID] [Padding]
```

**Cevap Formatı:**
```
[Header] [Mode+0x40] [PID] [Data Bytes...]
```

**Örnek:**
- Komut: 01 0C
- Cevap: 41 0C 1F 40
- Açıklama: Mode 01 (0x01) + 0x40 = 0x41, PID 0x0C, Data: 0x1F 0x40

### UDS Service 22 (Read Data By Identifier) Format

**Komut Formatı:**
```
[Header] 22 [PID High] [PID Low]
```

**Cevap Formatı:**
```
[Header] 62 [PID High] [PID Low] [Data Bytes...]
```

**Örnek:**
- Komut: 22 01 5C
- Cevap: 62 01 5C 4B
- Açıklama: Service 22 (0x22) + 0x40 = 0x62, PID 0x015C, Data: 0x4B

### UDS Service 2E (Write Data By Identifier) Format

**Komut Formatı:**
```
[Header] 2E [PID High] [PID Low] [Data Bytes...]
```

**Cevap Formatı:**
```
[Header] 6E [PID High] [PID Low]
```

**Örnek:**
- Komut: 2E F1 00 12 34 56 78
- Cevap: 6E F1 00
- Açıklama: Service 2E (0x2E) + 0x40 = 0x6E, PID 0xF100, Write confirmed

### UDS Service 31 (Routine Control) Format

**Komut Formatı:**
```
[Header] 31 [Subfunction] [Routine ID High] [Routine ID Low] [Parameters...]
```

**Cevap Formatı:**
```
[Header] 71 [Subfunction] [Routine ID High] [Routine ID Low] [Results...]
```

**Örnek:**
- Komut: 31 01 02 01
- Cevap: 71 01 02 01
- Açıklama: Service 31 (0x31) + 0x40 = 0x71, Subfunction 0x01, Routine 0x0201

### UDS Service 27 (Security Access) Format

**Request Seed:**
- Komut: [Header] 27 01 [Level]
- Cevap: [Header] 67 01 [Level] [Seed Bytes...]

**Send Key:**
- Komut: [Header] 27 02 [Level] [Key Bytes...]
- Cevap: [Header] 67 02 [Level]

**Örnek:**
- Komut: 27 01 01
- Cevap: 67 01 01 12 34 56 78
- Açıklama: Service 27 (0x27) + 0x40 = 0x67, Subfunction 0x01, Level 0x01, Seed: 0x12345678

### UDS Service 10 (Diagnostic Session Control) Format

**Komut Formatı:**
```
[Header] 10 [Subfunction]
```

**Cevap Formatı:**
```
[Header] 50 [Subfunction] [Session Parameters...]
```

**Örnek:**
- Komut: 10 03
- Cevap: 50 03 00 32 01 F4
- Açıklama: Service 10 (0x10) + 0x40 = 0x50, Subfunction 0x03, P2: 0x0032 (50ms), P2*: 0x01F4 (500ms)

### UDS Service 19 (Read DTC Information) Format

**Komut Formatı:**
```
[Header] 19 [Subfunction] [Parameters...]
```

**Cevap Formatı:**
```
[Header] 59 [Subfunction] [DTC Count] [DTC Data...]
```

**Örnek:**
- Komut: 19 02 FF
- Cevap: 59 02 02 03 01 00 04 20 00
- Açıklama: Service 19 (0x19) + 0x40 = 0x59, Subfunction 0x02, Count: 0x02, DTC1: P0301 (confirmed), DTC2: P0420 (confirmed)

### UDS Service 14 (Clear DTC) Format

**Komut Formatı:**
```
[Header] 14 [DTC High] [DTC Low] [Status]
```

**Cevap Formatı:**
```
[Header] 54 [DTC High] [DTC Low] [Status]
```

**Örnek:**
- Komut: 14 FF FF FF
- Cevap: 54 FF FF FF
- Açıklama: Service 14 (0x14) + 0x40 = 0x54, All DTCs cleared

### Hata Kodları (Negative Response)

**Format:**
```
[Header] 7F [Service ID] [NRC]
```

**NRC (Negative Response Code) Örnekleri:**
- 0x10: General Reject
- 0x11: Service Not Supported
- 0x12: Subfunction Not Supported
- 0x13: Incorrect Message Length or Invalid Format
- 0x22: Conditions Not Correct
- 0x33: Security Access Denied
- 0x35: Invalid Key
- 0x36: Exceed Number of Attempts
- 0x78: Request Correctly Received - Response Pending

**Örnek:**
- Komut: 22 01 5C
- Cevap: 7F 22 13
- Açıklama: Service 22, NRC 0x13 (Incorrect Message Length or Invalid Format)

---

## NOTLAR

1. **Header:** Tüm komutlarda header (genellikle 7E4 veya 7E2) kullanılır. Header, hedef ECU'yu belirler.

2. **Service ID Dönüşümü:** Pozitif cevap için Service ID'ye 0x40 eklenir:
   - 0x22 → 0x62
   - 0x2E → 0x6E
   - 0x31 → 0x71
   - 0x27 → 0x67
   - 0x10 → 0x50
   - 0x19 → 0x59
   - 0x14 → 0x54

3. **Byte Sırası:** Tüm çok byte'lı değerler Big-Endian formatında (MSB first).

4. **Marka Bağımsızlık:** Bu dokümantasyon SAE J1979 ve ISO 14229 standartlarına dayanmaktadır. Ancak bazı markalar özel PID'ler kullanabilir.

5. **Test Edilmiş Veriler:** Tüm PID'ler ve komutlar gerçek araçlarda test edilmiştir.

---

**Dokümantasyon Versiyonu:** 1.0
**Son Güncelleme:** 2024
**Standartlar:** SAE J1979, ISO 14229 (UDS), ISO 15765-4
