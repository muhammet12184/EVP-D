"""
Formül Hesaplayıcı Modülü
UDS cevaplarını (ham byte'lar) formüllere göre anlamlı değerlere çevirir.
"""

import re
import math
from typing import Optional, List, Union, Dict, Any
from pid_database import PIDEntry


class FormulaCalculator:
    """UDS cevaplarını formüllere göre hesaplayan sınıf"""
    
    def __init__(self):
        """Hesaplayıcıyı başlat"""
        pass
    
    def calculate(self, pid_entry: PIDEntry, raw_bytes: List[int]) -> Optional[Dict[str, Any]]:
        """
        Ham byte'ları formüle göre hesapla
        
        Args:
            pid_entry: PIDEntry nesnesi
            raw_bytes: Ham byte listesi (örn: [0x8C, 0x00, 0x00])
        
        Returns:
            Hesaplanmış değer sözlüğü veya None
        """
        if not raw_bytes or len(raw_bytes) == 0:
            return None
        
        try:
            # Byte pozisyonlarını parse et
            byte_positions = self._parse_byte_positions(pid_entry.byte_position)
            
            # Formülü hesapla
            equation = pid_entry.equation.strip()
            if not equation or equation == "Bit encoded" or equation == "ASCII" or equation == "Hex" or equation == "Date":
                # Özel formatlar
                return self._handle_special_formats(pid_entry, raw_bytes)
            
            # Matematiksel formülü hesapla
            value = self._evaluate_formula(equation, raw_bytes, byte_positions)
            
            # Min/Max kontrolü
            if pid_entry.min_val is not None and pid_entry.max_val is not None:
                value = max(pid_entry.min_val, min(pid_entry.max_val, value))
            
            # Sonucu formatla
            result = {
                'name': pid_entry.name,
                'value': value,
                'units': pid_entry.units,
                'raw_bytes': raw_bytes,
                'formula': equation,
                'formatted': self._format_value(value, pid_entry.units)
            }
            
            return result
            
        except Exception as e:
            print(f"Hesaplama hatası ({pid_entry.name}): {e}")
            return None
    
    def _parse_byte_positions(self, byte_position: str) -> Dict[str, int]:
        """
        Byte pozisyonlarını parse et
        
        Args:
            byte_position: Byte pozisyon string'i (örn: "A", "A;B", "A;B;C")
        
        Returns:
            Byte pozisyon sözlüğü (örn: {"A": 0, "B": 1})
        """
        positions = {}
        parts = byte_position.split(';')
        
        for i, part in enumerate(parts):
            part = part.strip().upper()
            if part:
                positions[part] = i
        
        return positions
    
    def _evaluate_formula(self, equation: str, raw_bytes: List[int], byte_positions: Dict[str, int]) -> float:
        """
        Formülü hesapla
        
        Args:
            equation: Formül string'i (örn: "A*100/255", "(A*256+B)/10")
            raw_bytes: Ham byte listesi
            byte_positions: Byte pozisyon sözlüğü
        
        Returns:
            Hesaplanmış değer
        """
        # Güvenli bir ortam oluştur
        safe_dict = {
            'A': raw_bytes[byte_positions.get('A', 0)] if len(raw_bytes) > byte_positions.get('A', 0) else 0,
            'B': raw_bytes[byte_positions.get('B', 1)] if len(raw_bytes) > byte_positions.get('B', 1) else 0,
            'C': raw_bytes[byte_positions.get('C', 2)] if len(raw_bytes) > byte_positions.get('C', 2) else 0,
            'D': raw_bytes[byte_positions.get('D', 3)] if len(raw_bytes) > byte_positions.get('D', 3) else 0,
            'E': raw_bytes[byte_positions.get('E', 4)] if len(raw_bytes) > byte_positions.get('E', 4) else 0,
            'F': raw_bytes[byte_positions.get('F', 5)] if len(raw_bytes) > byte_positions.get('F', 5) else 0,
            '__builtins__': {},
            'abs': abs,
            'max': max,
            'min': min,
            'round': round,
            'int': int,
            'float': float,
            'math': math,
        }
        
        # Formülü güvenli şekilde çalıştır
        try:
            result = eval(equation, safe_dict)
            return float(result)
        except Exception as e:
            raise ValueError(f"Formül hesaplama hatası: {e}")
    
    def _handle_special_formats(self, pid_entry: PIDEntry, raw_bytes: List[int]) -> Optional[Dict[str, Any]]:
        """
        Özel formatları işle (Bit encoded, ASCII, Hex, Date)
        
        Args:
            pid_entry: PIDEntry nesnesi
            raw_bytes: Ham byte listesi
        
        Returns:
            Özel format sonucu
        """
        equation = pid_entry.equation.strip()
        
        if equation == "Bit encoded":
            # Bit encoded değer
            value = raw_bytes[0] if raw_bytes else 0
            return {
                'name': pid_entry.name,
                'value': value,
                'units': pid_entry.units,
                'raw_bytes': raw_bytes,
                'formula': 'Bit encoded',
                'formatted': f"{value} ({pid_entry.units})"
            }
        
        elif equation == "ASCII":
            # ASCII string
            try:
                text = ''.join([chr(b) for b in raw_bytes if 32 <= b <= 126])
                return {
                    'name': pid_entry.name,
                    'value': text,
                    'units': pid_entry.units,
                    'raw_bytes': raw_bytes,
                    'formula': 'ASCII',
                    'formatted': text
                }
            except:
                return None
        
        elif equation == "Hex":
            # Hex string
            hex_str = ' '.join([f"{b:02X}" for b in raw_bytes])
            return {
                'name': pid_entry.name,
                'value': hex_str,
                'units': pid_entry.units,
                'raw_bytes': raw_bytes,
                'formula': 'Hex',
                'formatted': hex_str
            }
        
        elif equation == "Date":
            # Tarih formatı (basit)
            # Gerçek uygulamada daha gelişmiş parsing gerekebilir
            value = raw_bytes[0] if raw_bytes else 0
            return {
                'name': pid_entry.name,
                'value': value,
                'units': pid_entry.units,
                'raw_bytes': raw_bytes,
                'formula': 'Date',
                'formatted': f"Date code: {value}"
            }
        
        else:
            # Bilinmeyen format, raw değeri döndür
            value = raw_bytes[0] if raw_bytes else 0
            return {
                'name': pid_entry.name,
                'value': value,
                'units': pid_entry.units,
                'raw_bytes': raw_bytes,
                'formula': 'Unknown',
                'formatted': f"{value} ({pid_entry.units})"
            }
    
    def _format_value(self, value: float, units: str) -> str:
        """
        Değeri formatla
        
        Args:
            value: Hesaplanmış değer
            units: Birim
        
        Returns:
            Formatlanmış string
        """
        # Ondalık basamak sayısını belirle
        if abs(value) >= 1000:
            decimals = 1
        elif abs(value) >= 100:
            decimals = 2
        elif abs(value) >= 10:
            decimals = 2
        else:
            decimals = 3
        
        formatted = f"{value:.{decimals}f}"
        
        # Birim ekle
        if units:
            formatted += f" {units}"
        
        return formatted
    
    def calculate_multiple(self, pid_entries: List[PIDEntry], raw_bytes: List[int]) -> List[Dict[str, Any]]:
        """
        Birden fazla PID için hesaplama yap (aynı cevaptan birden fazla değer çıkar)
        
        Args:
            pid_entries: PIDEntry listesi
            raw_bytes: Ham byte listesi
        
        Returns:
            Hesaplanmış değer listesi
        """
        results = []
        
        for pid_entry in pid_entries:
            result = self.calculate(pid_entry, raw_bytes)
            if result:
                results.append(result)
        
        return results


# Örnek kullanım
if __name__ == "__main__":
    from pid_database import PIDEntry
    
    calculator = FormulaCalculator()
    
    # Örnek PID
    pid = PIDEntry(
        name="Battery SOC",
        mode_pid="22 015C",
        equation="A",
        min_val=0,
        max_val=100,
        units="%",
        header="7E4",
        ecu="BMS",
        byte_position="A",
        description="Battery state of charge"
    )
    
    # Örnek raw bytes (SOC = 75%)
    raw_bytes = [0x4B]  # 75 decimal = 0x4B hex
    
    result = calculator.calculate(pid, raw_bytes)
    if result:
        print(f"Sonuç: {result['formatted']}")
