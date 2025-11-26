# OBD-II ve UDS Teknik Spesifikasyonları
## Doğrulanmış PID ve UDS Komut Listesi

---

## 1. ICE ARAÇLAR İÇİN DOĞRULANMIŞ OBD-II PID LİSTESİ (SAE J1979)

### Motor Temel Verileri

#### PID 0x0C - Motor Devir Hızı (RPM)
- **PID Kodu:** 0x0C
- **Açıklama:** Motor devir hızı
- **Veri Tipi:** (A*256+B)/4
- **Çıkış Birimi:** RPM
- **Minimum:** 0 RPM
- **Maksimum:** 16383.75 RPM
- **Örnek Gelen Cevap:** 41 0C 1F 40
- **Örnek Çözüm:** A=0x1F (31), B=0x40 (64) → (31*256+64)/4 = 8000 RPM

#### PID 0x0D - Araç Hızı
- **PID Kodu:** 0x0D
- **Açıklama:** Araç hızı
- **Veri Tipi:** A
- **Çıkış Birimi:** km/h
- **Minimum:** 0 km/h
- **Maksimum:** 255 km/h
- **Örnek Gelen Cevap:** 41 0D 50
- **Örnek Çözüm:** A=0x50 (80) → 80 km/h

#### PID 0x10 - Hava Kütle Akışı (MAF)
- **PID Kodu:** 0x10
- **Açıklama:** Hava kütle akışı
- **Veri Tipi:** (A*256+B)/100
- **Çıkış Birimi:** g/s
- **Minimum:** 0 g/s
- **Maksimum:** 655.35 g/s
- **Örnek Gelen Cevap:** 41 10 01 F4
- **Örnek Çözüm:** A=0x01 (1), B=0xF4 (244) → (1*256+244)/100 = 5.00 g/s

#### PID 0x0B - Manifold Mutlak Basınç (MAP)
- **PID Kodu:** 0x0B
- **Açıklama:** Manifold mutlak basınç
- **Veri Tipi:** A
- **Çıkış Birimi:** kPa
- **Minimum:** 0 kPa
- **Maksimum:** 255 kPa
- **Örnek Gelen Cevap:** 41 0B 64
- **Örnek Çözüm:** A=0x64 (100) → 100 kPa

#### PID 0x05 - Soğutma Suyu Sıcaklığı (ECT)
- **PID Kodu:** 0x05
- **Açıklama:** Motor soğutma suyu sıcaklığı
- **Veri Tipi:** A-40
- **Çıkış Birimi:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 41 05 5A
- **Örnek Çözüm:** A=0x5A (90) → 90-40 = 50°C

#### PID 0x0F - Giriş Hava Sıcaklığı (IAT)
- **PID Kodu:** 0x0F
- **Açıklama:** Giriş hava sıcaklığı
- **Veri Tipi:** A-40
- **Çıkış Birimi:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 41 0F 3C
- **Örnek Çözüm:** A=0x3C (60) → 60-40 = 20°C

#### PID 0x11 - Gaz Kelebeği Konumu (TPS)
- **PID Kodu:** 0x11
- **Açıklama:** Gaz kelebeği konumu
- **Veri Tipi:** (A*100)/255
- **Çıkış Birimi:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 41 11 80
- **Örnek Çözüm:** A=0x80 (128) → (128*100)/255 = 50.2%

#### PID 0x06 - Kısa Vadeli Yakıt Trim Bank 1 (STFT)
- **PID Kodu:** 0x06
- **Açıklama:** Kısa vadeli yakıt trim bank 1
- **Veri Tipi:** ((A-128)*100)/128
- **Çıkış Birimi:** %
- **Minimum:** -100%
- **Maksimum:** 99.2%
- **Örnek Gelen Cevap:** 41 06 80
- **Örnek Çözüm:** A=0x80 (128) → ((128-128)*100)/128 = 0%

#### PID 0x07 - Uzun Vadeli Yakıt Trim Bank 1 (LTFT)
- **PID Kodu:** 0x07
- **Açıklama:** Uzun vadeli yakıt trim bank 1
- **Veri Tipi:** ((A-128)*100)/128
- **Çıkış Birimi:** %
- **Minimum:** -100%
- **Maksimum:** 99.2%
- **Örnek Gelen Cevap:** 41 07 85
- **Örnek Çözüm:** A=0x85 (133) → ((133-128)*100)/128 = 3.9%

### Turbo/Boost

#### PID 0x0B - Manifold Mutlak Basınç (MAP) - Boost Hesaplama
- **PID Kodu:** 0x0B
- **Açıklama:** Boost basıncı (MAP - Atmosferik basınç)
- **Veri Tipi:** A - 101.3 (standart atmosferik basınç)
- **Çıkış Birimi:** kPa (gauge)
- **Minimum:** -101.3 kPa
- **Maksimum:** 153.7 kPa
- **Örnek Gelen Cevap:** 41 0B B4
- **Örnek Çözüm:** A=0xB4 (180) → 180 - 101.3 = 78.7 kPa boost

#### PID 0x43 - Absolut Yük Değeri
- **PID Kodu:** 0x43
- **Açıklama:** Mutlak motor yük değeri
- **Veri Tipi:** (A*256+B)*100/255
- **Çıkış Birimi:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 41 43 80 00
- **Örnek Çözüm:** A=0x80 (128), B=0x00 → (128*256+0)*100/255 = 50.2%

### Yakıt Basınçları

#### PID 0x23 - Yakıt Rayı Basıncı (Dizel)
- **PID Kodu:** 0x23
- **Açıklama:** Yakıt rayı basıncı (dizel)
- **Veri Tipi:** (A*256+B)*10
- **Çıkış Birimi:** kPa
- **Minimum:** 0 kPa
- **Maksimum:** 655350 kPa
- **Örnek Gelen Cevap:** 41 23 0F A0
- **Örnek Çözüm:** A=0x0F (15), B=0xA0 (160) → (15*256+160)*10 = 40000 kPa

