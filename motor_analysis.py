"""
Motor Analiz Modülü
Motor verilerini toplayan ve yakıt tüketim PID'ini bağlayan modül
"""

from typing import Optional, Dict, Any
from datetime import datetime
from obd_integration import OBDIntegration
from data_analyzer import DataAnalyzer
from pid_router import PIDRouter


class MotorAnalysis:
    """Motor analiz sınıfı - yakıt tüketim PID'ini bağlar"""
    
    def __init__(self, obd_integration: OBDIntegration, data_analyzer: DataAnalyzer):
        """
        Args:
            obd_integration: OBDIntegration nesnesi
            data_analyzer: DataAnalyzer nesnesi
        """
        self.obd = obd_integration
        self.analyzer = data_analyzer
        self.pid_router = obd_integration.pid_router
        
        # Yakıt tüketim PID'leri (farklı formatlar için)
        self.fuel_pid_names = [
            "Fuel Consumption Rate",
            "Fuel Rate",
            "Instantaneous Fuel Consumption",
            "Fuel Consumption",
            "Engine Fuel Rate",
        ]
        
        self.current_fuel_pid: Optional[str] = None
        self.last_fuel_value: float = 0.0
    
    def initialize_fuel_pid(self, manufacturer: Optional[str] = None) -> bool:
        """
        Yakıt tüketim PID'ini bul ve başlat
        
        Args:
            manufacturer: Araç üreticisi (opsiyonel)
        
        Returns:
            PID bulunursa True
        """
        manufacturer_to_use = manufacturer or self.obd.manufacturer
        
        # PID'leri dene
        for pid_name in self.fuel_pid_names:
            pid_entry = self.pid_router.get_pid_by_name(pid_name, manufacturer_to_use)
            if pid_entry:
                # PID'i test et
                result = self.obd.read_pid(pid_name, manufacturer_to_use)
                if result and result.get('value') is not None:
                    self.current_fuel_pid = pid_name
                    self.last_fuel_value = result.get('value', 0.0)
                    print(f"Yakıt tüketim PID'i bulundu: {pid_name}")
                    return True
        
        # Standart OBD-II PID'leri dene
        standard_pids = [
            ("01", "5E"),  # Mode 01 PID 5E - Engine fuel rate
            ("01", "5F"),  # Mode 01 PID 5F - Hybrid battery pack remaining life
        ]
        
        for mode, pid_code in standard_pids:
            try:
                response_bytes = self.obd.uds_commander.send_uds_command(mode, pid_code)
                if response_bytes:
                    # Basit hesaplama (Mode 01 PID 5E: (A*256+B)/20 L/h)
                    if len(response_bytes) >= 5:
                        value = (response_bytes[3] * 256 + response_bytes[4]) / 20.0
                        if value > 0 and value < 1000:  # Makul değer aralığı
                            self.current_fuel_pid = f"Mode{mode}_PID{pid_code}"
                            self.last_fuel_value = value
                            print(f"Standart yakıt tüketim PID'i bulundu: Mode {mode} PID {pid_code}")
                            return True
            except Exception as e:
                continue
        
        print("Uyarı: Yakıt tüketim PID'i bulunamadı, placeholder değer kullanılacak")
        return False
    
    def read_fuel_consumption(self) -> float:
        """
        Anlık yakıt tüketimini oku
        
        Returns:
            Yakıt tüketim oranı (L/h) veya 0.0 (PID bulunamazsa)
        """
        if not self.current_fuel_pid:
            # PID başlatılmamışsa dene
            if not self.initialize_fuel_pid():
                return 0.0
        
        try:
            manufacturer = self.obd.manufacturer
            result = self.obd.read_pid(self.current_fuel_pid, manufacturer)
            
            if result and result.get('value') is not None:
                fuel_value = float(result['value'])
                
                # Değeri DataAnalyzer'a ekle
                self.analyzer.add_fuel_consumption_data(fuel_value)
                
                self.last_fuel_value = fuel_value
                return fuel_value
            else:
                # Son bilinen değeri döndür
                return self.last_fuel_value
                
        except Exception as e:
            print(f"Yakıt tüketim okuma hatası: {e}")
            return self.last_fuel_value
    
    def get_motor_status(self) -> Dict[str, Any]:
        """
        Motor durumunu getir (yakıt tüketimi dahil)
        
        Returns:
            Motor durum dict'i
        """
        # Motor PID'lerini oku
        engine_status = self.obd.read_engine_status()
        
        # Yakıt tüketimini ekle
        fuel_consumption = self.read_fuel_consumption()
        
        # Yakıt analizini ekle
        fuel_analysis = self.analyzer.get_fuel_analysis()
        
        return {
            'engine': engine_status,
            'fuel_consumption': {
                'current': fuel_consumption,
                'unit': 'L/h',
                'pid_name': self.current_fuel_pid or 'Not Found',
                'analysis': fuel_analysis,
            },
            'timestamp': datetime.now().isoformat(),
        }
