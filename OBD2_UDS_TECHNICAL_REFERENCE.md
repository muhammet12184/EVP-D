# OBD-II ve UDS Teknik Referans Dokümanı
## SAE J1979 / ISO 15031-5 / ISO 14229 Standartları

---

# BÖLÜM 1: ICE ARAÇLAR İÇİN OBD-II PID LİSTESİ (SAE J1979 MODE 01)

## 1.1 Motor Temel Verileri

### PID 0x0C - Motor RPM
```
PID / UDS KODU: 01 0C
Açıklama: Motor devir sayısı
Veri Türü: (A*256+B)/4
Birim: RPM
Minimum - Maksimum: 0 - 16383.75 RPM
Byte Sayısı: 2
Örnek Gelen Cevap: 41 0C 1A F8
Örnek Çözüm: (0x1A*256 + 0xF8)/4 = (26*256 + 248)/4 = 6904/4 = 1726 RPM
```

### PID 0x0D - Araç Hızı
```
PID / UDS KODU: 01 0D
Açıklama: Araç hızı (Vehicle Speed)
Veri Türü: A
Birim: km/h
Minimum - Maksimum: 0 - 255 km/h
Byte Sayısı: 1
Örnek Gelen Cevap: 41 0D 50
Örnek Çözüm: 0x50 = 80 km/h
```

### PID 0x10 - MAF (Kütle Hava Akış Sensörü)
```
PID / UDS KODU: 01 10
Açıklama: Mass Air Flow - Emilen hava debisi
Veri Türü: (A*256+B)/100
Birim: g/s (gram/saniye)
Minimum - Maksimum: 0 - 655.35 g/s
Byte Sayısı: 2
Örnek Gelen Cevap: 41 10 01 F4
Örnek Çözüm: (1*256 + 244)/100 = 500/100 = 5.00 g/s
```

### PID 0x0B - MAP (Manifold Basınç Sensörü)
```
PID / UDS KODU: 01 0B
Açıklama: Intake Manifold Absolute Pressure
Veri Türü: A
Birim: kPa
Minimum - Maksimum: 0 - 255 kPa
Byte Sayısı: 1
Örnek Gelen Cevap: 41 0B 65
Örnek Çözüm: 0x65 = 101 kPa (atmosferik basınç)
```

### PID 0x05 - ECT (Motor Soğutma Suyu Sıcaklığı)
```
PID / UDS KODU: 01 05
Açıklama: Engine Coolant Temperature
Veri Türü: A - 40
Birim: °C
Minimum - Maksimum: -40 - 215 °C
Byte Sayısı: 1
Örnek Gelen Cevap: 41 05 7B
Örnek Çözüm: 0x7B - 40 = 123 - 40 = 83°C
```

### PID 0x0F - IAT (Emme Havası Sıcaklığı)
```
PID / UDS KODU: 01 0F
Açıklama: Intake Air Temperature
Veri Türü: A - 40
Birim: °C
Minimum - Maksimum: -40 - 215 °C
Byte Sayısı: 1
Örnek Gelen Cevap: 41 0F 41
Örnek Çözüm: 0x41 - 40 = 65 - 40 = 25°C
```

### PID 0x11 - TPS (Gaz Kelebeği Pozisyonu)
```
PID / UDS KODU: 01 11
Açıklama: Throttle Position Sensor
Veri Türü: A*100/255
Birim: %
Minimum - Maksimum: 0 - 100%
Byte Sayısı: 1
Örnek Gelen Cevap: 41 11 33
Örnek Çözüm: 0x33 * 100 / 255 = 51 * 100 / 255 = 20%
```

### PID 0x06 - STFT Bank 1 (Kısa Vadeli Yakıt Düzeltmesi)
```
PID / UDS KODU: 01 06
Açıklama: Short Term Fuel Trim - Bank 1
Veri Türü: (A-128)*100/128
Birim: %
Minimum - Maksimum: -100% - +99.2%
Byte Sayısı: 1
Örnek Gelen Cevap: 41 06 85
Örnek Çözüm: (0x85-128)*100/128 = (133-128)*100/128 = 3.9%
```

### PID 0x07 - LTFT Bank 1 (Uzun Vadeli Yakıt Düzeltmesi)
```
PID / UDS KODU: 01 07
Açıklama: Long Term Fuel Trim - Bank 1
Veri Türü: (A-128)*100/128
Birim: %
Minimum - Maksimum: -100% - +99.2%
Byte Sayısı: 1
Örnek Gelen Cevap: 41 07 82
Örnek Çözüm: (0x82-128)*100/128 = (130-128)*100/128 = 1.56%
```

### PID 0x08 - STFT Bank 2
```
PID / UDS KODU: 01 08
Açıklama: Short Term Fuel Trim - Bank 2
Veri Türü: (A-128)*100/128
Birim: %
Minimum - Maksimum: -100% - +99.2%
Byte Sayısı: 1
```

### PID 0x09 - LTFT Bank 2
```
PID / UDS KODU: 01 09
Açıklama: Long Term Fuel Trim - Bank 2
Veri Türü: (A-128)*100/128
Birim: %
Minimum - Maksimum: -100% - +99.2%
Byte Sayısı: 1
```

---

## 1.2 Turbo/Boost Verileri

### PID 0x6F - Turbo Compressor Inlet Pressure (SAE J1979-2)
```
PID / UDS KODU: 01 6F
Açıklama: Turbo kompresör giriş basıncı
Veri Türü: Byte A = Desteklenen sensörler, B-C = Sensör A, D-E = Sensör B
Formül Sensör A: (B*256+C)*0.03125 - 400
Birim: kPa
Minimum - Maksimum: -400 - 1638.375 kPa
Byte Sayısı: 5
```

### PID 0x70 - Boost Pressure Control
```
PID / UDS KODU: 01 70
Açıklama: Boost basınç kontrolü
Veri Türü: Byte A = Status, B-C = Sensor A, D-E = Sensor B
Formül: (B*256+C)*0.03125
Birim: kPa
Minimum - Maksimum: 0 - 2047.96875 kPa
Byte Sayısı: 5
```

### PID 0x74 - Turbocharger Temperature (ISO 15031-5)
```
PID / UDS KODU: 01 74
Açıklama: Turbo sıcaklığı
Veri Türü: (A*256+B)*0.1 - 40
Birim: °C
Minimum - Maksimum: -40 - 6513.5 °C
Byte Sayısı: 5 (multi-sensor)
```

### PID 0x75 - Turbocharger RPM
```
PID / UDS KODU: 01 75
Açıklama: Turbo devri
Veri Türü: (A*256+B)*10
Birim: RPM
Minimum - Maksimum: 0 - 655,350 RPM
Byte Sayısı: 4
```

---

## 1.3 Yakıt Basınçları

### PID 0x0A - Fuel Pressure (Gauge)
```
PID / UDS KODU: 01 0A
Açıklama: Yakıt basıncı (düşük basınç tarafı)
Veri Türü: A * 3
Birim: kPa
Minimum - Maksimum: 0 - 765 kPa
Byte Sayısı: 1
Örnek Gelen Cevap: 41 0A 64
Örnek Çözüm: 100 * 3 = 300 kPa
```

### PID 0x23 - Fuel Rail Gauge Pressure (Diesel/GDI)
```
PID / UDS KODU: 01 23
Açıklama: Yakıt rampası basıncı (yüksek basınç - dizel/GDI)
Veri Türü: (A*256+B) * 10
Birim: kPa
Minimum - Maksimum: 0 - 655,350 kPa (655 bar)
Byte Sayısı: 2
Örnek Gelen Cevap: 41 23 03 E8
Örnek Çözüm: (3*256+232)*10 = 1000*10 = 10,000 kPa = 100 bar
```

### PID 0x59 - Fuel Rail Absolute Pressure
```
PID / UDS KODU: 01 59
Açıklama: Yakıt rampası mutlak basıncı
Veri Türü: (A*256+B) * 10
Birim: kPa
Minimum - Maksimum: 0 - 655,350 kPa
Byte Sayısı: 2
```

---

## 1.4 Ateşleme Zamanlaması

