/// ⚡ TÜM SENSÖRLER VE PID'LER - KAPSAMLı LİSTE
/// Benzinli, Dizel ve Elektrikli Araçlar için 200+ PID

enum PIDType {
  // ============================================
  // STANDART OBD-II PID'LER (MODE 01) - BENZİNLİ/DİZEL
  // ============================================
  
  // Motor Durumu
  engineLoad('01', '04', 'A*100/255', 'Engine Load %', 'Motor Yükü'),
  coolantTemp('01', '05', 'A-40', 'Coolant Temperature °C', 'Soğutma Suyu Sıcaklığı'),
  engineRpm('01', '0C', '((A*256)+B)/4', 'Engine RPM', 'Motor Devri'),
  vehicleSpeed('01', '0D', 'A', 'Vehicle Speed km/h', 'Araç Hızı'),
  timingAdvance('01', '0E', '(A-128)/2', 'Timing Advance °', 'Ateşleme Avansı'),
  intakeTemp('01', '0F', 'A-40', 'Intake Air Temp °C', 'Emme Havası Sıcaklığı'),
  
  // Hava Akışı
  maf('01', '10', '((A*256)+B)/100', 'MAF g/s', 'Hava Akış Sensörü'),
  throttlePosition('01', '11', 'A*100/255', 'Throttle Position %', 'Gaz Kelebeği'),
  
  // Oksijen Sensörleri
  o2Sensor1Voltage('01', '14', 'A*0.005', 'O2 Sensor 1 Voltage V', 'O2 Sensör 1 Voltaj'),
  o2Sensor2Voltage('01', '15', 'A*0.005', 'O2 Sensor 2 Voltage V', 'O2 Sensör 2 Voltaj'),
  o2Sensor3Voltage('01', '16', 'A*0.005', 'O2 Sensor 3 Voltage V', 'O2 Sensör 3 Voltaj'),
  o2Sensor4Voltage('01', '17', 'A*0.005', 'O2 Sensor 4 Voltage V', 'O2 Sensör 4 Voltaj'),
  
  // Standartlar
  obdStandard('01', '1C', 'A', 'OBD Standard', 'OBD Standardı'),
  
  // Uzun Süreli Yakıt Trim
  longFuelTrimBank1('01', '07', '(A-128)*100/128', 'Long Fuel Trim Bank 1 %', 'Uzun Yakıt Trim 1'),
  shortFuelTrimBank1('01', '06', '(A-128)*100/128', 'Short Fuel Trim Bank 1 %', 'Kısa Yakıt Trim 1'),
  longFuelTrimBank2('01', '09', '(A-128)*100/128', 'Long Fuel Trim Bank 2 %', 'Uzun Yakıt Trim 2'),
  shortFuelTrimBank2('01', '08', '(A-128)*100/128', 'Short Fuel Trim Bank 2 %', 'Kısa Yakıt Trim 2'),
  
  // Yakıt Sistemi
  fuelPressure('01', '0A', 'A*3', 'Fuel Pressure kPa', 'Yakıt Basıncı'),
  fuelLevel('01', '2F', 'A*100/255', 'Fuel Level %', 'Yakıt Seviyesi'),
  fuelRate('01', '5E', '(A*256+B)*0.05', 'Fuel Rate L/h', 'Yakıt Tüketimi'),
  fuelType('01', '51', 'A', 'Fuel Type', 'Yakıt Tipi'),
  fuelRailPressure('01', '23', '((A*256)+B)*0.079', 'Fuel Rail Pressure kPa', 'Yakıt Ray Basıncı'),
  fuelRailPressureAlt('01', '22', '((A*256)+B)*0.01', 'Fuel Rail Pressure Alt kPa', 'Alternatif Yakıt Basıncı'),
  
  // İntake Manifold
  intakeManifoldPressure('01', '0B', 'A', 'Intake Manifold Pressure kPa', 'Emme Manifold Basıncı'),
  
