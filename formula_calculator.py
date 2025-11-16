"""
Formül Hesaplayıcı Modülü
UDS cevaplarını formüllere göre işleyip anlamlı veriye çevirir
"""

import re
import math
from typing import Optional, Union, List, Dict, Any
from pid_router import PIDEntry


class FormulaCalculator:
    """UDS cevaplarını formüllere göre hesaplayan sınıf"""
    
    def __init__(self):
        """Hesaplayıcıyı başlat"""
        self.byte_cache: Dict[str, int] = {}
    
    def calculate(self, pid_entry: PIDEntry, response_bytes: List[int]) -> Optional[Union[float, int, str]]:
        """
        UDS cevabını formüle göre hesapla
        
        Args:
            pid_entry: PIDEntry nesnesi
            response_bytes: UDS'den gelen ham byte listesi (örn: [0x62, 0x10, 0x5B, 0x8C])
        
        Returns:
            Hesaplanmış değer (float, int veya string)
        
        Örnek:
            response = [0x62, 0x10, 0x5B, 0x8C]
            # 0x62 = positive response (atla)
            # 0x10 0x5B = echo (atla)
            # 0x8C = gerçek veri (140 decimal)
            # Formül: A (140 * 100 / 255 = 54.9%)
        """
        if not response_bytes or len(response_bytes) < 3:
            return None
        
        try:
            # UDS positive response kontrolü
            # Format: [0x62, service_echo, pid_byte1, pid_byte2, data...]
            if response_bytes[0] == 0x62:
                # Positive response, echo'yu atla
                data_start = 3  # 0x62 + service + pid
            elif response_bytes[0] == 0x7F:
                # Negative response
                return None
            else:
                # Direkt veri
                data_start = 0
            
            # Byte pozisyonlarını parse et
            byte_positions = self._parse_byte_positions(pid_entry.byte_positions)
            
            # Byte değerlerini al
            byte_values = {}
            for pos, idx in byte_positions.items():
                if data_start + idx < len(response_bytes):
                    byte_values[pos] = response_bytes[data_start + idx]
                else:
                    byte_values[pos] = 0
            
            # Formülü hesapla
            result = self._evaluate_formula(pid_entry.equation, byte_values)
            
            # Min/Max kontrolü (opsiyonel)
            if pid_entry.min_val and pid_entry.max_val:
                try:
                    min_val = float(pid_entry.min_val)
                    max_val = float(pid_entry.max_val)
                    if isinstance(result, (int, float)):
                        result = max(min_val, min(max_val, result))
                except ValueError:
                    pass
            
            return result
            
        except Exception as e:
            print(f"Hesaplama hatası ({pid_entry.name}): {e}")
            return None
    
    def _parse_byte_positions(self, byte_positions_str: str) -> Dict[str, int]:
        """
        Byte pozisyonlarını parse et
        
        Args:
            byte_positions_str: "A-B" veya "A-B-C-D" formatında string
        
        Returns:
            {'A': 0, 'B': 1, ...} formatında dict
        """
        positions = {}
        parts = byte_positions_str.upper().replace(' ', '').split('-')
        
        for i, part in enumerate(parts):
            if part:
                positions[part] = i
        
        return positions
    
    def _evaluate_formula(self, formula: str, byte_values: Dict[str, int]) -> Union[float, int, str]:
        """
        Formülü değerlendir
        
        Args:
            formula: Formül string'i (örn: "A*100/255", "(A*256+B)/100")
            byte_values: Byte değerleri dict'i
        
        Returns:
            Hesaplanmış değer
        """
        if not formula or formula.strip() == '':
            # Formül yoksa ilk byte'ı döndür
            return byte_values.get('A', 0)
        
        # Özel durumlar
        formula_upper = formula.upper().strip()
        
        if formula_upper == 'ASCII':
            # ASCII string
            return self._decode_ascii(byte_values)
        elif formula_upper == 'BIT ENCODED' or formula_upper == 'BIT':
            # Bit encoded
            return byte_values.get('A', 0)
        elif formula_upper == 'RAW DATA' or formula_upper == 'HEX':
            # Ham hex data
            return self._format_hex(byte_values)
        elif formula_upper == 'DATE':
            # Tarih formatı
            return self._decode_date(byte_values)
        elif 'RANDOM' in formula_upper or 'CALCULATED' in formula_upper:
            # Rastgele veya hesaplanmış değer
            return byte_values.get('A', 0)
        
        # Matematiksel formül
        try:
            # Formüldeki değişkenleri byte değerleriyle değiştir
            formula_processed = formula
            
            # Byte değerlerini yerleştir (A, B, C, D)
            for byte_name in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']:
                value = byte_values.get(byte_name, 0)
                # Regex ile güvenli değiştirme
                pattern = r'\b' + byte_name + r'\b'
                formula_processed = re.sub(pattern, str(value), formula_processed)
            
            # Güvenli eval (sadece matematiksel işlemler)
            # Tehlikeli fonksiyonları kaldır
            allowed_names = {
                "__builtins__": {},
                "abs": abs,
                "max": max,
                "min": min,
                "round": round,
                "int": int,
                "float": float,
                "math": math,
                "sqrt": math.sqrt,
                "sin": math.sin,
                "cos": math.cos,
                "tan": math.tan,
                "pi": math.pi,
                "e": math.e
            }
            
            result = eval(formula_processed, allowed_names)
            
            # Sonucu uygun formata çevir
            if isinstance(result, float):
                # Çok küçük değerleri 0 yap
                if abs(result) < 1e-10:
                    result = 0.0
                # Gereksiz ondalık basamakları temizle
                if result.is_integer():
                    return int(result)
            
            return result
            
        except Exception as e:
            print(f"Formül hesaplama hatası ({formula}): {e}")
            # Hata durumunda ilk byte'ı döndür
            return byte_values.get('A', 0)
    
    def _decode_ascii(self, byte_values: Dict[str, int]) -> str:
        """ASCII byte'ları string'e çevir"""
        chars = []
        for byte_name in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']:
            value = byte_values.get(byte_name, 0)
            if 32 <= value <= 126:  # Yazdırılabilir ASCII
                chars.append(chr(value))
            elif value == 0:
                break
        return ''.join(chars).strip()
    
    def _format_hex(self, byte_values: Dict[str, int]) -> str:
        """Byte'ları hex string'e çevir"""
        hex_parts = []
        for byte_name in ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H']:
            value = byte_values.get(byte_name)
            if value is not None:
                hex_parts.append(f"{value:02X}")
        return ' '.join(hex_parts)
    
    def _decode_date(self, byte_values: Dict[str, int]) -> str:
        """Tarih byte'larını decode et"""
        # Basit tarih formatı (byte formatına göre değişebilir)
        year = byte_values.get('A', 0) + 2000
        month = byte_values.get('B', 0)
        day = byte_values.get('C', 0)
        return f"{year:04d}-{month:02d}-{day:02d}"
    
    def format_value(self, value: Union[float, int, str], units: str, pid_entry: PIDEntry) -> str:
        """
        Değeri formatla ve birimle birlikte göster
        
        Args:
            value: Hesaplanmış değer
            units: Birim (örn: "°C", "%", "V")
            pid_entry: PIDEntry nesnesi
        
        Returns:
            Formatlanmış string (örn: "54.9%", "25.5°C")
        """
        if value is None:
            return "N/A"
        
        if isinstance(value, str):
            return value
        
        # Birim formatlaması
        if units == '%':
            return f"{value:.1f}%"
        elif units == '°C' or units == '°F':
            return f"{value:.1f}{units}"
        elif units == 'V':
            return f"{value:.2f}V"
        elif units == 'A':
            return f"{value:.2f}A"
        elif units == 'kW':
            return f"{value:.2f}kW"
        elif units == 'kWh':
            return f"{value:.2f}kWh"
        elif units == 'rpm':
            if value.is_integer():
                return f"{int(value)}rpm"
            return f"{value:.1f}rpm"
        elif units == 'km/h':
            return f"{value:.1f}km/h"
        elif units == 'kPa' or units == 'bar':
            return f"{value:.2f}{units}"
        elif units == 'Nm':
            return f"{int(value)}Nm"
        elif units == 'Count':
            return f"{int(value)}"
        elif units == 'Status':
            return f"{int(value)}"
        else:
            # Genel format
            if isinstance(value, float):
                if value.is_integer():
                    return f"{int(value)}{units}"
                return f"{value:.2f}{units}"
            return f"{value}{units}"
    
    def calculate_with_formatting(self, pid_entry: PIDEntry, response_bytes: List[int]) -> Optional[str]:
        """
        Hesapla ve formatla (tek adımda)
        
        Args:
            pid_entry: PIDEntry nesnesi
            response_bytes: UDS cevap byte'ları
        
        Returns:
            Formatlanmış string (örn: "54.9%")
        """
        value = self.calculate(pid_entry, response_bytes)
        if value is None:
            return None
        
        return self.format_value(value, pid_entry.units, pid_entry)