### PID 0x0E - Timing Advance
```
PID / UDS KODU: 01 0E
Açıklama: Ateşleme avansı (TDC referansına göre)
Veri Türü: (A/2) - 64
Birim: ° (derece) BTDC
Minimum - Maksimum: -64 - 63.5°
Byte Sayısı: 1
Örnek Gelen Cevap: 41 0E 8C
Örnek Çözüm: (0x8C/2) - 64 = (140/2) - 64 = 70 - 64 = 6° BTDC
```

---

## 1.5 Egzoz/O2 Sensörleri

### PID 0x14-0x1B - O2 Sensor Voltages (Bank 1 & 2, Sensor 1-4)
```
PID / UDS KODU: 01 14 (Bank 1, Sensor 1)
                01 15 (Bank 1, Sensor 2)
                01 16 (Bank 1, Sensor 3)
                01 17 (Bank 1, Sensor 4)
                01 18 (Bank 2, Sensor 1)
                01 19 (Bank 2, Sensor 2)
                01 1A (Bank 2, Sensor 3)
                01 1B (Bank 2, Sensor 4)
Açıklama: O2 sensör voltajı ve kısa vadeli yakıt düzeltmesi
Veri Türü: 
  Byte A (Voltaj): A / 200
  Byte B (STFT): (B-128)*100/128 (eğer B=0xFF ise STFT kullanılmıyor)
Birim: V (voltaj), % (STFT)
Minimum - Maksimum: 0 - 1.275 V
Byte Sayısı: 2
Örnek Gelen Cevap: 41 14 96 80
Örnek Çözüm: Voltaj = 0x96/200 = 150/200 = 0.75V, STFT = (128-128)*100/128 = 0%
```

### PID 0x24-0x2B - O2 Sensor (Wide-band, Air-Fuel Ratio)
```
PID / UDS KODU: 01 24 (Bank 1, Sensor 1)
                01 25 (Bank 1, Sensor 2)
                01 26 (Bank 1, Sensor 3)
                01 27 (Bank 1, Sensor 4)
                01 28 (Bank 2, Sensor 1)
                01 29 (Bank 2, Sensor 2)
                01 2A (Bank 2, Sensor 3)
                01 2B (Bank 2, Sensor 4)
Açıklama: Geniş bantlı O2 sensör - Hava/Yakıt oranı
Veri Türü:
  Byte A-B (Equivalence Ratio): (A*256+B)*2/65536 veya (A*256+B)/32768
  Byte C-D (Voltage): (C*256+D)*8/65536 veya (C*256+D)/8192
Birim: Lambda (oran), V
Minimum - Maksimum: 0-2 (lambda), 0-8V
Byte Sayısı: 4
Örnek Gelen Cevap: 41 24 80 00 40 00
Örnek Çözüm: Lambda = 32768/32768 = 1.0 (stokiyometrik)
            Voltage = 16384/8192 = 2.0V
```

### PID 0x34-0x3B - O2 Sensor (Wide-band, Current)
```
PID / UDS KODU: 01 34 - 01 3B
Açıklama: Geniş bantlı O2 sensör - Akım
Veri Türü:
  Byte A-B (Equivalence Ratio): (A*256+B)/32768
  Byte C-D (Current): (C*256+D)/256 - 128
Birim: Lambda (oran), mA
Minimum - Maksimum: 0-2 (lambda), -128 - +127.996 mA
Byte Sayısı: 4
```

---

## 1.6 Yakıt Sistemi Durumu

### PID 0x03 - Fuel System Status
```
PID / UDS KODU: 01 03
Açıklama: Yakıt sistemi durumu
Veri Türü: Bit-encoded
Byte Sayısı: 2 (her byte bir bank için)
Değerler:
  0x00 = Motor kapalı
  0x01 = Açık döngü - motor sıcaklığı yetersiz
  0x02 = Kapalı döngü - O2 sensör geri beslemesi kullanılıyor
  0x04 = Açık döngü - motor yükü nedeniyle
  0x08 = Açık döngü - sistem arızası nedeniyle
  0x10 = Kapalı döngü - O2 sensör arızası, en az bir hata var
Örnek Gelen Cevap: 41 03 02 00
Örnek Çözüm: Bank 1 = Kapalı döngü, Bank 2 = Kullanılmıyor
```

### PID 0x2F - Fuel Tank Level Input
```
PID / UDS KODU: 01 2F
Açıklama: Yakıt deposu seviyesi
Veri Türü: A * 100 / 255
Birim: %
Minimum - Maksimum: 0 - 100%
Byte Sayısı: 1
Örnek Gelen Cevap: 41 2F CC
Örnek Çözüm: 204 * 100 / 255 = 80%
```

### PID 0x5E - Engine Fuel Rate
```
PID / UDS KODU: 01 5E
Açıklama: Motor yakıt tüketim oranı
Veri Türü: (A*256+B) / 20
Birim: L/h
Minimum - Maksimum: 0 - 3276.75 L/h
Byte Sayısı: 2
Örnek Gelen Cevap: 41 5E 00 C8
Örnek Çözüm: 200/20 = 10 L/h
```

---

## 1.7 Emisyonla İlgili Zorunlu PID'ler

### PID 0x01 - Monitor Status Since DTCs Cleared
```
PID / UDS KODU: 01 01
Açıklama: DTC temizlenmesinden bu yana monitör durumu, MIL durumu
Veri Türü: Bit-encoded (4 byte)
Byte Sayısı: 4
Yapı:
  Byte A, Bit 7: MIL açık/kapalı (1=açık)
  Byte A, Bit 0-6: DTC sayısı
  Byte B: Desteklenen testler (bit-encoded)
  Byte C-D: Test tamamlanma durumu
Örnek Gelen Cevap: 41 01 81 07 65 00
Örnek Çözüm: MIL = AÇIK, DTC sayısı = 1
```

### PID 0x02 - Freeze DTC
```
PID / UDS KODU: 01 02
Açıklama: Freeze frame'e neden olan DTC
Veri Türü: (A*256+B)
Birim: DTC kodu
Byte Sayısı: 2
Örnek Gelen Cevap: 41 02 01 33
Örnek Çözüm: P0133 (O2 Sensor Circuit Slow Response)
```

### PID 0x21 - Distance Traveled with MIL On
```
PID / UDS KODU: 01 21
Açıklama: MIL açıkken kat edilen mesafe
Veri Türü: A*256+B
Birim: km
Minimum - Maksimum: 0 - 65,535 km
Byte Sayısı: 2
```

### PID 0x31 - Distance Since DTC Cleared
```
PID / UDS KODU: 01 31
Açıklama: DTC temizlendikten sonra kat edilen mesafe
Veri Türü: A*256+B
Birim: km
Minimum - Maksimum: 0 - 65,535 km
Byte Sayısı: 2
```

### PID 0x41 - Monitor Status This Drive Cycle
```
PID / UDS KODU: 01 41
Açıklama: Bu sürüş döngüsündeki monitör durumu
Veri Türü: Bit-encoded (4 byte)
Byte Sayısı: 4
```

### PID 0x4D - Time Run with MIL On
```
PID / UDS KODU: 01 4D
Açıklama: MIL açıkken geçen süre
Veri Türü: A*256+B
Birim: dakika
Minimum - Maksimum: 0 - 65,535 dakika
Byte Sayısı: 2
```

### PID 0x4E - Time Since DTC Cleared
```
PID / UDS KODU: 01 4E
Açıklama: DTC temizlendikten sonra geçen süre
Veri Türü: A*256+B
Birim: dakika
Minimum - Maksimum: 0 - 65,535 dakika
Byte Sayısı: 2
```

### PID 0x30 - Warm-ups Since DTC Cleared
```
PID / UDS KODU: 01 30
Açıklama: DTC temizlendikten sonra ısınma döngüsü sayısı
Veri Türü: A
Birim: sayı
Minimum - Maksimum: 0 - 255
Byte Sayısı: 1
```

---

## 1.8 Alternatör/Şarj Sistemi

### PID 0x42 - Control Module Voltage
```
PID / UDS KODU: 01 42
Açıklama: ECU besleme voltajı (akü/şarj sistemi voltajı)
Veri Türü: (A*256+B) / 1000
Birim: V
Minimum - Maksimum: 0 - 65.535 V
Byte Sayısı: 2
Örnek Gelen Cevap: 41 42 37 DC
Örnek Çözüm: (0x37*256 + 0xDC)/1000 = (55*256+220)/1000 = 14300/1000 = 14.3V
```