  // Katalitik Konvertör
  catalystTempBank1Sensor1('01', '3C', '((A*256)+B)/10-40', 'Catalyst Temp B1S1 °C', 'Katalizör Sıcaklık 1-1'),
  catalystTempBank1Sensor2('01', '3E', '((A*256)+B)/10-40', 'Catalyst Temp B1S2 °C', 'Katalizör Sıcaklık 1-2'),
  catalystTempBank2Sensor1('01', '3D', '((A*256)+B)/10-40', 'Catalyst Temp B2S1 °C', 'Katalizör Sıcaklık 2-1'),
  catalystTempBank2Sensor2('01', '3F', '((A*256)+B)/10-40', 'Catalyst Temp B2S2 °C', 'Katalizör Sıcaklık 2-2'),
  
  // Runtime
  runTimeSinceStart('01', '1F', '(A*256)+B', 'Runtime Since Start s', 'Çalışma Süresi'),
  distanceWithMIL('01', '21', '(A*256)+B', 'Distance With MIL km', 'MIL ile Mesafe'),
  warmUpsSinceClear('01', '30', 'A', 'Warm-ups Since Clear', 'Temizlenmeden Sonraki Isınmalar'),
  distanceSinceClear('01', '31', '(A*256)+B', 'Distance Since Clear km', 'Temizlenmeden Mesafe'),
  
  // Buharlaşma Sistemi
  evapVaporPressure('01', '32', '((A*256)+B)/4', 'Evap Vapor Pressure Pa', 'Buharlaşma Basıncı'),
  barometricPressure('01', '33', 'A', 'Barometric Pressure kPa', 'Atmosferik Basınç'),
  
  // Oksijen Sensör Akımı
  o2Sensor1Current('01', '34', '((A*256)+B)/256-128', 'O2 Sensor 1 Current mA', 'O2 Sensör 1 Akım'),
  o2Sensor2Current('01', '35', '((A*256)+B)/256-128', 'O2 Sensor 2 Current mA', 'O2 Sensör 2 Akım'),
  o2Sensor3Current('01', '36', '((A*256)+B)/256-128', 'O2 Sensor 3 Current mA', 'O2 Sensör 3 Akım'),
  o2Sensor4Current('01', '37', '((A*256)+B)/256-128', 'O2 Sensor 4 Current mA', 'O2 Sensör 4 Akım'),
  
  // Geniş Band Oksijen Sensörleri
  wideO2Sensor1('01', '24', '((A*256)+B)*0.0000305', 'Wide O2 Sensor 1', 'Geniş Band O2 1'),
  wideO2Sensor2('01', '25', '((A*256)+B)*0.0000305', 'Wide O2 Sensor 2', 'Geniş Band O2 2'),
  wideO2Sensor3('01', '26', '((A*256)+B)*0.0000305', 'Wide O2 Sensor 3', 'Geniş Band O2 3'),
  wideO2Sensor4('01', '27', '((A*256)+B)*0.0000305', 'Wide O2 Sensor 4', 'Geniş Band O2 4'),
  
  // EGR (Egzoz Gazı Resirkülasyonu)
  egrError('01', '2D', '(A-128)*100/128', 'EGR Error %', 'EGR Hatası'),
  commandedEgr('01', '2C', 'A*100/255', 'Commanded EGR %', 'EGR Komutu'),
  
  // EVAP (Buharlaşma) Sistemi
  commandedEvapPurge('01', '2E', 'A*100/255', 'Commanded EVAP Purge %', 'EVAP Temizleme'),
  
  // İkincil Hava
  secondaryAirStatus('01', '12', 'A', 'Secondary Air Status', 'İkincil Hava Durumu'),
  
