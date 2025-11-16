"""
OBD-II / UDS Entegrasyon Modülü
Tüm bileşenleri birleştiren ana modül
"""

from typing import Optional, Dict, List, Tuple
from uds_commander import UDSCommander
from pid_router import PIDRouter, PIDEntry
from formula_calculator import FormulaCalculator


class OBDIntegration:
    """OBD-II/UDS entegrasyon sınıfı - tüm bileşenleri birleştirir"""
    
    def __init__(self, port: str = None, csv_file: str = "comprehensive_automotive_pids.csv"):
        """
        Args:
            port: ELM327 seri port adı
            csv_file: PID veritabanı CSV dosyası
        """
        self.uds_commander = UDSCommander(port=port)
        self.pid_router = PIDRouter(csv_file)
        self.formula_calculator = FormulaCalculator()
        self.manufacturer: Optional[str] = None
        self.current_header: str = "7E4"  # Varsayılan BMS header
    
    def connect(self, manufacturer: str = None) -> bool:
        """
        ELM327'ye bağlan ve oturum başlat
        
        Args:
            manufacturer: Araç üreticisi (opsiyonel, PID seçimini optimize eder)
        
        Returns:
            Başarılı olursa True
        """
        if not self.uds_commander.connect():
            return False
        
        # Üreticiyi kaydet
        self.manufacturer = manufacturer
        
        # Extended diagnostic session başlat
        if not self.uds_commander.send_uds_session_control("03"):
            print("Uyarı: Extended session başlatılamadı")
        
        return True
    
    def disconnect(self):
        """Bağlantıyı kapat"""
        self.uds_commander.disconnect()
    
    def read_pid(self, pid_name: str, manufacturer: str = None) -> Optional[Dict[str, any]]:
        """
        PID oku ve hesapla
        
        Args:
            pid_name: PID adı (örn: "Battery SOC", "Engine RPM")
            manufacturer: Üretici adı (opsiyonel, otomatik seçim için)
        
        Returns:
            {
                'name': PID adı,
                'value': Hesaplanmış değer,
                'formatted': Formatlanmış string,
                'units': Birim,
                'raw_bytes': Ham byte'lar
            } veya None
        """
        # PID'i bul
        manufacturer_to_use = manufacturer or self.manufacturer
        pid_entry = self.pid_router.get_pid_by_name(pid_name, manufacturer_to_use)
        
        if not pid_entry:
            print(f"PID bulunamadı: {pid_name}")
            return None
        
        # Header'ı ayarla
        if pid_entry.header:
            self.uds_commander.set_header(pid_entry.header)
            self.current_header = pid_entry.header
        
        # Mode ve PID kodunu al
        mode = pid_entry.get_mode()
        pid_code = pid_entry.get_pid_code()
        
        if not mode or not pid_code:
            print(f"Geçersiz PID formatı: {pid_entry.mode_pid}")
            return None
        
        # UDS komutu gönder
        if mode == "22":
            # ReadDataByIdentifier
            response_bytes = self.uds_commander.send_uds_read_data_by_id(pid_code)
        elif mode == "01":
            # Mode 01 (OBD-II standard)
            response_bytes = self.uds_commander.send_uds_command(mode, pid_code)
        else:
            # Diğer modlar
            response_bytes = self.uds_commander.send_uds_command(mode, pid_code)
        
        if not response_bytes:
            print(f"UDS cevabı alınamadı: {pid_name}")
            return None
        
        # Değeri hesapla
        value = self.formula_calculator.calculate(pid_entry, response_bytes)
        formatted = self.formula_calculator.calculate_with_formatting(pid_entry, response_bytes)
        
        return {
            'name': pid_entry.name,
            'value': value,
            'formatted': formatted,
            'units': pid_entry.units,
            'raw_bytes': response_bytes,
            'pid_code': f"{mode} {pid_code}",
            'ecu': pid_entry.ecu,
            'description': pid_entry.description
        }
    
    def read_multiple_pids(self, pid_names: List[str], manufacturer: str = None) -> Dict[str, Dict]:
        """
        Birden fazla PID oku
        
        Args:
            pid_names: PID adları listesi
            manufacturer: Üretici adı
        
        Returns:
            {pid_name: result_dict} formatında dict
        """
        results = {}
        for pid_name in pid_names:
            result = self.read_pid(pid_name, manufacturer)
            if result:
                results[pid_name] = result
        return results
    
    def read_ev_battery_status(self, manufacturer: str = None) -> Dict[str, any]:
        """
        EV batarya durumunu oku (tüm önemli parametreler)
        
        Args:
            manufacturer: Üretici adı
        
        Returns:
            Batarya durumu dict'i
        """
        battery_pids = [
            "Battery State of Charge",
            "Battery State of Health",
            "Battery Voltage",
            "Battery Current",
            "Battery Temperature",
            "Cell Voltage Delta",
            "Battery Capacity"
        ]
        
        results = {}
        manufacturer_to_use = manufacturer or self.manufacturer
        
        for pid_name in battery_pids:
            result = self.read_pid(pid_name, manufacturer_to_use)
            if result:
                results[pid_name] = result
        
        return results
    
    def read_engine_status(self) -> Dict[str, any]:
        """Motor durumunu oku"""
        engine_pids = [
            "Engine RPM",
            "Engine Coolant Temperature",
            "Intake Air Temperature",
            "Throttle Position",
            "MAF Air Flow Rate",
            "Engine Load"
        ]
        
        results = {}
        for pid_name in engine_pids:
            result = self.read_pid(pid_name)
            if result:
                results[pid_name] = result
        
        return results
    
    def read_transmission_status(self) -> Dict[str, any]:
        """Şanzıman durumunu oku"""
        transmission_pids = [
            "Transmission Gear Position",
            "Transmission Fluid Temperature",
            "Transmission Input Shaft Speed",
            "Transmission Output Shaft Speed"
        ]
        
        results = {}
        for pid_name in transmission_pids:
            result = self.read_pid(pid_name)
            if result:
                results[pid_name] = result
        
        return results
    
    def search_and_read(self, keyword: str, ecu: str = None, limit: int = 10) -> List[Dict]:
        """
        Anahtar kelimeye göre PID ara ve oku
        
        Args:
            keyword: Arama kelimesi
            ecu: ECU filtresi
            limit: Maksimum okunacak PID sayısı
        
        Returns:
            Okunan PID sonuçları listesi
        """
        # PID'leri ara
        found_pids = self.pid_router.search_pids(keyword, ecu=ecu, manufacturer=self.manufacturer)
        
        results = []
        for pid_entry in found_pids[:limit]:
            mode = pid_entry.get_mode()
            pid_code = pid_entry.get_pid_code()
            
            if mode == "22":
                response_bytes = self.uds_commander.send_uds_read_data_by_id(pid_code)
            else:
                response_bytes = self.uds_commander.send_uds_command(mode, pid_code)
            
            if response_bytes:
                value = self.formula_calculator.calculate(pid_entry, response_bytes)
                formatted = self.formula_calculator.calculate_with_formatting(pid_entry, response_bytes)
                
                results.append({
                    'name': pid_entry.name,
                    'value': value,
                    'formatted': formatted,
                    'units': pid_entry.units,
                    'ecu': pid_entry.ecu
                })
        
        return results
    
    def get_available_pids(self, ecu: str = None, manufacturer: str = None) -> List[str]:
        """
        Mevcut PID'lerin listesini getir
        
        Args:
            ecu: ECU filtresi
            manufacturer: Üretici filtresi
        
        Returns:
            PID adları listesi
        """
        if manufacturer:
            pids = self.pid_router.get_pids_by_manufacturer(manufacturer)
        elif ecu:
            pids = self.pid_router.get_pids_by_ecu(ecu)
        else:
            pids = self.pid_router.pid_database
        
        return [pid.name for pid in pids]
    
    def __enter__(self):
        """Context manager desteği"""
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager desteği"""
        self.disconnect()


# Örnek kullanım
if __name__ == "__main__":
    # Kullanım örneği
    print("OBD-II/UDS Entegrasyon Modülü")
    print("=" * 50)
    
    # Entegrasyon nesnesi oluştur
    obd = OBDIntegration(port=None)  # Port otomatik bulunacak
    
    try:
        # Bağlan
        print("ELM327'ye bağlanılıyor...")
        if obd.connect(manufacturer="TOGG"):
            print("Bağlantı başarılı!")
            
            # EV batarya durumunu oku
            print("\nEV Batarya Durumu:")
            battery_status = obd.read_ev_battery_status("TOGG")
            for name, data in battery_status.items():
                print(f"  {name}: {data['formatted']}")
            
            # Tek PID oku
            print("\nTek PID Okuma:")
            soc_result = obd.read_pid("Battery State of Charge", "TOGG")
            if soc_result:
                print(f"  {soc_result['name']}: {soc_result['formatted']}")
                print(f"  Ham byte'lar: {[hex(b) for b in soc_result['raw_bytes']]}")
            
            # Arama ve okuma
            print("\nArama ve Okuma:")
            search_results = obd.search_and_read("battery", ecu="BMS", limit=5)
            for result in search_results:
                print(f"  {result['name']}: {result['formatted']}")
        
        else:
            print("Bağlantı başarısız!")
    
    except Exception as e:
        print(f"Hata: {e}")
    
    finally:
        obd.disconnect()
        print("\nBağlantı kapatıldı.")
