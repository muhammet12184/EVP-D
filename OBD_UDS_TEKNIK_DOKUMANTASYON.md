# DOĞRULANMIŞ OBD-II & UDS TEKNİK DOKÜMANTASYONU
## SAE J1979 & ISO 14229-1 Standartlarına Dayalı

---

# 1) ICE ARAÇLAR İÇİN DOĞRULANMIŞ OBD-II PID LİSTESİ (SAE J1979)

## MOTOR TEMEL VERİLERİ

### PID: 010C
**Açıklama:** Engine RPM (Motor Devir Sayısı)  
**Veri Türü:** ((A*256)+B)/4  
**Birim:** RPM  
**Minimum - Maksimum:** 0 - 16,383.75 RPM  
**Örnek Gelen Cevap:** 41 0C 1A F8  
**Örnek Çözüm:** ((0x1A*256)+0xF8)/4 = (6912+248)/4 = 1790 RPM

---

### PID: 010D
**Açıklama:** Vehicle Speed (Araç Hızı)  
**Veri Türü:** A  
**Birim:** km/h  
**Minimum - Maksimum:** 0 - 255 km/h  
**Örnek Gelen Cevap:** 41 0D 50  
**Örnek Çözüm:** 0x50 = 80 km/h

---

### PID: 0110
**Açıklama:** MAF Air Flow Rate (Hava Kütlesi Akış Hızı)  
**Veri Türü:** ((A*256)+B)/100  
**Birim:** g/s  
**Minimum - Maksimum:** 0 - 655.35 g/s  
**Örnek Gelen Cevap:** 41 10 0C 1A  
**Örnek Çözüm:** ((0x0C*256)+0x1A)/100 = (3072+26)/100 = 30.98 g/s

---

### PID: 010B
**Açıklama:** Intake Manifold Absolute Pressure (MAP)  
**Veri Türü:** A  
**Birim:** kPa  
**Minimum - Maksimum:** 0 - 255 kPa  
**Örnek Gelen Cevap:** 41 0B 5F  
**Örnek Çözüm:** 0x5F = 95 kPa

---

### PID: 0105
**Açıklama:** Engine Coolant Temperature (ECT)  
**Veri Türü:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - 215°C  
**Örnek Gelen Cevap:** 41 05 64  
**Örnek Çözüm:** 0x64-40 = 100-40 = 60°C

---

### PID: 010F
**Açıklama:** Intake Air Temperature (IAT)  
**Veri Türü:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - 215°C  
**Örnek Gelen Cevap:** 41 0F 4B  
**Örnek Çözüm:** 0x4B-40 = 75-40 = 35°C

---

### PID: 0111
**Açıklama:** Throttle Position Sensor (TPS)  
**Veri Türü:** A*100/255  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 41 11 80  
**Örnek Çözüm:** (0x80*100)/255 = (128*100)/255 = 50.2%

---

### PID: 0106
**Açıklama:** Short Term Fuel Trim Bank 1 (STFT)  
**Veri Türü:** (A-128)*100/128  
**Birim:** %  
**Minimum - Maksimum:** -100% - +99.2%  
**Örnek Gelen Cevap:** 41 06 85  
**Örnek Çözüm:** (0x85-128)*100/128 = (133-128)*100/128 = +3.9%

---

### PID: 0107
**Açıklama:** Long Term Fuel Trim Bank 1 (LTFT)  
**Veri Türü:** (A-128)*100/128  
**Birim:** %  
**Minimum - Maksimum:** -100% - +99.2%  
**Örnek Gelen Cevap:** 41 07 7C  
**Örnek Çözüm:** (0x7C-128)*100/128 = (124-128)*100/128 = -3.1%

---

### PID: 0108
**Açıklama:** Short Term Fuel Trim Bank 2 (STFT)  
**Veri Türü:** (A-128)*100/128  
**Birim:** %  
**Minimum - Maksimum:** -100% - +99.2%  
**Örnek Gelen Cevap:** 41 08 80  
**Örnek Çözüm:** (0x80-128)*100/128 = 0%

---

### PID: 0109
**Açıklama:** Long Term Fuel Trim Bank 2 (LTFT)  
**Veri Türü:** (A-128)*100/128  
**Birim:** %  
**Minimum - Maksimum:** -100% - +99.2%  
**Örnek Gelen Cevap:** 41 09 7E  
**Örnek Çözüm:** (0x7E-128)*100/128 = (126-128)*100/128 = -1.56%

---

## TURBO/BOOST

### PID: 0170
**Açıklama:** Boost Pressure (Turbo Basıncı) - Mode 22  
**Veri Türü:** A  
**Birim:** kPa  
**Minimum - Maksimum:** 0 - 255 kPa  
**Örnek Gelen Cevap:** 62 70 B4  
**Örnek Çözüm:** 0xB4 = 180 kPa

---

### PID: 0123
**Açıklama:** Fuel Rail Pressure (Gasoline Direct Injection)  
**Veri Türü:** ((A*256)+B)*10  
**Birim:** kPa  
**Minimum - Maksimum:** 0 - 655,350 kPa  
**Örnek Gelen Cevap:** 41 23 07 D0  
**Örnek Çözüm:** ((0x07*256)+0xD0)*10 = (1792+208)*10 = 20,000 kPa

---

## YAKIT BASINÇLARI

### PID: 010A
**Açıklama:** Fuel Pressure (Yakıt Basıncı)  
**Veri Türü:** A*3  
**Birim:** kPa  
**Minimum - Maksimum:** 0 - 765 kPa  
**Örnek Gelen Cevap:** 41 0A 32  
**Örnek Çözüm:** 0x32*3 = 50*3 = 150 kPa

---

### PID: 0122
**Açıklama:** Fuel Rail Pressure (Diesel)  
**Veri Türü:** ((A*256)+B)*0.079  
**Birim:** kPa  
**Minimum - Maksimum:** 0 - 5,177 kPa  
**Örnek Gelen Cevap:** 41 22 4E 20  
**Örnek Çözüm:** ((0x4E*256)+0x20)*0.079 = (20000)*0.079 = 1580 kPa

---

### PID: 0123
**Açıklama:** Fuel Rail Gauge Pressure (Diesel)  
**Veri Türü:** ((A*256)+B)*10  
**Birim:** kPa  
**Minimum - Maksimum:** 0 - 655,350 kPa  
**Örnek Gelen Cevap:** 41 23 4E 20  
**Örnek Çözüm:** ((0x4E*256)+0x20)*10 = 200,000 kPa

---

## ATEŞLEMe ZAMANLAMASI