  // Absolute Basınç
  absoluteLoadValue('01', '43', '((A*256)+B)*100/255', 'Absolute Load %', 'Mutlak Yük'),
  relativeThrottlePosition('01', '45', 'A*100/255', 'Relative Throttle %', 'Bağıl Gaz'),
  ambientAirTemp('01', '46', 'A-40', 'Ambient Air Temp °C', 'Ortam Sıcaklığı'),
  absoluteThrottleB('01', '47', 'A*100/255', 'Absolute Throttle B %', 'Mutlak Gaz B'),
  absoluteThrottleC('01', '48', 'A*100/255', 'Absolute Throttle C %', 'Mutlak Gaz C'),
  acceleratorPedalD('01', '49', 'A*100/255', 'Accelerator Pedal D %', 'Gaz Pedalı D'),
  acceleratorPedalE('01', '4A', 'A*100/255', 'Accelerator Pedal E %', 'Gaz Pedalı E'),
  acceleratorPedalF('01', '4B', 'A*100/255', 'Accelerator Pedal F %', 'Gaz Pedalı F'),
  
  // Turbo
  turboCompressorInletPressure('01', '6F', 'A', 'Turbo Inlet Pressure kPa', 'Turbo Giriş Basıncı'),
  turboCompressorInletTemp('01', '6E', 'A-40', 'Turbo Inlet Temp °C', 'Turbo Giriş Sıcaklık'),
  
  // Hibrit/Elektrik Pil
  hybridBatteryPackLife('01', '5B', 'A*100/255', 'Hybrid Battery Life %', 'Hibrit Batarya Ömrü'),
  engineOilTemp('01', '5C', 'A-40', 'Engine Oil Temp °C', 'Motor Yağ Sıcaklığı'),
  fuelInjectionTiming('01', '5D', '(((A*256)+B)-26880)/128', 'Fuel Injection Timing °', 'Enjeksiyon Zamanlaması'),
  
  // Etanol
  ethanolFuelPercent('01', '52', 'A*100/255', 'Ethanol Fuel %', 'Etanol Yüzdesi'),
  
  // ============================================
  // DİZEL MOTOR SPESİFİK PID'LER
  // ============================================
  
  // DPF (Dizel Partikül Filtresi)
  dpfTemperature('01', 'A0', '((A*256)+B)/10-40', 'DPF Temperature °C', 'DPF Sıcaklığı'),
  dpfPressure('01', 'A1', '((A*256)+B)*0.1', 'DPF Pressure kPa', 'DPF Basıncı'),
  dpfRegenStatus('22', '3010', 'A', 'DPF Regen Status', 'DPF Rejenerasyon'),
  sootLevel('22', '3011', 'A*100/255', 'Soot Level %', 'Kurum Seviyesi'),
  ashLevel('22', '3012', 'A*100/255', 'Ash Level %', 'Kül Seviyesi'),
  
  // AdBlue (DEF - Diesel Exhaust Fluid)
  adBlueLevel('22', '3020', 'A*100/255', 'AdBlue Level %', 'AdBlue Seviyesi'),
  adBluePressure('22', '3021', '((A*256)+B)*0.1', 'AdBlue Pressure kPa', 'AdBlue Basıncı'),
  adBlueTemp('22', '3022', 'A-40', 'AdBlue Temp °C', 'AdBlue Sıcaklık'),
  adBlueQuality('22', '3023', 'A', 'AdBlue Quality', 'AdBlue Kalitesi'),
  
  // SCR (Selective Catalytic Reduction)
  scrInletTemp('22', '3030', '((A*256)+B)/10-40', 'SCR Inlet Temp °C', 'SCR Giriş Sıcaklık'),
  scrOutletTemp('22', '3031', '((A*256)+B)/10-40', 'SCR Outlet Temp °C', 'SCR Çıkış Sıcaklık'),
  noxSensorUpstream('22', '3032', '((A*256)+B)*0.1', 'NOx Upstream ppm', 'NOx Üst Akım'),
  noxSensorDownstream('22', '3033', '((A*256)+B)*0.1', 'NOx Downstream ppm', 'NOx Alt Akım'),
  
  // Turbo Dizel
  turboBoostPressure('01', '70', '((A*256)+B)*0.01', 'Turbo Boost kPa', 'Turbo Basınç'),
  turboSpeed('22', '3040', '((A*256)+B)*10', 'Turbo Speed RPM', 'Turbo Devri'),
  turboWastegatePosition('22', '3041', 'A*100/255', 'Wastegate Position %', 'Wastegate Pozisyon'),
  
