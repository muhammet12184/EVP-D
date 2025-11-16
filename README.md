# OBD-II / UDS Entegrasyon Sistemi

Kapsamlı otomotiv PID veritabanı ve UDS protokolü ile ECU iletişim sistemi.

## Özellikler

1. **UDS Komut Gönderme**: ELM327 adaptörü üzerinden UDS protokolü ile ECU iletişimi
2. **Akıllı PID Yönlendirici**: Araç markasına göre doğru PID seçimi
3. **Formül Hesaplayıcı**: UDS cevaplarını formüllere göre işleyip anlamlı veriye çevirme

## Kurulum

```bash
pip install -r requirements.txt
```

## Kullanım

### Temel Kullanım

```python
from obd_integration import OBDIntegration

# Entegrasyon nesnesi oluştur
obd = OBDIntegration(port="COM3")  # Windows için
# obd = OBDIntegration(port="/dev/ttyUSB0")  # Linux için

# Bağlan
if obd.connect(manufacturer="TOGG"):
    # PID oku
    result = obd.read_pid("Battery State of Charge", "TOGG")
    print(f"SOC: {result['formatted']}")
    
    obd.disconnect()
```

### EV Batarya Durumu

```python
obd = OBDIntegration(port="COM3")

if obd.connect(manufacturer="TESLA"):
    battery_status = obd.read_ev_battery_status("TESLA")
    
    for name, data in battery_status.items():
        print(f"{name}: {data['formatted']}")
```

### Birden Fazla PID Okuma

```python
obd = OBDIntegration(port="COM3")

if obd.connect(manufacturer="HYUNDAI"):
    pid_names = [
        "Battery SOC",
        "Battery Voltage",
        "Battery Current",
        "Battery Temperature"
    ]
    
    results = obd.read_multiple_pids(pid_names, "HYUNDAI")
    for pid_name, data in results.items():
        print(f"{pid_name}: {data['formatted']}")
```

### Arama ve Okuma

```python
obd = OBDIntegration(port="COM3")

if obd.connect():
    # "battery" kelimesini ara ve oku
    results = obd.search_and_read("battery", ecu="BMS", limit=10)
    
    for result in results:
        print(f"{result['name']}: {result['formatted']}")
```

## Modüller

### 1. uds_commander.py
ELM327 adaptörü ile UDS komutları gönderen modül.

**Ana Fonksiyonlar:**
- `connect()`: ELM327'ye bağlan
- `send_uds_command(service, pid)`: UDS komutu gönder
- `send_uds_read_data_by_id(pid)`: Mode 22 komutu gönder
- `set_header(header)`: ECU header'ını ayarla

### 2. pid_router.py
PID veritabanı yönlendiricisi.

**Ana Fonksiyonlar:**
- `get_pid_by_name(name, manufacturer)`: İsme göre PID bul
- `get_pid_by_code(mode, pid_code)`: Koda göre PID bul
- `get_pids_by_ecu(ecu)`: ECU'ya göre PID'leri getir
- `get_pids_by_manufacturer(manufacturer)`: Üreticiye göre PID'leri getir
- `search_pids(keyword)`: Anahtar kelimeye göre ara

### 3. formula_calculator.py
Formül hesaplayıcı modülü.

**Ana Fonksiyonlar:**
- `calculate(pid_entry, response_bytes)`: UDS cevabını hesapla
- `calculate_with_formatting(pid_entry, response_bytes)`: Hesapla ve formatla
- `format_value(value, units, pid_entry)`: Değeri formatla

### 4. obd_integration.py
Ana entegrasyon modülü - tüm bileşenleri birleştirir.

**Ana Fonksiyonlar:**
- `connect(manufacturer)`: Bağlan
- `read_pid(pid_name, manufacturer)`: PID oku
- `read_multiple_pids(pid_names)`: Birden fazla PID oku
- `read_ev_battery_status(manufacturer)`: EV batarya durumu
- `read_engine_status()`: Motor durumu
- `search_and_read(keyword)`: Ara ve oku

## Desteklenen Üreticiler

- TOGG
- Tesla
- Hyundai/Kia
- BMW
- Mercedes-Benz
- Toyota/Lexus
- VW/Audi
- Ford
- GM/Opel
- Nissan
- PSA (Peugeot/Citroen)
- Volvo
- Porsche
- Ve daha fazlası...

## Desteklenen ECU'lar

- ECM (Motor Kontrol)
- TCM (Şanzıman)
- BMS (Batarya Yönetim)
- ABS/ESP (Fren Sistemi)
- EPS (Direksiyon)
- HVAC (Klima)
- SRS (Hava Yastığı)
- Ve daha fazlası...

## Örnekler

Detaylı örnekler için `example_usage.py` dosyasına bakın.

## Notlar

- ELM327 adaptörü gereklidir
- Seri port izinleri gerekebilir (Linux'ta)
- Bazı PID'ler belirli araç modellerinde mevcut olmayabilir
- Gerçek değerler araçtan araç değişebilir