### PID 0x66 - Mass Air Flow Sensor (includes battery voltage on some vehicles)
```
PID / UDS KODU: 01 66
Açıklama: MAF Sensör B ve ilgili veriler
Veri Türü: Çoklu sensör
Byte Sayısı: 5
```

---

## 1.9 Motor Torku

### PID 0x62 - Actual Engine - Percent Torque
```
PID / UDS KODU: 01 62
Açıklama: Gerçek motor torku yüzdesi
Veri Türü: A - 125
Birim: %
Minimum - Maksimum: -125% - 130%
Byte Sayısı: 1
Örnek Gelen Cevap: 41 62 96
Örnek Çözüm: 150 - 125 = 25%
```

### PID 0x63 - Engine Reference Torque
```
PID / UDS KODU: 01 63
Açıklama: Motor referans torku
Veri Türü: A*256+B
Birim: Nm
Minimum - Maksimum: 0 - 65,535 Nm
Byte Sayısı: 2
Örnek Gelen Cevap: 41 63 01 2C
Örnek Çözüm: 1*256+44 = 300 Nm
```

### PID 0x64 - Engine Percent Torque Data
```
PID / UDS KODU: 01 64
Açıklama: Motor tork verileri (idle, point 1-4)
Veri Türü: Her byte için: değer - 125
Birim: %
Byte Sayısı: 5
Yapı:
  A = Rölanti torku
  B = Nokta 1 tork (motor RPM noktası)
  C = Nokta 2 tork
  D = Nokta 3 tork
  E = Nokta 4 tork
```

### PID 0x61 - Driver's Demand Engine - Percent Torque
```
PID / UDS KODU: 01 61
Açıklama: Sürücü talebi motor torku yüzdesi
Veri Türü: A - 125
Birim: %
Minimum - Maksimum: -125% - 130%
Byte Sayısı: 1
```

---

## 1.10 Araç Yük Verileri

### PID 0x04 - Calculated Engine Load
```
PID / UDS KODU: 01 04
Açıklama: Hesaplanmış motor yükü
Veri Türü: A * 100 / 255
Birim: %
Minimum - Maksimum: 0 - 100%
Byte Sayısı: 1
Örnek Gelen Cevap: 41 04 66
Örnek Çözüm: 102 * 100 / 255 = 40%
```

### PID 0x43 - Absolute Load Value
```
PID / UDS KODU: 01 43
Açıklama: Mutlak yük değeri
Veri Türü: (A*256+B) * 100 / 255
Birim: %
Minimum - Maksimum: 0 - 25700%
Byte Sayısı: 2
```

### PID 0x4C - Commanded Throttle Actuator
```
PID / UDS KODU: 01 4C
Açıklama: Komut edilen gaz kelebeği aktüatör pozisyonu
Veri Türü: A * 100 / 255
Birim: %
Minimum - Maksimum: 0 - 100%
Byte Sayısı: 1
```

---

# BÖLÜM 2: EV ARAÇLAR İÇİN OBD-II + UDS PID LİSTESİ

> **ÖNEMLİ NOT:** EV araçlarda OBD-II Mode 01 PID'leri sınırlıdır. Çoğu veri UDS Service 22 (Read Data By Identifier) ile üreticiye özgü DID'ler kullanılarak okunur. Aşağıdaki veriler, yaygın olarak kullanılan ve birden fazla üreticinin kullandığı DID'lerdir.

## 2.1 Batarya SOC (State of Charge)

### Nissan/Renault (Leaf, Zoe)
```
UDS Service ID: 22
DID (Subfunction): 01 5C
Açıklama: Batarya doluluk durumu
Formül: A
Birim: %
Minimum - Maksimum: 0 - 100%
Header: 7E4
Örnek Komut: 22 01 5C
Örnek Cevap: 62 01 5C 50
Örnek Çözüm: 0x50 = 80%
```

### Hyundai/Kia (Kona, Ioniq, Niro, EV6)
```
UDS Service ID: 22
DID (Subfunction): 01 5C
Açıklama: Batarya doluluk durumu
Formül: A
Birim: %
Minimum - Maksimum: 0 - 100%
Header: 7E4
Örnek Komut: 22 01 5C
Örnek Cevap: 62 01 5C 5A
Örnek Çözüm: 0x5A = 90%
```

### Hyundai/Kia (21xx Serisi - Alternatif)
```
UDS Service ID: 22
DID (Subfunction): 21 01
Açıklama: Batarya SOC (BMS)
Formül: (A*256+B)/10
Birim: %
Minimum - Maksimum: 0 - 100%
Header: 7E4
```

---

## 2.2 Batarya SOH (State of Health)

### Nissan Leaf
```
UDS Service ID: 22
DID (Subfunction): 01 5B
Açıklama: Batarya sağlık durumu
Formül: A
Birim: %
Minimum - Maksimum: 0 - 100%
Header: 7E4
Örnek Komut: 22 01 5B
Örnek Cevap: 62 01 5B 62
Örnek Çözüm: 0x62 = 98%
```

### Hyundai/Kia
```
UDS Service ID: 22
DID (Subfunction): 01 70
Açıklama: Batarya sağlık durumu (BMS hesaplaması)
Formül: A
Birim: %
Minimum - Maksimum: 0 - 100%
Header: 7E4
```

### BMW i3
```
UDS Service ID: 22
DID (Subfunction): 2A 38
Açıklama: HV Battery SOH
Formül: A
Birim: %
Minimum - Maksimum: 0 - 100%
Header: 7E4
```

### PSA (Peugeot/Opel/Citroën)
```
UDS Service ID: 22
DID (Subfunction): F4 0D
Açıklama: Batarya SOH
Formül: A
Birim: %
Minimum - Maksimum: 0 - 100%
Header: 7E4
```

---

## 2.3 Batarya Voltajı

### Genel EV Standardı (Yaygın Kullanım)
```
UDS Service ID: 22
DID (Subfunction): 01 5D
Açıklama: HV Batarya Toplam Voltajı
Formül: (A*256+B)/100
Birim: V
Minimum - Maksimum: 0 - 500 V (655.35 V teorik max)
Header: 7E4
Örnek Komut: 22 01 5D
Örnek Cevap: 62 01 5D 0E 74
Örnek Çözüm: (14*256+116)/100 = 3700/100 = 370.0 V
```

---

## 2.4 Batarya Akımı

### Genel EV Standardı (Yaygın Kullanım)
```
UDS Service ID: 22
DID (Subfunction): 01 5E
Açıklama: HV Batarya Akımı (pozitif=deşarj, negatif=şarj)
Formül: (A*256+B-32768)/10 veya işaretli: ((A*256+B)/10)-3276.8
Birim: A
Minimum - Maksimum: -1000 - +1000 A
Header: 7E4
Örnek Komut: 22 01 5E
Örnek Cevap: 62 01 5E 80 64
Örnek Çözüm: (32868-32768)/10 = 100/10 = +10.0 A (deşarj)
```

---

## 2.5 Hücre Sıcaklıkları

### Batarya Ortalama/Ana Sıcaklık
```
UDS Service ID: 22
DID (Subfunction): 01 5F
Açıklama: Batarya sıcaklığı (ana/ortalama)
Formül: A - 40
Birim: °C
Minimum - Maksimum: -40 - 100 °C
Header: 7E4
Örnek Komut: 22 01 5F
Örnek Cevap: 62 01 5F 41
Örnek Çözüm: 65 - 40 = 25°C
```

### Hyundai/Kia - Batarya Giriş Sıcaklığı
```
UDS Service ID: 22
DID (Subfunction): 01 73
Açıklama: Batarya soğutma suyu giriş sıcaklığı
Formül: A - 40
Birim: °C
Minimum - Maksimum: -40 - 100 °C
Header: 7E4
```

### Hyundai/Kia - Hücre Sıcaklık Detayları (21xx)
```
UDS Service ID: 22
DID (Subfunction): 21 05
Açıklama: Hücre sıcaklıkları (çoklu byte)
Formül: Her byte için: değer - 40
Birim: °C
Header: 7E4
Cevap Yapısı: 62 21 05 [T1] [T2] [T3] ... [Tn]
```

---

## 2.6 Hücre Voltajları

### Minimum Hücre Voltajı
```
UDS Service ID: 22
DID (Subfunction): 01 62
Açıklama: Minimum hücre voltajı
Formül: A/50
Birim: V
Minimum - Maksimum: 2.5 - 4.2 V
Header: 7E4
Örnek Komut: 22 01 62
Örnek Cevap: 62 01 62 B4
Örnek Çözüm: 180/50 = 3.60 V
```

