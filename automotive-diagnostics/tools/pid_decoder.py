#!/usr/bin/env python3
"""
PID Decoder Tool
Converts raw OBD-II PID responses to human-readable values
"""

import struct
import argparse

class PIDDecoder:
    def __init__(self):
        self.pid_definitions = {
            0x04: {'name': 'Calculated Engine Load', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x05: {'name': 'Engine Coolant Temperature', 'formula': lambda a: a - 40, 'unit': '°C'},
            0x06: {'name': 'Short Term Fuel Trim - Bank 1', 'formula': lambda a: (a - 128) / 1.28, 'unit': '%'},
            0x07: {'name': 'Long Term Fuel Trim - Bank 1', 'formula': lambda a: (a - 128) / 1.28, 'unit': '%'},
            0x08: {'name': 'Short Term Fuel Trim - Bank 2', 'formula': lambda a: (a - 128) / 1.28, 'unit': '%'},
            0x09: {'name': 'Long Term Fuel Trim - Bank 2', 'formula': lambda a: (a - 128) / 1.28, 'unit': '%'},
            0x0A: {'name': 'Fuel Pressure', 'formula': lambda a: a * 3, 'unit': 'kPa'},
            0x0B: {'name': 'Intake Manifold Absolute Pressure', 'formula': lambda a: a, 'unit': 'kPa'},
            0x0C: {'name': 'Engine Speed', 'formula': lambda a, b: (256 * a + b) / 4, 'unit': 'rpm'},
            0x0D: {'name': 'Vehicle Speed', 'formula': lambda a: a, 'unit': 'km/h'},
            0x0E: {'name': 'Timing Advance', 'formula': lambda a: a / 2 - 64, 'unit': '°BTDC'},
            0x0F: {'name': 'Intake Air Temperature', 'formula': lambda a: a - 40, 'unit': '°C'},
            0x10: {'name': 'Mass Air Flow Rate', 'formula': lambda a, b: (256 * a + b) / 100, 'unit': 'g/s'},
            0x11: {'name': 'Throttle Position', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x13: {'name': 'Oxygen Sensors Present', 'formula': lambda a: bin(a), 'unit': 'binary'},
            0x1C: {'name': 'OBD Standards', 'formula': lambda a: self.decode_obd_standard(a), 'unit': ''},
            0x1F: {'name': 'Run Time Since Engine Start', 'formula': lambda a, b: 256 * a + b, 'unit': 'seconds'},
            0x21: {'name': 'Distance With MIL On', 'formula': lambda a, b: 256 * a + b, 'unit': 'km'},
            0x23: {'name': 'Fuel Rail Gauge Pressure', 'formula': lambda a, b: 10 * (256 * a + b), 'unit': 'kPa'},
            0x2C: {'name': 'Commanded EGR', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x2D: {'name': 'EGR Error', 'formula': lambda a: (a - 128) / 1.28, 'unit': '%'},
            0x2E: {'name': 'Commanded Evaporative Purge', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x2F: {'name': 'Fuel Tank Level Input', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x30: {'name': 'Warm-ups Since Codes Cleared', 'formula': lambda a: a, 'unit': 'count'},
            0x31: {'name': 'Distance Since Codes Cleared', 'formula': lambda a, b: 256 * a + b, 'unit': 'km'},
            0x33: {'name': 'Absolute Barometric Pressure', 'formula': lambda a: a, 'unit': 'kPa'},
            0x42: {'name': 'Control Module Voltage', 'formula': lambda a, b: (256 * a + b) / 1000, 'unit': 'V'},
            0x43: {'name': 'Absolute Load Value', 'formula': lambda a, b: (256 * a + b) / 2.55, 'unit': '%'},
            0x44: {'name': 'Fuel-Air Commanded Ratio', 'formula': lambda a, b: (256 * a + b) / 32768, 'unit': 'ratio'},
            0x45: {'name': 'Relative Throttle Position', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x46: {'name': 'Ambient Air Temperature', 'formula': lambda a: a - 40, 'unit': '°C'},
            0x47: {'name': 'Absolute Throttle Position B', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x48: {'name': 'Absolute Throttle Position C', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x49: {'name': 'Accelerator Pedal Position D', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x4A: {'name': 'Accelerator Pedal Position E', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x4B: {'name': 'Accelerator Pedal Position F', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x4C: {'name': 'Commanded Throttle Actuator', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x4D: {'name': 'Time Run With MIL On', 'formula': lambda a, b: 256 * a + b, 'unit': 'minutes'},
            0x4E: {'name': 'Time Since Trouble Codes Cleared', 'formula': lambda a, b: 256 * a + b, 'unit': 'minutes'},
            0x51: {'name': 'Fuel Type', 'formula': lambda a: self.decode_fuel_type(a), 'unit': ''},
            0x52: {'name': 'Ethanol Fuel %', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x53: {'name': 'Absolute Evap System Vapor Pressure', 'formula': lambda a, b: (256 * a + b) / 200, 'unit': 'kPa'},
            0x59: {'name': 'Fuel Rail Absolute Pressure', 'formula': lambda a, b: 10 * (256 * a + b), 'unit': 'kPa'},
            0x5A: {'name': 'Relative Accelerator Pedal Position', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x5B: {'name': 'Hybrid Battery Pack Remaining Life', 'formula': lambda a: a / 2.55, 'unit': '%'},
            0x5C: {'name': 'Engine Oil Temperature', 'formula': lambda a: a - 40, 'unit': '°C'},
            0x5D: {'name': 'Fuel Injection Timing', 'formula': lambda a, b: ((256 * a + b) / 128) - 210, 'unit': '°'},
            0x5E: {'name': 'Engine Fuel Rate', 'formula': lambda a, b: (256 * a + b) / 20, 'unit': 'L/h'},
        }
    
    def decode_obd_standard(self, value):
        standards = {
            1: 'OBD-II as defined by CARB',
            2: 'OBD as defined by EPA',
            3: 'OBD and OBD-II',
            4: 'OBD-I',
            5: 'Not OBD compliant',
            6: 'EOBD (Europe)',
            7: 'EOBD and OBD-II',
            8: 'EOBD and OBD',
            9: 'EOBD, OBD and OBD-II',
            10: 'JOBD (Japan)',
            11: 'JOBD and OBD-II',
            12: 'JOBD and EOBD',
            13: 'JOBD, EOBD and OBD-II',
            14: 'Reserved',
            15: 'Reserved',
            16: 'Reserved',
            17: 'Engine Manufacturer Diagnostics',
            18: 'Engine Manufacturer Diagnostics Enhanced',
            19: 'Heavy Duty OBD-C',
            20: 'Heavy Duty OBD',
            21: 'WWH-OBD',
            22: 'Reserved',
            23: 'Heavy Duty EURO IV',
            24: 'Reserved',
            25: 'Heavy Duty EURO V',
            26: 'Reserved',
            27: 'Heavy Duty EURO VI',
            28: 'OBDonUDS',
            29: 'Reserved',
            30: 'Reserved',
            31: 'Reserved',
            32: 'Reserved',
            33: 'Heavy Duty EURO IV/V/VI',
        }
        return standards.get(value, f'Unknown ({value})')
    
    def decode_fuel_type(self, value):
        fuel_types = {
            0: 'Not available',
            1: 'Gasoline',
            2: 'Methanol',
            3: 'Ethanol',
            4: 'Diesel',
            5: 'LPG',
            6: 'CNG',
            7: 'Propane',
            8: 'Electric',
            9: 'Bifuel running Gasoline',
            10: 'Bifuel running Methanol',
            11: 'Bifuel running Ethanol',
            12: 'Bifuel running LPG',
            13: 'Bifuel running CNG',
            14: 'Bifuel running Propane',
            15: 'Bifuel running Electric',
            16: 'Bifuel running electric and combustion',
            17: 'Hybrid gasoline',
            18: 'Hybrid ethanol',
            19: 'Hybrid diesel',
            20: 'Hybrid electric',
            21: 'Hybrid running electric and combustion',
            22: 'Hybrid regenerative',
            23: 'Bifuel running diesel',
        }
        return fuel_types.get(value, f'Unknown ({value})')
    
    def decode_pid(self, pid, data_bytes):
        """Decode a PID response"""
        if pid not in self.pid_definitions:
            return f"PID 0x{pid:02X}: Unknown PID"
        
        pid_def = self.pid_definitions[pid]
        
        try:
            # Determine number of parameters the formula expects
            if pid_def['formula'].__code__.co_argcount == 1:
                value = pid_def['formula'](data_bytes[0])
            elif pid_def['formula'].__code__.co_argcount == 2:
                value = pid_def['formula'](data_bytes[0], data_bytes[1])
            elif pid_def['formula'].__code__.co_argcount == 3:
                value = pid_def['formula'](data_bytes[0], data_bytes[1], data_bytes[2])
            elif pid_def['formula'].__code__.co_argcount == 4:
                value = pid_def['formula'](data_bytes[0], data_bytes[1], data_bytes[2], data_bytes[3])
            else:
                return f"PID 0x{pid:02X}: Unsupported formula"
            
            if isinstance(value, float):
                return f"{pid_def['name']}: {value:.2f} {pid_def['unit']}"
            else:
                return f"{pid_def['name']}: {value} {pid_def['unit']}"
                
        except Exception as e:
            return f"PID 0x{pid:02X}: Error decoding - {str(e)}"
    
    def decode_can_message(self, can_id, data):
        """Decode a CAN message containing PID response"""
        if len(data) < 3:
            return "Invalid CAN message"
        
        # Check if this is a response (mode + 0x40)
        if data[0] != 0x41:
            return "Not a Mode 01 PID response"
        
        pid = data[1]
        pid_data = data[2:]
        
        return self.decode_pid(pid, pid_data)
    
    def decode_dtc(self, dtc_bytes):
        """Decode Diagnostic Trouble Code"""
        if len(dtc_bytes) < 2:
            return "Invalid DTC"
        
        # First byte contains the system and first digit
        systems = ['P', 'C', 'B', 'U']
        system = systems[(dtc_bytes[0] & 0xC0) >> 6]
        first_digit = (dtc_bytes[0] & 0x30) >> 4
        
        # Remaining 12 bits are the code
        code = ((dtc_bytes[0] & 0x0F) << 8) | dtc_bytes[1]
        
        return f"{system}{first_digit:01X}{code:03X}"

def main():
    parser = argparse.ArgumentParser(description='Decode OBD-II PID responses')
    parser.add_argument('--pid', type=str, help='PID in hex (e.g., 0C for RPM)')
    parser.add_argument('--data', type=str, help='Response data bytes in hex (e.g., "1A F8")')
    parser.add_argument('--can', type=str, help='Full CAN message in hex (e.g., "41 0C 1A F8")')
    parser.add_argument('--dtc', type=str, help='DTC bytes in hex (e.g., "01 33" for P0133)')
    parser.add_argument('--list', action='store_true', help='List all supported PIDs')
    
    args = parser.parse_args()
    decoder = PIDDecoder()
    
    if args.list:
        print("\nSupported PIDs:")
        print("-" * 60)
        for pid, info in sorted(decoder.pid_definitions.items()):
            print(f"0x{pid:02X}: {info['name']}")
        return
    
    if args.dtc:
        dtc_bytes = [int(b, 16) for b in args.dtc.split()]
        print(decoder.decode_dtc(dtc_bytes))
        return
    
    if args.can:
        can_bytes = [int(b, 16) for b in args.can.split()]
        print(decoder.decode_can_message(0x7E8, can_bytes))
        return
    
    if args.pid and args.data:
        pid = int(args.pid, 16)
        data_bytes = [int(b, 16) for b in args.data.split()]
        print(decoder.decode_pid(pid, data_bytes))
        return
    
    # Interactive mode
    print("OBD-II PID Decoder - Interactive Mode")
    print("Enter 'quit' to exit, 'list' to show PIDs, or 'help' for usage")
    print("-" * 60)
    
    while True:
        try:
            cmd = input("\nCommand: ").strip().lower()
            
            if cmd == 'quit':
                break
            elif cmd == 'list':
                print("\nSupported PIDs:")
                for pid, info in sorted(decoder.pid_definitions.items()):
                    print(f"0x{pid:02X}: {info['name']}")
            elif cmd == 'help':
                print("\nUsage:")
                print("  pid <hex> <data bytes>  - Decode PID response")
                print("  can <hex bytes>         - Decode CAN message")
                print("  dtc <hex bytes>         - Decode DTC")
                print("  list                    - List supported PIDs")
                print("  quit                    - Exit")
            elif cmd.startswith('pid '):
                parts = cmd.split()
                if len(parts) >= 3:
                    pid = int(parts[1], 16)
                    data_bytes = [int(b, 16) for b in parts[2:]]
                    print(decoder.decode_pid(pid, data_bytes))
            elif cmd.startswith('can '):
                parts = cmd.split()
                if len(parts) >= 2:
                    can_bytes = [int(b, 16) for b in parts[1:]]
                    print(decoder.decode_can_message(0x7E8, can_bytes))
            elif cmd.startswith('dtc '):
                parts = cmd.split()
                if len(parts) >= 2:
                    dtc_bytes = [int(b, 16) for b in parts[1:]]
                    print(decoder.decode_dtc(dtc_bytes))
            else:
                print("Unknown command. Type 'help' for usage.")
                
        except ValueError as e:
            print(f"Error: Invalid input - {e}")
        except KeyboardInterrupt:
            print("\nExiting...")
            break

if __name__ == "__main__":
    main()