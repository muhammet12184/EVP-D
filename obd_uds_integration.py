"""
OBD/UDS Entegrasyon Modülü
Tüm bileşenleri birleştirir: UDS komut gönderme, PID veritabanı, formül hesaplama
"""

from typing import Optional, Dict, Any, List
from uds_commander import UDSCommander
from pid_database import PIDDatabase, PIDEntry
from formula_calculator import FormulaCalculator


class OBDUDSIntegration:
    """OBD/UDS entegrasyon sınıfı - Tüm bileşenleri birleştirir"""
    
    def __init__(self, port: str = None, csv_file: str = "ev_unified_professional.csv"):
        """
        Args:
            port: Serial port (örn: 'COM3', '/dev/ttyUSB0')
            csv_file: PID CSV dosyası yolu
        """
        self.uds_commander = UDSCommander(port=port)
        self.pid_database = PIDDatabase(csv_file)
        self.formula_calculator = FormulaCalculator()
        self.connected = False
        self.current_brand = None
    
    def connect(self) -> bool:
        """ELM327'ye bağlan"""
        if self.uds_commander.connect():
            self.connected = True
            return True
        return False
    
    def disconnect(self):
        """Bağlantıyı kapat"""
        self.uds_commander.disconnect()
        self.connected = False
    
    def set_brand(self, brand: str):
        """
        Araç markasını ayarla (PID seçimi için)
        
        Args:
            brand: Marka adı (örn: "TOGG", "Tesla", "Hyundai")
        """
        self.current_brand = brand
    
    def read_pid(self, pid_name: str, brand: str = None, ecu: str = None) -> Optional[Dict[str, Any]]:
        """
        PID oku ve hesapla
        
        Args:
            pid_name: PID adı (örn: "Battery SOC")
            brand: Marka (opsiyonel, set_brand ile ayarlanmışsa kullanılır)
            ecu: ECU türü (opsiyonel)
        
        Returns:
            Hesaplanmış değer sözlüğü veya None
        """
        if not self.connected:
            raise ConnectionError("ELM327'ye bağlı değil")
        
        # Marka belirleme
        selected_brand = brand or self.current_brand
        
        # PID'i veritabanından bul
        pid_entry = self.pid_database.get_smart_pid(pid_name, brand=selected_brand, ecu=ecu)
        
        if not pid_entry:
            print(f"PID bulunamadı: {pid_name}")
            return None
        
        # Header ayarla
        if not self.uds_commander.set_header(pid_entry.header):
            print(f"Header ayarlanamadı: {pid_entry.header}")
            return None
        
        # Komut gönder
        mode = pid_entry.get_mode()
        raw_bytes = None
        
        if mode == "22":
            # UDS Mode 22
            did = pid_entry.get_did()
            raw_bytes = self.uds_commander.send_uds_command(did, pid_entry.header)
        elif mode in ["01", "09"]:
            # OBD-II Mode 01 veya 09
            pid_code = pid_entry.mode_pid.split()[1] if len(pid_entry.mode_pid.split()) > 1 else ""
            raw_bytes = self.uds_commander.send_obd_command(mode, pid_code, pid_entry.header)
        else:
            print(f"Desteklenmeyen mode: {mode}")
            return None
        
        if not raw_bytes:
            print(f"Komut cevabı alınamadı: {pid_name}")
            return None
        
        # Formülü hesapla
        result = self.formula_calculator.calculate(pid_entry, raw_bytes)
        
        return result
    
    def read_multiple_pids(self, pid_names: List[str], brand: str = None, ecu: str = None) -> Dict[str, Any]:
        """
        Birden fazla PID oku
        
        Args:
            pid_names: PID adı listesi
            brand: Marka (opsiyonel)
            ecu: ECU türü (opsiyonel)
        
        Returns:
            PID adı -> sonuç sözlüğü
        """
        results = {}
        
        for pid_name in pid_names:
            result = self.read_pid(pid_name, brand=brand, ecu=ecu)
            if result:
                results[pid_name] = result
        
        return results
    
    def read_ev_battery_status(self, brand: str = None) -> Dict[str, Any]:
        """
        EV batarya durumunu oku (standart PID'ler)
        
        Args:
            brand: Marka (opsiyonel)
        
        Returns:
            Batarya durumu sözlüğü
        """
        battery_pids = [
            "Battery SOC",
            "Battery Voltage",
            "Battery Current",
            "Battery Temp",
            "Battery SOH"
        ]
        
        return self.read_multiple_pids(battery_pids, brand=brand, ecu="BMS")
    
    def read_engine_status(self) -> Dict[str, Any]:
        """
        Motor durumunu oku (standart OBD-II PID'leri)
        
        Returns:
            Motor durumu sözlüğü
        """
        engine_pids = [
            "Engine RPM",
            "Vehicle Speed",
            "Engine Coolant Temperature",
            "Throttle Position",
            "Intake Air Temperature"
        ]
        
        return self.read_multiple_pids(engine_pids, ecu="ECM")
    
    def get_available_pids(self, brand: str = None, ecu: str = None) -> List[str]:
        """
        Mevcut PID'leri listele
        
        Args:
            brand: Marka (opsiyonel)
            ecu: ECU türü (opsiyonel)
        
        Returns:
            PID adı listesi
        """
        if brand:
            pids = self.pid_database.get_pids_by_brand(brand)
        elif ecu:
            pids = self.pid_database.get_pids_by_ecu(ecu)
        else:
            pids = self.pid_database.get_all_pids()
        
        return [pid.name for pid in pids]
    
    def __enter__(self):
        """Context manager giriş"""
        self.connect()
        return self
    
    def __exit__(self, exc_type, exc_val, exc_tb):
        """Context manager çıkış"""
        self.disconnect()


# Örnek kullanım
if __name__ == "__main__":
    # Port'u kendi cihazınıza göre ayarlayın
    port = "COM3"  # Windows için
    # port = "/dev/ttyUSB0"  # Linux için
    
    # Entegrasyon nesnesi oluştur
    obd = OBDUDSIntegration(port=port)
    
    try:
        # Bağlan
        if obd.connect():
            print("ELM327'ye bağlandı")
            
            # Marka ayarla (TOGG örneği)
            obd.set_brand("TOGG")
            
            # Battery SOC oku
            result = obd.read_pid("Battery SOC", brand="TOGG")
            if result:
                print(f"\nBattery SOC: {result['formatted']}")
                print(f"Raw bytes: {result['raw_bytes']}")
                print(f"Formula: {result['formula']}")
            
            # Birden fazla PID oku
            print("\n--- EV Batarya Durumu ---")
            battery_status = obd.read_ev_battery_status(brand="TOGG")
            for pid_name, result in battery_status.items():
                print(f"{pid_name}: {result['formatted']}")
            
            # Motor durumu (benzinli/dizel için)
            print("\n--- Motor Durumu ---")
            engine_status = obd.read_engine_status()
            for pid_name, result in engine_status.items():
                print(f"{pid_name}: {result['formatted']}")
        
        else:
            print("Bağlantı başarısız")
    
    except Exception as e:
        print(f"Hata: {e}")
    
    finally:
        obd.disconnect()
        print("\nBağlantı kapatıldı")
