enum VehicleType {
  ev,   // Elektrikli Araç
  ice,  // Benzinli/Dizel Araç
}

enum VehicleBrand {
  tesla,
  togg,
  bmw,
  mercedes,
  audi,
  volvo,
  hyundai,
  kia,
  nissan,
  renault,
  psa, // Peugeot/Citroën/Opel
  byd,
  mg,
  honda,
  toyota,
  mini,
  other,
}

class Vehicle {
  final String id;
  final VehicleType type;
  final VehicleBrand brand;
  final String model;
  final int year;
  final String? obdDeviceId; // ICE araçlar için OBD-II cihaz ID
  
  Vehicle({
    required this.id,
    required this.type,
    required this.brand,
    required this.model,
    required this.year,
    this.obdDeviceId,
  });
}