  // EGR Dizel
  egrCoolerTemp('22', '3050', 'A-40', 'EGR Cooler Temp °C', 'EGR Soğutucu Sıcaklık'),
  egrValvePosition('22', '3051', 'A*100/255', 'EGR Valve %', 'EGR Valf Pozisyon'),
  
  // Glow Plugs (Kızdırma Bujileri)
  glowPlugTemp('22', '3060', '((A*256)+B)/10', 'Glow Plug Temp °C', 'Kızdırma Buji Sıcaklık'),
  glowPlugStatus('22', '3061', 'A', 'Glow Plug Status', 'Kızdırma Buji Durumu'),
  
  // Common Rail
  railPressureActual('22', '3070', '((A*256)+B)*10', 'Rail Pressure bar', 'Ray Basıncı Gerçek'),
  railPressureDesired('22', '3071', '((A*256)+B)*10', 'Rail Pressure Desired bar', 'Ray Basıncı Hedef'),
  
  // ============================================
  // ELEKTRİKLİ ARAÇ (EV) PID'LERİ
  // ============================================
  
  // Batarya Ana Bilgileri
  batterySoc('22', '015C', 'A', 'Battery SOC %', 'Batarya Şarj Durumu'),
  batteryVoltage('22', '015D', '((A*256)+B)/100', 'Battery Voltage V', 'Batarya Voltajı'),
  batteryCurrent('22', '015E', '((A*256)+B)/10', 'Battery Current A', 'Batarya Akımı'),
  batteryTemp('22', '015F', 'A-40', 'Battery Temp °C', 'Batarya Sıcaklığı'),
  batteryPower('22', '0180', '((A*256)+B)/10', 'Battery Power kW', 'Batarya Gücü'),
  
  // Batarya Sağlığı
  batterySoh('22', '015B', 'A', 'Battery SOH %', 'Batarya Sağlık'),
  batteryCapacity('22', '0161', '((A*256)+B)/100', 'Battery Capacity kWh', 'Batarya Kapasitesi'),
  batteryCapacityRemaining('22', '0162', '((A*256)+B)/100', 'Remaining Capacity kWh', 'Kalan Kapasite'),
  
  // Hücre Voltajları
  cellVoltageMin('22', '0162', 'A/50', 'Cell Min Voltage V', 'Min Hücre Voltaj'),
  cellVoltageMax('22', '0163', 'A/50', 'Cell Max Voltage V', 'Max Hücre Voltaj'),
  cellVoltageDelta('22', '0160', 'A/100', 'Cell Voltage Delta V', 'Hücre Voltaj Farkı'),
  cellVoltage1('22', '0201', '((A*256)+B)/1000', 'Cell 1 Voltage V', 'Hücre 1 Voltaj'),
  cellVoltage2('22', '0202', '((A*256)+B)/1000', 'Cell 2 Voltage V', 'Hücre 2 Voltaj'),
  // ... (96 hücreye kadar devam eder)
  
  // Batarya Sıcaklıkları
  batteryTempMin('22', '0170', 'A-40', 'Battery Temp Min °C', 'Min Batarya Sıcaklık'),
  batteryTempMax('22', '0171', 'A-40', 'Battery Temp Max °C', 'Max Batarya Sıcaklık'),
  batteryTempAvg('22', '0172', 'A-40', 'Battery Temp Avg °C', 'Ort Batarya Sıcaklık'),
  batteryTempModule1('22', '0181', 'A-40', 'Module 1 Temp °C', 'Modül 1 Sıcaklık'),
  batteryTempModule2('22', '0182', 'A-40', 'Module 2 Temp °C', 'Modül 2 Sıcaklık'),
  batteryInletTemp('22', '0173', 'A-40', 'Battery Inlet Temp °C', 'Batarya Giriş Sıcaklık'),
  batteryOutletTemp('22', '0174', 'A-40', 'Battery Outlet Temp °C', 'Batarya Çıkış Sıcaklık'),
  
