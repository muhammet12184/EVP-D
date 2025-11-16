# OBD-II / UDS PID Okuma Sistemi

Bu proje, ELM327 adaptörü kullanarak OBD-II ve UDS protokolleri ile araç ECU'larından veri okumak için kapsamlı bir sistem sağlar.

## Özellikler

- **UDS Komut Gönderme**: ELM327 ile UDS (Mode 22) ve OBD-II (Mode 01, 09) komutları gönderme
- **Akıllı PID Yönlendiricisi**: Marka ve ECU'ya göre doğru PID'i otomatik seçme
- **Formül Hesaplayıcı**: Ham byte'ları anlamlı değerlere çevirme
- **500+ PID Desteği**: Benzinli, dizel, hibrit ve elektrikli araçlar için kapsamlı PID listesi

## Kurulum

```bash
pip install -r requirements.txt
```

## Kullanım

### Temel Kullanım

```python
from obd_uds_integration import OBDUDSIntegration

# ELM327 port'unu belirtin
obd = OBDUDSIntegration(port="COM3")  # Windows
# obd = OBDUDSIntegration(port="/dev/ttyUSB0")  # Linux

# Bağlan
if obd.connect():
    # Marka ayarla
    obd.set_brand("TOGG")
    
    # PID oku
    result = obd.read_pid("Battery SOC", brand="TOGG")
    if result:
        print(f"Battery SOC: {result['formatted']}")
    
    # Bağlantıyı kapat
    obd.disconnect()
```

### EV Batarya Durumu

```python
obd = OBDUDSIntegration(port="COM3")
obd.connect()
obd.set_brand("TOGG")

# Tüm batarya durumunu oku
battery_status = obd.read_ev_battery_status(brand="TOGG")
for pid_name, result in battery_status.items():
    print(f"{pid_name}: {result['formatted']}")
```

### Motor Durumu (Benzinli/Dizel)

```python
obd = OBDUDSIntegration(port="COM3")
obd.connect()

# Motor durumunu oku
engine_status = obd.read_engine_status()
for pid_name, result in engine_status.items():
    print(f"{pid_name}: {result['formatted']}")
```

### Context Manager Kullanımı

```python
with OBDUDSIntegration(port="COM3") as obd:
    obd.set_brand("TOGG")
    result = obd.read_pid("Battery SOC")
    print(result['formatted'])
```

## Modüller

### 1. `uds_commander.py`
ELM327 adaptörü ile UDS komutları gönderir.

**Özellikler:**
- `set_header()`: CAN header ayarlama (AT SH)
- `send_uds_command()`: UDS Mode 22 komutu gönderme
- `send_obd_command()`: OBD-II komutu gönderme

### 2. `pid_database.py`
PID veritabanını yönetir ve markaya göre PID seçer.

**Özellikler:**
- CSV dosyasından PID yükleme
- Marka/ECU'ya göre PID arama
- Akıllı PID seçimi

### 3. `formula_calculator.py`
Ham byte'ları formüllere göre hesaplar.

**Özellikler:**
- Matematiksel formül hesaplama
- Min/Max değer kontrolü
- Özel format desteği (ASCII, Hex, Bit encoded)

### 4. `obd_uds_integration.py`
Tüm bileşenleri birleştirir.

**Özellikler:**
- Tek fonksiyonla PID okuma
- Çoklu PID okuma
- EV batarya durumu okuma
- Motor durumu okuma

## Desteklenen Araçlar

- **Elektrikli Araçlar**: TOGG, Tesla, Hyundai/Kia, Nissan, BMW, Mercedes, Audi, Volvo, Porsche, BYD, MG, Honda, Toyota, Mini
- **Hibrit Araçlar**: Toyota, Honda, Hyundai, Kia
- **Benzinli/Dizel**: Tüm OBD-II uyumlu araçlar

## Desteklenen ECU'lar

- ECM (Motor Kontrol)
- TCM (Şanzıman)
- BMS (Batarya Yönetim)
- ABS/ESP (Fren Sistemi)
- SRS (Hava Yastığı)
- EPS (Direksiyon)
- HVAC (Klima)
- DPF (Partikül Filtresi)
- EGR (Egzoz Gazı Devridaim)

## PID Formatı

CSV dosyasındaki her PID şu bilgileri içerir:
- **Name**: PID adı
- **Mode/PID**: Mode ve PID kodu (örn: "22 015B")
- **Equation**: Hesaplama formülü (örn: "A*100/255")
- **Min/Max**: Değer aralığı
- **Units**: Birim (%, V, A, °C, vb.)
- **Header**: CAN ID (örn: "7E4")
- **ECU**: ECU türü
- **Byte Position**: Byte pozisyonları (A, B, C, vb.)
- **Description**: Açıklama

## Formül Örnekleri

- `A`: Tek byte değer
- `A*100/255`: Yüzde hesaplama
- `(A*256+B)/10`: İki byte birleştirme
- `A-40`: Offset çıkarma
- `((A*256+B)-32767)/100`: İşaretli değer

## Hata Ayıklama

```python
# Verbose mod için
import logging
logging.basicConfig(level=logging.DEBUG)

# Manuel komut gönderme
commander = UDSCommander(port="COM3")
commander.connect()
commander.set_header("7E4")
result = commander.send_uds_command("015B")
print(f"Raw bytes: {result}")
```

## Notlar

- ELM327 adaptörünün doğru port'ta olduğundan emin olun
- Bazı PID'ler sadece belirli markalar için çalışır
- UDS komutları için araçın UDS desteği olmalıdır
- OBD-II komutları daha yaygın olarak desteklenir

## Lisans

Bu proje açık kaynaklıdır ve özgürce kullanılabilir.