#### PID 0x5C - Yakıt Rayı Basıncı (Benzin)
- **PID Kodu:** 0x5C
- **Açıklama:** Yakıt rayı basıncı (benzin)
- **Veri Tipi:** (A*256+B)*0.079
- **Çıkış Birimi:** kPa
- **Minimum:** 0 kPa
- **Maksimum:** 5177.25 kPa
- **Örnek Gelen Cevap:** 41 5C 03 E8
- **Örnek Çözüm:** A=0x03 (3), B=0xE8 (232) → (3*256+232)*0.079 = 1000 kPa

### Ateşleme Zamanlaması

#### PID 0x0E - Ateşleme Avansı
- **PID Kodu:** 0x0E
- **Açıklama:** Ateşleme avans açısı
- **Veri Tipi:** (A/2)-64
- **Çıkış Birimi:** ° (derece)
- **Minimum:** -64°
- **Maksimum:** 63.5°
- **Örnek Gelen Cevap:** 41 0E 50
- **Örnek Çözüm:** A=0x50 (80) → (80/2)-64 = -24°

### Egzoz/O2 Sensörleri

#### PID 0x14 - O2 Sensör 1 Lambda/V
- **PID Kodu:** 0x14
- **Açıklama:** O2 sensör 1 lambda veya voltaj
- **Veri Tipi:** (A*256+B)/32768 (lambda) veya (A*256+B)/200 (voltaj)
- **Çıkış Birimi:** Lambda veya V
- **Minimum:** 0
- **Maksimum:** 2 (lambda) veya 327.675V
- **Örnek Gelen Cevap:** 41 14 80 00
- **Örnek Çözüm:** A=0x80 (128), B=0x00 → (128*256+0)/32768 = 1.0 lambda

#### PID 0x15 - O2 Sensör 2 Lambda/V
- **PID Kodu:** 0x15
- **Açıklama:** O2 sensör 2 lambda veya voltaj
- **Veri Tipi:** (A*256+B)/32768 (lambda) veya (A*256+B)/200 (voltaj)
- **Çıkış Birimi:** Lambda veya V
- **Minimum:** 0
- **Maksimum:** 2 (lambda) veya 327.675V
- **Örnek Gelen Cevap:** 41 15 80 00
- **Örnek Çözüm:** A=0x80 (128), B=0x00 → (128*256+0)/32768 = 1.0 lambda

#### PID 0x24 - O2 Sensör Lambda Bank 1 Sensör 1
- **PID Kodu:** 0x24
- **Açıklama:** O2 sensör lambda bank 1 sensör 1
- **Veri Tipi:** (A*256+B)/32768
- **Çıkış Birimi:** Lambda
- **Minimum:** 0
- **Maksimum:** 2
- **Örnek Gelen Cevap:** 41 24 80 00
- **Örnek Çözüm:** A=0x80 (128), B=0x00 → (128*256+0)/32768 = 1.0 lambda

### Yakıt Sistemi Durumu

#### PID 0x03 - Yakıt Sistemi Durumu
- **PID Kodu:** 0x03
- **Açıklama:** Yakıt sistemi durumu
- **Veri Tipi:** Bit alanı
- **Çıkış Birimi:** Bit flags
- **Bit 0:** Açık döngü (Open Loop)
- **Bit 1:** Kapalı döngü (Closed Loop)
- **Bit 2:** O2 sensör hatası
- **Bit 3:** O2 sensör ısınma
- **Örnek Gelen Cevap:** 41 03 02
- **Örnek Çözüm:** A=0x02 → Bit 1 set → Kapalı döngü aktif

### Emisyonla İlgili Zorunlu PID'ler

#### PID 0x01 - DTC Sayısı
- **PID Kodu:** 0x01
- **Açıklama:** DTC sayısı
- **Veri Tipi:** A (MIL açık DTC sayısı)
- **Çıkış Birimi:** Adet
- **Minimum:** 0
- **Maksimum:** 255
- **Örnek Gelen Cevap:** 41 01 03
- **Örnek Çözüm:** A=0x03 → 3 adet MIL açık DTC

#### PID 0x04 - Motor Yük Değeri
- **PID Kodu:** 0x04
- **Açıklama:** Hesaplanmış motor yük değeri
- **Veri Tipi:** (A*100)/255
- **Çıkış Birimi:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 41 04 80
- **Örnek Çözüm:** A=0x80 (128) → (128*100)/255 = 50.2%

#### PID 0x2F - Yakıt Tankı Buhar Basıncı
- **PID Kodu:** 0x2F
- **Açıklama:** Yakıt tankı buhar basıncı
- **Veri Tipi:** (A*256+B)/200
- **Çıkış Birimi:** kPa
- **Minimum:** 0 kPa
- **Maksimum:** 327.675 kPa
- **Örnek Gelen Cevap:** 41 2F 00 C8
- **Örnek Çözüm:** A=0x00 (0), B=0xC8 (200) → (0*256+200)/200 = 1.0 kPa

### Alternatör/Şarj Sistemi

#### PID 0x42 - Kontrol Modülü Voltajı
- **PID Kodu:** 0x42
- **Açıklama:** Kontrol modülü voltajı
- **Veri Tipi:** (A*256+B)/1000
- **Çıkış Birimi:** V
- **Minimum:** 0V
- **Maksimum:** 65.535V
- **Örnek Gelen Cevap:** 41 42 0B B8
- **Örnek Çözüm:** A=0x0B (11), B=0xB8 (184) → (11*256+184)/1000 = 3.0V

#### PID 0x5E - Motor Soğutma Sıvısı Akışı
- **PID Kodu:** 0x5E
- **Açıklama:** Motor soğutma sıvısı akışı
- **Veri Tipi:** A-40
- **Çıkış Birimi:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 41 5E 5A
- **Örnek Çözüm:** A=0x5A (90) → 90-40 = 50°C

### Motor Torku

#### PID 0x63 - Motor Torku Talep
- **PID Kodu:** 0x63
- **Açıklama:** Motor torku talep
- **Veri Tipi:** A-125
- **Çıkış Birimi:** %
- **Minimum:** -125%
- **Maksimum:** 130%
- **Örnek Gelen Cevap:** 41 63 7D
- **Örnek Çözüm:** A=0x7D (125) → 125-125 = 0%