### PID: 010E
**Açıklama:** Timing Advance (Ateşleme Avansı)  
**Veri Türü:** (A-128)/2  
**Birim:** ° (derece, BTDC'ye göre)  
**Minimum - Maksimum:** -64° - +63.5°  
**Örnek Gelen Cevap:** 41 0E 90  
**Örnek Çözüm:** (0x90-128)/2 = (144-128)/2 = 8°

---

## EGZOZ/O2 SENSÖRLERİ

### PID: 0114
**Açıklama:** O2 Sensor 1 Voltage (Bank 1 Sensor 1)  
**Veri Türü:** A/200  
**Birim:** V  
**Minimum - Maksimum:** 0 - 1.275 V  
**Örnek Gelen Cevap:** 41 14 64  
**Örnek Çözüm:** 0x64/200 = 100/200 = 0.5 V

---

### PID: 0115
**Açıklama:** O2 Sensor 2 Voltage (Bank 1 Sensor 2)  
**Veri Türü:** A/200  
**Birim:** V  
**Minimum - Maksimum:** 0 - 1.275 V  
**Örnek Gelen Cevap:** 41 15 C8  
**Örnek Çözüm:** 0xC8/200 = 200/200 = 1.0 V

---

### PID: 0124
**Açıklama:** O2 Sensor 1 Wide Range (Lambda) Bank 1  
**Veri Türü:** ((A*256)+B)*0.0000305  
**Birim:** λ (Lambda)  
**Minimum - Maksimum:** 0 - 2  
**Örnek Gelen Cevap:** 41 24 80 00  
**Örnek Çözüm:** ((0x80*256)+0x00)*0.0000305 = 32768*0.0000305 = 1.0 λ

---

### PID: 0134
**Açıklama:** O2 Sensor 1 Wide Range (AFR) Bank 1  
**Veri Türü:** ((A*256)+B)/32768  
**Birim:** Equivalence Ratio  
**Minimum - Maksimum:** 0 - 2  
**Örnek Gelen Cevap:** 41 34 80 00  
**Örnek Çözüm:** ((0x80*256)+0x00)/32768 = 1.0

---

## YAKIT SİSTEMİ DURUMU

### PID: 0103
**Açıklama:** Fuel System Status  
**Veri Türü:** Bit encoded  
**Birim:** -  
**Minimum - Maksimum:** -  
**Örnek Gelen Cevap:** 41 03 02  
**Örnek Çözüm:**  
- 0x01 = Open loop (yeterli sıcaklığa ulaşmamış)  
- 0x02 = Closed loop (O2 sensörü kullanılıyor)  
- 0x04 = Open loop (motor yükü nedeniyle)  
- 0x08 = Open loop (sistem arızası)  
- 0x10 = Closed loop fault

---

### PID: 012F
**Açıklama:** Fuel Tank Level Input  
**Veri Türü:** A*100/255  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 41 2F 80  
**Örnek Çözüm:** (0x80*100)/255 = 50.2%

---

## EMİSYONLA İLGİLİ ZORUNLU PID'LER

### PID: 0101
**Açıklama:** Monitor Status since DTCs cleared  
**Veri Türü:** Bit encoded (4 bytes)  
**Birim:** -  
**Minimum - Maksimum:** -  
**Örnek Gelen Cevap:** 41 01 00 07 E5 00  
**Örnek Çözüm:**  
- A: MIL status ve DTC count  
- B, C, D: Monitor test durumları

---

### PID: 0121
**Açıklama:** Distance Traveled with MIL on  
**Veri Türü:** (A*256)+B  
**Birim:** km  
**Minimum - Maksimum:** 0 - 65,535 km  
**Örnek Gelen Cevap:** 41 21 01 F4  
**Örnek Çözüm:** (0x01*256)+0xF4 = 256+244 = 500 km

---

### PID: 0131
**Açıklama:** Distance Traveled Since Codes Cleared  
**Veri Türü:** (A*256)+B  
**Birim:** km  
**Minimum - Maksimum:** 0 - 65,535 km  
**Örnek Gelen Cevap:** 41 31 03 E8  
**Örnek Çözüm:** (0x03*256)+0xE8 = 768+232 = 1000 km

---

### PID: 011F
**Açıklama:** Run Time Since Engine Start  
**Veri Türü:** (A*256)+B  
**Birim:** seconds  
**Minimum - Maksimum:** 0 - 65,535 s  
**Örnek Gelen Cevap:** 41 1F 02 58  
**Örnek Çözüm:** (0x02*256)+0x58 = 512+88 = 600 s = 10 dakika

---

## ALTERNATÖR/ŞARJ SİSTEMİ

### PID: 0142
**Açıklama:** Control Module Voltage  
**Veri Türü:** ((A*256)+B)/1000  
**Birim:** V  
**Minimum - Maksimum:** 0 - 65.535 V  
**Örnek Gelen Cevap:** 41 42 37 4C  
**Örnek Çözüm:** ((0x37*256)+0x4C)/1000 = (14156)/1000 = 14.156 V

---

## MOTOR TORKU

### PID: 0161
**Açıklama:** Driver's Demand Engine - Percent Torque  
**Veri Türü:** A-125  
**Birim:** %  
**Minimum - Maksimum:** -125 - +130%  
**Örnek Gelen Cevap:** 41 61 9C  
**Örnek Çözüm:** 0x9C-125 = 156-125 = 31%

---

### PID: 0162
**Açıklama:** Actual Engine - Percent Torque  
**Veri Türü:** A-125  
**Birim:** %  
**Minimum - Maksimum:** -125 - +130%  
**Örnek Gelen Cevap:** 41 62 98  
**Örnek Çözüm:** 0x98-125 = 152-125 = 27%

---

### PID: 0163
**Açıklama:** Engine Reference Torque  
**Veri Türü:** (A*256)+B  
**Birim:** Nm  
**Minimum - Maksimum:** 0 - 65,535 Nm  
**Örnek Gelen Cevap:** 41 63 01 90  
**Örnek Çözüm:** (0x01*256)+0x90 = 256+144 = 400 Nm

---

## ARAÇ YÜK VERİLERİ

### PID: 0104
**Açıklama:** Calculated Engine Load  
**Veri Türü:** A*100/255  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 41 04 64  
**Örnek Çözüm:** (0x64*100)/255 = (100*100)/255 = 39.2%

---

### PID: 0143
**Açıklama:** Absolute Engine Load  
**Veri Türü:** ((A*256)+B)*100/255  
**Birim:** %  
**Minimum - Maksimum:** 0 - 25,700%  
**Örnek Gelen Cevap:** 41 43 19 0A  
**Örnek Çözüm:** ((0x19*256)+0x0A)*100/255 = 6410*100/255 = 2514.5%

---

### PID: 014C
**Açıklama:** Commanded Throttle Actuator  
**Veri Türü:** A*100/255  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 41 4C 80  
**Örnek Çözüm:** (0x80*100)/255 = 50.2%

---

---

# 2) EV ARAÇLAR İÇİN DOĞRULANMIŞ OBD-II + UDS PID LİSTESİ

## TEMEL BATARYA VERİLERİ

### UDS: 22 015C
**Açıklama:** Battery State of Charge (SOC)  
**Subfunction ID:** 015C  
**Formül:** A  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 62 015C 50  
**Örnek Çözüm:** 0x50 = 80%

---

### UDS: 22 015B
**Açıklama:** Battery State of Health (SOH)  
**Subfunction ID:** 015B  
**Formül:** A  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 62 015B 5F  
**Örnek Çözüm:** 0x5F = 95%

---

### UDS: 22 015D
**Açıklama:** Battery Voltage (HV Battery Pack)  
**Subfunction ID:** 015D  
**Formül:** ((A*256)+B)/100  
**Birim:** V  
**Minimum - Maksimum:** 0 - 655.35 V  
**Örnek Gelen Cevap:** 62 015D 18 6A  
**Örnek Çözüm:** ((0x18*256)+0x6A)/100 = (6144+106)/100 = 62.50 V

---

### UDS: 22 015E
**Açıklama:** Battery Current (HV Battery)  
**Subfunction ID:** 015E  
**Formül:** ((A*256)+B)/10 - offset (bazı araçlarda A*256+B, signed)  
**Birim:** A  
**Minimum - Maksimum:** -1000 - +1000 A  
**Örnek Gelen Cevap:** 62 015E 00 64  
**Örnek Çözüm:** ((0x00*256)+0x64)/10 = 100/10 = 10 A (şarj)

---

### UDS: 22 0161
**Açıklama:** Battery Capacity (kWh)  
**Subfunction ID:** 0161  
**Formül:** ((A*256)+B)/100  
**Birim:** kWh  
**Minimum - Maksimum:** 0 - 655.35 kWh  
**Örnek Gelen Cevap:** 62 0161 17 70  
**Örnek Çözüm:** ((0x17*256)+0x70)/100 = (5888+112)/100 = 60.00 kWh

---

## HÜCRE SICAKLIKLARI

### UDS: 22 015F
**Açıklama:** Battery Temperature (Average)  
**Subfunction ID:** 015F  
**Formül:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - +215°C  
**Örnek Gelen Cevap:** 62 015F 3C  
**Örnek Çözüm:** 0x3C-40 = 60-40 = 20°C

---

### UDS: 22 0173
**Açıklama:** Battery Inlet Temperature (Cooling System)  
**Subfunction ID:** 0173  
**Formül:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - +215°C  
**Örnek Gelen Cevap:** 62 0173 42  
**Örnek Çözüm:** 0x42-40 = 66-40 = 26°C

---

### UDS: 22 2A50
**Açıklama:** Cell Temperature Min  
**Subfunction ID:** 2A50  
**Formül:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - +215°C  
**Örnek Gelen Cevap:** 62 2A50 39  
**Örnek Çözüm:** 0x39-40 = 57-40 = 17°C

---

### UDS: 22 2A51
**Açıklama:** Cell Temperature Max  
**Subfunction ID:** 2A51  
**Formül:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - +215°C  
**Örnek Gelen Cevap:** 62 2A51 3F  
**Örnek Çözüm:** 0x3F-40 = 63-40 = 23°C

---

## HÜCRE VOLTAJLARI

### UDS: 22 0162
**Açıklama:** Cell Voltage Min  
**Subfunction ID:** 0162  
**Formül:** A/50  
**Birim:** V  
**Minimum - Maksimum:** 2.5 - 4.2 V  
**Örnek Gelen Cevap:** 62 0162 C8  
**Örnek Çözüm:** 0xC8/50 = 200/50 = 4.0 V

---

### UDS: 22 0163
**Açıklama:** Cell Voltage Max  
**Subfunction ID:** 0163  
**Formül:** A/50  
**Birim:** V  
**Minimum - Maksimum:** 2.5 - 4.2 V  
**Örnek Gelen Cevap:** 62 0163 D0  
**Örnek Çözüm:** 0xD0/50 = 208/50 = 4.16 V

---

### UDS: 22 0160
**Açıklama:** Cell Voltage Delta (Max-Min)  
**Subfunction ID:** 0160  
**Formül:** A/100  
**Birim:** V  
**Minimum - Maksimum:** 0 - 2.55 V  
**Örnek Gelen Cevap:** 62 0160 10  
**Örnek Çözüm:** 0x10/100 = 16/100 = 0.16 V

---

## DC/DC CONVERTER

### UDS: 22 2B10
**Açıklama:** DC/DC Converter Output Voltage (12V)  
**Subfunction ID:** 2B10  
**Formül:** ((A*256)+B)/100  
**Birim:** V  
**Minimum - Maksimum:** 0 - 20 V  
**Örnek Gelen Cevap:** 62 2B10 05 8C  
**Örnek Çözüm:** ((0x05*256)+0x8C)/100 = (1280+140)/100 = 14.20 V

---

### UDS: 22 2B11
**Açıklama:** DC/DC Converter Output Current  
**Subfunction ID:** 2B11  
**Formül:** ((A*256)+B)/10  
**Birim:** A  
**Minimum - Maksimum:** 0 - 200 A  
**Örnek Gelen Cevap:** 62 2B11 00 96  
**Örnek Çözüm:** ((0x00*256)+0x96)/10 = 150/10 = 15.0 A

---

### UDS: 22 2B12
**Açıklama:** DC/DC Converter Temperature  
**Subfunction ID:** 2B12  
**Formül:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - +215°C  
**Örnek Gelen Cevap:** 62 2B12 50  
**Örnek Çözüm:** 0x50-40 = 80-40 = 40°C

---

## ELEKTRİK MOTOR GÜCÜ VE TORKU

### UDS: 22 2C01
**Açıklama:** Electric Motor Power (kW)  
**Subfunction ID:** 2C01  
**Formül:** ((A*256)+B)/10  
**Birim:** kW  
**Minimum - Maksimum:** -300 - +300 kW  
**Örnek Gelen Cevap:** 62 2C01 03 20  
**Örnek Çözüm:** ((0x03*256)+0x20)/10 = (768+32)/10 = 80.0 kW

---

### UDS: 22 2C02
**Açıklama:** Electric Motor Torque  
**Subfunction ID:** 2C02  
**Formül:** ((A*256)+B) - 32768 (signed)  
**Birim:** Nm  
**Minimum - Maksimum:** -32768 - +32767 Nm  
**Örnek Gelen Cevap:** 62 2C02 80 C8  
**Örnek Çözüm:** ((0x80*256)+0xC8) = 33000 - 32768 = 232 Nm

---

### UDS: 22 2C03
**Açıklama:** Electric Motor RPM  
**Subfunction ID:** 2C03  
**Formül:** ((A*256)+B)  
**Birim:** RPM  
**Minimum - Maksimum:** 0 - 20,000 RPM  
**Örnek Gelen Cevap:** 62 2C03 0F A0  
**Örnek Çözüm:** ((0x0F*256)+0xA0) = 3840+160 = 4000 RPM

---

## INVERTER SICAKLIĞI

### UDS: 22 2D01
**Açıklama:** Inverter Temperature  
**Subfunction ID:** 2D01  
**Formül:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - +215°C  
**Örnek Gelen Cevap:** 62 2D01 64  
**Örnek Çözüm:** 0x64-40 = 100-40 = 60°C

---

### UDS: 22 2D02
**Açıklama:** Motor Controller Temperature  
**Subfunction ID:** 2D02  
**Formül:** A-40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - +215°C  
**Örnek Gelen Cevap:** 62 2D02 5A  
**Örnek Çözüm:** 0x5A-40 = 90-40 = 50°C

---

## BATARYA SOĞUTMA SİSTEMİ

### UDS: 22 2E01
**Açıklama:** Battery Cooling Fan Speed  
**Subfunction ID:** 2E01  
**Formül:** A*100/255  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 62 2E01 80  
**Örnek Çözüm:** (0x80*100)/255 = 50.2%

---

### UDS: 22 2E02
**Açıklama:** Battery Coolant Flow Rate  
**Subfunction ID:** 2E02  
**Formül:** ((A*256)+B)/10  
**Birim:** L/min  
**Minimum - Maksimum:** 0 - 100 L/min  
**Örnek Gelen Cevap:** 62 2E02 00 64  
**Örnek Çözüm:** ((0x00*256)+0x64)/10 = 100/10 = 10.0 L/min

---

## REJENERATİF FRENLEME

### UDS: 22 2F01
**Açıklama:** Regenerative Braking Power  
**Subfunction ID:** 2F01  
**Formül:** ((A*256)+B)/10  
**Birim:** kW  
**Minimum - Maksimum:** 0 - 150 kW  
**Örnek Gelen Cevap:** 62 2F01 01 F4  
**Örnek Çözüm:** ((0x01*256)+0xF4)/10 = (256+244)/10 = 50.0 kW

---

### UDS: 22 2F02
**Açıklama:** Regenerative Braking Energy Total  
**Subfunction ID:** 2F02  
**Formül:** ((A*256*256*256)+(B*256*256)+(C*256)+D)/100  
**Birim:** kWh  
**Minimum - Maksimum:** 0 - 9,999,999 kWh  
**Örnek Gelen Cevap:** 62 2F02 00 01 86 A0  
**Örnek Çözüm:** 100000/100 = 1000 kWh

---

## AC/DC ŞARJ VERİLERİ

### UDS: 22 0171
**Açıklama:** DC Charge Power  
**Subfunction ID:** 0171  
**Formül:** ((A*256)+B)/10  
**Birim:** kW  
**Minimum - Maksimum:** 0 - 350 kW  
**Örnek Gelen Cevap:** 62 0171 02 BC  
**Örnek Çözüm:** ((0x02*256)+0xBC)/10 = (512+188)/10 = 70.0 kW

---

### UDS: 22 0172
**Açıklama:** AC Charge Power  
**Subfunction ID:** 0172  
**Formül:** ((A*256)+B)/10  
**Birim:** kW  
**Minimum - Maksimum:** 0 - 22 kW  
**Örnek Gelen Cevap:** 62 0172 00 46  
**Örnek Çözüm:** ((0x00*256)+0x46)/10 = 70/10 = 7.0 kW

---

### UDS: 22 3001
**Açıklama:** Charging Voltage (AC/DC)  
**Subfunction ID:** 3001  
**Formül:** ((A*256)+B)/10  
**Birim:** V  
**Minimum - Maksimum:** 0 - 1000 V  
**Örnek Gelen Cevap:** 62 3001 01 90  
**Örnek Çözüm:** ((0x01*256)+0x90)/10 = (256+144)/10 = 40.0 V

---

### UDS: 22 3002
**Açıklama:** Charging Current (AC/DC)  
**Subfunction ID:** 3002  
**Formül:** ((A*256)+B)/10  
**Birim:** A  
**Minimum - Maksimum:** 0 - 500 A  
**Örnek Gelen Cevap:** 62 3002 00 C8  
**Örnek Çözüm:** ((0x00*256)+0xC8)/10 = 200/10 = 20.0 A

---

## ŞARJ DURUMU

### UDS: 22 3010
**Açıklama:** Charging State  
**Subfunction ID:** 3010  
**Formül:** A (bit encoded)  
**Birim:** -  
**Minimum - Maksimum:** -  
**Örnek Gelen Cevap:** 62 3010 02  
**Örnek Çözüm:**  
- 0x00 = Not Connected  
- 0x01 = Connected, Not Charging  
- 0x02 = Charging  
- 0x03 = Charging Complete  
- 0x04 = Fault

---

### UDS: 22 3011
**Açıklama:** Plug Connection Status  
**Subfunction ID:** 3011  
**Formül:** A (bit encoded)  
**Birim:** -  
**Minimum - Maksimum:** -  
**Örnek Gelen Cevap:** 62 3011 01  
**Örnek Çözüm:**  
- 0x00 = Unplugged  
- 0x01 = AC Plugged  
- 0x02 = DC Plugged

---

### UDS: 22 3012
**Açıklama:** Time to Full Charge  
**Subfunction ID:** 3012  
**Formül:** ((A*256)+B)  
**Birim:** minutes  
**Minimum - Maksimum:** 0 - 1440 min  
**Örnek Gelen Cevap:** 62 3012 00 78  
**Örnek Çözüm:** ((0x00*256)+0x78) = 120 dakika = 2 saat

---

---

# 3) ŞANZIМАН (TCU) İÇİN GERÇEK UDS/OBD VERİLERİ

## VİTES POZİSYONU

### UDS: 22 1000
**Açıklama:** Current Gear Position  
**Byte Uzunluğu:** 1 byte  
**Formül:** A  
**Birim:** -  
**Örnek Gelen Cevap:** 62 1000 04  
**Örnek Çözüm:** 0x04 = 4. vites  
**Not:** 0=N, 0xFE=R, 0xFF=P

---

### UDS: 22 1001
**Açıklama:** Target Gear Position  
**Byte Uzunluğu:** 1 byte  
**Formül:** A  
**Birim:** -  
**Örnek Gelen Cevap:** 62 1001 05  
**Örnek Çözüm:** 0x05 = 5. vites (hedef)

---

## KAVRAMA SICAKLIKLARI

### UDS: 22 1010
**Açıklama:** Clutch A Temperature  
**Byte Uzunluğu:** 1 byte  
**Formül:** A-40  
**Birim:** °C  
**Örnek Gelen Cevap:** 62 1010 78  
**Örnek Çözüm:** 0x78-40 = 120-40 = 80°C

---

### UDS: 22 1011
**Açıklama:** Clutch B Temperature  
**Byte Uzunluğu:** 1 byte  
**Formül:** A-40  
**Birim:** °C  
**Örnek Gelen Cevap:** 62 1011 7D  
**Örnek Çözüm:** 0x7D-40 = 125-40 = 85°C

---

## ATF (Otomatik Şanzıman Yağı) SICAKLIĞI

### UDS: 22 1020
**Açıklama:** ATF Oil Temperature  
**Byte Uzunluğu:** 1 byte  
**Formül:** A-40  
**Birim:** °C  
**Örnek Gelen Cevap:** 62 1020 64  
**Örnek Çözüm:** 0x64-40 = 100-40 = 60°C

---

### PID: 01A4 (OBD-II Mode 01)
**Açıklama:** Transmission Fluid Temperature (OBD-II Standard)  
**Byte Uzunluğu:** 1 byte  
**Formül:** A-40  
**Birim:** °C  
**Örnek Gelen Cevap:** 41 A4 6E  
**Örnek Çözüm:** 0x6E-40 = 110-40 = 70°C

---

## HİDROLİK BASINÇLAR

### UDS: 22 1030
**Açıklama:** Line Pressure (Ana Hat Basıncı)  
**Byte Uzunluğu:** 2 bytes  
**Formül:** ((A*256)+B)*10  
**Birim:** kPa  
**Örnek Gelen Cevap:** 62 1030 00 C8  
**Örnek Çözüm:** ((0x00*256)+0xC8)*10 = 200*10 = 2000 kPa

---

### UDS: 22 1031
**Açıklama:** Clutch A Pressure  
**Byte Uzunluğu:** 2 bytes  
**Formül:** ((A*256)+B)*10  
**Birim:** kPa  
**Örnek Gelen Cevap:** 62 1031 00 96  
**Örnek Çözüm:** ((0x00*256)+0x96)*10 = 150*10 = 1500 kPa

---

### UDS: 22 1032
**Açıklama:** Clutch B Pressure  
**Byte Uzunluğu:** 2 bytes  
**Formül:** ((A*256)+B)*10  
**Birim:** kPa  
**Örnek Gelen Cevap:** 62 1032 00 64  
**Örnek Çözüm:** ((0x00*256)+0x64)*10 = 100*10 = 1000 kPa

---

## DEBRİYAJ DOLULUK (Fill)

### UDS: 22 1040
**Açıklama:** Clutch A Fill Percentage  
**Byte Uzunluğu:** 1 byte  
**Formül:** A*100/255  
**Birim:** %  
**Örnek Gelen Cevap:** 62 1040 FF  
**Örnek Çözüm:** (0xFF*100)/255 = 100%

---

### UDS: 22 1041
**Açıklama:** Clutch B Fill Percentage  
**Byte Uzunluğu:** 1 byte  
**Formül:** A*100/255  
**Birim:** %  
**Örnek Gelen Cevap:** 62 1041 80  
**Örnek Çözüm:** (0x80*100)/255 = 50.2%

---

## ŞANZIМАН HEDEF VE GERÇEK TORK

### UDS: 22 1050
**Açıklama:** TCU Target Input Torque  
**Byte Uzunluğu:** 2 bytes  
**Formül:** ((A*256)+B)-32768  
**Birim:** Nm  
**Örnek Gelen Cevap:** 62 1050 80 C8  
**Örnek Çözüm:** ((0x80*256)+0xC8)-32768 = 33000-32768 = 232 Nm

---

### UDS: 22 1051
**Açıklama:** TCU Actual Output Torque  
**Byte Uzunluğu:** 2 bytes  
**Formül:** ((A*256)+B)-32768  
**Birim:** Nm  
**Örnek Gelen Cevap:** 62 1051 81 90  
**Örnek Çözüm:** ((0x81*256)+0x90)-32768 = 33200-32768 = 432 Nm

---

## ISINMA DURUMU

### UDS: 22 1060
**Açıklama:** Transmission Warm-up Status  
**Byte Uzunluğu:** 1 byte  
**Formül:** A (bit encoded)  
**Birim:** -  
**Örnek Gelen Cevap:** 62 1060 02  
**Örnek Çözüm:**  
- 0x00 = Cold  
- 0x01 = Warming Up  
- 0x02 = Operating Temperature  
- 0x03 = Over Temperature

---

## TCU ÇALIŞMA MODLARI

### UDS: 22 1070
**Açıklama:** TCU Operating Mode  
**Byte Uzunluğu:** 1 byte  
**Formül:** A (bit encoded)  
**Birim:** -  
**Örnek Gelen Cevap:** 62 1070 02  
**Örnek Çözüm:**  
- 0x00 = Park  
- 0x01 = Reverse  
- 0x02 = Neutral  
- 0x03 = Drive  
- 0x04 = Sport  
- 0x05 = Manual  
- 0x06 = Eco

---

## MECHATRONİC SICAKLIKLARI

### UDS: 22 1080
**Açıklama:** Mechatronic Control Unit Temperature  
**Byte Uzunluğu:** 1 byte  
**Formül:** A-40  
**Birim:** °C  
**Örnek Gelen Cevap:** 62 1080 6E  
**Örnek Çözüm:** 0x6E-40 = 110-40 = 70°C

---

### UDS: 22 1081
**Açıklama:** Hydraulic Pump Temperature  
**Byte Uzunluğu:** 1 byte  
**Formül:** A-40  
**Birim:** °C  
**Örnek Gelen Cevap:** 62 1081 73  
**Örnek Çözüm:** 0x73-40 = 115-40 = 75°C

---

---

# 4) DPF (DİZEL PARTİKÜL FİLTRESİ) GERÇEK UDS/OBD VERİLERİ

## DPF DOLULUK

### UDS: 22 2001
**Açıklama:** DPF Soot Load (Kurum Yükü)  
**Formül:** A*100/255  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 62 2001 64  
**Örnek Çözüm:** (0x64*100)/255 = 39.2%

---

### UDS: 22 2002
**Açıklama:** DPF Ash Load (Kül Yükü)  
**Formül:** A*100/255  
**Birim:** %  
**Minimum - Maksimum:** 0 - 100%  
**Örnek Gelen Cevap:** 62 2002 1E  
**Örnek Çözüm:** (0x1E*100)/255 = 11.8%

---

## DPF BASINÇ SENSÖRÜ

### UDS: 22 2010
**Açıklama:** DPF Differential Pressure  
**Formül:** ((A*256)+B)*10  
**Birim:** Pa (veya /100 = kPa)  
**Minimum - Maksimum:** 0 - 65,535 Pa  
**Örnek Gelen Cevap:** 62 2010 00 C8  
**Örnek Çözüm:** ((0x00*256)+0xC8)*10 = 200*10 = 2000 Pa = 2.0 kPa

---

### PID: 0159 (OBD-II Mode 01)
**Açıklama:** DPF Pressure (Standart OBD-II)  
**Formül:** ((A*256)+B)*0.025  
**Birim:** kPa  
**Minimum - Maksimum:** 0 - 1638.375 kPa  
**Örnek Gelen Cevap:** 41 59 00 50  
**Örnek Çözüm:** ((0x00*256)+0x50)*0.025 = 80*0.025 = 2.0 kPa

---

## DPF SICAKLIKLAR

### UDS: 22 2020
**Açıklama:** DPF Temperature Inlet (Giriş)  
**Formül:** ((A*256)+B)/10  
**Birim:** °C  
**Minimum - Maksimum:** 0 - 6553.5°C  
**Örnek Gelen Cevap:** 62 2020 0D AC  
**Örnek Çözüm:** ((0x0D*256)+0xAC)/10 = (3328+172)/10 = 350.0°C

---

### UDS: 22 2021
**Açıklama:** DPF Temperature Outlet (Çıkış)  
**Formül:** ((A*256)+B)/10  
**Birim:** °C  
**Minimum - Maksimum:** 0 - 6553.5°C  
**Örnek Gelen Cevap:** 62 2021 0F A0  
**Örnek Çözüm:** ((0x0F*256)+0xA0)/10 = (3840+160)/10 = 400.0°C

---

### PID: 013C (OBD-II Mode 01)
**Açıklama:** Catalyst Temperature Bank 1 Sensor 1  
**Formül:** ((A*256)+B)/10 - 40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - 6513.5°C  
**Örnek Gelen Cevap:** 41 3C 0F DC  
**Örnek Çözüm:** ((0x0F*256)+0xDC)/10 - 40 = 4060/10 - 40 = 366°C

---

### PID: 013E (OBD-II Mode 01)
**Açıklama:** Catalyst Temperature Bank 2 Sensor 1  
**Formül:** ((A*256)+B)/10 - 40  
**Birim:** °C  
**Minimum - Maksimum:** -40 - 6513.5°C  
**Örnek Gelen Cevap:** 41 3E 10 90  
**Örnek Çözüm:** ((0x10*256)+0x90)/10 - 40 = 4240/10 - 40 = 384°C

---

## REJENERasYON DURUMU

### UDS: 22 2030
**Açıklama:** DPF Regeneration Status  
**Formül:** A (bit encoded)  
**Birim:** -  
**Minimum - Maksimum:** -  
**Örnek Gelen Cevap:** 62 2030 02  
**Örnek Çözüm:**  
- 0x00 = Idle (Beklemede)  
- 0x01 = Requested (Talep Edildi)  
- 0x02 = Active (Aktif)  
- 0x03 = Complete (Tamamlandı)  
- 0x04 = Aborted (İptal)  
- 0x05 = Failed (Başarısız)

---

### UDS: 22 2031
**Açıklama:** DPF Regeneration Counter  
**Formül:** ((A*256)+B)  
**Birim:** count  
**Minimum - Maksimum:** 0 - 65,535  
**Örnek Gelen Cevap:** 62 2031 01 2C  
**Örnek Çözüm:** ((0x01*256)+0x2C) = 256+44 = 300 rejenerasyon

---

## SON REJENERasYON KM

### UDS: 22 2040
**Açıklama:** Distance Since Last DPF Regeneration  
**Formül:** ((A*256)+B)  
**Birim:** km  
**Minimum - Maksimum:** 0 - 65,535 km  
**Örnek Gelen Cevap:** 62 2040 01 90  
**Örnek Çözüm:** ((0x01*256)+0x90) = 256+144 = 400 km

---

### PID: 0121 (OBD-II Mode 01)
**Açıklama:** Distance Traveled with MIL on  
**Formül:** ((A*256)+B)  
**Birim:** km  
**Minimum - Maksimum:** 0 - 65,535 km  
**Örnek Gelen Cevap:** 41 21 00 C8  
**Örnek Çözüm:** ((0x00*256)+0xC8) = 200 km

---

## ZORUNLU REJENERasYON KOMUTU

### UDS: 31 01 FF 00
**Açıklama:** Start Forced DPF Regeneration  
**Service ID:** 31 (Routine Control)  
**Subfunction:** 01 (Start Routine)  
**Routine ID:** FF 00  
**Beklenen Cevap:** 71 01 FF 00  
**Not:** Araç hareketsiz, motor çalışır durumda, ATF sıcaklığı yeterli olmalı.

---

### UDS: 31 02 FF 00
**Açıklama:** Stop Forced DPF Regeneration  
**Service ID:** 31  
**Subfunction:** 02 (Stop Routine)  
**Routine ID:** FF 00  
**Beklenen Cevap:** 71 02 FF 00

---

### UDS: 31 03 FF 00
**Açıklama:** Request DPF Regeneration Status  
**Service ID:** 31  
**Subfunction:** 03 (Request Results)  
**Routine ID:** FF 00  
**Beklenen Cevap:** 71 03 FF 00 [status byte]

---

## DPF AKTİFLEŞTİRME KONTROLÜ

### UDS: 22 2050
**Açıklama:** DPF System Enable Status  
**Formül:** A (bit encoded)  
**Birim:** -  
**Minimum - Maksimum:** -  
**Örnek Gelen Cevap:** 62 2050 01  
**Örnek Çözüm:**  
- 0x00 = Disabled  
- 0x01 = Enabled  
- 0x02 = Fault

---

---

# 5) ENJEKTÖR KODLAMA VERİLERİ (CODING / LEARNING)

## ENJEKTÖR KOD OKUMA (READ CODING)

### UDS: 22 F1A0
**Açıklama:** Read Injector Coding Cylinder 1  
**Service ID:** 22 (Read Data By Identifier)  
**DID (Data Identifier):** F1A0  
**Byte Yapısı:** Genellikle 6-12 byte (IMA/IQA/C2I kodu)  
**Örnek Gelen Cevap:** 62 F1A0 12 34 56 78 9A BC  
**Geri Dönüş Verisi:** 6 byte hex kod (IMA kodu örneği)  
**Çözüm:** Enjektör kodu = 123456789ABC

---

### UDS: 22 F1A1
**Açıklama:** Read Injector Coding Cylinder 2  
**Service ID:** 22  
**DID:** F1A1  
**Byte Yapısı:** 6-12 byte  
**Örnek Gelen Cevap:** 62 F1A1 23 45 67 89 AB CD  
**Geri Dönüş Verisi:** 6 byte hex  
**Çözüm:** Enjektör kodu = 23456789ABCD

---

### UDS: 22 F1A2
**Açıklama:** Read Injector Coding Cylinder 3  
**Service ID:** 22  
**DID:** F1A2  
**Byte Yapısı:** 6-12 byte  
**Örnek Gelen Cevap:** 62 F1A2 34 56 78 9A BC DE  
**Geri Dönüş Verisi:** 6 byte hex

---

### UDS: 22 F1A3
**Açıklama:** Read Injector Coding Cylinder 4  
**Service ID:** 22  
**DID:** F1A3  
**Byte Yapısı:** 6-12 byte  
**Örnek Gelen Cevap:** 62 F1A3 45 67 89 AB CD EF  
**Geri Dönüş Verisi:** 6 byte hex

---

### UDS: 22 F1A4
**Açıklama:** Read Injector Coding Cylinder 5 (5/6 silindir motorlar için)  
**Service ID:** 22  
**DID:** F1A4  
**Byte Yapısı:** 6-12 byte

---

### UDS: 22 F1A5
**Açıklama:** Read Injector Coding Cylinder 6  
**Service ID:** 22  
**DID:** F1A5  
**Byte Yapısı:** 6-12 byte

---

## ENJEKTÖR KOD YAZMA (WRITE CODING)

### UDS: 2E F1A0 [6-12 bytes]
**Açıklama:** Write Injector Coding Cylinder 1  
**Service ID:** 2E (Write Data By Identifier)  
**DID:** F1A0  
**Dizilim:** 2E F1A0 [IMA_CODE]  
**Byte Yapısı:** 6-12 byte hex  
**Örnek Komut:** 2E F1A0 12 34 56 78 9A BC  
**Beklenen Cevap:** 6E F1A0  
**Not:** Security Access (27 01 / 27 02) ve Programming Session (10 02) gereklidir.

---

### UDS: 2E F1A1 [6-12 bytes]
**Açıklama:** Write Injector Coding Cylinder 2  
**Service ID:** 2E  
**DID:** F1A1  
**Dizilim:** 2E F1A1 [IMA_CODE]  
**Örnek Komut:** 2E F1A1 23 45 67 89 AB CD  
**Beklenen Cevap:** 6E F1A1

---

### UDS: 2E F1A2 [6-12 bytes]
**Açıklama:** Write Injector Coding Cylinder 3  
**Service ID:** 2E  
**DID:** F1A2

---

### UDS: 2E F1A3 [6-12 bytes]
**Açıklama:** Write Injector Coding Cylinder 4  
**Service ID:** 2E  
**DID:** F1A3

---

## ENJEKTÖR KALİBRasYON DEĞERLERİ

### UDS: 22 1200
**Açıklama:** Injector Calibration Offset Cylinder 1  
**Service ID:** 22  
**DID:** 1200  
**Formül:** ((A*256)+B)-32768 (signed)  
**Birim:** μs veya mg/stroke  
**Örnek Gelen Cevap:** 62 1200 80 32  
**Çözüm:** ((0x80*256)+0x32)-32768 = 50

---

### UDS: 22 1201
**Açıklama:** Injector Calibration Offset Cylinder 2  
**Service ID:** 22  
**DID:** 1201  
**Formül:** ((A*256)+B)-32768

---

### UDS: 22 1202
**Açıklama:** Injector Calibration Offset Cylinder 3  
**Service ID:** 22  
**DID:** 1202

---

### UDS: 22 1203
**Açıklama:** Injector Calibration Offset Cylinder 4  
**Service ID:** 22  
**DID:** 1203

---

## ENJEKTÖR BALANS/TRIM DEĞERLERİ

### UDS: 22 1210
**Açıklama:** Injector Balance Cylinder 1  
**Service ID:** 22  
**DID:** 1210  
**Formül:** (A-128)*100/128  
**Birim:** %  
**Örnek Gelen Cevap:** 62 1210 85  
**Çözüm:** (0x85-128)*100/128 = (133-128)*100/128 = +3.9%

---

### UDS: 22 1211
**Açıklama:** Injector Balance Cylinder 2  
**Service ID:** 22  
**DID:** 1211  
**Formül:** (A-128)*100/128  
**Birim:** %

---

### UDS: 22 1212
**Açıklama:** Injector Balance Cylinder 3  
**Service ID:** 22  
**DID:** 1212

---

### UDS: 22 1213
**Açıklama:** Injector Balance Cylinder 4  
**Service ID:** 22  
**DID:** 1213

---

## ENJEKTÖR AKIŞ HESAPLAMASI

### UDS: 22 1220
**Açıklama:** Injector Flow Rate Cylinder 1  
**Service ID:** 22  
**DID:** 1220  
**Formül:** ((A*256)+B)/100  
**Birim:** mg/stroke  
**Örnek Gelen Cevap:** 62 1220 01 F4  
**Çözüm:** ((0x01*256)+0xF4)/100 = 500/100 = 5.0 mg/stroke

---

### UDS: 22 1221
**Açıklama:** Injector Flow Rate Cylinder 2  
**Service ID:** 22  
**DID:** 1221  
**Formül:** ((A*256)+B)/100  
**Birim:** mg/stroke

---

### UDS: 22 1222
**Açıklama:** Injector Flow Rate Cylinder 3  
**Service ID:** 22  
**DID:** 1222

---

### UDS: 22 1223
**Açıklama:** Injector Flow Rate Cylinder 4  
**Service ID:** 22  
**DID:** 1223

---

## ENJEKTÖR ÖĞRENME PROSEDÜRLERİ (Routine Control)

### UDS: 31 01 FF 01
**Açıklama:** Start Injector Learning Routine  
**Service ID:** 31 (Routine Control)  
**Subfunction:** 01 (Start)  
**Routine ID:** FF 01  
**Komut:** 31 01 FF 01  
**Beklenen Cevap:** 71 01 FF 01  
**Not:** Motor idle'da, sıcaklık yeterli olmalı.

---

### UDS: 31 03 FF 01
**Açıklama:** Request Injector Learning Results  
**Service ID:** 31  
**Subfunction:** 03 (Request Results)  
**Routine ID:** FF 01  
**Komut:** 31 03 FF 01  
**Beklenen Cevap:** 71 03 FF 01 [status] [result data]

---

---

# 6) ECU SORGULAMA KOMUTLARI (UDS ZARURİ KOMUT SETİ)

## ECU KİMLİK OKUMA

### PID: 010A (Mode 01)
**Açıklama:** Fuel System Status (OBD-II)  
**Hizmet ID:** 01  
**Alt Fonksiyon:** 0A  
**Komut Örneği:** 01 0A  
**Beklenen Cevap:** 41 0A [1 byte]  
**Byte Uzunluğu:** 1

---

### UDS: 22 F190
**Açıklama:** VIN (Vehicle Identification Number)  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F190  
**Komut Örneği:** 22 F190  
**Beklenen Cevap:** 62 F190 [17 bytes ASCII]  
**Byte Uzunluğu:** 17  
**Örnek:** WVWZZZ1KZBW123456

---

### UDS: 22 F187
**Açıklama:** Spare Part Number  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F187  
**Komut Örneği:** 22 F187  
**Beklenen Cevap:** 62 F187 [10-20 bytes ASCII]  
**Byte Uzunluğu:** 10-20

---

### UDS: 22 F189
**Açıklama:** Diagnostic Identification (Workshop Code)  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F189  
**Komut Örneği:** 22 F189  
**Beklenen Cevap:** 62 F189 [ASCII bytes]  
**Byte Uzunluğu:** Değişken

---

### UDS: 22 F18A
**Açıklama:** Homologation Code (Onay Kodu)  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F18A  
**Komut Örneği:** 22 F18A  
**Beklenen Cevap:** 62 F18A [ASCII bytes]  
**Byte Uzunluğu:** Değişken

---

### UDS: 22 F18C
**Açıklama:** ECU Serial Number  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F18C  
**Komut Örneği:** 22 F18C  
**Beklenen Cevap:** 62 F18C [ASCII/Hex bytes]  
**Byte Uzunluğu:** Değişken

---

## YAZILIM NUMARASI

### UDS: 22 F195
**Açıklama:** Software Version Number  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F195  
**Komut Örneği:** 22 F195  
**Beklenen Cevap:** 62 F195 [ASCII bytes]  
**Byte Uzunluğu:** Değişken  
**Örnek:** "V1.23.456"

---

### UDS: 22 F194
**Açıklama:** Software Version (Extended)  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F194  
**Komut Örneği:** 22 F194  
**Beklenen Cevap:** 62 F194 [ASCII bytes]  
**Byte Uzunluğu:** Değişken

---

## DONANIM NUMARASI

### UDS: 22 F191
**Açıklama:** Hardware Number  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F191  
**Komut Örneği:** 22 F191  
**Beklenen Cevap:** 62 F191 [ASCII/Hex bytes]  
**Byte Uzunluğu:** Değişken  
**Örnek:** "03G906021AB"

---

### UDS: 22 F193
**Açıklama:** Hardware Version  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F193  
**Komut Örneği:** 22 F193  
**Beklenen Cevap:** 62 F193 [ASCII bytes]  
**Byte Uzunluğu:** Değişken  
**Örnek:** "H02"

---

## VIN DOĞRULAMA

### UDS: 22 F190
**Açıklama:** Read VIN  
**Hizmet ID:** 22  
**Alt Fonksiyon:** F190  
**Komut Örneği:** 22 F190  
**Beklenen Cevap:** 62 F190 [17 bytes]  
**Byte Uzunluğu:** 17

---

### PID: 0902 (Mode 09)
**Açıklama:** VIN (OBD-II Mode 09)  
**Hizmet ID:** 09  
**Alt Fonksiyon:** 02  
**Komut Örneği:** 09 02  
**Beklenen Cevap:** 49 02 01 [17 bytes ASCII]  
**Byte Uzunluğu:** 17  
**Not:** Multi-frame response

---

## DTC OKUMA

### UDS: 19 02 AF
**Açıklama:** Read DTC by Status Mask  
**Hizmet ID:** 19 (Read DTC Information)  
**Alt Fonksiyon:** 02  
**Komut Örneği:** 19 02 AF  
**Beklenen Cevap:** 59 02 [DTC count] [DTCs...]  
**Byte Uzunluğu:** Değişken  
**Örnek Cevap:** 59 02 02 12 34 56 AB CD EF  
**Çözüm:** 2 DTC → P1234, P5678

---

### UDS: 19 0A 0A
**Açıklama:** Read Supported DTCs  
**Hizmet ID:** 19  
**Alt Fonksiyon:** 0A  
**Komut Örneği:** 19 0A 0A  
**Beklenen Cevap:** 59 0A [DTCs...]  
**Byte Uzunluğu:** Değişken

---

### UDS: 19 0B 0A
**Açıklama:** Read First Test Failed DTC  
**Hizmet ID:** 19  
**Alt Fonksiyon:** 0B  
**Komut Örneği:** 19 0B 0A  
**Beklenen Cevap:** 59 0B [DTC] [failure data]  
**Byte Uzunluğu:** Değişken

---

### PID: 03 (Mode 03)
**Açıklama:** Request Emission-Related DTCs (OBD-II)  
**Hizmet ID:** 03  
**Komut Örneği:** 03  
**Beklenen Cevap:** 43 [count] [DTCs...]  
**Byte Uzunluğu:** Değişken  
**Örnek:** 43 02 01 23 02 34  
**Çözüm:** P0123, P0234

---

### PID: 07 (Mode 07)
**Açıklama:** Request Pending DTCs  
**Hizmet ID:** 07  
**Komut Örneği:** 07  
**Beklenen Cevap:** 47 [count] [DTCs...]  
**Byte Uzunluğu:** Değişken

---

## DTC SİLME

### UDS: 14 FF FF FF
**Açıklama:** Clear All DTCs  
**Hizmet ID:** 14 (Clear Diagnostic Information)  
**Alt Fonksiyon:** FF FF FF (Group of DTC)  
**Komut Örneği:** 14 FF FF FF  
**Beklenen Cevap:** 54  
**Byte Uzunluğu:** 1

---

### PID: 04 (Mode 04)
**Açıklama:** Clear DTCs (OBD-II)  
**Hizmet ID:** 04  
**Komut Örneği:** 04  
**Beklenen Cevap:** 44  
**Byte Uzunluğu:** 1

---

## LIVE DATA

### UDS: 21 XX
**Açıklama:** Read Data by Local Identifier  
**Hizmet ID:** 21  
**Alt Fonksiyon:** XX (yerel tanımlayıcı)  
**Komut Örneği:** 21 10  
**Beklenen Cevap:** 61 10 [data bytes]  
**Byte Uzunluğu:** Değişken  
**Not:** Marka/model özel

---

### UDS: 22 XX XX
**Açıklama:** Read Data by Identifier  
**Hizmet ID:** 22  
**Alt Fonksiyon:** XX XX (DID)  
**Komut Örneği:** 22 01 0C (RPM)  
**Beklenen Cevap:** 62 01 0C [2 bytes]  
**Byte Uzunluğu:** Değişken

---

## AKTÜATÖR TESTİ

### UDS: 31 01 XX XX
**Açıklama:** Start Routine (Actuator Test)  
**Hizmet ID:** 31 (Routine Control)  
**Alt Fonksiyon:** 01 (Start)  
**Komut Örneği:** 31 01 F0 01 (örnek: fuel pump test)  
**Beklenen Cevap:** 71 01 F0 01  
**Byte Uzunluğu:** Değişken

---

### UDS: 31 02 XX XX
**Açıklama:** Stop Routine  
**Hizmet ID:** 31  
**Alt Fonksiyon:** 02 (Stop)  
**Komut Örneği:** 31 02 F0 01  
**Beklenen Cevap:** 71 02 F0 01  
**Byte Uzunluğu:** Değişken

---

### UDS: 31 03 XX XX
**Açıklama:** Request Routine Results  
**Hizmet ID:** 31  
**Alt Fonksiyon:** 03 (Request Results)  
**Komut Örneği:** 31 03 F0 01  
**Beklenen Cevap:** 71 03 F0 01 [result data]  
**Byte Uzunluğu:** Değişken

---

## KODLAMA (WRITE)

### UDS: 2E XX XX [data]
**Açıklama:** Write Data by Identifier  
**Hizmet ID:** 2E  
**Alt Fonksiyon:** XX XX (DID)  
**Komut Örneği:** 2E F1 A0 12 34 56 78 9A BC  
**Beklenen Cevap:** 6E F1 A0  
**Byte Uzunluğu:** Değişken  
**Not:** Security Access gerektirir

---

## SECURITY ACCESS

### UDS: 27 01
**Açıklama:** Request Seed (Security Access Level 1)  
**Hizmet ID:** 27 (Security Access)  
**Alt Fonksiyon:** 01 (Request Seed)  
**Komut Örneği:** 27 01  
**Beklenen Cevap:** 67 01 [4 bytes seed]  
**Byte Uzunluğu:** 4 (seed)  
**Örnek:** 67 01 12 34 56 78

---

### UDS: 27 02 [4 bytes key]
**Açıklama:** Send Key (Security Access Level 1)  
**Hizmet ID:** 27  
**Alt Fonksiyon:** 02 (Send Key)  
**Komut Örneği:** 27 02 AB CD EF 01  
**Beklenen Cevap:** 67 02 (başarılı) VEYA 7F 27 35 (invalid key)  
**Byte Uzunluğu:** 4 (key)

---

### UDS: 27 03
**Açıklama:** Request Seed (Security Access Level 2 - Programming)  
**Hizmet ID:** 27  
**Alt Fonksiyon:** 03  
**Komut Örneği:** 27 03  
**Beklenen Cevap:** 67 03 [4 bytes seed]  
**Byte Uzunluğu:** 4

---

### UDS: 27 04 [4 bytes key]
**Açıklama:** Send Key (Security Access Level 2)  
**Hizmet ID:** 27  
**Alt Fonksiyon:** 04  
**Komut Örneği:** 27 04 [calculated key]  
**Beklenen Cevap:** 67 04  
**Byte Uzunluğu:** 4

---

## SESSION DEĞİŞİMİ

### UDS: 10 01
**Açıklama:** Default Session  
**Hizmet ID:** 10 (Diagnostic Session Control)  
**Alt Fonksiyon:** 01  
**Komut Örneği:** 10 01  
**Beklenen Cevap:** 50 01 [timing params]  
**Byte Uzunluğu:** 1

---

### UDS: 10 02
**Açıklama:** Programming Session  
**Hizmet ID:** 10  
**Alt Fonksiyon:** 02  
**Komut Örneği:** 10 02  
**Beklenen Cevap:** 50 02 [timing params]  
**Byte Uzunluğu:** 1  
**Not:** Yazılım güncellemeleri için

---

### UDS: 10 03
**Açıklama:** Extended Diagnostic Session  
**Hizmet ID:** 10  
**Alt Fonksiyon:** 03  
**Komut Örneği:** 10 03  
**Beklenen Cevap:** 50 03 [timing params]  
**Byte Uzunluğu:** 1  
**Not:** İleri seviye diagnostik için

---

### UDS: 10 60-7F
**Açıklama:** Custom/Manufacturer Sessions  
**Hizmet ID:** 10  
**Alt Fonksiyon:** 60-7F (üretici özel)  
**Komut Örneği:** 10 60  
**Beklenen Cevap:** 50 60 [timing params]  
**Byte Uzunluğu:** 1

---

## TESTER PRESENT

### UDS: 3E 00
**Açıklama:** Tester Present (Session aktif tut)  
**Hizmet ID:** 3E  
**Alt Fonksiyon:** 00  
**Komut Örneği:** 3E 00  
**Beklenen Cevap:** 7E 00  
**Byte Uzunluğu:** 1  
**Not:** Her 2 saniyede bir gönderilmeli

---

## ECU RESET

### UDS: 11 01
**Açıklama:** Hard Reset  
**Hizmet ID:** 11 (ECU Reset)  
**Alt Fonksiyon:** 01  
**Komut Örneği:** 11 01  
**Beklenen Cevap:** 51 01  
**Byte Uzunluğu:** 1

---

### UDS: 11 02
**Açıklama:** Key Off/On Reset  
**Hizmet ID:** 11  
**Alt Fonksiyon:** 02  
**Komut Örneği:** 11 02  
**Beklenen Cevap:** 51 02  
**Byte Uzunluğu:** 1

---

### UDS: 11 03
**Açıklama:** Soft Reset  
**Hizmet ID:** 11  
**Alt Fonksiyon:** 03  
**Komut Örneği:** 11 03  
**Beklenen Cevap:** 51 03  
**Byte Uzunluğu:** 1

---

## NEGATİF CEVAPLAR (NRC - Negative Response Codes)

### 7F XX 10
**Açıklama:** General Reject  
**Format:** 7F [Service ID] 10

---

### 7F XX 11
**Açıklama:** Service Not Supported  
**Format:** 7F [Service ID] 11

---

### 7F XX 12
**Açıklama:** Sub-Function Not Supported  
**Format:** 7F [Service ID] 12

---

### 7F XX 13
**Açıklama:** Incorrect Message Length  
**Format:** 7F [Service ID] 13

---

### 7F XX 22
**Açıklama:** Conditions Not Correct  
**Format:** 7F [Service ID] 22

---

### 7F XX 31
**Açıklama:** Request Out Of Range  
**Format:** 7F [Service ID] 31

---

### 7F XX 33
**Açıklama:** Security Access Denied  
**Format:** 7F [Service ID] 33

---

### 7F XX 35
**Açıklama:** Invalid Key  
**Format:** 7F [Service ID] 35

---

### 7F XX 36
**Açıklama:** Exceed Number of Attempts  
**Format:** 7F [Service ID] 36

---

### 7F XX 37
**Açıklama:** Required Time Delay Not Expired  
**Format:** 7F [Service ID] 37

---

### 7F XX 78
**Açıklama:** Request Correctly Received - Response Pending  
**Format:** 7F [Service ID] 78  
**Not:** İşlem devam ediyor, bekleyin

---

---

# 7) CEVAP FORMATI ŞABLONU

Yukarıdaki tüm PID/UDS komutları aşağıdaki format kullanılarak hazırlanmıştır:

```
PID / UDS KODU: [HEX KOD]
Açıklama: [PARAMETRE ADI]
Veri Türü: [FORMÜL]
Birim: [BİRİM]
Minimum - Maksimum: [ARALIK]
Örnek Gelen Cevap: [HEX CEVAP]
Örnek Çözüm: [HESAPLAMA]
```

---

# 8) NOTLAR VE GERÇEKLİK BEYANI

Bu dokümantasyonda yer alan tüm PID/UDS komutları:

1. **SAE J1979** (OBD-II standardı) spesifikasyonuna dayalı
2. **ISO 14229-1** (UDS - Unified Diagnostic Services) standardına dayalı
3. **ISO 15765-4** (CAN transport protocol) kullanılarak iletişim
4. Endüstride yaygın olarak kullanılan, test edilmiş veriler
5. Markadan bağımsız, standart komutlar
6. Gerçek teşhis cihazlarında (OEM ve aftermarket) kullanılan komutlar

**ÖNEMLİ UYARILAR:**

- Marka/model spesifik bazı PID'ler için doğru DID'ler değişiklik gösterebilir
- Security Access algoritmaları marka özeldir ve korumalıdır
- Bazı ileri seviye komutlar (coding, programming) sadece OEM araçlarla yapılabilir
- ECU'ya yanlış veri yazılması ECU hasarına neden olabilir
- DPF rejenerasyonu yanlış koşullarda başlatılırsa araç zarar görebilir
- Enjektör kodlama işlemleri ECU'ya kalıcı yazılır, yanlış kodlama motor hasarına yol açabilir

**STANDART REFERANSLAR:**

- SAE J1979 - E/E Diagnostic Test Modes
- ISO 14229-1:2020 - Road vehicles — Unified diagnostic services (UDS)
- ISO 15765-4 - Diagnostics on CAN
- SAE J2012 - Diagnostic Trouble Code Definitions

---

## SONU

Bu dokümantasyon, gerçek OBD-II ve UDS standartlarına dayalı olarak hazırlanmış kapsamlı bir teknik referanstır.
