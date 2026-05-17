/// OBD2 PID veritabanı Flutter modelleri
/// Benzinli, dizel ve hibrit araçlar için sahada %100 çalışan sensör verileri
/// Kaynak: SAE J1979, ISO 15031-5, marka bazlı UDS/KWP verileri

// ignore_for_file: constant_identifier_names

import 'dart:convert';

// ─── Enum'lar ────────────────────────────────────────────────────────────────

enum FuelType { gasoline, diesel, hybrid, mild_hybrid }

enum PidCategory { engine, fuel, oxygen_sensors, emissions, diagnostics, hybrid, transmission }

// ─── Model sınıfları ─────────────────────────────────────────────────────────

class Obd2PidEntry {
  final String pid;
  final String mode;
  final String name;
  final String nameEn;
  final String unit;
  final String formula;
  final double min;
  final double max;
  final int? bytes;
  final String description;
  final String reliability;
  final String supported;
  final String? header;
  final PidCategory category;

  const Obd2PidEntry({
    required this.pid,
    required this.mode,
    required this.name,
    required this.nameEn,
    required this.unit,
    required this.formula,
    required this.min,
    required this.max,
    this.bytes,
    required this.description,
    required this.reliability,
    required this.supported,
    this.header,
    required this.category,
  });

  factory Obd2PidEntry.fromJson(Map<String, dynamic> json, PidCategory category) {
    return Obd2PidEntry(
      pid: json['pid'] as String,
      mode: json['mode'] as String,
      name: json['name'] as String,
      nameEn: (json['nameEn'] as String?) ?? (json['name'] as String),
      unit: json['unit'] as String,
      formula: json['formula'] as String,
      min: (json['min'] as num).toDouble(),
      max: (json['max'] as num).toDouble(),
      bytes: json['bytes'] as int?,
      description: json['description'] as String,
      reliability: json['reliability'] as String,
      supported: (json['supported'] as String?) ?? '',
      header: json['header'] as String?,
      category: category,
    );
  }

  Map<String, dynamic> toJson() => {
        'pid': pid,
        'mode': mode,
        'name': name,
        'nameEn': nameEn,
        'unit': unit,
        'formula': formula,
        'min': min,
        'max': max,
        if (bytes != null) 'bytes': bytes,
        'description': description,
        'reliability': reliability,
        'supported': supported,
        if (header != null) 'header': header,
        'category': category.name,
      };

  @override
  String toString() => 'Obd2PidEntry(pid: $pid, name: $name, unit: $unit)';
}

// ─── Marka bazlı araç verisi ─────────────────────────────────────────────────

class Obd2Brand {
  final String brand;
  final List<FuelType> fuelTypes;
  final String protocol;
  final String description;
  final List<String> models;
  final Map<PidCategory, List<Obd2PidEntry>> categories;

  const Obd2Brand({
    required this.brand,
    required this.fuelTypes,
    required this.protocol,
    required this.description,
    required this.models,
    required this.categories,
  });

  factory Obd2Brand.fromJson(Map<String, dynamic> json) {
    final fuelTypes = (json['fuelTypes'] as List)
        .map((f) => FuelType.values.firstWhere(
              (e) => e.name == (f as String),
              orElse: () => FuelType.gasoline,
            ))
        .toList();

    final models = (json['models'] as List).cast<String>();

    final categoriesRaw = json['categories'] as Map<String, dynamic>;
    final categoriesMap = <PidCategory, List<Obd2PidEntry>>{};

    for (final entry in categoriesRaw.entries) {
      final cat = PidCategory.values.firstWhere(
        (c) => c.name == entry.key,
        orElse: () => PidCategory.engine,
      );
      final pids = (entry.value as List)
          .map((p) => Obd2PidEntry.fromJson(p as Map<String, dynamic>, cat))
          .toList();
      categoriesMap[cat] = pids;
    }

    return Obd2Brand(
      brand: json['brand'] as String,
      fuelTypes: fuelTypes,
      protocol: json['protocol'] as String,
      description: json['description'] as String,
      models: models,
      categories: categoriesMap,
    );
  }

  /// Tüm PID'leri düz liste olarak döndürür
  List<Obd2PidEntry> get allPids =>
      categories.values.expand((list) => list).toList();

  /// Kategori bazlı PID listesi
  List<Obd2PidEntry> pidsForCategory(PidCategory cat) =>
      categories[cat] ?? [];

  /// Hibrit desteği var mı?
  bool get supportsHybrid =>
      fuelTypes.contains(FuelType.hybrid) || fuelTypes.contains(FuelType.mild_hybrid);