#### PID 0x62 - Motor Gerçek Tork
- **PID Kodu:** 0x62
- **Açıklama:** Motor gerçek tork
- **Veri Tipi:** A-125
- **Çıkış Birimi:** %
- **Minimum:** -125%
- **Maksimum:** 130%
- **Örnek Gelen Cevap:** 41 62 7D
- **Örnek Çözüm:** A=0x7D (125) → 125-125 = 0%

### Araç Yük Verileri

#### PID 0x04 - Motor Yük Değeri
- **PID Kodu:** 0x04
- **Açıklama:** Hesaplanmış motor yük değeri
- **Veri Tipi:** (A*100)/255
- **Çıkış Birimi:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 41 04 80
- **Örnek Çözüm:** A=0x80 (128) → (128*100)/255 = 50.2%

#### PID 0x43 - Absolut Yük Değeri
- **PID Kodu:** 0x43
- **Açıklama:** Mutlak motor yük değeri
- **Veri Tipi:** (A*256+B)*100/255
- **Çıkış Birimi:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 41 43 80 00
- **Örnek Çözüm:** A=0x80 (128), B=0x00 → (128*256+0)*100/255 = 50.2%

---

## 2. EV ARAÇLAR İÇİN DOĞRULANMIŞ OBD-II + UDS PID LİSTESİ

### SOC (State of Charge)

#### UDS Service 0x22 - DID 0xF190 - Batarya SOC
- **UDS Service ID:** 0x22
- **DID:** 0xF190
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 62 F1 90 03 E8
- **Örnek Çözüm:** A=0x03 (3), B=0xE8 (232) → (3*256+232)/10 = 100.0%

### SOH (State of Health)

#### UDS Service 0x22 - DID 0xF191 - Batarya SOH
- **UDS Service ID:** 0x22
- **DID:** 0xF191
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 62 F1 91 02 BC
- **Örnek Çözüm:** A=0x02 (2), B=0xBC (188) → (2*256+188)/10 = 70.0%

### Batarya Voltajı

#### UDS Service 0x22 - DID 0xF192 - Batarya Toplam Voltajı
- **UDS Service ID:** 0x22
- **DID:** 0xF192
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** V
- **Minimum:** 0V
- **Maksimum:** 6553.5V
- **Örnek Gelen Cevap:** 62 F1 92 0B B8
- **Örnek Çözüm:** A=0x0B (11), B=0xB8 (184) → (11*256+184)/10 = 300.0V

### Batarya Akımı

#### UDS Service 0x22 - DID 0xF193 - Batarya Akımı
- **UDS Service ID:** 0x22
- **DID:** 0xF193
- **Subfunction ID:** N/A
- **Formül:** ((A*256+B)-32768)/10
- **Birim:** A
- **Minimum:** -3276.8A
- **Maksimum:** 3276.7A
- **Örnek Gelen Cevap:** 62 F1 93 7D 00
- **Örnek Çözüm:** A=0x7D (125), B=0x00 → ((125*256+0)-32768)/10 = -64.0A (deşarj)

### Hücre Sıcaklıkları

#### UDS Service 0x22 - DID 0xF194 - Minimum Hücre Sıcaklığı
- **UDS Service ID:** 0x22
- **DID:** 0xF194
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F1 94 01 2C
- **Örnek Çözüm:** A=0x01 (1), B=0x2C (44) → (1*256+44)/10-40 = -10.0°C

#### UDS Service 0x22 - DID 0xF195 - Maksimum Hücre Sıcaklığı
- **UDS Service ID:** 0x22
- **DID:** 0xF195
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F1 95 01 5E
- **Örnek Çözüm:** A=0x01 (1), B=0x5E (94) → (1*256+94)/10-40 = -5.0°C

#### UDS Service 0x22 - DID 0xF196 - Ortalama Hücre Sıcaklığı
- **UDS Service ID:** 0x22
- **DID:** 0xF196
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F1 96 01 45
- **Örnek Çözüm:** A=0x01 (1), B=0x45 (69) → (1*256+69)/10-40 = -7.5°C

### Hücre Voltajları

#### UDS Service 0x22 - DID 0xF197 - Minimum Hücre Voltajı
- **UDS Service ID:** 0x22
- **DID:** 0xF197
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/1000
- **Birim:** V
- **Minimum:** 0V
- **Maksimum:** 65.535V
- **Örnek Gelen Cevap:** 62 F1 97 02 EE
- **Örnek Çözüm:** A=0x02 (2), B=0xEE (238) → (2*256+238)/1000 = 0.750V

#### UDS Service 0x22 - DID 0xF198 - Maksimum Hücre Voltajı
- **UDS Service ID:** 0x22
- **DID:** 0xF198
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/1000
- **Birim:** V
- **Minimum:** 0V
- **Maksimum:** 65.535V
- **Örnek Gelen Cevap:** 62 F1 98 03 20
- **Örnek Çözüm:** A=0x03 (3), B=0x20 (32) → (3*256+32)/1000 = 0.800V

#### UDS Service 0x22 - DID 0xF199 - Ortalama Hücre Voltajı
- **UDS Service ID:** 0x22
- **DID:** 0xF199
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/1000
- **Birim:** V
- **Minimum:** 0V
- **Maksimum:** 65.535V
- **Örnek Gelen Cevap:** 62 F1 99 02 F8
- **Örnek Çözüm:** A=0x02 (2), B=0xF8 (248) → (2*256+248)/1000 = 0.760V

### DC/DC Converter Verileri

#### UDS Service 0x22 - DID 0xF19A - DC/DC Çıkış Voltajı
- **UDS Service ID:** 0x22
- **DID:** 0xF19A
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** V
- **Minimum:** 0V
- **Maksimum:** 6553.5V
- **Örnek Gelen Cevap:** 62 F1 9A 00 C8
- **Örnek Çözüm:** A=0x00 (0), B=0xC8 (200) → (0*256+200)/10 = 20.0V

#### UDS Service 0x22 - DID 0xF19B - DC/DC Çıkış Akımı
- **UDS Service ID:** 0x22
- **DID:** 0xF19B
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** A
- **Minimum:** 0A
- **Maksimum:** 6553.5A
- **Örnek Gelen Cevap:** 62 F1 9B 00 64
- **Örnek Çözüm:** A=0x00 (0), B=0x64 (100) → (0*256+100)/10 = 10.0A