### Maksimum Hücre Voltajı
```
UDS Service ID: 22
DID (Subfunction): 01 63
Açıklama: Maksimum hücre voltajı
Formül: A/50
Birim: V
Minimum - Maksimum: 2.5 - 4.2 V
Header: 7E4
Örnek Komut: 22 01 63
Örnek Cevap: 62 01 63 B7
Örnek Çözüm: 183/50 = 3.66 V
```

### Hücre Voltaj Farkı (Delta)
```
UDS Service ID: 22
DID (Subfunction): 01 60
Açıklama: Hücreler arası maksimum voltaj farkı
Formül: A/100
Birim: V
Minimum - Maksimum: 0 - 1 V
Header: 7E4
Örnek Komut: 22 01 60
Örnek Cevap: 62 01 60 06
Örnek Çözüm: 6/100 = 0.06 V = 60 mV
```

---

## 2.7 DC/DC Converter Verileri

### DC/DC Converter Çıkış Voltajı
```
UDS Service ID: 22
DID (Subfunction): 01 80 (üreticiye bağlı)
Açıklama: DC/DC converter 12V çıkış voltajı
Formül: A/10
Birim: V
Minimum - Maksimum: 10 - 16 V
Header: 7E4
Örnek Cevap: 62 01 80 8E
Örnek Çözüm: 142/10 = 14.2 V
```

### DC/DC Converter Çıkış Akımı
```
UDS Service ID: 22
DID (Subfunction): 01 81 (üreticiye bağlı)
Açıklama: DC/DC converter çıkış akımı
Formül: A
Birim: A
Minimum - Maksimum: 0 - 200 A
Header: 7E4
```

---

## 2.8 Elektrik Motor Gücü

### Motor Gücü Hesaplaması
```
UDS Service ID: 22
DID (Subfunction): 01 64 (üreticiye bağlı)
Açıklama: Elektrik motor gücü
Formül: (A*256+B)/10 veya Voltaj*Akım/1000
Birim: kW
Minimum - Maksimum: -200 - +300 kW (regen negatif)
Header: 7E1 veya 7E2
Not: Çoğu durumda P = V × I / 1000 şeklinde hesaplanır
```

---

## 2.9 Motor Torku

### Motor Torku (Talep)
```
UDS Service ID: 22
DID (Subfunction): 01 65 (üreticiye bağlı)
Açıklama: Talep edilen motor torku
Formül: (A*256+B)/10 - 3276.8 veya işaretli değer
Birim: Nm
Minimum - Maksimum: -500 - +500 Nm
Header: 7E1
```

### Motor Torku (Gerçek)
```
UDS Service ID: 22
DID (Subfunction): 01 66 (üreticiye bağlı)
Açıklama: Gerçek motor torku
Formül: (A*256+B)/10 - 3276.8
Birim: Nm
Minimum - Maksimum: -500 - +500 Nm
Header: 7E1
```

---

## 2.10 Inverter Sıcaklığı

```
UDS Service ID: 22
DID (Subfunction): 01 67 (üreticiye bağlı)
Açıklama: Inverter sıcaklığı
Formül: A - 40
Birim: °C
Minimum - Maksimum: -40 - 150 °C
Header: 7E1
Örnek Cevap: 62 01 67 5A
Örnek Çözüm: 90 - 40 = 50°C
```

---

## 2.11 Batarya Soğutma Sistemi

### Soğutma Pompası Durumu
```
UDS Service ID: 22
DID (Subfunction): 01 74 (üreticiye bağlı)
Açıklama: Batarya soğutma pompası çalışma yüzdesi
Formül: A*100/255
Birim: %
Minimum - Maksimum: 0 - 100%
Header: 7E4
```

### Soğutucu Sıvı Sıcaklığı
```
UDS Service ID: 22
DID (Subfunction): 01 75 (üreticiye bağlı)
Açıklama: Batarya soğutucu sıvı sıcaklığı
Formül: A - 40
Birim: °C
Minimum - Maksimum: -40 - 100 °C
Header: 7E4
```

---

## 2.12 Rejeneratif Frenleme Verileri

### Regen Frenleme Gücü
```
UDS Service ID: 22
DID (Subfunction): 01 68 (üreticiye bağlı)
Açıklama: Rejeneratif frenleme gücü
Formül: (A*256+B)/10
Birim: kW
Minimum - Maksimum: 0 - 100 kW
Header: 7E1
Not: Negatif akım değeri de regen göstergesidir
```

### Regen Frenleme Seviyesi
```
UDS Service ID: 22
DID (Subfunction): 01 69 (üreticiye bağlı)
Açıklama: Regen frenleme seviye ayarı (0-3 veya 0-5)
Formül: A
Birim: Seviye
Minimum - Maksimum: 0 - 5
Header: 7E4
```

---

## 2.13 Şarj Voltajı ve Akımı

### DC Şarj Voltajı
```
UDS Service ID: 22
DID (Subfunction): 01 6A (üreticiye bağlı)
Açıklama: DC hızlı şarj voltajı
Formül: (A*256+B)/10
Birim: V
Minimum - Maksimum: 0 - 1000 V
Header: 7E4
```

### DC Şarj Akımı
```
UDS Service ID: 22
DID (Subfunction): 01 6B (üreticiye bağlı)
Açıklama: DC hızlı şarj akımı
Formül: (A*256+B)/10
Birim: A
Minimum - Maksimum: 0 - 500 A
Header: 7E4
```

### AC Şarj Voltajı
```
UDS Service ID: 22
DID (Subfunction): 01 6C (üreticiye bağlı)
Açıklama: AC şarj voltajı (tek faz veya L1)
Formül: A*2
Birim: V
Minimum - Maksimum: 0 - 500 V
Header: 7E4
```

### AC Şarj Akımı
```
UDS Service ID: 22
DID (Subfunction): 01 6D (üreticiye bağlı)
Açıklama: AC şarj akımı
Formül: A/2
Birim: A
Minimum - Maksimum: 0 - 64 A
Header: 7E4
```

---

## 2.14 Şarj Durumu

### Şarj Fişi Durumu
```
UDS Service ID: 22
DID (Subfunction): 01 6E (üreticiye bağlı)
Açıklama: Şarj fişi takılı mı
Formül: Bit 0 = AC, Bit 1 = DC
Birim: Boolean
Değerler:
  0x00 = Takılı değil
  0x01 = AC takılı
  0x02 = DC takılı
  0x03 = Her ikisi (geçersiz durum)
Header: 7E4
```

### Şarj Durumu (Charging State)
```
UDS Service ID: 22
DID (Subfunction): 01 6F (üreticiye bağlı)
Açıklama: Mevcut şarj durumu
Formül: Enumeration
Değerler:
  0x00 = Şarj olmuyor
  0x01 = Şarj hazırlanıyor
  0x02 = Şarj oluyor
  0x03 = Şarj tamamlandı
  0x04 = Şarj hatası
  0x05 = Şarj duraklatıldı
Header: 7E4
```

---

## 2.15 Şarj Gücü

### DC Şarj Gücü (Hyundai/Kia)
```
UDS Service ID: 22
DID (Subfunction): 01 71
Açıklama: DC hızlı şarj gücü
Formül: (A*256+B)/10
Birim: kW
Minimum - Maksimum: 0 - 300 kW
Header: 7E4
Örnek Komut: 22 01 71
Örnek Cevap: 62 01 71 03 E8
Örnek Çözüm: 1000/10 = 100 kW
```

### AC Şarj Gücü (Hyundai/Kia)
```
UDS Service ID: 22
DID (Subfunction): 01 72
Açıklama: AC şarj gücü
Formül: (A*256+B)/10
Birim: kW
Minimum - Maksimum: 0 - 22 kW
Header: 7E4
```

---

# BÖLÜM 3: ŞANZIMAN (TCU) UDS VERİLERİ

> **ÖNEMLİ NOT:** TCU verileri büyük ölçüde üreticiye ve şanzıman tipine (AT, DCT, CVT) özgüdür. Aşağıdaki veriler, ISO 14229 UDS standardına uygun genel formatı göstermektedir. Spesifik DID'ler üreticiden üreticiye değişir.