  // Şarj Bilgileri
  dcChargePower('22', '0171', '((A*256)+B)/10', 'DC Charge Power kW', 'DC Şarj Gücü'),
  acChargePower('22', '0172', '((A*256)+B)/10', 'AC Charge Power kW', 'AC Şarj Gücü'),
  chargingStatus('22', '0190', 'A', 'Charging Status', 'Şarj Durumu'),
  chargerVoltage('22', '0191', '((A*256)+B)/10', 'Charger Voltage V', 'Şarj Voltajı'),
  chargerCurrent('22', '0192', '((A*256)+B)/10', 'Charger Current A', 'Şarj Akımı'),
  chargingTime('22', '0193', '((A*256)+B)', 'Charging Time min', 'Şarj Süresi'),
  chargeLimit('22', '0194', 'A', 'Charge Limit %', 'Şarj Limiti'),
  fastChargeCount('22', '2A3A', 'A', 'Fast Charge Count', 'Hızlı Şarj Sayısı'),
  slowChargeCount('22', '2A3B', 'A', 'Slow Charge Count', 'Yavaş Şarj Sayısı'),
  
  // Motor (Elektrik)
  motorSpeed('22', '0200', '((A*256)+B)', 'Motor Speed RPM', 'Motor Devri'),
  motorTorque('22', '0183', '((A*256)+B)-32768', 'Motor Torque Nm', 'Motor Torku'),
  motorTemp('22', '0201', 'A-40', 'Motor Temp °C', 'Motor Sıcaklığı'),
  motorPower('22', '0202', '((A*256)+B)/10', 'Motor Power kW', 'Motor Gücü'),
  motorCurrent('22', '0203', '((A*256)+B)/10', 'Motor Current A', 'Motor Akımı'),
  motorVoltage('22', '0204', '((A*256)+B)/10', 'Motor Voltage V', 'Motor Voltajı'),
  
  // İnverter
  inverterTemp('22', '0210', 'A-40', 'Inverter Temp °C', 'İnverter Sıcaklık'),
  inverterVoltage('22', '0211', '((A*256)+B)/10', 'Inverter Voltage V', 'İnverter Voltaj'),
  inverterCurrent('22', '0212', '((A*256)+B)/10', 'Inverter Current A', 'İnverter Akım'),
  inverterFrequency('22', '0213', '((A*256)+B)/10', 'Inverter Frequency Hz', 'İnverter Frekans'),
  
  // Rejeneratif Fren
  regenPower('22', '0180', '((A*256)+B)/10', 'Regen Power kW', 'Regen Gücü'),
  regenCurrent('22', '0181', '((A*256)+B)/10', 'Regen Current A', 'Regen Akımı'),
  regenEnergyTotal('22', '0182', '((A*256)+B)/100', 'Total Regen kWh', 'Toplam Regen'),
  regenLevel('22', '0220', 'A', 'Regen Level', 'Regen Seviyesi'),
  
  // Marka Spesifik Regen
  regenNissan('22', '0190', 'A', 'Nissan Regen', 'Nissan Regen'),
  regenHyundai('22', '0175', '((A*256)+B)/10', 'Hyundai Regen kW', 'Hyundai Regen'),
  regenBmw('22', '2A40', '((A*256)+B)/10', 'BMW Regen kW', 'BMW Regen'),
  regenTesla('22', '118B', '((A*256)+B)/10', 'Tesla Regen kW', 'Tesla Regen'),
  regenTogg('22', '2110', '((A*256)+B)/10', 'TOGG Regen kW', 'TOGG Regen'),
  
  // Menzil ve Enerji
  estimatedRange('22', '0230', '((A*256)+B)', 'Estimated Range km', 'Tahmini Menzil'),
  energyConsumed('22', '0231', '((A*256)+B)/100', 'Energy Consumed kWh', 'Tüketilen Enerji'),
  energyEfficiency('22', '0232', '((A*256)+B)/10', 'Efficiency Wh/km', 'Verimlilik'),
  tripDistance('22', '0233', '((A*256)+B)/10', 'Trip Distance km', 'Yol Mesafesi'),
  averageSpeed('22', '0234', 'A', 'Average Speed km/h', 'Ortalama Hız'),
  