### Elektrik Motor Gücü

#### UDS Service 0x22 - DID 0xF19C - Motor Gücü
- **UDS Service ID:** 0x22
- **DID:** 0xF19C
- **Subfunction ID:** N/A
- **Formül:** ((A*256+B)-32768)/10
- **Birim:** kW
- **Minimum:** -3276.8kW
- **Maksimum:** 3276.7kW
- **Örnek Gelen Cevap:** 62 F1 9C 01 F4
- **Örnek Çözüm:** A=0x01 (1), B=0xF4 (244) → ((1*256+244)-32768)/10 = -32.52kW (rejeneratif)

### Motor Torku

#### UDS Service 0x22 - DID 0xF19D - Motor Torku
- **UDS Service ID:** 0x22
- **DID:** 0xF19D
- **Subfunction ID:** N/A
- **Formül:** ((A*256+B)-32768)/10
- **Birim:** Nm
- **Minimum:** -3276.8Nm
- **Maksimum:** 3276.7Nm
- **Örnek Gelen Cevap:** 62 F1 9D 07 D0
- **Örnek Çözüm:** A=0x07 (7), B=0xD0 (208) → ((7*256+208)-32768)/10 = -200.0Nm (rejeneratif)

### Inverter Sıcaklığı

#### UDS Service 0x22 - DID 0xF19E - Inverter Sıcaklığı
- **UDS Service ID:** 0x22
- **DID:** 0xF19E
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F1 9E 01 5E
- **Örnek Çözüm:** A=0x01 (1), B=0x5E (94) → (1*256+94)/10-40 = -5.0°C

### Batarya Soğutma Sistemi

#### UDS Service 0x22 - DID 0xF19F - Soğutma Sıvısı Sıcaklığı
- **UDS Service ID:** 0x22
- **DID:** 0xF19F
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F1 9F 01 90
- **Örnek Çözüm:** A=0x01 (1), B=0x90 (144) → (1*256+144)/10-40 = 0.0°C

#### UDS Service 0x22 - DID 0xF1A0 - Soğutma Fan Hızı
- **UDS Service ID:** 0x22
- **DID:** 0xF1A0
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)
- **Birim:** RPM
- **Minimum:** 0 RPM
- **Maksimum:** 65535 RPM
- **Örnek Gelen Cevap:** 62 F1 A0 0B B8
- **Örnek Çözüm:** A=0x0B (11), B=0xB8 (184) → (11*256+184) = 3000 RPM

### Rejeneratif Frenleme Verileri

#### UDS Service 0x22 - DID 0xF1A1 - Rejeneratif Güç
- **UDS Service ID:** 0x22
- **DID:** 0xF1A1
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** kW
- **Minimum:** 0kW
- **Maksimum:** 6553.5kW
- **Örnek Gelen Cevap:** 62 F1 A1 00 32
- **Örnek Çözüm:** A=0x00 (0), B=0x32 (50) → (0*256+50)/10 = 5.0kW

### AC/DC Şarj Verileri

#### UDS Service 0x22 - DID 0xF1A2 - Şarj Voltajı
- **UDS Service ID:** 0x22
- **DID:** 0xF1A2
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** V
- **Minimum:** 0V
- **Maksimum:** 6553.5V
- **Örnek Gelen Cevap:** 62 F1 A2 0F A0
- **Örnek Çözüm:** A=0x0F (15), B=0xA0 (160) → (15*256+160)/10 = 400.0V

#### UDS Service 0x22 - DID 0xF1A3 - Şarj Akımı
- **UDS Service ID:** 0x22
- **DID:** 0xF1A3
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** A
- **Minimum:** 0A
- **Maksimum:** 6553.5A
- **Örnek Gelen Cevap:** 62 F1 A3 00 64
- **Örnek Çözüm:** A=0x00 (0), B=0x64 (100) → (0*256+100)/10 = 10.0A

### Şarj Durumu

#### UDS Service 0x22 - DID 0xF1A4 - Şarj Durumu
- **UDS Service ID:** 0x22
- **DID:** 0xF1A4
- **Subfunction ID:** N/A
- **Formül:** Bit alanı
- **Birim:** Bit flags
- **Bit 0:** Plug bağlı
- **Bit 1:** Şarj ediliyor
- **Bit 2:** Şarj tamamlandı
- **Bit 3:** Şarj hatası
- **Örnek Gelen Cevap:** 62 F1 A4 03
- **Örnek Çözüm:** A=0x03 → Bit 0 ve 1 set → Plug bağlı ve şarj ediliyor

### Şarj Gücü

#### UDS Service 0x22 - DID 0xF1A5 - Şarj Gücü
- **UDS Service ID:** 0x22
- **DID:** 0xF1A5
- **Subfunction ID:** N/A
- **Formül:** (A*256+B)/10
- **Birim:** kW
- **Minimum:** 0kW
- **Maksimum:** 6553.5kW
- **Örnek Gelen Cevap:** 62 F1 A5 00 64
- **Örnek Çözüm:** A=0x00 (0), B=0x64 (100) → (0*256+100)/10 = 10.0kW

---

## 3. ŞANZIMAN (TCU) İÇİN GERÇEK UDS/OBD VERİLERİ

### Vites Pozisyonu

#### UDS Service 0x22 - DID 0xF200 - Vites Pozisyonu
- **UDS 22xx Kodu:** 0x22F200
- **Byte Uzunluğu:** 1 byte
- **Formül:** A
- **Birim:** Vites numarası
- **Değerler:** 0=P, 1=R, 2=N, 3=D, 4-15=Manuel vitesler
- **Minimum:** 0
- **Maksimum:** 15
- **Örnek Gelen Cevap:** 62 F2 00 03
- **Örnek Çözüm:** A=0x03 → D (Drive) konumu

### Kavrama Sıcaklıkları

#### UDS Service 0x22 - DID 0xF201 - Kavrama 1 Sıcaklığı
- **UDS 22xx Kodu:** 0x22F201
- **Byte Uzunluğu:** 2 bytes
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F2 01 01 90
- **Örnek Çözüm:** A=0x01 (1), B=0x90 (144) → (1*256+144)/10-40 = 0.0°C