## 3.1 Vites Pozisyonu

### Mode 01 - Standart OBD-II (Varsa)
```
PID / UDS KODU: 01 A4 (SAE J1979-2)
Açıklama: Şanzıman gerçek vites oranı
Veri Türü: (A*256+B)/1000
Birim: Oran
Byte Sayısı: 2
```

### UDS Service 22 - TCU
```
UDS Service ID: 22
DID: F2 00 (örnek - üreticiye özgü)
Açıklama: Vites pozisyonu
Formül: Enumeration
Değerler:
  0x00 = Park (P)
  0x01 = Reverse (R)
  0x02 = Neutral (N)
  0x03 = Drive (D)
  0x04-0x0A = Manuel vites 1-7
Birim: Pozisyon
Byte Sayısı: 1
Header: 7E1 (TCU adresi)
```

---

## 3.2 ATF Yağ Sıcaklığı

### Mode 01 - Standart OBD-II
```
PID / UDS KODU: 01 5C
Açıklama: Transmission Fluid Temperature
Veri Türü: A - 40
Birim: °C
Minimum - Maksimum: -40 - 215 °C
Byte Sayısı: 1
Örnek Gelen Cevap: 41 5C 64
Örnek Çözüm: 100 - 40 = 60°C
```

### UDS Service 22 - TCU
```
UDS Service ID: 22
DID: F2 01 (örnek - üreticiye özgü)
Açıklama: ATF sıcaklığı
Formül: A - 40
Birim: °C
Minimum - Maksimum: -40 - 180 °C
Byte Sayısı: 1
Header: 7E1
```

---

## 3.3 Kavrama/Clutch Sıcaklıkları (DCT için)

```
UDS Service ID: 22
DID: F2 10 (Clutch 1), F2 11 (Clutch 2)
Açıklama: Kavrama sıcaklığı
Formül: A*2 - 40 veya (A*256+B)/10 - 40
Birim: °C
Minimum - Maksimum: -40 - 300 °C
Byte Sayısı: 1-2
Header: 7E1
```

---

## 3.4 Hidrolik Basınçlar

### Ana Hat Basıncı (Line Pressure)
```
UDS Service ID: 22
DID: F2 20 (örnek)
Açıklama: Şanzıman ana hat basıncı
Formül: (A*256+B)*0.1 veya A*4
Birim: kPa veya bar
Minimum - Maksimum: 0 - 2500 kPa
Byte Sayısı: 2
Header: 7E1
```

### Torque Converter Basıncı
```
UDS Service ID: 22
DID: F2 21 (örnek)
Açıklama: Tork konvertör kilitleme basıncı
Formül: A*10
Birim: kPa
Minimum - Maksimum: 0 - 2500 kPa
Byte Sayısı: 1
Header: 7E1
```

---

## 3.5 Debriyaj/Kavrama Doluluk (Clutch Fill)

```
UDS Service ID: 22
DID: F2 30 (Clutch 1), F2 31 (Clutch 2)
Açıklama: Kavrama doluluk yüzdesi (DCT/AT)
Formül: A*100/255
Birim: %
Minimum - Maksimum: 0 - 100%
Byte Sayısı: 1
Header: 7E1
```

---

## 3.6 Şanzıman Torku Verileri

### Giriş Torku (Input Torque)
```
UDS Service ID: 22
DID: F2 40 (örnek)
Açıklama: Şanzıman giriş torku
Formül: (A*256+B)/10 - 3276.8 (işaretli)
Birim: Nm
Minimum - Maksimum: -500 - +1500 Nm
Byte Sayısı: 2
Header: 7E1
```

### Çıkış Torku (Output Torque)
```
UDS Service ID: 22
DID: F2 41 (örnek)
Açıklama: Şanzıman çıkış torku
Formül: (A*256+B)/10 - 3276.8 (işaretli)
Birim: Nm
Minimum - Maksimum: -500 - +5000 Nm
Byte Sayısı: 2
Header: 7E1
```

### Hedef Torku
```
UDS Service ID: 22
DID: F2 42 (örnek)
Açıklama: TCU hedef torku
Formül: (A*256+B)/10
Birim: Nm
Byte Sayısı: 2
Header: 7E1
```

---

## 3.7 TCU Çalışma Modları

```
UDS Service ID: 22
DID: F2 50 (örnek)
Açıklama: Şanzıman çalışma modu
Formül: Bit-encoded veya Enumeration
Değerler:
  0x00 = Normal/Comfort
  0x01 = Sport
  0x02 = Eco
  0x03 = Manual
  0x04 = Winter/Snow
  0x05 = Off-Road
  0x10 = Limp Mode (koruma modu)
Birim: Mod
Byte Sayısı: 1
Header: 7E1
```

---

## 3.8 Mechatronic Sıcaklık

```
UDS Service ID: 22
DID: F2 60 (örnek)
Açıklama: Mechatronic ünite sıcaklığı
Formül: A - 40
Birim: °C
Minimum - Maksimum: -40 - 150 °C
Byte Sayısı: 1
Header: 7E1
```

---

## 3.9 Isınma Durumu

```
UDS Service ID: 22
DID: F2 70 (örnek)
Açıklama: Şanzıman ısınma durumu
Formül: Bit veya Enumeration
Değerler:
  0x00 = Soğuk (Cold)
  0x01 = Isınıyor (Warming)
  0x02 = Normal çalışma
  0x03 = Aşırı sıcak (Overheating)
Birim: Durum
Byte Sayısı: 1
Header: 7E1
```

---

# BÖLÜM 4: DPF (DİZEL PARTİKÜL FİLTRESİ) VERİLERİ

## 4.1 DPF Doluluk Yüzdesi

### Mode 01 (SAE J1979-2)
```
PID / UDS KODU: 01 7C
Açıklama: DPF soot doluluk yüzdesi
Veri Türü: A*100/255
Birim: %
Minimum - Maksimum: 0 - 100%
Byte Sayısı: 1
Örnek Gelen Cevap: 41 7C 33
Örnek Çözüm: 51*100/255 = 20%
```

### UDS Service 22
```
UDS Service ID: 22
DID: 3A 01 veya F4 50 (üreticiye özgü)
Açıklama: DPF kurum yükleme seviyesi
Formül: A*100/255 veya (A*256+B)/100
Birim: %
Minimum - Maksimum: 0 - 100%
Byte Sayısı: 1-2
Header: 7E0
```

---

## 4.2 DPF Basınç Sensörü (Diferansiyel Basınç)

### Mode 01
```
PID / UDS KODU: 01 7A
Açıklama: Diesel Particulate Filter Differential Pressure
Veri Türü: (A*256+B)/10
Birim: Pa (Pascal) veya hPa
Minimum - Maksimum: 0 - 6553.5 Pa
Byte Sayısı: 2
Örnek Gelen Cevap: 41 7A 03 E8
Örnek Çözüm: 1000/10 = 100 hPa = 10 kPa
```

### UDS Service 22
```
UDS Service ID: 22
DID: 3A 02 veya F4 51 (üreticiye özgü)
Açıklama: DPF diferansiyel basınç
Formül: (A*256+B)*0.1 - 327.68 (işaretli)
Birim: kPa
Minimum - Maksimum: -30 - +30 kPa
Byte Sayısı: 2
Header: 7E0
```

---

## 4.3 DPF Sıcaklıkları

### DPF Inlet (Pre-DPF) Sıcaklık - Mode 01
```
PID / UDS KODU: 01 7B
Açıklama: DPF giriş sıcaklığı (filtrenin önündeki egzoz sıcaklığı)
Veri Türü: (A*256+B)/10 - 40
Birim: °C
Minimum - Maksimum: -40 - 6513.5 °C
Byte Sayısı: 2
Örnek Gelen Cevap: 41 7B 0F A0
Örnek Çözüm: 4000/10 - 40 = 400 - 40 = 360°C
```

### DPF Outlet (Post-DPF) Sıcaklık
```
UDS Service ID: 22
DID: 3A 04 veya F4 53 (üreticiye özgü)
Açıklama: DPF çıkış sıcaklığı
Formül: (A*256+B)/10 - 40
Birim: °C
Minimum - Maksimum: -40 - 1000 °C
Byte Sayısı: 2
Header: 7E0
```