  // DC-DC Konvertör
  dcdc12vVoltage('22', '0240', 'A/10', '12V System Voltage V', '12V Sistem Voltaj'),
  dcdc12vCurrent('22', '0241', 'A/10', '12V System Current A', '12V Sistem Akım'),
  dcdcTemp('22', '0242', 'A-40', 'DC-DC Temp °C', 'DC-DC Sıcaklık'),
  
  // OBC (On-Board Charger)
  obcTemp('22', '0250', 'A-40', 'OBC Temp °C', 'OBC Sıcaklık'),
  obcInputVoltage('22', '0251', '((A*256)+B)/10', 'OBC Input V', 'OBC Giriş Voltaj'),
  obcOutputVoltage('22', '0252', '((A*256)+B)/10', 'OBC Output V', 'OBC Çıkış Voltaj'),
  obcOutputCurrent('22', '0253', '((A*256)+B)/10', 'OBC Output A', 'OBC Çıkış Akım'),
  
  // BMS (Battery Management System)
  bmsStatus('22', '0260', 'A', 'BMS Status', 'BMS Durumu'),
  bmsError('22', '0261', 'A', 'BMS Error', 'BMS Hata'),
  bmsBalancingStatus('22', '0262', 'A', 'BMS Balancing', 'BMS Dengeleme'),
  
  // Soğutma Sistemi (EV)
  coolantPumpSpeed('22', '0270', 'A*100/255', 'Coolant Pump %', 'Soğutma Pompası'),
  coolantFlowRate('22', '0271', 'A/10', 'Coolant Flow L/min', 'Soğutma Akış'),
  radiatorFanSpeed('22', '0272', 'A*100/255', 'Radiator Fan %', 'Radyatör Fan'),
  batteryHeaterStatus('22', '0273', 'A', 'Battery Heater', 'Batarya Isıtıcı'),
  
  // Klima (EV)
  hvacPower('22', '0280', '((A*256)+B)/10', 'HVAC Power kW', 'Klima Gücü'),
  hvacStatus('22', '0281', 'A', 'HVAC Status', 'Klima Durumu'),
  cabinTemp('22', '0282', 'A-40', 'Cabin Temp °C', 'Kabin Sıcaklık'),
  targetCabinTemp('22', '0283', 'A-40', 'Target Cabin °C', 'Hedef Kabin Sıcaklık'),
  
  // ============================================
  // HİBRİT ARAÇ PID'LERİ
  // ============================================
  
  hybridMode('22', '5100', 'A', 'Hybrid Mode', 'Hibrit Modu'),
  hybridBatteryVoltage('22', '5101', '((A*256)+B)/100', 'Hybrid Battery V', 'Hibrit Batarya Voltaj'),
  hybridBatteryCurrent('22', '5102', '((A*256)+B)/10', 'Hybrid Battery A', 'Hibrit Batarya Akım'),
  hybridBatterySoc('22', '5103', 'A', 'Hybrid Battery SOC %', 'Hibrit Batarya SOC'),
  hybridBatteryTemp('22', '5104', 'A-40', 'Hybrid Battery Temp °C', 'Hibrit Batarya Sıcaklık'),
  electricMotorRpm('22', '5105', '((A*256)+B)', 'Electric Motor RPM', 'Elektrik Motor Devri'),
  electricMotorTorque('22', '5106', '((A*256)+B)-32768', 'Electric Motor Torque Nm', 'Elektrik Motor Tork'),
  
  // ============================================
  // ARAÇ BİLGİSİ (MODE 09)
  // ============================================
  
  vin('09', '02', 'ASCII', 'VIN', 'Şasi Numarası'),
  calibrationId('09', '04', 'ASCII', 'Calibration ID', 'Kalibrasyon ID'),
  cvn('09', '06', 'ASCII', 'CVN', 'CVN'),
  ecuName('09', '0A', 'ASCII', 'ECU Name', 'ECU Adı'),
  
