# CSV Şeması

Tüm CSV dosyaları (`ev_unified_professional.csv` ve `brands/*.csv`) aynı
kolon düzenini paylaşır. Ayıraç `;` (noktalı virgül), karakter kodlaması
UTF-8'dir.

## Kolonlar

### `Name`
İnsan tarafından okunabilir parametre adı. Örnekler:

- `Battery SOC` — State of Charge
- `Battery SOH` — State of Health
- `Battery Voltage`
- `Cell Voltage Delta`
- `DC Charge Power`

### `Mode/PID`
İki oktet: OBD-II mode ve PID. Boşlukla ayrılır.

- `22 015C` — Mode `0x22` (ReadDataByIdentifier), PID `0x015C`
- `22 F40D` — PSA özel SOH PID'i

Mode `22` UDS `ReadDataByIdentifier` servisidir. ISO 15765-3 üzerinden
çalışan tüm modern EV'ler bu servisi destekler.

### `Equation`
Ham cevap baytlarından değeri üretmek için matematiksel formül. Bayt
değişkenleri sırasıyla `A`, `B`, `C`, `D` olarak adlandırılır.

| Formül             | Anlamı                                 |
|--------------------|----------------------------------------|
| `A`                | Tek bayt direkt değer                  |
| `A-40`             | Offset uygulanmış sıcaklık             |
| `(A*256+B)/100`    | 16-bit word, 0.01 ölçekli              |
| `(A*256+B)/10`     | 16-bit word, 0.1 ölçekli               |
| `A/50`             | Hücre voltajı (2.5-4.2 V aralığı)      |
| `A/100`            | Hücre delta voltajı                    |

### `Min` / `Max`
Parametrenin fiziksel olarak geçerli aralığı. Ölçüm bu aralığın dışındaysa
muhtemelen ECU yanıtı yanlış yorumlanmıştır.

### `Units`
SI veya yaygın kullanılan birim: `V`, `A`, `°C`, `%`, `kWh`, `kW`, `Count`.

### `Header`
CAN bus üzerinde kullanılacak istek header'ı (11-bit CAN ID).

- `7E4` — Hibrit/EV batarya ECU (çoğu marka)
- `7E2` — Motor veya diğer ECU (örn. Honda e)

Cevap header'ı tipik olarak `7EC` / `7EA` (istek + 8) olur.

## Eksik veriler

Bazı modeller için `Battery SOH` satırı boştur:

```
Battery SOH;;;;;%;
```

Bu, o model için resmi PID'in henüz doğrulanmadığını gösterir. Kolon
yapısı değişmez — sadece değer alanları boştur.

## Bölüm başlıkları (yalnızca unified dosyada)

`ev_unified_professional.csv` dosyasında markaları ayırmak için şu formatta
satırlar bulunur:

```
=== Marka Adı ===;;;;;;
```

`brands/*.csv` dosyalarında bu başlıklar bulunmaz; marka bilgisi dosya
adından alınır.
