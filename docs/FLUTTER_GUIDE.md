# Flutter Entegrasyon Rehberi

## Dosya Yapısı

```
assets/
  ev_pids.json          ← tüm araç PID veritabanı
lib/
  models/
    ev_pid_model.dart   ← Dart model sınıfları
```

## pubspec.yaml Ayarı

```yaml
flutter:
  assets:
    - assets/ev_pids.json
```

## Kullanım Örnekleri

### 1. Veritabanını Yükle

```dart
import 'models/ev_pid_model.dart';

// Widget içinde (initState veya FutureBuilder)
final db = await EvPidDatabase.loadFromAssets();
print(db); // EvPidDatabase(16 vehicles)
```

### 2. Araç Listesi

```dart
for (final vehicle in db.vehicles) {
  print('${vehicle.name} — ${vehicle.parameters.length} parametre');
}
```

### 3. Araç Ara

```dart
final results = db.search('bmw');
// → [EvVehicle(BMW i3), EvVehicle(BMW i4 / iX)]
```

### 4. Belirli Aracın Parametrelerini Listele

```dart
final nissan = db.findById('nissan_leaf_renault_zoe');
for (final p in nissan!.availableParameters) {
  print('${p.name}: PID=${p.modePid}, Birim=${p.units}');
}
```

### 5. SOH Desteği Kontrolü

```dart
// Tam SOH desteği olan araçlar
final withSoh = db.vehiclesWithSoh;
print('SOH destekli: ${withSoh.map((v) => v.name).join(", ")}');

// Tek araç için
final bmwI4 = db.findById('bmw_i4_ix');
print(bmwI4!.hasSoh); // false — henüz bilinmiyor
```

### 6. FutureBuilder ile UI

```dart
FutureBuilder<EvPidDatabase>(
  future: EvPidDatabase.loadFromAssets(),
  builder: (context, snapshot) {
    if (!snapshot.hasData) return CircularProgressIndicator();
    final db = snapshot.data!;
    return ListView.builder(
      itemCount: db.vehicles.length,
      itemBuilder: (_, i) {
        final v = db.vehicles[i];
        return ListTile(
          title: Text(v.name),
          subtitle: Text(
            '${v.availableParameters.length} PID mevcut'
            '${v.hasSoh ? " · SOH ✓" : " · SOH eksik"}',
          ),
          trailing: Icon(
            v.hasSoh ? Icons.check_circle : Icons.warning,
            color: v.hasSoh ? Colors.green : Colors.orange,
          ),
        );
      },
    );
  },
)
```

### 7. Ham OBD Değerini Hesapla

```dart
// Formüle göre değer hesaplama örneği
double? calculateValue(EvParameter param, List<int> bytes) {
  // Basit değerlendirici — gerçek uygulamada math_expressions paketi kullanın
  final eq = param.equation;
  if (eq == null) return null;

  final A = bytes.isNotEmpty ? bytes[0] : 0;
  final B = bytes.length > 1 ? bytes[1] : 0;

  if (eq == 'A')                   return A.toDouble();
  if (eq == 'A-40')                return (A - 40).toDouble();
  if (eq == 'A/100')               return A / 100;
  if (eq == 'A/50')                return A / 50;
  if (eq == '(A*256+B)/10')        return (A * 256 + B) / 10;
  if (eq == '(A*256+B)/100')       return (A * 256 + B) / 100;
  return null;
}
```

## JSON Yapısı

```json
{
  "vehicles": [
    {
      "id": "nissan_leaf_renault_zoe",
      "name": "Nissan Leaf / Renault Zoe",
      "parameters": [
        {
          "name": "Battery SOH",
          "modePid": "22 015B",
          "equation": "A",
          "min": 0.0,
          "max": 100.0,
          "units": "%",
          "header": "7E4",
          "available": true
        }
      ]
    }
  ]
}
```

| Alan        | Tip      | Açıklama                                  |
|-------------|----------|-------------------------------------------|
| `id`        | String   | URL-safe araç kimliği                     |
| `name`      | String   | Tam araç adı                              |
| `modePid`   | String?  | OBD-II servis kodu + PID (null = eksik)   |
| `equation`  | String?  | Ham byte → gerçek değer dönüşüm formülü   |
| `min`       | double?  | Minimum beklenen değer                    |
| `max`       | double?  | Maksimum beklenen değer                   |
| `units`     | String?  | Birim (%, V, A, °C, kWh, …)              |
| `header`    | String?  | CAN header (7E4, 7E2, …)                  |
| `available` | bool     | PID biliniyorsa true, eksikse false       |