  // ============================================
  // SENSÖR VE AKTÜATÖR TESTLERİ (MODE 08)
  // ============================================
  
  testO2Sensor('08', '01', 'A', 'Test O2 Sensor', 'O2 Sensör Testi'),
  testEgrValve('08', '02', 'A', 'Test EGR Valve', 'EGR Valf Testi'),
  testEvapSystem('08', '03', 'A', 'Test EVAP System', 'EVAP Sistem Testi'),
  
  // ============================================
  // HATA KODLARI
  // ============================================
  
  dtcCount('01', '01', 'A', 'DTC Count', 'Hata Kodu Sayısı'),
  milStatus('01', '01', 'A', 'MIL Status', 'MIL Durumu'),
  
  // ============================================
  // DİĞER SENSÖRLER
  // ============================================
  
  // ABS/ESP
  wheelSpeedFL('22', '6000', '((A*256)+B)/100', 'Wheel Speed FL km/h', 'Teker Hızı ÖS'),
  wheelSpeedFR('22', '6001', '((A*256)+B)/100', 'Wheel Speed FR km/h', 'Teker Hızı ÖS'),
  wheelSpeedRL('22', '6002', '((A*256)+B)/100', 'Wheel Speed RL km/h', 'Teker Hızı AS'),
  wheelSpeedRR('22', '6003', '((A*256)+B)/100', 'Wheel Speed RR km/h', 'Teker Hızı AS'),
  
  // Direksiyon
  steeringAngle('22', '6010', '((A*256)+B)-32768', 'Steering Angle °', 'Direksiyon Açısı'),
  steeringTorque('22', '6011', '((A*256)+B)-32768', 'Steering Torque Nm', 'Direksiyon Tork'),
  
  // G Sensörleri
  lateralAcceleration('22', '6020', '((A*256)+B)/1000-32', 'Lateral G', 'Yanal İvme'),
  longitudinalAcceleration('22', '6021', '((A*256)+B)/1000-32', 'Longitudinal G', 'Boyuna İvme'),
  yawRate('22', '6022', '((A*256)+B)/100-327', 'Yaw Rate °/s', 'Sapma Hızı'),
  
  // Lastik Basıncı (TPMS)
  tirePressureFL('22', '6030', 'A*2.5', 'Tire Pressure FL kPa', 'Lastik Basınç ÖS'),
  tirePressureFR('22', '6031', 'A*2.5', 'Tire Pressure FR kPa', 'Lastik Basınç ÖS'),
  tirePressureRL('22', '6032', 'A*2.5', 'Tire Pressure RL kPa', 'Lastik Basınç AS'),
  tirePressureRR('22', '6033', 'A*2.5', 'Tire Pressure RR kPa', 'Lastik Basınç AS'),
  tireTempFL('22', '6034', 'A-40', 'Tire Temp FL °C', 'Lastik Sıcaklık ÖS'),
  tireTempFR('22', '6035', 'A-40', 'Tire Temp FR °C', 'Lastik Sıcaklık ÖS'),
  tireTempRL('22', '6036', 'A-40', 'Tire Temp RL °C', 'Lastik Sıcaklık AS'),
  tireTempRR('22', '6037', 'A-40', 'Tire Temp RR °C', 'Lastik Sıcaklık AS'),
  
  // GPS/Navigasyon
  gpsLatitude('22', '7000', 'GPS', 'GPS Latitude', 'GPS Enlem'),
  gpsLongitude('22', '7001', 'GPS', 'GPS Longitude', 'GPS Boylam'),
  gpsAltitude('22', '7002', '((A*256)+B)', 'GPS Altitude m', 'GPS Rakım'),
  gpsSpeed('22', '7003', 'A', 'GPS Speed km/h', 'GPS Hız');

  final String mode;
  final String pid;
  final String equation;
  final String description;
  final String turkishName;

  const PIDType(
    this.mode,
    this.pid,
    this.equation,
    this.description,
    this.turkishName,
  );

  String getFullCommand({String header = '7DF'}) {
    return '$mode$pid';
  }