### Egzoz Sıcaklığı Sensörleri - Mode 01
```
PID / UDS KODU: 01 78 (Bank 1 Sensor 1)
               01 79 (Bank 1 Sensor 2)
Açıklama: Exhaust Gas Temperature
Veri Türü: (A*256+B)/10 - 40
Birim: °C
Minimum - Maksimum: -40 - 6513.5 °C
Byte Sayısı: 9 (çoklu sensör)
```

---

## 4.4 Rejenerasyon Durumu

### Mode 01
```
PID / UDS KODU: 01 7D
Açıklama: DPF rejenerasyon durumu
Veri Türü: Bit-encoded
Byte Sayısı: 1
Bit Tanımları:
  Bit 0 = Aktif regen devam ediyor
  Bit 1 = Pasif regen devam ediyor
  Bit 2 = Regen talep edildi
  Bit 3 = Regen engellendi (koşullar uygun değil)
Örnek Gelen Cevap: 41 7D 01
Örnek Çözüm: Aktif rejenerasyon devam ediyor
```

### UDS Service 22
```
UDS Service ID: 22
DID: 3A 10 veya F4 60 (üreticiye özgü)
Açıklama: DPF rejenerasyon durumu
Formül: Enumeration
Değerler:
  0x00 = Regen yok
  0x01 = Pasif regen
  0x02 = Aktif regen
  0x03 = Servis regen gerekli
  0x04 = Regen başarısız
Birim: Durum
Byte Sayısı: 1
Header: 7E0
```

---

## 4.5 Son Rejenerasyon Bilgileri

```
UDS Service ID: 22
DID: 3A 11 (örnek - üreticiye özgü)
Açıklama: Son başarılı rejenerasyon km'si
Formül: A*256*256*256 + B*256*256 + C*256 + D (4-byte km)
Birim: km
Minimum - Maksimum: 0 - 999,999 km
Byte Sayısı: 4
Header: 7E0
```

### Son Rejendan Bu Yana Geçen Süre
```
UDS Service ID: 22
DID: 3A 12 (örnek)
Açıklama: Son rejenerasyondan bu yana geçen süre
Formül: A*256+B
Birim: dakika veya saat
Byte Sayısı: 2
Header: 7E0
```

---

## 4.6 Zorunlu Rejenerasyon Komutu (Service Regen)

> **UYARI:** Bu komut sadece uygun servis koşullarında ve araç sabitken kullanılmalıdır!

```
UDS Service ID: 31 (Routine Control)
Routine ID: 01 (Start Routine)
Sub-function: FF 00 veya üreticiye özgü
Açıklama: Zorla DPF rejenerasyonu başlat

Komut Dizilimi:
1. Oturum değiştir (Extended Diagnostic Session): 10 03
2. Güvenlik erişimi (Security Access):
   - İstek: 27 01
   - Seed al, key hesapla
   - Key gönder: 27 02 [KEY]
3. Rejenerasyon başlat: 31 01 [Routine ID] [Opsiyon]

Örnek Komutlar (üreticiye özgü):
  VW/Audi: 31 01 06 04 01
  BMW:     31 01 A3 5C 01
  Ford:    31 01 F0 01 01

Beklenen Cevap: 71 01 [Routine ID] [Status]
  Status 0x00 = Başarıyla başlatıldı
  Status 0x01 = Koşullar uygun değil
  Status 0x02 = Zaten devam ediyor

Byte Uzunluğu: Değişken (3-6 byte komut, 4+ byte cevap)
Header: 7E0
```

---

## 4.7 DPF Aktifleştirme Kontrolü

```
UDS Service ID: 31 01
Routine ID: Üreticiye özgü
Açıklama: DPF sistem aktifleştirme/deaktifleştirme kontrolü

Bu işlem tipik olarak şunları içerir:
- EGR açma/kapama
- Turbo boost ayarı
- Yakıt enjeksiyon zamanlama değişimi
- Post-enjeksiyon aktifleştirme

Not: Bu rutin, aracın hasar görmesini önlemek için
     ECU tarafından koşul kontrolü yapılır.
```

---

# BÖLÜM 5: ENJEKTÖR KODLAMA VERİLERİ

> **ÖNEMLİ NOT:** Enjektör kodlama verileri tamamen üreticiye özgüdür. Yanlış kodlama motor hasarına yol açabilir. Aşağıdakiler genel format ve yapıyı göstermektedir.

## 5.1 Enjektör Kod Okuma (Read Coding)

```
UDS Service ID: 22 (Read Data By Identifier)
DID: Üreticiye özgü (örnek: F1 90, 06 00-06 05 vb.)
Açıklama: Her silindir için enjektör kalibrasyon kodu

Örnek Komut (VW/Audi - 4 silindir):
  22 06 00 → Silindir 1 enjektör kodu
  22 06 01 → Silindir 2 enjektör kodu
  22 06 02 → Silindir 3 enjektör kodu
  22 06 03 → Silindir 4 enjektör kodu

Örnek Cevap: 62 06 00 [16-32 byte alfanümerik kod]

Veri Yapısı:
- Genellikle 6-32 karakter uzunluğunda alfanümerik string
- Bazı sistemlerde 6-8 basamaklı sayısal kod
- IMA/QR kod formatı (Bosch Common Rail)

Byte Uzunluğu: 8-32 byte (üreticiye bağlı)
Header: 7E0
```

---

## 5.2 Enjektör Kod Yazma (Write Coding)

```
UDS Service ID: 2E (Write Data By Identifier)
DID: Üreticiye özgü

Yazma Prosedürü:
1. Extended Diagnostic Session: 10 03
2. Security Access: 27 01 → [seed] → 27 02 [key]
3. Kod Yazma: 2E [DID High] [DID Low] [Kod Verileri]

Örnek Komut (VW/Audi):
  2E 06 00 30 31 32 33 34 35 36 37
  (Silindir 1'e "01234567" kodunu yaz)

Beklenen Cevap: 6E [DID High] [DID Low]
  (Pozitif cevap - başarılı)

Negatif Cevaplar:
  7F 2E 13 = Uzunluk hatası
  7F 2E 33 = Güvenlik erişimi reddedildi
  7F 2E 72 = Genel programlama hatası

Byte Uzunluğu: 3 + kod uzunluğu byte
Header: 7E0
```

---

## 5.3 Enjektör Kalibrasyon Değerleri

```
UDS Service ID: 22
DID: Üreticiye özgü (örnek: F1 A0 - F1 A7)
Açıklama: Enjektör miktar kalibrasyonu (IQA - Injector Quantity Adjustment)

Veri İçeriği:
- Pilot enjeksiyon miktarı düzeltmesi
- Ana enjeksiyon miktarı düzeltmesi
- Post enjeksiyon miktarı düzeltmesi

Örnek Cevap: 62 F1 A0 [Cal1] [Cal2] [Cal3] [Cal4]

Formül: (değer - 128) * 0.1 = mg/stroke düzeltme
Birim: mg/stroke
Minimum - Maksimum: -12.8 - +12.7 mg/stroke

Byte Uzunluğu: 4-16 byte (silindir sayısına bağlı)
Header: 7E0
```

---

## 5.4 Enjektör Balance/Trim Değerleri

```
UDS Service ID: 22
DID: Üreticiye özgü

Açıklama: Her silindir için enjektör dengeleme değerleri

Örnek Komut: 22 F1 B0
Örnek Cevap: 62 F1 B0 [Cyl1] [Cyl2] [Cyl3] [Cyl4]

Her silindir değeri için:
Formül: (değer - 128) * 0.1
Birim: % veya ms (üreticiye bağlı)
Minimum - Maksimum: -12.8% - +12.7%

Not: Pozitif değer = daha fazla yakıt
     Negatif değer = daha az yakıt

Byte Uzunluğu: 4-8 byte
Header: 7E0
```

---

## 5.5 Enjektör Akış Hesaplaması / Flow Rate

```
UDS Service ID: 22
DID: Üreticiye özgü (örnek: F1 C0)
Açıklama: Enjektör akış oranı verisi

Örnek Cevap: 62 F1 C0 [FlowHigh] [FlowLow]

Formül: (A*256+B) / 100
Birim: mm³/stroke veya mg/stroke
Minimum - Maksimum: 0 - 655.35 mm³/stroke

Byte Uzunluğu: 2-8 byte (her silindir için)
Header: 7E0
```

---

# BÖLÜM 6: ECU SORGULAMA KOMUTLARI (UDS KOMUT SETİ)

