# EVP-D — EV Parametre Database

OBD-II / UDS PID tanımları için veri tabanı. Elektrikli araç BMS (Battery
Management System) parametrelerini marka bazında tutar.

## Klasör yapısı

```
.
├── ev_unified_professional.csv   # Kaynak: tek dosyada tüm markalar
├── brands/                       # Marka başına ayrılmış CSV'ler
│   ├── nissan-leaf-renault-zoe.csv
│   ├── hyundai-kia-kona-ioniq-niro-ev6.csv
│   ├── psa-peugeot-opel-citron.csv
│   ├── bmw-i3.csv
│   ├── bmw-i4-ix.csv
│   ├── mercedes-eq-eqa-eqb-eqe-eqs.csv
│   ├── audi-e-tron-q4-q8-gt.csv
│   ├── volvo-recharge-ex30-c40-xc40.csv
│   ├── porsche-taycan.csv
│   ├── byd-atto-3-dolphin-seal.csv
│   ├── mg-zs-ev-mg4.csv
│   ├── tesla-model-s-3-x-y.csv
│   ├── togg-t10x.csv
│   ├── honda-e.csv
│   ├── toyota-bz4x.csv
│   └── mini-cooper-se.csv
├── scripts/
│   └── split_by_brand.py         # Unified CSV'yi marka dosyalarına böler
└── docs/
    └── SCHEMA.md                 # Kolon tanımları ve örnekler
```

## CSV şeması

Tüm dosyalar `;` ayıraçlı ve aynı başlığı kullanır:

| Kolon      | Açıklama                                   |
|------------|--------------------------------------------|
| `Name`     | Parametre adı (örn. `Battery SOC`)         |
| `Mode/PID` | OBD-II Mode + PID (örn. `22 015C`)         |
| `Equation` | Ham baytlardan mühendislik birimine çevirme|
| `Min`      | Geçerli değer aralığının alt sınırı        |
| `Max`      | Geçerli değer aralığının üst sınırı        |
| `Units`    | Birim (`V`, `A`, `°C`, `%`, `kWh`, ...)    |
| `Header`   | CAN istek başlığı (örn. `7E4`)             |

Bazı satırlarda `Battery SOH` için alanlar boş bırakılmıştır — o model için
PID henüz doğrulanmamıştır.

## Marka dosyalarını yeniden üretme

`ev_unified_professional.csv` güncellenirse `brands/` klasörü şu komutla
yeniden üretilebilir:

```bash
python3 scripts/split_by_brand.py
```

Script, `=== Marka Adı ===` bölüm başlıklarını tarayarak her bölümü ayrı bir
CSV'ye yazar. Mevcut marka dosyalarının üzerine yazılır.

## Kapsam

16 EV ailesi, 105 parametre satırı. Ortak parametreler (SOC, Voltage, Current,
Temp, Cell Delta) tüm modellerde mevcut; marka spesifik parametreler (örn. BMW
i3 `Usable Capacity`, Hyundai/Kia `DC Charge Power`) yalnızca ilgili dosyada
bulunur.