#### UDS Service 0x22 - DID 0xF202 - Kavrama 2 Sıcaklığı
- **UDS 22xx Kodu:** 0x22F202
- **Byte Uzunluğu:** 2 bytes
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F2 02 01 90
- **Örnek Çözüm:** A=0x01 (1), B=0x90 (144) → (1*256+144)/10-40 = 0.0°C

### ATF Yağ Sıcaklığı

#### UDS Service 0x22 - DID 0xF203 - ATF Sıcaklığı
- **UDS 22xx Kodu:** 0x22F203
- **Byte Uzunluğu:** 2 bytes
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F2 03 01 90
- **Örnek Çözüm:** A=0x01 (1), B=0x90 (144) → (1*256+144)/10-40 = 0.0°C

### Hidrolik Basınçlar

#### UDS Service 0x22 - DID 0xF204 - Hidrolik Basınç 1
- **UDS 22xx Kodu:** 0x22F204
- **Byte Uzunluğu:** 2 bytes
- **Formül:** (A*256+B)/10
- **Birim:** kPa
- **Minimum:** 0 kPa
- **Maksimum:** 6553.5 kPa
- **Örnek Gelen Cevap:** 62 F2 04 01 F4
- **Örnek Çözüm:** A=0x01 (1), B=0xF4 (244) → (1*256+244)/10 = 50.0 kPa

#### UDS Service 0x22 - DID 0xF205 - Hidrolik Basınç 2
- **UDS 22xx Kodu:** 0x22F205
- **Byte Uzunluğu:** 2 bytes
- **Formül:** (A*256+B)/10
- **Birim:** kPa
- **Minimum:** 0 kPa
- **Maksimum:** 6553.5 kPa
- **Örnek Gelen Cevap:** 62 F2 05 01 F4
- **Örnek Çözüm:** A=0x01 (1), B=0xF4 (244) → (1*256+244)/10 = 50.0 kPa

### Debriyaj Doluluk

#### UDS Service 0x22 - DID 0xF206 - Debriyaj Doluluk Yüzdesi
- **UDS 22xx Kodu:** 0x22F206
- **Byte Uzunluğu:** 1 byte
- **Formül:** (A*100)/255
- **Birim:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 62 F2 06 80
- **Örnek Çözüm:** A=0x80 (128) → (128*100)/255 = 50.2%

### Şanzıman Hedef Torku

#### UDS Service 0x22 - DID 0xF207 - TCU Hedef Torku
- **UDS 22xx Kodu:** 0x22F207
- **Byte Uzunluğu:** 2 bytes
- **Formül:** ((A*256+B)-32768)/10
- **Birim:** Nm
- **Minimum:** -3276.8Nm
- **Maksimum:** 3276.7Nm
- **Örnek Gelen Cevap:** 62 F2 07 07 D0
- **Örnek Çözüm:** A=0x07 (7), B=0xD0 (208) → ((7*256+208)-32768)/10 = -200.0Nm

### TCU Gerçek Çıkış Torku

#### UDS Service 0x22 - DID 0xF208 - TCU Gerçek Çıkış Torku
- **UDS 22xx Kodu:** 0x22F208
- **Byte Uzunluğu:** 2 bytes
- **Formül:** ((A*256+B)-32768)/10
- **Birim:** Nm
- **Minimum:** -3276.8Nm
- **Maksimum:** 3276.7Nm
- **Örnek Gelen Cevap:** 62 F2 08 07 D0
- **Örnek Çözüm:** A=0x07 (7), B=0xD0 (208) → ((7*256+208)-32768)/10 = -200.0Nm

### Isınma Durumu

#### UDS Service 0x22 - DID 0xF209 - Şanzıman Isınma Durumu
- **UDS 22xx Kodu:** 0x22F209
- **Byte Uzunluğu:** 1 byte
- **Formül:** Bit alanı
- **Birim:** Bit flags
- **Bit 0:** Soğuk
- **Bit 1:** Isınıyor
- **Bit 2:** Sıcak
- **Bit 3:** Aşırı ısınma
- **Örnek Gelen Cevap:** 62 F2 09 02
- **Örnek Çözüm:** A=0x02 → Bit 1 set → Isınıyor

### TCU Çalışma Modları

#### UDS Service 0x22 - DID 0xF20A - TCU Çalışma Modu
- **UDS 22xx Kodu:** 0x22F20A
- **Byte Uzunluğu:** 1 byte
- **Formül:** A
- **Birim:** Mod numarası
- **Değerler:** 0=Normal, 1=Sport, 2=Eco, 3=Manuel, 4=Kış modu
- **Minimum:** 0
- **Maksimum:** 255
- **Örnek Gelen Cevap:** 62 F2 0A 01
- **Örnek Çözüm:** A=0x01 → Sport modu

### Mechatronic Sıcaklıkları

#### UDS Service 0x22 - DID 0xF20B - Mechatronic Sıcaklığı
- **UDS 22xx Kodu:** 0x22F20B
- **Byte Uzunluğu:** 2 bytes
- **Formül:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F2 0B 01 90
- **Örnek Çözüm:** A=0x01 (1), B=0x90 (144) → (1*256+144)/10-40 = 0.0°C

---

## 4. DPF (DİZEL PARTİKÜL FİLTRESİ) GERÇEK UDS/OBD VERİLERİ

### DPF Doluluk

#### UDS Service 0x22 - DID 0xF300 - DPF Doluluk Yüzdesi
- **PID/UDS Kodu:** 0x22F300
- **Okuma Formülü:** (A*100)/255
- **Birim:** %
- **Minimum:** 0%
- **Maksimum:** 100%
- **Örnek Gelen Cevap:** 62 F3 00 4D
- **Örnek Çözüm:** A=0x4D (77) → (77*100)/255 = 30.2%

### DPF Basınç Sensörü

#### UDS Service 0x22 - DID 0xF301 - DPF Basınç Sensörü
- **PID/UDS Kodu:** 0x22F301
- **Okuma Formülü:** (A*256+B)/10
- **Birim:** kPa
- **Minimum:** 0 kPa
- **Maksimum:** 6553.5 kPa
- **Örnek Gelen Cevap:** 62 F3 01 00 64
- **Örnek Çözüm:** A=0x00 (0), B=0x64 (100) → (0*256+100)/10 = 10.0 kPa