## 6.1 ECU Kimlik Okuma

### OBD-II Mode 09 - Vehicle Information
```
Service ID: 09
PID: 0A
Açıklama: ECU Name / Calibration ID
Komut: 09 0A
Beklenen Cevap: 49 0A [Count] [20 byte ASCII string]
Byte Uzunluğu: 20+ byte
```

### UDS Read Data By Identifier - ECU Part Number
```
Service ID: 22
DID: F1 87
Açıklama: ECU Parça Numarası
Komut (hex): 22 F1 87
Beklenen Cevap: 62 F1 87 [ASCII part number, genellikle 12-20 byte]
Örnek Cevap: 62 F1 87 30 33 4C 39 30 36 30 32 31 41
Örnek Çözüm: "03L906021A" (VW parça numarası)
Byte Uzunluğu: 12-24 byte
```

### UDS - ECU Identification
```
Service ID: 22
DID: F1 90
Açıklama: VIN (Vehicle Identification Number)
Komut (hex): 22 F1 90
Beklenen Cevap: 62 F1 90 [17 byte ASCII VIN]
Byte Uzunluğu: 17 byte
```

---

## 6.2 Yazılım Numarası

```
Service ID: 22
DID: F1 88
Açıklama: ECU Yazılım/Kalibrasyon Numarası
Komut (hex): 22 F1 88
Beklenen Cevap: 62 F1 88 [yazılım numarası - ASCII veya hex]
Örnek Cevap: 62 F1 88 30 30 31 39 30 37 35 30 32 30
Örnek Çözüm: "0019075020" yazılım versiyonu
Byte Uzunluğu: 10-20 byte
```

### Yazılım Versiyonu (Alternative)
```
Service ID: 22
DID: F1 95
Açıklama: Software Version Number
Komut (hex): 22 F1 95
Beklenen Cevap: 62 F1 95 [versiyon]
Byte Uzunluğu: 4-10 byte
```

---

## 6.3 Donanım Numarası

```
Service ID: 22
DID: F1 91
Açıklama: ECU Donanım Numarası
Komut (hex): 22 F1 91
Beklenen Cevap: 62 F1 91 [donanım numarası]
Örnek Cevap: 62 F1 91 30 33 4C 39 30 36 30 31 38
Örnek Çözüm: "03L906018" donanım versiyonu
Byte Uzunluğu: 10-20 byte
```

---

## 6.4 VIN Doğrulama

### OBD-II Mode 09 PID 02
```
Service ID: 09
PID: 02
Açıklama: Vehicle Identification Number (VIN)
Komut (hex): 09 02
Beklenen Cevap: 49 02 01 [17 byte ASCII VIN]
Örnek Cevap: 49 02 01 57 56 57 5A 5A 5A 33 43 5A 57 45 31 32 33 34 35 36
Örnek Çözüm: "WVWZZZ3CZWE123456"
Byte Uzunluğu: 17 byte VIN
```

### UDS VIN Okuma
```
Service ID: 22
DID: F1 90
Açıklama: VIN (UDS)
Komut (hex): 22 F1 90
Beklenen Cevap: 62 F1 90 [17 byte ASCII VIN]
Byte Uzunluğu: 17 byte
```

---

## 6.5 DTC Okuma (Read DTCs)

### Mode 03 - Request Emission-Related DTCs
```
Service ID: 03
Açıklama: Onaylı (Confirmed) emisyon DTC'leri
Komut (hex): 03
Beklenen Cevap: 43 [DTC count] [DTC1 high] [DTC1 low] [DTC2 high] [DTC2 low]...
Örnek Cevap: 43 02 01 33 02 00
Örnek Çözüm: 2 DTC: P0133, P0200
Byte Uzunluğu: 2 byte per DTC + 1 byte count
```

### UDS Service 19 - Read DTC Information

#### Sub-function 02 - Report DTC By Status Mask
```
Service ID: 19
Sub-function: 02
Status Mask: FF (tüm DTC'ler)
Açıklama: Durum maskesine göre DTC listesi
Komut (hex): 19 02 FF
Beklenen Cevap: 59 02 FF [DTC1 3-byte] [Status1] [DTC2 3-byte] [Status2]...
Örnek Cevap: 59 02 FF 01 33 00 2F 02 00 00 21
Örnek Çözüm: 
  P0133 (status 0x2F = confirmed, current, stored)
  P0200 (status 0x21 = stored, confirmed)
Byte Uzunluğu: 4 byte per DTC
```

#### Sub-function 0A - Report Supported DTCs
```
Service ID: 19
Sub-function: 0A
Açıklama: Desteklenen tüm DTC'lerin listesi
Komut (hex): 19 0A
Beklenen Cevap: 59 0A [DTC1] [Status1] [DTC2] [Status2]...
Byte Uzunluğu: 4 byte per DTC
```

#### Sub-function 0B - Report First Test Failed DTC
```
Service ID: 19
Sub-function: 0B
Açıklama: İlk başarısız test DTC'si
Komut (hex): 19 0B
Beklenen Cevap: 59 0B [DTC 3-byte] [Status]
Byte Uzunluğu: 4 byte
```

### DTC Status Byte Tanımları
```
Bit 0 (0x01) = testFailed - Test şu anda başarısız
Bit 1 (0x02) = testFailedThisOperationCycle - Bu çalışma döngüsünde başarısız
Bit 2 (0x04) = pendingDTC - Bekleyen DTC
Bit 3 (0x08) = confirmedDTC - Onaylanmış DTC
Bit 4 (0x10) = testNotCompletedSinceLastClear - Son silmeden bu yana test tamamlanmadı
Bit 5 (0x20) = testFailedSinceLastClear - Son silmeden bu yana test başarısız
Bit 6 (0x40) = testNotCompletedThisOperationCycle - Bu döngüde test tamamlanmadı
Bit 7 (0x80) = warningIndicatorRequested - Uyarı göstergesi istendi
```

---

## 6.6 DTC Silme (Clear DTCs)

### OBD-II Mode 04
```
Service ID: 04
Açıklama: Emisyon DTC'lerini ve freeze frame'i sil
Komut (hex): 04
Beklenen Cevap: 44
Byte Uzunluğu: 1 byte
```

### UDS Service 14 - Clear Diagnostic Information
```
Service ID: 14
Group of DTC: FF FF FF (tüm DTC'ler)
Açıklama: Tüm DTC'leri sil
Komut (hex): 14 FF FF FF
Beklenen Cevap: 54
Byte Uzunluğu: 1 byte (pozitif cevap)

Negatif Cevaplar:
  7F 14 22 = Koşullar uygun değil
  7F 14 33 = Güvenlik erişimi gerekli
```

### Belirli DTC Grubunu Silme
```
Service ID: 14
Powertrain DTCs: 14 00 00 00
Chassis DTCs:    14 40 00 00
Body DTCs:       14 80 00 00
Network DTCs:    14 C0 00 00
```

---

## 6.7 Live Data (Canlı Veri Okuma)

### UDS Service 21 - Read Data By Local Identifier (eski)
```
Service ID: 21
Açıklama: Yerel tanımlayıcı ile veri okuma (bazı eski sistemlerde)
Komut Formatı: 21 [Local ID]
Örnek Komut: 21 01
Beklenen Cevap: 61 01 [data bytes]
```

### UDS Service 22 - Read Data By Identifier
```
Service ID: 22
Açıklama: Tanımlayıcı (DID) ile veri okuma
Komut Formatı: 22 [DID High] [DID Low]
Örnek Komut: 22 F1 90 (VIN okuma)
Beklenen Cevap: 62 F1 90 [data bytes]

Yaygın DID'ler:
  22 01 0C → Motor RPM (bazı sistemlerde)
  22 F1 90 → VIN
  22 F1 87 → ECU Part Number
  22 F1 88 → Software Number
  22 F1 91 → Hardware Number
  22 F1 95 → Software Version
  22 F4 xx → Üreticiye özgü veriler

Byte Uzunluğu: Değişken (DID'e bağlı)
```

---

## 6.8 Aktüatör Testi (Routine Control)

