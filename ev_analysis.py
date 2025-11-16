"""
EV Analiz Modülü
EV verilerini toplayan ve regen PID'ini bağlayan modül
"""

from typing import Optional, Dict, Any
from datetime import datetime
from obd_integration import OBDIntegration
from data_analyzer import DataAnalyzer
from pid_router import PIDRouter


class EVAnalysis:
    """EV analiz sınıfı - regen PID'ini bağlar"""
    
    def __init__(self, obd_integration: OBDIntegration, data_analyzer: DataAnalyzer):
        """
        Args:
            obd_integration: OBDIntegration nesnesi
            data_analyzer: DataAnalyzer nesnesi
        """
        self.obd = obd_integration
        self.analyzer = data_analyzer
        self.pid_router = obd_integration.pid_router
        
        # Regen PID'leri (farklı formatlar için)
        self.regen_pid_names = [
            "Regenerative Power",
            "Regen Power",
            "Regenerative Braking Power",
            "Battery Regeneration Power",
            "Motor Regeneration Power",
            "Regenerative Energy",
        ]
        
        self.current_regen_pid: Optional[str] = None
        self.last_regen_value: float = 0.0
    
    def initialize_regen_pid(self, manufacturer: Optional[str] = None) -> bool:
        """
        Regen PID'ini bul ve başlat
        
        Args:
            manufacturer: Araç üreticisi (opsiyonel)
        
        Returns:
            PID bulunursa True
        """
        manufacturer_to_use = manufacturer or self.obd.manufacturer
        
        # EV batarya PID'lerini ara
        ev_pids = self.pid_router.get_ev_battery_pids(manufacturer_to_use)
        
        # Regen ile ilgili PID'leri bul
        for pid_entry in ev_pids:
            pid_name_lower = pid_entry.name.lower()
            if any(keyword in pid_name_lower for keyword in ['regen', 'regenerative', 'braking', 'recovery']):
                # PID'i test et
                result = self.obd.read_pid(pid_entry.name, manufacturer_to_use)
                if result and result.get('value') is not None:
                    value = result.get('value', 0.0)
                    # Negatif akım genellikle regen'i gösterir
                    if isinstance(value, (int, float)) and value != 0:
                        self.current_regen_pid = pid_entry.name
                        # Eğer negatifse pozitife çevir (regen gücü pozitif olarak gösterilir)
                        self.last_regen_value = abs(value) if value < 0 else value
                        print(f"Regen PID'i bulundu: {pid_entry.name}")
                        return True
        
        # Özel PID isimleriyle dene
        for pid_name in self.regen_pid_names:
            pid_entry = self.pid_router.get_pid_by_name(pid_name, manufacturer_to_use)
            if pid_entry:
                result = self.obd.read_pid(pid_name, manufacturer_to_use)
                if result and result.get('value') is not None:
                    self.current_regen_pid = pid_name
                    self.last_regen_value = result.get('value', 0.0)
                    print(f"Regen PID'i bulundu: {pid_name}")
                    return True
        
        # Battery Current PID'ini kullan (negatif değerler regen gösterir)
        battery_current_pid = self.pid_router.get_pid_by_name("Battery Current", manufacturer_to_use)
        if battery_current_pid:
            result = self.obd.read_pid("Battery Current", manufacturer_to_use)
            if result and result.get('value') is not None:
                current = result.get('value', 0.0)
                voltage_result = self.obd.read_pid("Battery Voltage", manufacturer_to_use)
                voltage = voltage_result.get('value', 400.0) if voltage_result else 400.0
                
                # Negatif akım regen gösterir, güç = voltaj * |akım| / 1000 (kW)
                if current < 0:
                    regen_power = abs(current) * voltage / 1000.0
                    self.current_regen_pid = "Battery Current (calculated)"
                    self.last_regen_value = regen_power
                    print(f"Regen gücü Battery Current'dan hesaplandı: {regen_power:.2f} kW")
                    return True
        
        print("Uyarı: Regen PID'i bulunamadı")
        return False
    
    def read_regen_power(self) -> float:
        """
        Rejeneratif gücü oku
        
        Returns:
            Rejeneratif güç (kW) veya 0.0 (PID bulunamazsa)
        """
        if not self.current_regen_pid:
            # PID başlatılmamışsa dene
            if not self.initialize_regen_pid():
                return 0.0
        
        try:
            manufacturer = self.obd.manufacturer
            
            # Özel hesaplama kullanılıyorsa
            if self.current_regen_pid == "Battery Current (calculated)":
                current_result = self.obd.read_pid("Battery Current", manufacturer)
                voltage_result = self.obd.read_pid("Battery Voltage", manufacturer)
                
                if current_result and voltage_result:
                    current = current_result.get('value', 0.0)
                    voltage = voltage_result.get('value', 400.0)
                    
                    if current < 0:
                        regen_power = abs(current) * voltage / 1000.0
                        self.analyzer.add_regen_data(regen_power)
                        self.last_regen_value = regen_power
                        return regen_power
                return 0.0
            
            # Normal PID okuma
            result = self.obd.read_pid(self.current_regen_pid, manufacturer)
            
            if result and result.get('value') is not None:
                regen_value = float(result['value'])
                
                # Negatif değerleri pozitife çevir
                if regen_value < 0:
                    regen_value = abs(regen_value)
                
                # Değeri DataAnalyzer'a ekle
                self.analyzer.add_regen_data(regen_value)
                
                self.last_regen_value = regen_value
                return regen_value
            else:
                # Son bilinen değeri döndür
                return self.last_regen_value
                
        except Exception as e:
            print(f"Regen okuma hatası: {e}")
            return self.last_regen_value
    
    def get_ev_status(self) -> Dict[str, Any]:
        """
        EV durumunu getir (regen dahil)
        
        Returns:
            EV durum dict'i
        """
        # EV batarya PID'lerini oku
        battery_status = self.obd.read_ev_battery_status()
        
        # Regen gücünü ekle
        regen_power = self.read_regen_power()
        
        # Regen analizini ekle
        regen_analysis = self.analyzer.get_regen_analysis()
        
        return {
            'battery': battery_status,
            'regen': {
                'current': regen_power,
                'unit': 'kW',
                'pid_name': self.current_regen_pid or 'Not Found',
                'analysis': regen_analysis,
            },
            'timestamp': datetime.now().isoformat(),
        }
