/// PID türleri enum - Genişletilmiş PID desteği
enum PIDType {
  // ===== STANDART OBD-II PID'LERİ =====
  engineRpm('01', '0C', '((A*256)+B)/4', 'Engine RPM'),
  vehicleSpeed('01', '0D', 'A', 'Vehicle Speed'),
  throttlePosition('01', '11', 'A*100/255', 'Throttle Position'),
  engineLoad('01', '04', 'A*100/255', 'Engine Load'),
  coolantTemp('01', '05', 'A-40', 'Coolant Temperature'),
  intakeTemp('01', '0F', 'A-40', 'Intake Air Temperature'),

  // ===== YAKIT TÜKETİMİ PID'LERİ (YENİ!) =====
  fuelRate('01', '5E', '(A*256+B)*0.05', 'Fuel Rate L/h'),
  maf('01', '10', '((A*256)+B)/100', 'Mass Air Flow g/s'),
  fuelPressure('01', '0A', 'A*3', 'Fuel Pressure kPa'),
  fuelLevel('01', '2F', 'A*100/255', 'Fuel Level %'),

  // ===== EV BATARYA PID'LERİ =====
  batterySoc('22', '015C', 'A', 'Battery State of Charge'),
  batteryVoltage('22', '015D', '(A*256+B)/100', 'Battery Voltage'),
  batteryCurrent('22', '015E', '(A*256+B)/10', 'Battery Current'),
  batteryTemp('22', '015F', 'A-40', 'Battery Temperature'),

  // ===== REJENERATİF FREN PID'LERİ (YENİ!) =====
  regenPower('22', '0180', '(A*256+B)/10', 'Regenerative Power kW'),
  regenCurrent('22', '0181', '(A*256+B)/10', 'Regen Current A'),
  regenEnergyTotal('22', '0182', '(A*256+B)/100', 'Total Regen Energy kWh'),
  motorTorque('22', '0183', '(A*256+B)-32768', 'Motor Torque Nm'),

  // ===== MARKA-SPESİFİK REGEN PID'LERİ =====
  regenNissan('22', '0190', 'A', 'Nissan Regen Level'),
  regenHyundai('22', '0175', '(A*256+B)/10', 'Hyundai Regen Power'),
  regenBmw('22', '2A40', '(A*256+B)/10', 'BMW Regen Power'),
  regenTesla('22', '118B', '(A*256+B)/10', 'Tesla Regen Power'),

  // ===== ARAÇ BİLGİSİ PID'LERİ (YENİ!) =====
  vin('09', '02', 'ASCII', 'Vehicle Identification Number'),
  ecuName('09', '0A', 'ASCII', 'ECU Name');

  final String mode;
  final String pid;
  final String equation;
  final String description;

  const PIDType(this.mode, this.pid, this.equation, this.description);

  String getFullCommand({String header = '7DF'}) {
    return '$mode$pid';
  }
}