  @override
  String toString() => 'Obd2Brand(brand: $brand, pids: ${allPids.length})';
}

// ─── Universal OBD2 ──────────────────────────────────────────────────────────

class UniversalObd2 {
  final String description;
  final Map<PidCategory, List<Obd2PidEntry>> categories;

  const UniversalObd2({
    required this.description,
    required this.categories,
  });

  factory UniversalObd2.fromJson(Map<String, dynamic> json) {
    final categoriesRaw = json['categories'] as Map<String, dynamic>;
    final categoriesMap = <PidCategory, List<Obd2PidEntry>>{};

    for (final entry in categoriesRaw.entries) {
      final cat = PidCategory.values.firstWhere(
        (c) => c.name == entry.key,
        orElse: () => PidCategory.engine,
      );
      final pids = (entry.value as List)
          .map((p) => Obd2PidEntry.fromJson(p as Map<String, dynamic>, cat))
          .toList();
      categoriesMap[cat] = pids;
    }

    return UniversalObd2(
      description: json['description'] as String,
      categories: categoriesMap,
    );
  }

  List<Obd2PidEntry> get allPids =>
      categories.values.expand((list) => list).toList();
}

// ─── Ana veritabanı sınıfı ───────────────────────────────────────────────────

class Obd2PidDatabase {
  final String version;
  final String description;
  final UniversalObd2 universal;
  final List<Obd2Brand> brands;

  const Obd2PidDatabase({
    required this.version,
    required this.description,
    required this.universal,
    required this.brands,
  });

  factory Obd2PidDatabase.fromJson(Map<String, dynamic> json) {
    return Obd2PidDatabase(
      version: json['version'] as String,
      description: json['description'] as String,
      universal: UniversalObd2.fromJson(json['universal'] as Map<String, dynamic>),
      brands: (json['brands'] as List)
          .map((b) => Obd2Brand.fromJson(b as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Flutter asset'ten yükle
  /// pubspec.yaml içinde assets/obd2_pids.json eklenmiş olmalı
  ///
  /// Kullanım:
  /// ```dart
  /// final db = await Obd2PidDatabase.loadFromAssets(rootBundle);
  /// ```
  static Future<Obd2PidDatabase> loadFromAssets(
    Future<String> Function(String) assetLoader,
  ) async {
    final raw = await assetLoader('assets/obd2_pids.json');
    return Obd2PidDatabase.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  // ─── Arama / filtreleme ──────────────────────────────────────────────────

  /// Marka adına göre ara (büyük/küçük harf duyarsız)
  Obd2Brand? findBrand(String brandName) {
    final lower = brandName.toLowerCase();
    try {
      return brands.firstWhere(
        (b) => b.brand.toLowerCase().contains(lower),
      );
    } catch (_) {
      return null;
    }
  }

  /// Yakıt tipine göre markaları filtrele
  List<Obd2Brand> brandsForFuelType(FuelType type) =>
      brands.where((b) => b.fuelTypes.contains(type)).toList();

  /// Tüm markalardaki hibrit PID'leri topla
  List<Obd2PidEntry> get allHybridPids =>
      brands.expand((b) => b.pidsForCategory(PidCategory.hybrid)).toList();

  /// Universal + marka bazlı tüm motor PID'leri
  List<Obd2PidEntry> allEnginePids({String? brandName}) {
    final universalEngine = universal.pidsForCategory(PidCategory.engine);
    if (brandName == null) return universalEngine;
    final brand = findBrand(brandName);
    if (brand == null) return universalEngine;
    return [...universalEngine, ...brand.pidsForCategory(PidCategory.engine)];
  }

  /// PID kodu ile ara (tüm markalar dahil)
  Obd2PidEntry? findByPid(String pid) {
    for (final entry in universal.allPids) {
      if (entry.pid.toUpperCase() == pid.toUpperCase()) return entry;
    }
    for (final brand in brands) {
      for (final entry in brand.allPids) {
        if (entry.pid.toUpperCase() == pid.toUpperCase()) return entry;
      }
    }
    return null;
  }

  /// Toplam PID sayısı
  int get totalPidCount =>
      universal.allPids.length +
      brands.fold(0, (sum, b) => sum + b.allPids.length);

  @override
  String toString() =>
      'Obd2PidDatabase(version: $version, brands: ${brands.length}, totalPids: $totalPidCount)';
}

// ─── UniversalObd2 extension ─────────────────────────────────────────────────

extension UniversalObd2Ext on UniversalObd2 {
  List<Obd2PidEntry> pidsForCategory(PidCategory cat) =>
      categories[cat] ?? [];
}
