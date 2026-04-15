import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// ─────────────────────────────────────────────────────────────────────────────
// EvParameterCategory  –  parametre kategorisi
// ─────────────────────────────────────────────────────────────────────────────
enum EvParameterCategory {
  battery,
  charging,
  motor,
  thermal,
  vehicle,
  unknown;

  static EvParameterCategory fromString(String? s) {
    switch (s) {
      case 'battery':  return battery;
      case 'charging': return charging;
      case 'motor':    return motor;
      case 'thermal':  return thermal;
      case 'vehicle':  return vehicle;
      default:         return unknown;
    }
  }

  String get label {
    switch (this) {
      case battery:  return 'Batarya';
      case charging: return 'Şarj';
      case motor:    return 'Motor';
      case thermal:  return 'Termal';
      case vehicle:  return 'Araç';
      case unknown:  return 'Diğer';
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// EvParameter  –  tek bir OBD-II parametre tanımı
// ─────────────────────────────────────────────────────────────────────────────
class EvParameter {
  final String name;
  final String? modePid;
  final String? equation;
  final double? min;
  final double? max;
  final String? units;
  final String? header;
  final bool available;
  final EvParameterCategory category;
  final String description;

  const EvParameter({
    required this.name,
    this.modePid,
    this.equation,
    this.min,
    this.max,
    this.units,
    this.header,
    required this.available,
    this.category = EvParameterCategory.unknown,
    this.description = '',
  });

  factory EvParameter.fromJson(Map<String, dynamic> json) {
    return EvParameter(
      name:        json['name']        as String,
      modePid:     json['modePid']     as String?,
      equation:    json['equation']    as String?,
      min:         (json['min']  as num?)?.toDouble(),
      max:         (json['max']  as num?)?.toDouble(),
      units:       json['units']       as String?,
      header:      json['header']      as String?,
      available:   json['available']   as bool? ?? false,
      category:    EvParameterCategory.fromString(json['category'] as String?),
      description: json['description'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'name':        name,
    'modePid':     modePid,
    'equation':    equation,
    'min':         min,
    'max':         max,
    'units':       units,
    'header':      header,
    'available':   available,
    'category':    category.name,
    'description': description,
  };

  @override
  String toString() =>
      'EvParameter($name, pid=$modePid, cat=${category.name}, available=$available)';
}

// ─────────────────────────────────────────────────────────────────────────────
// EvVehicle  –  bir araç ve tüm OBD-II parametreleri
// ─────────────────────────────────────────────────────────────────────────────
class EvVehicle {
  final String id;
  final String name;
  final String manufacturer;
  final String platform;
  final double batteryCapacityKwh;
  final List<String> models;
  final List<EvParameter> parameters;

  const EvVehicle({
    required this.id,
    required this.name,
    required this.manufacturer,
    required this.platform,
    required this.batteryCapacityKwh,
    required this.models,
    required this.parameters,
  });

  factory EvVehicle.fromJson(Map<String, dynamic> json) {
    final params = (json['parameters'] as List<dynamic>)
        .map((p) => EvParameter.fromJson(p as Map<String, dynamic>))
        .toList();
    return EvVehicle(
      id:                  json['id']                   as String,
      name:                json['name']                 as String,
      manufacturer:        json['manufacturer']         as String? ?? '',
      platform:            json['platform']             as String? ?? '',
      batteryCapacityKwh:  (json['batteryCapacityKwh'] as num?)?.toDouble() ?? 0,
      models:              (json['models'] as List<dynamic>?)
                               ?.map((e) => e as String).toList() ?? [],
      parameters:          params,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':                 id,
    'name':               name,
    'manufacturer':       manufacturer,
    'platform':           platform,
    'batteryCapacityKwh': batteryCapacityKwh,
    'models':             models,
    'parameters':         parameters.map((p) => p.toJson()).toList(),
  };

  // ── Helpers ──────────────────────────────────────────────────────

  /// Yalnızca PID'i bilinen (available: true) parametreler
  List<EvParameter> get availableParameters =>
      parameters.where((p) => p.available).toList();

  /// Kategoriye göre parametreler
  List<EvParameter> byCategory(EvParameterCategory cat) =>
      parameters.where((p) => p.category == cat).toList();

  List<EvParameter> get batteryParameters  => byCategory(EvParameterCategory.battery);
  List<EvParameter> get chargingParameters => byCategory(EvParameterCategory.charging);
  List<EvParameter> get motorParameters    => byCategory(EvParameterCategory.motor);
  List<EvParameter> get thermalParameters  => byCategory(EvParameterCategory.thermal);
  List<EvParameter> get vehicleParameters  => byCategory(EvParameterCategory.vehicle);

  /// Battery SOH parametresi (null → henüz bilinmiyor)
  EvParameter? get batterySOH =>
      parameters.cast<EvParameter?>().firstWhere(
            (p) => p?.name == 'Battery SOH',
            orElse: () => null,
          );

  bool get hasSoh => batterySOH?.available == true;

  @override
  String toString() =>
      'EvVehicle($manufacturer $name [$platform], params=${parameters.length})';
}

// ─────────────────────────────────────────────────────────────────────────────
// EvPidDatabase  –  tüm veritabanı
// ─────────────────────────────────────────────────────────────────────────────
class EvPidDatabase {
  final List<EvVehicle> vehicles;

  const EvPidDatabase({required this.vehicles});

  factory EvPidDatabase.fromJson(Map<String, dynamic> json) {
    final list = (json['vehicles'] as List<dynamic>)
        .map((v) => EvVehicle.fromJson(v as Map<String, dynamic>))
        .toList();
    return EvPidDatabase(vehicles: list);
  }

  /// Flutter asset'ten yükle:
  ///   final db = await EvPidDatabase.loadFromAssets();
  static Future<EvPidDatabase> loadFromAssets({
    String assetPath = 'assets/ev_pids.json',
  }) async {
    final raw  = await rootBundle.loadString(assetPath);
    final data = jsonDecode(raw) as Map<String, dynamic>;
    return EvPidDatabase.fromJson(data);
  }

  // ── Lookup & Filter ──────────────────────────────────────────────

  /// ID ile araç bul (örn. 'nissan_leaf_ze0')
  EvVehicle? findById(String id) =>
      vehicles.cast<EvVehicle?>().firstWhere(
            (v) => v?.id == id,
            orElse: () => null,
          );

  /// İsim, marka veya platform ile arama (büyük/küçük harf duyarsız)
  List<EvVehicle> search(String query) {
    final q = query.toLowerCase();
    return vehicles.where((v) =>
      v.name.toLowerCase().contains(q) ||
      v.manufacturer.toLowerCase().contains(q) ||
      v.platform.toLowerCase().contains(q) ||
      v.models.any((m) => m.toLowerCase().contains(q))
    ).toList();
  }

  /// Markaya göre araçlar (örn. 'BMW', 'Tesla')
  List<EvVehicle> byManufacturer(String manufacturer) {
    final q = manufacturer.toLowerCase();
    return vehicles
        .where((v) => v.manufacturer.toLowerCase() == q)
        .toList();
  }

  /// Platforma göre araçlar (örn. 'E-GMP', 'MEB')
  List<EvVehicle> byPlatform(String platform) {
    final q = platform.toLowerCase();
    return vehicles
        .where((v) => v.platform.toLowerCase().contains(q))
        .toList();
  }

  /// Tam SOH desteği olan araçlar
  List<EvVehicle> get vehiclesWithSoh =>
      vehicles.where((v) => v.hasSoh).toList();

  /// Tüm markalar (unique, sıralı)
  List<String> get manufacturers =>
      vehicles.map((v) => v.manufacturer).toSet().toList()..sort();

  /// Tüm platformlar (unique, sıralı)
  List<String> get platforms =>
      vehicles.map((v) => v.platform).toSet().toList()..sort();

  // ── Stats ────────────────────────────────────────────────────────

  int get totalParameters =>
      vehicles.fold(0, (sum, v) => sum + v.parameters.length);

  int get availableParameters =>
      vehicles.fold(0, (sum, v) => sum + v.availableParameters.length);

  @override
  String toString() =>
      'EvPidDatabase(${vehicles.length} vehicles, '
      '${manufacturers.length} brands, '
      '$totalParameters params)';
}