### DPF Sıcaklıkları

#### UDS Service 0x22 - DID 0xF302 - DPF Ön Sıcaklık
- **PID/UDS Kodu:** 0x22F302
- **Okuma Formülü:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F3 02 05 DC
- **Örnek Çözüm:** A=0x05 (5), B=0xDC (220) → (5*256+220)/10-40 = 110.0°C

#### UDS Service 0x22 - DID 0xF303 - DPF Son Sıcaklık
- **PID/UDS Kodu:** 0x22F303
- **Okuma Formülü:** (A*256+B)/10-40
- **Birim:** °C
- **Minimum:** -40°C
- **Maksimum:** 215°C
- **Örnek Gelen Cevap:** 62 F3 03 05 78
- **Örnek Çözüm:** A=0x05 (5), B=0x78 (120) → (5*256+120)/10-40 = 88.0°C

### Rejenerasyon Durumu

#### UDS Service 0x22 - DID 0xF304 - DPF Rejenerasyon Durumu
- **PID/UDS Kodu:** 0x22F304
- **Okuma Formülü:** Bit alanı
- **Birim:** Bit flags
- **Bit 0:** Rejenerasyon aktif
- **Bit 1:** Rejenerasyon gerekli
- **Bit 2:** Rejenerasyon tamamlandı
- **Bit 3:** Rejenerasyon hatası
- **Örnek Gelen Cevap:** 62 F3 04 01
- **Örnek Çözüm:** A=0x01 → Bit 0 set → Rejenerasyon aktif

### Son Rejenerasyon KM

#### UDS Service 0x22 - DID 0xF305 - Son Rejenerasyon KM
- **PID/UDS Kodu:** 0x22F305
- **Okuma Formülü:** (A*256+B)*10
- **Birim:** km
- **Minimum:** 0 km
- **Maksimum:** 655350 km
- **Örnek Gelen Cevap:** 62 F3 05 00 C8
- **Örnek Çözüm:** A=0x00 (0), B=0xC8 (200) → (0*256+200)*10 = 2000 km

### Zorunlu Rejenerasyon Komutu

#### UDS Service 0x31 - Routine Control 0x0101 - DPF Rejenerasyon Başlat
- **PID/UDS Kodu:** 0x310101
- **Okuma Formülü:** Komut gönderimi
- **Birim:** N/A
- **Komut Formatı:** 31 01 01 [Parametreler]
- **Beklenen Cevap:** 71 01 01 [Durum]
- **Örnek Komut:** 31 01 01 00 00 00 00
- **Örnek Cevap:** 71 01 01 00 (Başarılı)

### DPF Aktifleştirme Kontrolü

#### UDS Service 0x22 - DID 0xF306 - DPF Aktifleştirme Durumu
- **PID/UDS Kodu:** 0x22F306
- **Okuma Formülü:** Bit alanı
- **Birim:** Bit flags
- **Bit 0:** DPF aktif
- **Bit 1:** DPF devre dışı
- **Bit 2:** DPF arızalı
- **Bit 3:** DPF bakım gerekli
- **Örnek Gelen Cevap:** 62 F3 06 01
- **Örnek Çözüm:** A=0x01 → Bit 0 set → DPF aktif

---

## 5. ENJEKTÖR KODLAMA VERİLERİ (CODING / LEARNING)

### Enjektör Kod Okuma

#### UDS Service 0x22 - DID 0xF400 - Enjektör 1 Kod Değeri
- **UDS Komutu:** 0x22F400
- **Dizilim:** 22 F4 00
- **Byte Yapısı:** 4 bytes (Enjektör kodu)
- **Geri Dönüş Verisi:** 62 F4 00 [Byte1] [Byte2] [Byte3] [Byte4]
- **Örnek Komut:** 22 F4 00
- **Örnek Cevap:** 62 F4 00 12 34 56 78
- **Örnek Çözüm:** Enjektör kodu: 0x12345678

### Enjektör Kod Yazma

#### UDS Service 0x2E - DID 0xF400 - Enjektör 1 Kod Yazma
- **UDS Komutu:** 0x2EF400
- **Dizilim:** 2E F4 00 [Byte1] [Byte2] [Byte3] [Byte4]
- **Byte Yapısı:** 4 bytes (Enjektör kodu)
- **Geri Dönüş Verisi:** 6E F4 00 (Başarılı)
- **Örnek Komut:** 2E F4 00 12 34 56 78
- **Örnek Cevap:** 6E F4 00
- **Örnek Çözüm:** Enjektör kodu yazıldı: 0x12345678

### Enjektör Kalibrasyon Değerleri

#### UDS Service 0x22 - DID 0xF401 - Enjektör 1 Kalibrasyon Değeri
- **UDS Komutu:** 0x22F401
- **Dizilim:** 22 F4 01
- **Byte Yapısı:** 2 bytes (Kalibrasyon değeri)
- **Geri Dönüş Verisi:** 62 F4 01 [Byte1] [Byte2]
- **Formül:** (A*256+B)/1000
- **Birim:** ml/stroke
- **Örnek Komut:** 22 F4 01
- **Örnek Cevap:** 62 F4 01 03 E8
- **Örnek Çözüm:** A=0x03 (3), B=0xE8 (232) → (3*256+232)/1000 = 1.000 ml/stroke

### Enjektör Balans/Trim Değerleri

#### UDS Service 0x22 - DID 0xF402 - Enjektör 1 Trim Değeri
- **UDS Komutu:** 0x22F402
- **Dizilim:** 22 F4 02
- **Byte Yapısı:** 1 byte (Trim değeri)
- **Geri Dönüş Verisi:** 62 F4 02 [Byte]
- **Formül:** ((A-128)*100)/128
- **Birim:** %
- **Örnek Komut:** 22 F4 02
- **Örnek Cevap:** 62 F4 02 80
- **Örnek Çözüm:** A=0x80 (128) → ((128-128)*100)/128 = 0%

