"""
PID Veritabanı Yönlendiricisi
Araç markasına göre doğru PID'leri seçen akıllı yönlendirici
"""

import csv
import os
from typing import Dict, List, Optional, Tuple
from dataclasses import dataclass


@dataclass
class PIDEntry:
    """PID veri yapısı"""
    name: str
    mode_pid: str
    equation: str
    min_val: str
    max_val: str
    units: str
    header: str
    ecu: str
    description: str
    byte_positions: str
    
    def get_pid_code(self) -> str:
        """PID kodunu temizle ve döndür (örn: "22 015B" -> "015B")"""
        parts = self.mode_pid.strip().split()
        if len(parts) >= 2:
            return parts[1]
        return parts[0] if parts else ""
    
    def get_mode(self) -> str:
        """Mode kodunu döndür (örn: "22 015B" -> "22")"""
        parts = self.mode_pid.strip().split()
        return parts[0] if parts else ""


class PIDRouter:
    """Araç markasına göre PID seçimi yapan yönlendirici"""
    
    def __init__(self, csv_file: str = "comprehensive_automotive_pids.csv"):
        """
        Args:
            csv_file: PID veritabanı CSV dosyası yolu
        """
        self.csv_file = csv_file
        self.pid_database: List[PIDEntry] = []
        self.manufacturer_pids: Dict[str, List[PIDEntry]] = {}
        self.ecu_pids: Dict[str, List[PIDEntry]] = {}
        self._load_database()
    
    def _load_database(self):
        """CSV dosyasından PID veritabanını yükle"""
        if not os.path.exists(self.csv_file):
            raise FileNotFoundError(f"PID veritabanı bulunamadı: {self.csv_file}")
        
        current_category = ""
        current_manufacturer = ""
        
        with open(self.csv_file, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f, delimiter=';')
            
            for row in reader:
                # Kategori satırlarını kontrol et
                name = row.get('Name', '').strip()
                
                if name.startswith('==='):
                    # Kategori satırı
                    current_category = name
                    
                    # Üretici bilgisini çıkar
                    if 'MANUFACTURER SPECIFIC' in name.upper():
                        if 'VW' in name.upper() or 'AUDI' in name.upper():
                            current_manufacturer = 'VW/AUDI'
                        elif 'BMW' in name.upper():
                            current_manufacturer = 'BMW'
                        elif 'MERCEDES' in name.upper() or 'MB' in name.upper():
                            current_manufacturer = 'MERCEDES'
                        elif 'TOYOTA' in name.upper() or 'LEXUS' in name.upper():
                            current_manufacturer = 'TOYOTA'
                        elif 'FORD' in name.upper():
                            current_manufacturer = 'FORD'
                        elif 'GM' in name.upper() or 'OPEL' in name.upper():
                            current_manufacturer = 'GM'
                        elif 'NISSAN' in name.upper():
                            current_manufacturer = 'NISSAN'
                        elif 'HYUNDAI' in name.upper() or 'KIA' in name.upper():
                            current_manufacturer = 'HYUNDAI/KIA'
                        elif 'TESLA' in name.upper():
                            current_manufacturer = 'TESLA'
                        elif 'PSA' in name.upper() or 'PEUGEOT' in name.upper():
                            current_manufacturer = 'PSA'
                        elif 'VOLVO' in name.upper():
                            current_manufacturer = 'VOLVO'
                        elif 'PORSCHE' in name.upper():
                            current_manufacturer = 'PORSCHE'
                        elif 'JAGUAR' in name.upper() or 'LAND ROVER' in name.upper():
                            current_manufacturer = 'JLR'
                        elif 'MAZDA' in name.upper():
                            current_manufacturer = 'MAZDA'
                        elif 'SUBARU' in name.upper():
                            current_manufacturer = 'SUBARU'
                        elif 'MITSUBISHI' in name.upper():
                            current_manufacturer = 'MITSUBISHI'
                        elif 'RENAULT' in name.upper():
                            current_manufacturer = 'RENAULT'
                        elif 'BYD' in name.upper():
                            current_manufacturer = 'BYD'
                        elif 'GEELY' in name.upper():
                            current_manufacturer = 'GEELY'
                        elif 'CHERY' in name.upper():
                            current_manufacturer = 'CHERY'
                        elif 'GREAT WALL' in name.upper():
                            current_manufacturer = 'GREATWALL'
                        elif 'SAIC' in name.upper():
                            current_manufacturer = 'SAIC'
                        elif 'TOGG' in name.upper():
                            current_manufacturer = 'TOGG'
                        elif 'HONDA' in name.upper():
                            current_manufacturer = 'HONDA'
                        elif 'MG' in name.upper():
                            current_manufacturer = 'MG'
                    else:
                        current_manufacturer = None
                    
                    continue
                
                # Boş satırları atla
                if not name or not row.get('Mode/PID'):
                    continue
                
                # PIDEntry oluştur
                try:
                    pid_entry = PIDEntry(
                        name=name,
                        mode_pid=row.get('Mode/PID', '').strip(),
                        equation=row.get('Equation', '').strip(),
                        min_val=row.get('Min', '').strip(),
                        max_val=row.get('Max', '').strip(),
                        units=row.get('Units', '').strip(),
                        header=row.get('Header', '').strip(),
                        ecu=row.get('ECU', '').strip(),
                        description=row.get('Description', '').strip(),
                        byte_positions=row.get('BytePositions', '').strip()
                    )
                    
                    self.pid_database.append(pid_entry)
                    
                    # Üreticiye göre indeksle
                    if current_manufacturer:
                        if current_manufacturer not in self.manufacturer_pids:
                            self.manufacturer_pids[current_manufacturer] = []
                        self.manufacturer_pids[current_manufacturer].append(pid_entry)
                    
                    # ECU'ya göre indeksle
                    ecu = pid_entry.ecu
                    if ecu:
                        if ecu not in self.ecu_pids:
                            self.ecu_pids[ecu] = []
                        self.ecu_pids[ecu].append(pid_entry)
                        
                except Exception as e:
                    print(f"PID yükleme hatası (satır: {name}): {e}")
                    continue
    
    def get_pid_by_name(self, name: str, manufacturer: str = None) -> Optional[PIDEntry]:
        """
        İsme göre PID bul
        
        Args:
            name: PID adı (örn: "Battery SOC")
            manufacturer: Üretici adı (opsiyonel, arama hızlandırır)
        
        Returns:
            PIDEntry veya None
        """
        search_list = self.pid_database
        
        if manufacturer:
            manufacturer_upper = manufacturer.upper()
            # Üretici eşleştirme
            if manufacturer_upper in ['VW', 'VOLKSWAGEN', 'AUDI', 'SEAT', 'SKODA']:
                manufacturer = 'VW/AUDI'
            elif manufacturer_upper in ['BMW', 'MINI']:
                manufacturer = 'BMW'
            elif manufacturer_upper in ['MERCEDES', 'MERCEDES-BENZ', 'MB', 'SMART']:
                manufacturer = 'MERCEDES'
            elif manufacturer_upper in ['TOYOTA', 'LEXUS']:
                manufacturer = 'TOYOTA'
            elif manufacturer_upper in ['HYUNDAI', 'KIA', 'GENESIS']:
                manufacturer = 'HYUNDAI/KIA'
            elif manufacturer_upper in ['TESLA']:
                manufacturer = 'TESLA'
            elif manufacturer_upper in ['PEUGEOT', 'CITROEN', 'OPEL', 'PSA']:
                manufacturer = 'PSA'
            elif manufacturer_upper in ['TOGG']:
                manufacturer = 'TOGG'
            elif manufacturer_upper in ['HONDA']:
                manufacturer = 'HONDA'
            elif manufacturer_upper in ['MG']:
                manufacturer = 'MG'
            
            if manufacturer in self.manufacturer_pids:
                search_list = self.manufacturer_pids[manufacturer]
        
        # Arama
        name_lower = name.lower()
        for pid in search_list:
            if name_lower in pid.name.lower():
                return pid
        
        return None
    
    def get_pid_by_code(self, mode: str, pid_code: str) -> Optional[PIDEntry]:
        """
        Mode ve PID koduna göre PID bul
        
        Args:
            mode: Mode kodu (örn: "22")
            pid_code: PID kodu (örn: "015B")
        
        Returns:
            PIDEntry veya None
        """
        for pid in self.pid_database:
            pid_parts = pid.mode_pid.strip().split()
            if len(pid_parts) >= 2:
                if pid_parts[0] == mode and pid_parts[1].upper() == pid_code.upper():
                    return pid
            elif len(pid_parts) == 1 and pid_parts[0] == mode:
                return pid
        
        return None
    
    def get_pids_by_ecu(self, ecu: str) -> List[PIDEntry]:
        """
        ECU tipine göre tüm PID'leri getir
        
        Args:
            ecu: ECU tipi (örn: "BMS", "ECM", "TCM", "ABS")
        
        Returns:
            PIDEntry listesi
        """
        return self.ecu_pids.get(ecu.upper(), [])
    
    def get_pids_by_manufacturer(self, manufacturer: str) -> List[PIDEntry]:
        """
        Üreticiye göre tüm PID'leri getir
        
        Args:
            manufacturer: Üretici adı
        
        Returns:
            PIDEntry listesi
        """
        manufacturer_upper = manufacturer.upper()
        
        # Üretici eşleştirme
        if manufacturer_upper in ['VW', 'VOLKSWAGEN', 'AUDI', 'SEAT', 'SKODA']:
            manufacturer = 'VW/AUDI'
        elif manufacturer_upper in ['BMW', 'MINI']:
            manufacturer = 'BMW'
        elif manufacturer_upper in ['MERCEDES', 'MERCEDES-BENZ', 'MB', 'SMART']:
            manufacturer = 'MERCEDES'
        elif manufacturer_upper in ['TOYOTA', 'LEXUS']:
            manufacturer = 'TOYOTA'
        elif manufacturer_upper in ['HYUNDAI', 'KIA', 'GENESIS']:
            manufacturer = 'HYUNDAI/KIA'
        elif manufacturer_upper in ['TESLA']:
            manufacturer = 'TESLA'
        elif manufacturer_upper in ['PEUGEOT', 'CITROEN', 'OPEL', 'PSA']:
            manufacturer = 'PSA'
        elif manufacturer_upper in ['TOGG']:
            manufacturer = 'TOGG'
        elif manufacturer_upper in ['HONDA']:
            manufacturer = 'HONDA'
        elif manufacturer_upper in ['MG']:
            manufacturer = 'MG'
        
        return self.manufacturer_pids.get(manufacturer, [])
    
    def get_standard_pids(self) -> List[PIDEntry]:
        """Standart (üreticiye özel olmayan) PID'leri getir"""
        standard = []
        for pid in self.pid_database:
            # Üreticiye özel olmayan PID'ler
            if not any(mf in pid.name.upper() for mf in [
                'VW', 'BMW', 'MB', 'MERCEDES', 'TOYOTA', 'FORD', 'GM', 
                'NISSAN', 'HYUNDAI', 'KIA', 'TESLA', 'PSA', 'VOLVO', 
                'PORSCHE', 'JLR', 'MAZDA', 'SUBARU', 'MITSUBISHI', 
                'RENAULT', 'BYD', 'GEELY', 'CHERY', 'GREAT WALL', 'SAIC',
                'TOGG', 'HONDA', 'MG'
            ]):
                standard.append(pid)
        return standard
    
    def search_pids(self, keyword: str, ecu: str = None, manufacturer: str = None) -> List[PIDEntry]:
        """
        Anahtar kelimeye göre PID ara
        
        Args:
            keyword: Arama kelimesi
            ecu: ECU filtresi (opsiyonel)
            manufacturer: Üretici filtresi (opsiyonel)
        
        Returns:
            PIDEntry listesi
        """
        results = []
        keyword_lower = keyword.lower()
        
        search_list = self.pid_database
        
        # Filtrele
        if manufacturer:
            search_list = self.get_pids_by_manufacturer(manufacturer)
        elif ecu:
            search_list = self.get_pids_by_ecu(ecu)
        
        # Ara
        for pid in search_list:
            if (keyword_lower in pid.name.lower() or 
                keyword_lower in pid.description.lower() or
                keyword_lower in pid.ecu.lower()):
                results.append(pid)
        
        return results
    
    def get_ev_battery_pids(self, manufacturer: str = None) -> List[PIDEntry]:
        """
        EV batarya PID'lerini getir
        
        Args:
            manufacturer: Üretici adı (opsiyonel)
        
        Returns:
            EV batarya PIDEntry listesi
        """
        keywords = ['battery', 'soc', 'soh', 'cell', 'charging']
        results = []
        
        search_list = self.pid_database
        if manufacturer:
            search_list = self.get_pids_by_manufacturer(manufacturer)
        
        for pid in search_list:
            pid_lower = pid.name.lower() + " " + pid.description.lower()
            if any(kw in pid_lower for kw in keywords) and 'BMS' in pid.ecu.upper():
                results.append(pid)
        
        return results
    
    def get_engine_pids(self) -> List[PIDEntry]:
        """Motor (ECM) PID'lerini getir"""
        return self.get_pids_by_ecu('ECM')
    
    def get_transmission_pids(self) -> List[PIDEntry]:
        """Şanzıman (TCM) PID'lerini getir"""
        return self.get_pids_by_ecu('TCM')
    
    def get_abs_pids(self) -> List[PIDEntry]:
        """ABS/ESP PID'lerini getir"""
        return self.get_pids_by_ecu('ABS')
    
    def get_statistics(self) -> Dict[str, int]:
        """Veritabanı istatistiklerini getir"""
        return {
            'total_pids': len(self.pid_database),
            'manufacturers': len(self.manufacturer_pids),
            'ecus': len(self.ecu_pids),
            'ecm_pids': len(self.get_pids_by_ecu('ECM')),
            'tcm_pids': len(self.get_pids_by_ecu('TCM')),
            'bms_pids': len(self.get_pids_by_ecu('BMS')),
            'abs_pids': len(self.get_pids_by_ecu('ABS')),
            'ev_pids': len(self.get_ev_battery_pids())
        }
