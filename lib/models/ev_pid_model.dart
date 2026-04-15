import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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

  const EvParameter({
    required this.name,
    this.modePid,
    this.equation,
    this.min,
    this.max,
    this.units,
    this.header,
    required this.available,
  });

  factory EvParameter.fromJson(Map<String, dynamic> json) {
    return EvParameter(
      name:      json['name']     as String,
      modePid:   json['modePid']  as String?,
      equation:  json['equation'] as String?,
      min:       (json['min']  as num?)?.toDouble(),
      max:       (json['max']  as num?)?.toDouble(),
      units:     json['units']  as String?,
      header:    json['header'] as String?,
      available: json['available'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'name':      name,
    'modePid':   modePid,
    'equation':  equation,
    'min':       min,
    'max':       max,
    'units':     units,
    'header':    header,
    'available': available,
  };

  @override
  String toString() => 'EvParameter($name, pid=$modePid, available=$available)';
}

// ─────────────────────────────────────────────────────────────────────────────
// EvVehicle  –  bir araç ve parametreleri
// ─────────────────────────────────────────────────────────────────────────────
class EvVehicle {
  final String id;
  final String name;
  final List<EvParameter> parameters;

  const EvVehicle({
    required this.id,
    required this.name,
    required this.parameters,
  });

  factory EvVehicle.fromJson(Map<String, dynamic> json) {
    final params = (json['parameters'] as List<dynamic>)
        .map((p) => EvParameter.fromJson(p as Map<String, dynamic>))
        .toList();
    return EvVehicle(
      id:         json['id']   as String,
      name:       json['name'] as String,
      parameters: params,
    );
  }

  Map<String, dynamic> toJson() => {
    'id':         id,
    'name':       name,
    'parameters': parameters.map((p) => p.toJson()).toList(),
  };

  /// Yalnızca PID'i bilinen parametreler
  List<EvParameter> get availableParameters =>
      parameters.where((p) => p.available).toList();

  /// Battery SOH parametresi (null → henüz bilinmiyor)
  EvParameter? get batterySOH =>
      parameters.cast<EvParameter?>().firstWhere(
            (p) => p?.name == 'Battery SOH',
            orElse: () => null,
          );

  bool get hasSoh => batterySOH?.available == true;

  @override
  String toString() => 'EvVehicle($name, params=${parameters.length})';
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
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return EvPidDatabase.fromJson(json);
  }

  /// id ile araç bul (örn. 'nissan_leaf_renault_zoe')
  EvVehicle? findById(String id) =>
      vehicles.cast<EvVehicle?>().firstWhere(
            (v) => v?.id == id,
            orElse: () => null,
          );

  /// İsme göre arama (küçük/büyük harf duyarsız)
  List<EvVehicle> search(String query) {
    final q = query.toLowerCase();
    return vehicles.where((v) => v.name.toLowerCase().contains(q)).toList();
  }

  /// Tam SOH desteği olan araçlar
  List<EvVehicle> get vehiclesWithSoh =>
      vehicles.where((v) => v.hasSoh).toList();

  @override
  String toString() => 'EvPidDatabase(${vehicles.length} vehicles)';
}