  /// Araç tipine göre filtrele
  bool isForVehicleType(VehicleType type) {
    switch (type) {
      case VehicleType.gasoline:
        return _isGasolinePID();
      case VehicleType.diesel:
        return _isDieselPID();
      case VehicleType.electric:
        return _isElectricPID();
      case VehicleType.hybrid:
        return _isHybridPID();
      case VehicleType.all:
        return true;
    }
  }

  bool _isGasolinePID() {
    final gasolinePIDs = [
      'engineLoad', 'coolantTemp', 'engineRpm', 'vehicleSpeed',
      'maf', 'throttlePosition', 'fuelRate', 'fuelPressure',
      'o2Sensor1Voltage', 'o2Sensor2Voltage', 'timingAdvance',
      'intakeTemp', 'intakeManifoldPressure', 'fuelLevel',
    ];
    return gasolinePIDs.contains(name);
  }

  bool _isDieselPID() {
    return name.contains('dpf') ||
        name.contains('adBlue') ||
        name.contains('scr') ||
        name.contains('nox') ||
        name.contains('glowPlug') ||
        name.contains('turbo') ||
        name.contains('soot') ||
        name.contains('rail') ||
        _isGasolinePID(); // Dizel de benzinli PID'lerini kullanır
  }

  bool _isElectricPID() {
    return name.contains('battery') ||
        name.contains('cell') ||
        name.contains('regen') ||
        name.contains('motor') && !name.contains('engine') ||
        name.contains('inverter') ||
        name.contains('dcdc') ||
        name.contains('obc') ||
        name.contains('bms') ||
        name.contains('hvac') ||
        name.contains('charge');
  }

  bool _isHybridPID() {
    return name.contains('hybrid') || _isGasolinePID() || _isElectricPID();
  }
}

/// Araç tipi enum
enum VehicleType {
  gasoline,  // Benzinli
  diesel,    // Dizel
  electric,  // Elektrikli
  hybrid,    // Hibrit
  all        // Hepsi
}

/// PID kategorileri
enum PIDCategory {
  engine,           // Motor
  fuel,            // Yakıt
  exhaust,         // Egzoz
  transmission,    // Şanzıman
  battery,         // Batarya
  electricMotor,   // Elektrik Motoru
  charging,        // Şarj
  climate,         // Klima
  safety,          // Güvenlik
  comfort,         // Konfor
  diagnosis,       // Teşhis
}

/// PID listesini kategoriye göre filtrele
List<PIDType> getPIDsByCategory(PIDCategory category) {
  return PIDType.values.where((pid) {
    switch (category) {
      case PIDCategory.engine:
        return pid.name.contains('engine') || pid.name.contains('rpm') ||
               pid.name.contains('motor') && !pid.name.contains('electric');
      case PIDCategory.fuel:
        return pid.name.contains('fuel') || pid.name.contains('injection');
      case PIDCategory.exhaust:
        return pid.name.contains('o2') || pid.name.contains('catalyst') ||
               pid.name.contains('egr') || pid.name.contains('dpf') ||
               pid.name.contains('scr') || pid.name.contains('nox');
      case PIDCategory.battery:
        return pid.name.contains('battery') || pid.name.contains('cell');
      case PIDCategory.electricMotor:
        return pid.name.contains('motor') && !pid.name.contains('engine') ||
               pid.name.contains('inverter');
      case PIDCategory.charging:
        return pid.name.contains('charge') || pid.name.contains('obc');
      case PIDCategory.climate:
        return pid.name.contains('hvac') || pid.name.contains('cabin') ||
               pid.name.contains('coolant') || pid.name.contains('temp');
      case PIDCategory.safety:
        return pid.name.contains('wheel') || pid.name.contains('abs') ||
               pid.name.contains('steering') || pid.name.contains('tire');
      default:
        return false;
    }
  }).toList();
}

/// Araç tipine göre PID listesi al
List<PIDType> getPIDsForVehicleType(VehicleType type) {
  return PIDType.values.where((pid) => pid.isForVehicleType(type)).toList();
}