### UDS Service 31 - Routine Control
```
Service ID: 31
Sub-functions:
  01 = Start Routine
  02 = Stop Routine
  03 = Request Routine Results

Komut Formatı: 31 [Sub-function] [Routine ID High] [Routine ID Low] [Options]

Örnek - Enjektör Testi:
  Komut: 31 01 02 00 01 (Silindir 1 enjektör testi başlat)
  Cevap: 71 01 02 00 [status]

Örnek - Fan Testi:
  Komut: 31 01 03 00 (Fan testi başlat)
  Cevap: 71 01 03 00 [status]

Örnek - DPF Rejenerasyon:
  Komut: 31 01 06 04 01 (DPF regen başlat)
  Cevap: 71 01 06 04 [status]

Yaygın Routine ID'ler (üreticiye özgü):
  01 xx = Genel test rutinleri
  02 xx = Enjektör testleri
  03 xx = Fan/soğutma testleri
  06 xx = Egzoz sistemi testleri
  F0 xx = Özel OEM rutinleri

Byte Uzunluğu: 4-8 byte (komut), 4+ byte (cevap)
```

---

## 6.9 Kodlama (Write Data By Identifier)

### UDS Service 2E
```
Service ID: 2E
Açıklama: DID'e göre veri yazma (kodlama)
Komut Formatı: 2E [DID High] [DID Low] [New Data]

Prosedür:
1. Extended Session: 10 03
2. Security Access: 27 xx
3. Write Data: 2E [DID] [data]

Örnek - Kodlama Yazma:
  Komut: 2E F1 99 01 02 03 04 05
  Pozitif Cevap: 6E F1 99
  
Negatif Cevaplar:
  7F 2E 13 = Incorrect message length or invalid format
  7F 2E 22 = Conditions not correct
  7F 2E 31 = Request out of range
  7F 2E 33 = Security access denied
  7F 2E 72 = General programming failure

Byte Uzunluğu: 3 + veri uzunluğu (komut), 3 byte (pozitif cevap)
```

---

## 6.10 Security Access

### UDS Service 27
```
Service ID: 27
Açıklama: Güvenlik erişimi (korumalı fonksiyonlar için)

Prosedür:
1. Seed İste (Request Seed):
   Komut: 27 01 (Security Level 1) veya 27 03 (Level 2) vb.
   Cevap: 67 01 [Seed - 2-4 byte]
   
2. Key Gönder (Send Key):
   Komut: 27 02 [Hesaplanmış Key]
   Pozitif Cevap: 67 02 (erişim verildi)
   
Örnek Akış:
  Gönder: 27 01
  Al:     67 01 A5 5A B3 4C (seed = A55AB34C)
  [Key hesapla - algoritma üreticiye özgü]
  Gönder: 27 02 12 34 56 78 (hesaplanan key)
  Al:     67 02 (başarılı)

Security Levels (tek sayılar = seed iste, çift sayılar = key gönder):
  27 01 / 27 02 = Level 1 (temel)
  27 03 / 27 04 = Level 2 (gelişmiş)
  27 05 / 27 06 = Level 3 (üretici)
  27 09 / 27 0A = Level 5 (yüksek güvenlik)
  27 11 / 27 12 = Level 9 (fabrika)

Negatif Cevaplar:
  7F 27 12 = Sub-function not supported
  7F 27 22 = Conditions not correct
  7F 27 35 = Invalid key
  7F 27 36 = Exceeded number of attempts
  7F 27 37 = Required time delay not expired

Byte Uzunluğu: 1-5 byte (seed request), 3-9 byte (key send)
```

---

## 6.11 Session Değişimi (Diagnostic Session Control)

### UDS Service 10
```
Service ID: 10
Açıklama: Diagnostik oturum kontrolü

Session Tipleri:
  10 01 = Default Session (standart OBD-II)
  10 02 = Programming Session (ECU programlama)
  10 03 = Extended Diagnostic Session (gelişmiş teşhis)
  10 40 = End Of Line Session (bazı üreticiler)
  10 60 = Coding Session (bazı üreticiler)

Örnek Komutlar:
  Extended Session:
    Komut: 10 03
    Pozitif Cevap: 50 03 [P2Server Max High] [P2Server Max Low] [P2*Server Max]
    Örnek Cevap: 50 03 00 19 01 F4
    Çözüm: P2 timeout = 25ms, P2* timeout = 5000ms

  Programming Session:
    Komut: 10 02
    Cevap: 50 02 00 19 01 F4

Negatif Cevaplar:
  7F 10 12 = Sub-function not supported
  7F 10 22 = Conditions not correct (örn: araç hareket halinde)

Byte Uzunluğu: 2 byte (komut), 6 byte (pozitif cevap)
```

---

## 6.12 Tester Present

### UDS Service 3E
```
Service ID: 3E
Açıklama: Oturumu aktif tutma (keep-alive)

Komut: 3E 00 (cevap beklenir)
       3E 80 (cevap beklenmez - suppressPositiveResponse)

Pozitif Cevap: 7E 00

Kullanım: Extended session'ı aktif tutmak için düzenli aralıklarla gönderilir
          (genellikle her 2-3 saniyede bir)

Byte Uzunluğu: 2 byte (komut), 2 byte (cevap)
```

---

# BÖLÜM 7: NEGATIF CEVAP KODLARI (NRC - Negative Response Codes)

```
Kod   | Tanım
------|--------------------------------------------------
0x10  | General reject
0x11  | Service not supported
0x12  | Sub-function not supported
0x13  | Incorrect message length or invalid format
0x14  | Response too long
0x21  | Busy - repeat request
0x22  | Conditions not correct
0x24  | Request sequence error
0x25  | No response from subnet component
0x26  | Failure prevents execution of requested action
0x31  | Request out of range
0x33  | Security access denied
0x35  | Invalid key
0x36  | Exceeded number of attempts
0x37  | Required time delay not expired
0x70  | Upload/download not accepted
0x71  | Transfer data suspended
0x72  | General programming failure
0x73  | Wrong block sequence counter
0x78  | Request correctly received - response pending
0x7E  | Sub-function not supported in active session
0x7F  | Service not supported in active session
```

---

# BÖLÜM 8: CAN HEADER REFERANSI

```
Header  | ECU
--------|------------------------------------------
7E0     | Engine Control Module (ECM)
7E1     | Transmission Control Module (TCM)
7E2     | Hybrid/EV Battery Management System
7E3     | ABS/ESP Module
7E4     | BMS (Battery Management) / Body Control
7E5     | Instrument Cluster
7E6     | Air Conditioning Module
7E7     | Telematics / Gateway
7DF     | Broadcast (tüm ECU'lara OBD-II sorgusu)

Cevap Header'ları (istek + 8):
7E8     | ECM cevabı (7E0'a)
7E9     | TCM cevabı (7E1'e)
7EA     | BMS cevabı (7E2'ye)
7EB     | ABS cevabı (7E3'e)
7EC     | Body cevabı (7E4'e)
```

---

# EK: PID DESTEK KONTROLÜ

### Mode 01 PID 00 - Desteklenen PID'ler (01-20)
```
Komut: 01 00
Cevap: 41 00 [A] [B] [C] [D]

Her bit bir PID'i temsil eder:
  Byte A, Bit 7 = PID 01 destekleniyor
  Byte A, Bit 6 = PID 02 destekleniyor
  ...
  Byte D, Bit 0 = PID 20 destekleniyor

Örnek: 41 00 BE 1F A8 13
  A = 0xBE = 10111110 → PID 01,03,04,05,06,07 destekleniyor
  B = 0x1F = 00011111 → PID 0C,0D,0E,0F,10 destekleniyor
  ...
```

### Diğer PID Destek Sorguları
```
01 20 → PID 21-40 desteği
01 40 → PID 41-60 desteği
01 60 → PID 61-80 desteği
01 80 → PID 81-A0 desteği
01 A0 → PID A1-C0 desteği
01 C0 → PID C1-E0 desteği
```

---

**YASAL UYARI:** Bu dokümandaki bilgiler SAE J1979, ISO 15031-5 ve ISO 14229 standartlarına dayanmaktadır. Üreticiye özgü DID'ler ve rutinler, her marka/model için farklılık gösterebilir. Güvenlik gerektiren işlemler (kodlama, programlama, aktüatör testleri) yalnızca yetkili personel tarafından ve uygun koşullarda gerçekleştirilmelidir.

---
*Doküman Versiyonu: 1.0*
*Referanslar: SAE J1979, SAE J1979-2, ISO 15031-5, ISO 14229-1 (UDS)*
