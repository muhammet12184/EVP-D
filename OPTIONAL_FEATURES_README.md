# Opsiyonel Özellikler - Uygulama Dokümantasyonu

Bu dokümantasyon, eklenen opsiyonel özellikleri açıklar.

## Eklenen Özellikler

### 1. Motor Analizinde Yakıt Tüketim PID Bağlantısı

**Dosya:** `motor_analysis.py`

Motor analizinde yakıt alanına gerçek anlık/tüketim PID'i bağlandı. Artık placeholder (0.0) değer yerine gerçek PID verileri kullanılıyor.

**Özellikler:**
- Otomatik yakıt tüketim PID'i tespiti
- Birden fazla PID formatı desteği (standart OBD-II ve üreticiye özel)
- DataAnalyzer entegrasyonu ile istatistiksel analiz
- Flutter UI'da yakıt tüketimi gösterimi

**Kullanım:**
```python
from motor_analysis import MotorAnalysis
from obd_integration import OBDIntegration
from data_analyzer import DataAnalyzer

obd = OBDIntegration()
analyzer = DataAnalyzer()
motor = MotorAnalysis(obd, analyzer)

# PID'i başlat
motor.initialize_fuel_pid(manufacturer="TOGG")

# Yakıt tüketimini oku
fuel_consumption = motor.read_fuel_consumption()  # L/h
```

**Flutter UI:**
- `lib/engine_section.dart` dosyasında yakıt tüketimi kartı eklendi
- Gerçek zamanlı PID verileri gösterilir
- PID bağlantısı yoksa gri renkte gösterilir

### 2. EV Regen PID Yakalama ve DataAnalyzer Entegrasyonu

**Dosya:** `ev_analysis.py`

EV tarafında regen için ayrı PID yakalama ve DataAnalyzer'a bağlama özelliği eklendi.

**Özellikler:**
- Otomatik regen PID tespiti
- Battery Current PID'inden regen gücü hesaplama (negatif akım = regen)
- DataAnalyzer ile regen istatistikleri
- Gerçek zamanlı regen analizi

**Kullanım:**
```python
from ev_analysis import EVAnalysis
from obd_integration import OBDIntegration
from data_analyzer import DataAnalyzer

obd = OBDIntegration()
analyzer = DataAnalyzer()
ev = EVAnalysis(obd, analyzer)

# PID'i başlat
ev.initialize_regen_pid(manufacturer="TOGG")

# Regen gücünü oku
regen_power = ev.read_regen_power()  # kW

# Analiz sonuçlarını al
regen_analysis = analyzer.get_regen_analysis()
```

**DataAnalyzer Özellikleri:**
- Hareketli pencere istatistikleri (son N ölçüm)
- Ortalama, maksimum, minimum değerler
- Standart sapma hesaplama
- Toplam enerji hesaplama (yaklaşık)

### 3. Araç Marka Tespiti UI Gösterimi

**Dosya:** `lib/dashboard.dart`, `pid_router.py`

PIDRouter tarafından bulunan araç marka tespiti UI'da gösteriliyor (debug kolaylığı için).

**Özellikler:**
- Otomatik marka tespiti (`detect_vehicle_brand()` metodu)
- Flutter UI'da debug bilgi widget'ı
- Tespit edilen marka görsel gösterimi
- Tıklanarak gizlenebilir/gösterilebilir

**PIDRouter Güncellemeleri:**
- `detect_vehicle_brand()` metodu eklendi
- `get_detected_brand()` metodu eklendi
- EV unified professional CSV formatı desteği
- Çoklu marka tespit algoritması

**Flutter UI:**
- Sağ üst köşede debug bilgi widget'ı
- Yeşil: Marka tespit edildi
- Turuncu: Tespit ediliyor
- Tıklanarak gizlenebilir

**Kullanım:**
```python
from pid_router import PIDRouter

router = PIDRouter("ev_unified_professional.csv")

# Marka tespiti
detected_brand = router.detect_vehicle_brand()
print(f"Tespit edilen marka: {detected_brand}")

# Tespit edilen markayı al
current_brand = router.get_detected_brand()
```

## Dosya Yapısı

```
/workspace/
├── data_analyzer.py          # Veri analiz modülü
├── motor_analysis.py         # Motor analiz modülü (yakıt PID bağlantısı)
├── ev_analysis.py           # EV analiz modülü (regen PID bağlantısı)
├── pid_router.py            # PID router (marka tespiti eklendi)
├── integration_example.py   # Tam entegrasyon örneği
├── lib/
│   ├── dashboard.dart       # Ana dashboard (marka tespiti gösterimi)
│   └── engine_section.dart  # Motor bölümü (yakıt tüketimi eklendi)
└── OPTIONAL_FEATURES_README.md  # Bu dosya
```

## Entegrasyon Örneği

Tam entegrasyon için `integration_example.py` dosyasını çalıştırın:

```bash
python integration_example.py
```

Bu örnek:
1. ELM327'ye bağlanır
2. Araç markasını tespit eder
3. Yakıt tüketim PID'ini başlatır
4. Regen PID'ini başlatır
5. Veri okuma döngüsü başlatır
6. İstatistikleri gösterir

## Flutter UI Güncellemeleri

### Dashboard (`lib/dashboard.dart`)
- Araç marka tespiti debug widget'ı eklendi
- Yakıt tüketimi parametresi eklendi
- `detectedVehicleBrand` state değişkeni eklendi

### Engine Section (`lib/engine_section.dart`)
- `fuelConsumption` parametresi eklendi
- Yakıt tüketimi kartı eklendi (YAKIT TÜKETİMİ)
- PID bağlantısı durumuna göre renk değişimi

## Notlar

1. **Yakıt Tüketim PID'i:** Eğer PID bulunamazsa, sistem 0.0 değerini kullanır ve uyarı verir. Bu durumda placeholder değer gösterilir.

2. **Regen PID'i:** Regen PID'i bulunamazsa, Battery Current PID'inden hesaplanmaya çalışılır. Negatif akım değerleri regen gücü olarak yorumlanır.

3. **Marka Tespiti:** Marka tespiti otomatik olarak çalışır, ancak başarısız olursa manuel olarak ayarlanabilir.

4. **DataAnalyzer:** Veriler hareketli pencere içinde tutulur (varsayılan: 100 ölçüm). Bu, performans analizi için kullanılabilir.

## Gelecek Geliştirmeler

- [ ] Yakıt tüketimi için daha fazla PID formatı desteği
- [ ] Regen için özel PID formatları
- [ ] Marka tespiti için makine öğrenmesi desteği
- [ ] Flutter UI'da daha detaylı istatistikler
- [ ] Veri kaydetme ve analiz özellikleri