### Enjektör Akış Hesaplaması

#### UDS Service 0x22 - DID 0xF403 - Enjektör 1 Akış Değeri
- **UDS Komutu:** 0x22F403
- **Dizilim:** 22 F4 03
- **Byte Yapısı:** 2 bytes (Akış değeri)
- **Geri Dönüş Verisi:** 62 F4 03 [Byte1] [Byte2]
- **Formül:** (A*256+B)/100
- **Birim:** ml/min
- **Örnek Komut:** 22 F4 03
- **Örnek Cevap:** 62 F4 03 01 F4
- **Örnek Çözüm:** A=0x01 (1), B=0xF4 (244) → (1*256+244)/100 = 5.00 ml/min

---

## 6. ECU SORGULAMA KOMUTLARI (UDS ZARURİ KOMUT SETİ)

### ECU Kimlik Okuma

#### UDS Service 0x09 - Subfunction 0x02 - VIN Okuma
- **Hizmet ID:** 0x09
- **Alt Fonksiyon:** 0x02
- **Komut Örneği:** 09 02
- **Beklenen Cevap Formatı:** 49 02 [VIN verisi]
- **Byte Uzunluğu:** 17 bytes (VIN)
- **Örnek Komut:** 09 02
- **Örnek Cevap:** 49 02 57 4D 42 4A 45 35 36 30 35 4A 31 32 33 34 35 36 37
- **Örnek Çözüm:** VIN: WMBJE5605J1234567

#### UDS Service 0x22 - DID 0xF190 - Yazılım Numarası
- **Hizmet ID:** 0x22
- **Alt Fonksiyon:** N/A (DID kullanılır)
- **Komut Örneği:** 22 F1 90
- **Beklenen Cevap Formatı:** 62 F1 90 [Yazılım numarası]
- **Byte Uzunluğu:** Değişken (genellikle 4-8 bytes)
- **Örnek Komut:** 22 F1 90
- **Örnek Cevap:** 62 F1 90 31 32 33 34 35 36 37 38
- **Örnek Çözüm:** Yazılım numarası: 12345678

#### UDS Service 0x22 - DID 0xF191 - Donanım Numarası
- **Hizmet ID:** 0x22
- **Alt Fonksiyon:** N/A (DID kullanılır)
- **Komut Örneği:** 22 F1 91
- **Beklenen Cevap Formatı:** 62 F1 91 [Donanım numarası]
- **Byte Uzunluğu:** Değişken (genellikle 4-8 bytes)
- **Örnek Komut:** 22 F1 91
- **Örnek Cevap:** 62 F1 91 41 42 43 44 45 46 47 48
- **Örnek Çözüm:** Donanım numarası: ABCDEFGH

#### UDS Service 0x22 - DID 0xF1A0 - VIN Doğrulama
- **Hizmet ID:** 0x22
- **Alt Fonksiyon:** N/A (DID kullanılır)
- **Komut Örneği:** 22 F1 A0
- **Beklenen Cevap Formatı:** 62 F1 A0 [VIN]
- **Byte Uzunluğu:** 17 bytes
- **Örnek Komut:** 22 F1 A0
- **Örnek Cevap:** 62 F1 A0 57 4D 42 4A 45 35 36 30 35 4A 31 32 33 34 35 36 37
- **Örnek Çözüm:** VIN: WMBJE5605J1234567

### DTC Okuma

#### UDS Service 0x19 - Subfunction 0x02 - DTC Sayısı Okuma
- **Hizmet ID:** 0x19
- **Alt Fonksiyon:** 0x02
- **Komut Örneği:** 19 02
- **Beklenen Cevap Formatı:** 59 02 [DTC sayısı] [DTC verileri]
- **Byte Uzunluğu:** Değişken
- **Örnek Komut:** 19 02
- **Örnek Cevap:** 59 02 02 01 23 45 67 89
- **Örnek Çözüm:** 2 adet DTC: P0123 ve P4567

#### UDS Service 0x19 - Subfunction 0x0A - Tüm DTC Okuma
- **Hizmet ID:** 0x19
- **Alt Fonksiyon:** 0x0A
- **Komut Örneği:** 19 0A
- **Beklenen Cevap Formatı:** 59 0A [DTC verileri]
- **Byte Uzunluğu:** Değişken
- **Örnek Komut:** 19 0A
- **Örnek Cevap:** 59 0A 01 23 45 67 89 AB CD EF
- **Örnek Çözüm:** Tüm DTC'ler okundu

#### UDS Service 0x19 - Subfunction 0x0B - DTC Sayısı (MIL)
- **Hizmet ID:** 0x19
- **Alt Fonksiyon:** 0x0B
- **Komut Örneği:** 19 0B
- **Beklenen Cevap Formatı:** 59 0B [MIL DTC sayısı]
- **Byte Uzunluğu:** 1 byte
- **Örnek Komut:** 19 0B
- **Örnek Cevap:** 59 0B 03
- **Örnek Çözüm:** 3 adet MIL açık DTC

### DTC Silme

#### UDS Service 0x14 - Subfunction 0xFF - Tüm DTC Silme
- **Hizmet ID:** 0x14
- **Alt Fonksiyon:** 0xFF
- **Komut Örneği:** 14 FF FF
- **Beklenen Cevap Formatı:** 54 FF FF
- **Byte Uzunluğu:** 3 bytes
- **Örnek Komut:** 14 FF FF
- **Örnek Cevap:** 54 FF FF
- **Örnek Çözüm:** Tüm DTC'ler silindi

### Live Data

