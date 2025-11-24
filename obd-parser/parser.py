"""
OBD-II Data Parser
Parses OBD-II data for various EV and ICE vehicle brands
"""
import csv
import json
from typing import Dict, List, Optional, Any
from dataclasses import dataclass

@dataclass
class OBDPID:
    """OBD-II PID definition"""
    name: str
    mode_pid: str
    equation: str
    min_value: float
    max_value: float
    units: str
    header: str

class OBDParser:
    """Parse OBD-II data based on vehicle brand and model"""
    
    def __init__(self, csv_file_path: str = 'ev_unified_professional.csv'):
        self.pids_by_brand = self._load_pids_from_csv(csv_file_path)
    
    def _load_pids_from_csv(self, csv_path: str) -> Dict[str, List[OBDPID]]:
        """Load PID definitions from CSV file"""
        pids_by_brand = {}
        current_brand = None
        
        try:
            with open(csv_path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f, delimiter=';')
                
                for row in reader:
                    # Check if this is a brand header
                    name = row.get('Name', '').strip()
                    if name.startswith('===') and name.endswith('==='):
                        # Extract brand name
                        brand_name = name.replace('===', '').strip()
                        current_brand = brand_name
                        pids_by_brand[current_brand] = []
                        continue
                    
                    # Skip empty rows
                    if not name or not row.get('Mode/PID'):
                        continue
                    
                    # Create PID object
                    try:
                        pid = OBDPID(
                            name=name,
                            mode_pid=row.get('Mode/PID', '').strip(),
                            equation=row.get('Equation', '').strip(),
                            min_value=float(row.get('Min', 0) or 0),
                            max_value=float(row.get('Max', 0) or 0),
                            units=row.get('Units', '').strip(),
                            header=row.get('Header', '').strip()
                        )
                        
                        if current_brand:
                            pids_by_brand[current_brand].append(pid)
                    except (ValueError, KeyError) as e:
                        print(f"Error parsing PID {name}: {e}")
                        continue
        
        except FileNotFoundError:
            print(f"CSV file not found: {csv_path}")
        
        return pids_by_brand
    
    def parse_response(self, brand: str, mode_pid: str, raw_data: bytes) -> Optional[Dict[str, Any]]:
        """
        Parse OBD-II response data
        
        Args:
            brand: Vehicle brand (e.g., "Tesla Model S / 3 / X / Y")
            mode_pid: Mode/PID code (e.g., "22 015C")
            raw_data: Raw OBD-II response bytes
            
        Returns:
            Parsed data dictionary or None
        """
        if brand not in self.pids_by_brand:
            return None
        
        # Find matching PID
        pid = None
        for p in self.pids_by_brand[brand]:
            if p.mode_pid == mode_pid:
                pid = p
                break
        
        if not pid:
            return None
        
        # Parse raw data according to equation
        try:
            value = self._evaluate_equation(pid.equation, raw_data)
            
            # Validate range
            if pid.min_value != 0 or pid.max_value != 0:
                value = max(pid.min_value, min(pid.max_value, value))
            
            return {
                'name': pid.name,
                'value': value,
                'units': pid.units,
                'mode_pid': pid.mode_pid,
                'header': pid.header
            }
        except Exception as e:
            print(f"Error parsing data: {e}")
            return None
    
    def _evaluate_equation(self, equation: str, raw_data: bytes) -> float:
        """
        Evaluate equation with raw data
        
        Common equations:
        - A: Single byte value
        - (A*256+B)/100: Two-byte value divided by 100
        - A-40: Single byte minus offset
        """
        if len(raw_data) < 2:
            return 0.0
        
        A = raw_data[0] if len(raw_data) > 0 else 0
        B = raw_data[1] if len(raw_data) > 1 else 0
        
        # Replace equation variables
        eq = equation.replace('A', str(A)).replace('B', str(B))
        
        try:
            # Evaluate equation safely
            result = eval(eq)
            return float(result)
        except:
            return 0.0
    
    def get_available_pids(self, brand: str) -> List[str]:
        """Get list of available PIDs for a brand"""
        if brand not in self.pids_by_brand:
            return []
        
        return [pid.name for pid in self.pids_by_brand[brand]]
    
    def get_battery_data(self, brand: str, raw_responses: Dict[str, bytes]) -> Dict[str, Any]:
        """
        Extract battery-related data for EV vehicles
        
        Args:
            brand: Vehicle brand
            raw_responses: Dictionary mapping mode_pid to raw bytes
            
        Returns:
            Dictionary with battery data
        """
        battery_data = {}
        
        if brand not in self.pids_by_brand:
            return battery_data
        
        # Common battery PIDs
        battery_pids = {
            'Battery SOC': '22 015C',
            'Battery SOH': None,  # Varies by brand
            'Battery Voltage': '22 015D',
            'Battery Current': '22 015E',
            'Battery Temp': '22 015F',
        }
        
        for pid in self.pids_by_brand[brand]:
            if 'Battery' in pid.name or 'SOC' in pid.name or 'SOH' in pid.name:
                mode_pid = pid.mode_pid
                if mode_pid in raw_responses:
                    parsed = self.parse_response(brand, mode_pid, raw_responses[mode_pid])
                    if parsed:
                        battery_data[pid.name] = parsed['value']
        
        return battery_data

# Example usage
if __name__ == '__main__':
    parser = OBDParser('../ev_unified_professional.csv')
    
    # Example: Parse Tesla battery SOC
    brand = "Tesla Model S / 3 / X / Y"
    mode_pid = "22 1187"
    raw_data = bytes([0x64])  # Example: 100% SOC
    
    result = parser.parse_response(brand, mode_pid, raw_data)
    print(f"Parsed result: {result}")
    
    # Get available PIDs
    available = parser.get_available_pids(brand)
    print(f"Available PIDs for {brand}: {available}")
