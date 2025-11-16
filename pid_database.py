"""
PID Veritabanı Yönlendiricisi
CSV dosyasından PID'leri okur ve markaya göre doğru PID'i seçer.
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
    min_val: float
    max_val: float
    units: str
    header: str
    ecu: str
    byte_position: str
    description: str
    
    def get_did(self) -> str:
        """UDS Mode 22 için DID'i döndür"""
        # Mode/PID formatından DID'i çıkar
        # Örnek: "22 015B" -> "015B"
        parts = self.mode_pid.split()
        if len(parts) >= 2:
            return parts[1]
        return ""
    
    def get_mode(self) -> str:
        """Mode'u döndür (01, 09, 22, vb.)"""
        parts = self.mode_pid.split()
        if len(parts) >= 1:
            return parts[0]
        return ""


class PIDDatabase:
    """PID veritabanı ve yönlendirici"""
    
    def __init__(self, csv_file: str = "ev_unified_professional.csv"):
        """
        Args:
            csv_file: PID CSV dosyası yolu
        """
        self.csv_file = csv_file
        self.pids: List[PIDEntry] = []
        self.pid_index: Dict[str, List[PIDEntry]] = {}  # name -> [PIDEntry]
        self.brand_index: Dict[str, List[PIDEntry]] = {}  # brand -> [PIDEntry]
        self.ecu_index: Dict[str, List[PIDEntry]] = {}  # ecu -> [PIDEntry]
        self.did_index: Dict[str, PIDEntry] = {}  # did -> PIDEntry
        
        self._load_database()
    
    def _load_database(self):
        """CSV dosyasından PID'leri yükle"""
        if not os.path.exists(self.csv_file):
            raise FileNotFoundError(f"PID dosyası bulunamadı: {self.csv_file}")
        
        current_brand = None
        
        with open(self.csv_file, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f, delimiter=';')
            
            for row in reader:
                # Kategori satırlarını kontrol et (=== ... ===)
                name = row.get('Name', '').strip()
                if name.startswith('===') and name.endswith('==='):
                    # Marka/kategori bilgisini çıkar
                    current_brand = name.replace('===', '').strip()
                    continue
                
                # Boş satırları atla
                if not name or not row.get('Mode/PID', '').strip():
                    continue
                
                try:
                    # PIDEntry oluştur
                    pid = PIDEntry(
                        name=name,
                        mode_pid=row.get('Mode/PID', '').strip(),
                        equation=row.get('Equation', '').strip(),
                        min_val=self._parse_float(row.get('Min', '0')),
                        max_val=self._parse_float(row.get('Max', '255')),
                        units=row.get('Units', '').strip(),
                        header=row.get('Header', '7E0').strip(),
                        ecu=row.get('ECU', 'ECM').strip(),
                        byte_position=row.get('Byte Position', 'A').strip(),
                        description=row.get('Description', '').strip()
                    )
                    
                    self.pids.append(pid)
                    
                    # İndeksleme
                    # Name index
                    if pid.name not in self.pid_index:
                        self.pid_index[pid.name] = []
                    self.pid_index[pid.name].append(pid)
                    
                    # Brand index
                    if current_brand:
                        if current_brand not in self.brand_index:
                            self.brand_index[current_brand] = []
                        self.brand_index[current_brand].append(pid)
                    
                    # ECU index
                    if pid.ecu:
                        if pid.ecu not in self.ecu_index:
                            self.ecu_index[pid.ecu] = []
                        self.ecu_index[pid.ecu].append(pid)
                    
                    # DID index (UDS Mode 22 için)
                    if pid.get_mode() == "22":
                        did = pid.get_did()
                        if did:
                            # Aynı DID için birden fazla PID olabilir (farklı markalar)
                            # Bu durumda brand'e göre seçim yapılacak
                            if did not in self.did_index:
                                self.did_index[did] = pid
                            # Eğer brand match ediyorsa, onu kullan
                            if current_brand and did in self.did_index:
                                # Brand match kontrolü yapılabilir
                                pass
                
                except Exception as e:
                    print(f"PID yükleme hatası ({name}): {e}")
                    continue
        
        print(f"Toplam {len(self.pids)} PID yüklendi")
        print(f"Marka sayısı: {len(self.brand_index)}")
        print(f"ECU sayısı: {len(self.ecu_index)}")
    
    def _parse_float(self, value: str) -> float:
        """String'i float'a çevir"""
        try:
            return float(value) if value else 0.0
        except:
            return 0.0
    
    def find_pid_by_name(self, name: str, brand: str = None) -> Optional[PIDEntry]:
        """
        İsme göre PID bul
        
        Args:
            name: PID adı (örn: "Battery SOC")
            brand: Marka (opsiyonel, öncelik verir)
        
        Returns:
            PIDEntry veya None
        """
        if name in self.pid_index:
            pids = self.pid_index[name]
            
            # Eğer brand belirtilmişse, önce brand'e göre filtrele
            if brand:
                for pid in pids:
                    # Brand bilgisini kontrol et (kategori satırından)
                    # Basit bir kontrol: brand adı PID'in bulunduğu kategoride mi?
                    if brand.lower() in str(pid).lower():
                        return pid
            
            # İlk eşleşmeyi döndür
            return pids[0] if pids else None
        
        return None
    
    def find_pid_by_did(self, did: str, brand: str = None) -> Optional[PIDEntry]:
        """
        DID'e göre PID bul
        
        Args:
            did: Data Identifier (örn: "015B", "015C")
            brand: Marka (opsiyonel)
        
        Returns:
            PIDEntry veya None
        """
        # DID'i normalize et
        did = did.upper().strip()
        if len(did) == 2:
            did = '00' + did
        elif len(did) == 3:
            did = '0' + did
        
        # DID index'te ara
        if did in self.did_index:
            return self.did_index[did]
        
        # Tüm PID'lerde ara
        for pid in self.pids:
            if pid.get_mode() == "22" and pid.get_did() == did:
                return pid
        
        return None
    
    def find_pid_by_mode_pid(self, mode: str, pid_code: str, brand: str = None) -> Optional[PIDEntry]:
        """
        Mode ve PID koduna göre bul
        
        Args:
            mode: Mode (örn: "01", "09", "22")
            pid_code: PID kodu (örn: "0C", "015B")
            brand: Marka (opsiyonel)
        
        Returns:
            PIDEntry veya None
        """
        for pid_entry in self.pids:
            if pid_entry.get_mode() == mode:
                if mode == "22":
                    # UDS Mode 22 için DID kontrolü
                    if pid_entry.get_did() == pid_code.upper():
                        return pid_entry
                else:
                    # OBD-II için PID kontrolü
                    parts = pid_entry.mode_pid.split()
                    if len(parts) >= 2 and parts[1].upper() == pid_code.upper():
                        return pid_entry
        
        return None
    
    def get_pids_by_brand(self, brand: str) -> List[PIDEntry]:
        """
        Markaya göre tüm PID'leri getir
        
        Args:
            brand: Marka adı (örn: "TOGG", "Tesla", "Hyundai")
        
        Returns:
            PIDEntry listesi
        """
        brand_lower = brand.lower()
        result = []
        
        for brand_key, pids in self.brand_index.items():
            if brand_lower in brand_key.lower():
                result.extend(pids)
        
        return result
    
    def get_pids_by_ecu(self, ecu: str) -> List[PIDEntry]:
        """
        ECU'ya göre PID'leri getir
        
        Args:
            ecu: ECU türü (örn: "BMS", "ECM", "TCM", "ABS")
        
        Returns:
            PIDEntry listesi
        """
        return self.ecu_index.get(ecu.upper(), [])
    
    def get_smart_pid(self, name: str, brand: str = None, ecu: str = None) -> Optional[PIDEntry]:
        """
        Akıllı PID seçici: Marka ve ECU'ya göre en uygun PID'i seçer
        
        Args:
            name: PID adı (örn: "Battery SOC")
            brand: Marka (örn: "TOGG", "Tesla")
            ecu: ECU türü (opsiyonel)
        
        Returns:
            En uygun PIDEntry veya None
        """
        # Önce isme göre bul
        candidates = self.pid_index.get(name, [])
        
        if not candidates:
            return None
        
        # Eğer tek aday varsa, onu döndür
        if len(candidates) == 1:
            return candidates[0]
        
        # Marka ve ECU'ya göre filtrele
        best_match = None
        best_score = 0
        
        for pid in candidates:
            score = 0
            
            # Marka eşleşmesi
            if brand:
                # Brand bilgisini PID'in kategorisinde ara
                # Bu basit bir kontrol, gerçek uygulamada daha gelişmiş olabilir
                for brand_key in self.brand_index.keys():
                    if brand.lower() in brand_key.lower() and pid in self.brand_index[brand_key]:
                        score += 10
                        break
            
            # ECU eşleşmesi
            if ecu and pid.ecu.upper() == ecu.upper():
                score += 5
            
            if score > best_score:
                best_score = score
                best_match = pid
        
        # En iyi eşleşmeyi döndür veya ilk adayı
        return best_match if best_match else candidates[0]
    
    def get_all_pids(self) -> List[PIDEntry]:
        """Tüm PID'leri döndür"""
        return self.pids.copy()


# Örnek kullanım
if __name__ == "__main__":
    db = PIDDatabase()
    
    # TOGG için Battery SOC bul
    pid = db.get_smart_pid("Battery SOC", brand="TOGG")
    if pid:
        print(f"PID bulundu: {pid.name}")
        print(f"Mode/PID: {pid.mode_pid}")
        print(f"DID: {pid.get_did()}")
        print(f"Header: {pid.header}")
        print(f"Equation: {pid.equation}")