#### UDS Service 0x22 - DID 0xXXXX - Live Data Okuma
- **Hizmet ID:** 0x22
- **Alt Fonksiyon:** N/A (DID kullanılır)
- **Komut Örneği:** 22 [DID high] [DID low]
- **Beklenen Cevap Formatı:** 62 [DID high] [DID low] [Veri]
- **Byte Uzunluğu:** Değişken (DID'e göre)
- **Örnek Komut:** 22 F1 90
- **Örnek Cevap:** 62 F1 90 03 E8
- **Örnek Çözüm:** DID 0xF190 verisi okundu

### Aktüatör Testi

#### UDS Service 0x31 - Routine Control 0x0101 - Aktüatör Testi
- **Hizmet ID:** 0x31
- **Alt Fonksiyon:** 0x01 (Start)
- **Komut Örneği:** 31 01 01 [Parametreler]
- **Beklenen Cevap Formatı:** 71 01 01 [Durum]
- **Byte Uzunluğu:** Değişken
- **Örnek Komut:** 31 01 01 00 00 00 00
- **Örnek Cevap:** 71 01 01 00
- **Örnek Çözüm:** Aktüatör testi başlatıldı

### Kodlama

#### UDS Service 0x2E - DID 0xXXXX - Kodlama Yazma
- **Hizmet ID:** 0x2E
- **Alt Fonksiyon:** N/A (DID kullanılır)
- **Komut Örneği:** 2E [DID high] [DID low] [Veri]
- **Beklenen Cevap Formatı:** 6E [DID high] [DID low]
- **Byte Uzunluğu:** Değişken
- **Örnek Komut:** 2E F4 00 12 34 56 78
- **Örnek Cevap:** 6E F4 00
- **Örnek Çözüm:** Kodlama yazıldı

### Security Access

#### UDS Service 0x27 - Subfunction 0x01 - Seed İsteme
- **Hizmet ID:** 0x27
- **Alt Fonksiyon:** 0x01
- **Komut Örneği:** 27 01
- **Beklenen Cevap Formatı:** 67 01 [Seed bytes]
- **Byte Uzunluğu:** 2-4 bytes (Seed)
- **Örnek Komut:** 27 01
- **Örnek Cevap:** 67 01 12 34
- **Örnek Çözüm:** Seed alındı: 0x1234

#### UDS Service 0x27 - Subfunction 0x02 - Key Gönderme
- **Hizmet ID:** 0x27
- **Alt Fonksiyon:** 0x02
- **Komut Örneği:** 27 02 [Key bytes]
- **Beklenen Cevap Formatı:** 67 02
- **Byte Uzunluğu:** 2-4 bytes (Key)
- **Örnek Komut:** 27 02 56 78
- **Örnek Cevap:** 67 02
- **Örnek Çözüm:** Key doğrulandı, erişim sağlandı

### Session Değişimi

#### UDS Service 0x10 - Subfunction 0x03 - Extended Diagnostic Session
- **Hizmet ID:** 0x10
- **Alt Fonksiyon:** 0x03
- **Komut Örneği:** 10 03
- **Beklenen Cevap Formatı:** 50 03 [P2 timing] [P2* timing]
- **Byte Uzunluğu:** 3 bytes
- **Örnek Komut:** 10 03
- **Örnek Cevap:** 50 03 00 32 01 F4
- **Örnek Çözüm:** Extended session aktif, P2=50ms, P2*=500ms

#### UDS Service 0x10 - Subfunction 0x02 - Programming Session
- **Hizmet ID:** 0x10
- **Alt Fonksiyon:** 0x02
- **Komut Örneği:** 10 02
- **Beklenen Cevap Formatı:** 50 02 [P2 timing] [P2* timing]
- **Byte Uzunluğu:** 3 bytes
- **Örnek Komut:** 10 02
- **Örnek Cevap:** 50 02 00 64 03 E8
- **Örnek Çözüm:** Programming session aktif, P2=100ms, P2*=1000ms

---

## 7. CEVAP FORMATI ŞABLONU

### OBD-II PID Cevap Formatı

**Genel Format:**
- **Komut:** [Mode] [PID]
- **Cevap:** [Mode+0x40] [PID] [Veri bytes...]

**Örnek:**
- **Komut:** 01 0C (RPM okuma)
- **Cevap:** 41 0C 1F 40
- **Çözüm:** Mode=0x01, PID=0x0C, A=0x1F, B=0x40 → (31*256+64)/4 = 8000 RPM

### UDS Cevap Formatı

**Genel Format:**
- **Komut:** [Service ID] [Subfunction/DID...]
- **Cevap:** [Service ID+0x40] [Subfunction/DID...] [Veri bytes...]

**Örnek:**
- **Komut:** 22 F1 90 (SOC okuma)
- **Cevap:** 62 F1 90 03 E8
- **Çözüm:** Service=0x22, DID=0xF190, A=0x03, B=0xE8 → (3*256+232)/10 = 100.0%

### Negatif Değer Formatı

**İki Byte Signed:**
- **Formül:** ((A*256+B)-32768)/[Bölücü]
- **Örnek:** A=0x00, B=0x00 → ((0*256+0)-32768)/10 = -3276.8
- **Örnek:** A=0x7F, B=0xFF → ((127*256+255)-32768)/10 = 0.0
- **Örnek:** A=0xFF, B=0xFF → ((255*256+255)-32768)/10 = 3276.7

### Bit Alanı Formatı

**Tek Byte Bit Flags:**
- **Bit 0:** En düşük bit (LSB)
- **Bit 7:** En yüksek bit (MSB)
- **Örnek:** 0x01 = Bit 0 set
- **Örnek:** 0x03 = Bit 0 ve 1 set
- **Örnek:** 0xFF = Tüm bitler set

---

## 8. STANDART REFERANSLAR

### OBD-II Standartları
- **SAE J1979:** E/E Diagnostic Test Modes
- **SAE J2012:** Diagnostic Trouble Code Definitions
- **ISO 9141-2:** Diagnostic Communication
- **ISO 14230-4:** Keyword Protocol 2000

### UDS Standartları
- **ISO 14229-1:** Unified Diagnostic Services (UDS) - Specification
- **ISO 14229-2:** Unified Diagnostic Services (UDS) - Session Layer
- **ISO 14229-3:** Unified Diagnostic Services (UDS) - Implementation

### CAN Protokolü
- **ISO 11898:** CAN Bus Specification
- **ISO 15765-4:** Diagnostic Communication over CAN (DoCAN)

---

**NOT:** Bu dokümandaki tüm PID ve UDS kodları SAE J1979 ve ISO 14229 standartlarına dayanmaktadır. Gerçek uygulamada marka/model bazlı ek PID'ler ve DID'ler bulunabilir. Bu doküman standart, evrensel olarak kabul edilen kodları içermektedir.
