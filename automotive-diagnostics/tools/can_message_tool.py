#!/usr/bin/env python3
"""
CAN Message Tool - Decode and Build CAN Messages for Automotive Diagnostics

This tool helps with:
- Building CAN messages for diagnostics
- Decoding CAN frames
- ISO-TP multi-frame handling
- CAN ID analysis (standard/extended)
- Common automotive CAN protocols
"""

import argparse
import sys
from typing import List, Dict, Tuple, Optional, Union
from enum import Enum

class CANFrameType(Enum):
    """ISO-TP Frame Types"""
    SINGLE_FRAME = 0x00
    FIRST_FRAME = 0x10
    CONSECUTIVE_FRAME = 0x20
    FLOW_CONTROL = 0x30

class CANMessageTool:
    def __init__(self):
        # Common diagnostic CAN IDs
        self.common_can_ids = {
            # Standard OBD-II
            0x7DF: 'OBD-II Broadcast Request',
            0x7E0: 'Engine ECU Request',
            0x7E8: 'Engine ECU Response',
            0x7E1: 'Transmission Request',
            0x7E9: 'Transmission Response',
            0x7E2: 'Chassis/ABS Request',
            0x7EA: 'Chassis/ABS Response',
            0x7E3: 'Body/Accessories Request',
            0x7EB: 'Body/Accessories Response',
            0x7E4: 'Network Gateway Request',
            0x7EC: 'Network Gateway Response',
            0x7E5: 'Hybrid System Request',
            0x7ED: 'Hybrid System Response',
            0x7E6: 'Instrument Cluster Request',
            0x7EE: 'Instrument Cluster Response',
            0x7E7: 'HVAC Request',
            0x7EF: 'HVAC Response',
            
            # Common manufacturer-specific
            0x700: 'UDS Tester Present Broadcast',
            0x600: 'Gateway Control',
            0x500: 'Body Control Module',
            0x400: 'Instrument Cluster',
            0x300: 'ABS/ESP Control',
            0x200: 'Engine Control',
            0x100: 'Transmission Control'
        }
        
        # ISO-TP parameters
        self.iso_tp_params = {
            'max_single_frame': 7,  # Max data bytes in single frame
            'max_first_frame': 6,   # Max data bytes in first frame
            'max_consecutive_frame': 7,  # Max data bytes in consecutive frame
            'default_bs': 0,        # Block size (0 = no limit)
            'default_stmin': 0,     # Min separation time in ms
            'default_padding': 0xAA # Padding byte
        }
        
        # Common automotive protocols
        self.protocols = {
            'ISO-14229': 'UDS - Unified Diagnostic Services',
            'ISO-15765': 'Diagnostic on CAN',
            'SAE-J1939': 'Heavy Duty Vehicle Protocol',
            'ISO-11898': 'CAN Physical/Data Link Layer',
            'SAE-J2534': 'Pass-Thru Programming',
            'ISO-14230': 'Keyword Protocol 2000',
            'ISO-9141': 'K-Line Serial',
            'SAE-J1850': 'PWM/VPW Protocol'
        }
        
        # UDS service IDs for reference
        self.uds_services = {
            0x10: 'DiagnosticSessionControl',
            0x11: 'ECUReset',
            0x14: 'ClearDiagnosticInformation',
            0x19: 'ReadDTCInformation',
            0x22: 'ReadDataByIdentifier',
            0x23: 'ReadMemoryByAddress',
            0x24: 'ReadScalingDataByIdentifier',
            0x27: 'SecurityAccess',
            0x28: 'CommunicationControl',
            0x2A: 'ReadDataByPeriodicIdentifier',
            0x2C: 'DynamicallyDefineDataIdentifier',
            0x2E: 'WriteDataByIdentifier',
            0x2F: 'InputOutputControlByIdentifier',
            0x31: 'RoutineControl',
            0x34: 'RequestDownload',
            0x35: 'RequestUpload',
            0x36: 'TransferData',
            0x37: 'RequestTransferExit',
            0x3D: 'WriteMemoryByAddress',
            0x3E: 'TesterPresent',
            0x7F: 'NegativeResponse',
            0x84: 'SecuredDataTransmission',
            0x85: 'ControlDTCSetting',
            0x86: 'ResponseOnEvent',
            0x87: 'LinkControl'
        }
    
    def build_can_frame(self, can_id: int, data: List[int], extended: bool = False) -> Dict[str, Union[int, List[int], bool, str]]:
        """
        Build a CAN frame
        
        Args:
            can_id: CAN identifier
            data: Data bytes (max 8)
            extended: Extended ID format (29-bit)
            
        Returns:
            Dictionary representing CAN frame
        """
        # Validate CAN ID
        if extended:
            if can_id > 0x1FFFFFFF:
                raise ValueError(f"Extended CAN ID must be <= 0x1FFFFFFF, got 0x{can_id:X}")
        else:
            if can_id > 0x7FF:
                raise ValueError(f"Standard CAN ID must be <= 0x7FF, got 0x{can_id:X}")
        
        # Validate data
        if len(data) > 8:
            raise ValueError(f"CAN frame can have max 8 data bytes, got {len(data)}")
        
        # Build frame
        frame = {
            'id': can_id,
            'id_hex': f"0x{can_id:0{8 if extended else 3}X}",
            'extended': extended,
            'dlc': len(data),
            'data': data,
            'data_hex': ' '.join(f"{b:02X}" for b in data),
            'description': self.get_can_id_description(can_id)
        }
        
        return frame
    
    def decode_can_frame(self, can_id: int, data: List[int]) -> Dict[str, any]:
        """
        Decode a CAN frame
        
        Args:
            can_id: CAN identifier
            data: Data bytes
            
        Returns:
            Decoded frame information
        """
        result = {
            'can_id': can_id,
            'can_id_hex': f"0x{can_id:03X}",
            'data': data,
            'data_hex': ' '.join(f"{b:02X}" for b in data),
            'dlc': len(data),
            'id_description': self.get_can_id_description(can_id),
            'iso_tp': None,
            'uds_service': None
        }
        
        # Check if it's an ISO-TP frame
        if len(data) >= 1:
            iso_tp = self.decode_iso_tp(data)
            if iso_tp:
                result['iso_tp'] = iso_tp
                
                # Try to decode UDS service if it's a single frame or first frame
                if iso_tp['type'] in ['Single Frame', 'First Frame'] and iso_tp['payload']:
                    if iso_tp['payload'][0] in self.uds_services:
                        result['uds_service'] = self.uds_services[iso_tp['payload'][0]]
        
        # Check if it's a diagnostic response
        if can_id & 0x7F8 == 0x7E8:  # Diagnostic response pattern
            result['type'] = 'Diagnostic Response'
            result['ecu'] = self.get_ecu_from_can_id(can_id)
        elif can_id & 0x7F0 == 0x7E0:  # Diagnostic request pattern
            result['type'] = 'Diagnostic Request'
            result['ecu'] = self.get_ecu_from_can_id(can_id)
        
        return result
    
    def get_can_id_description(self, can_id: int) -> str:
        """Get description for common CAN IDs"""
        if can_id in self.common_can_ids:
            return self.common_can_ids[can_id]
        elif can_id & 0x7F8 == 0x7E8:  # Diagnostic response pattern
            return f"Diagnostic Response (ECU {can_id & 0x07})"
        elif can_id & 0x7F0 == 0x7E0:  # Diagnostic request pattern
            return f"Diagnostic Request (ECU {can_id & 0x0F})"
        else:
            return "Unknown"
    
    def get_ecu_from_can_id(self, can_id: int) -> str:
        """Get ECU name from CAN ID"""
        ecu_map = {
            0: 'Engine',
            1: 'Transmission',
            2: 'Chassis/ABS',
            3: 'Body/Accessories',
            4: 'Network Gateway',
            5: 'Hybrid System',
            6: 'Instrument Cluster',
            7: 'HVAC'
        }
        
        if can_id & 0x7F0 in [0x7E0, 0x7E8]:
            ecu_num = can_id & 0x0F if can_id < 0x7E8 else can_id & 0x07
            return ecu_map.get(ecu_num, f"ECU {ecu_num}")
        
        return "Unknown"
    
    def build_iso_tp_single_frame(self, data: List[int]) -> List[int]:
        """
        Build ISO-TP single frame
        
        Args:
            data: Payload data (max 7 bytes)
            
        Returns:
            Complete CAN frame data
        """
        if len(data) > 7:
            raise ValueError(f"Single frame can carry max 7 bytes, got {len(data)}")
        
        # PCI byte: 0x0N where N is data length
        pci = 0x00 | len(data)
        frame = [pci] + data
        
        # Pad to 8 bytes
        while len(frame) < 8:
            frame.append(self.iso_tp_params['default_padding'])
        
        return frame
    
    def build_iso_tp_first_frame(self, data: List[int]) -> Tuple[List[int], int]:
        """
        Build ISO-TP first frame
        
        Args:
            data: Complete message data
            
        Returns:
            Tuple of (first frame data, remaining bytes)
        """
        if len(data) <= 7:
            raise ValueError("Use single frame for messages <= 7 bytes")
        
        if len(data) > 4095:
            raise ValueError("Message too long for standard ISO-TP (max 4095 bytes)")
        
        # PCI bytes: 0x1N NN where NNN is total length
        length_high = (len(data) >> 8) & 0x0F
        length_low = len(data) & 0xFF
        pci_high = 0x10 | length_high
        
        frame = [pci_high, length_low] + data[:6]
        remaining = len(data) - 6
        
        return frame, remaining
    
    def build_iso_tp_consecutive_frame(self, sequence: int, data: List[int]) -> List[int]:
        """
        Build ISO-TP consecutive frame
        
        Args:
            sequence: Sequence number (0-15)
            data: Frame data (max 7 bytes)
            
        Returns:
            Complete CAN frame data
        """
        if sequence > 15:
            sequence = sequence & 0x0F  # Wrap around
        
        if len(data) > 7:
            raise ValueError(f"Consecutive frame can carry max 7 bytes, got {len(data)}")
        
        # PCI byte: 0x2N where N is sequence number
        pci = 0x20 | sequence
        frame = [pci] + data
        
        # Pad to 8 bytes
        while len(frame) < 8:
            frame.append(self.iso_tp_params['default_padding'])
        
        return frame
    
    def build_iso_tp_flow_control(self, flow_status: int = 0, block_size: int = 0, 
                                  separation_time: int = 0) -> List[int]:
        """
        Build ISO-TP flow control frame
        
        Args:
            flow_status: 0=Continue, 1=Wait, 2=Overflow
            block_size: Number of frames to send before next FC
            separation_time: Min time between frames in ms
            
        Returns:
            Complete CAN frame data
        """
        if flow_status > 2:
            raise ValueError(f"Invalid flow status: {flow_status}")
        
        # PCI byte: 0x3N where N is flow status
        pci = 0x30 | flow_status
        frame = [pci, block_size, separation_time]
        
        # Pad to 8 bytes
        while len(frame) < 8:
            frame.append(self.iso_tp_params['default_padding'])
        
        return frame
    
    def decode_iso_tp(self, data: List[int]) -> Optional[Dict[str, any]]:
        """
        Decode ISO-TP frame
        
        Args:
            data: CAN frame data
            
        Returns:
            Decoded ISO-TP information or None
        """
        if len(data) < 1:
            return None
        
        pci = data[0]
        frame_type = (pci & 0xF0) >> 4
        
        result = {
            'pci': pci,
            'pci_hex': f"0x{pci:02X}"
        }
        
        if frame_type == 0:  # Single frame
            length = pci & 0x0F
            result['type'] = 'Single Frame'
            result['length'] = length
            result['payload'] = data[1:1+length] if length <= len(data)-1 else data[1:]
            
        elif frame_type == 1:  # First frame
            length = ((pci & 0x0F) << 8) | (data[1] if len(data) > 1 else 0)
            result['type'] = 'First Frame'
            result['total_length'] = length
            result['payload'] = data[2:8] if len(data) >= 8 else data[2:]
            
        elif frame_type == 2:  # Consecutive frame
            sequence = pci & 0x0F
            result['type'] = 'Consecutive Frame'
            result['sequence'] = sequence
            result['payload'] = data[1:]
            
        elif frame_type == 3:  # Flow control
            flow_status = pci & 0x0F
            status_map = {0: 'Continue', 1: 'Wait', 2: 'Overflow'}
            result['type'] = 'Flow Control'
            result['flow_status'] = status_map.get(flow_status, f'Unknown ({flow_status})')
            result['block_size'] = data[1] if len(data) > 1 else 0
            result['separation_time'] = data[2] if len(data) > 2 else 0
            
        else:
            return None
        
        return result
    
    def build_multi_frame_message(self, can_id: int, data: List[int]) -> List[Dict[str, any]]:
        """
        Build complete multi-frame ISO-TP message
        
        Args:
            can_id: CAN identifier for all frames
            data: Complete message data
            
        Returns:
            List of CAN frames
        """
        frames = []
        
        if len(data) <= 7:
            # Single frame
            frame_data = self.build_iso_tp_single_frame(data)
            frames.append(self.build_can_frame(can_id, frame_data))
        else:
            # Multi-frame
            # First frame
            first_frame_data, remaining = self.build_iso_tp_first_frame(data)
            frames.append(self.build_can_frame(can_id, first_frame_data))
            
            # Consecutive frames
            data_offset = 6
            sequence = 1
            
            while remaining > 0:
                chunk_size = min(7, remaining)
                chunk_data = data[data_offset:data_offset + chunk_size]
                
                cf_data = self.build_iso_tp_consecutive_frame(sequence, chunk_data)
                frames.append(self.build_can_frame(can_id, cf_data))
                
                data_offset += chunk_size
                remaining -= chunk_size
                sequence = (sequence + 1) & 0x0F
        
        return frames
    
    def calculate_can_id_response(self, request_id: int) -> int:
        """
        Calculate response CAN ID from request ID
        
        Args:
            request_id: Request CAN ID
            
        Returns:
            Expected response CAN ID
        """
        # Standard OBD-II pattern
        if request_id >= 0x7E0 and request_id <= 0x7E7:
            return request_id + 8
        
        # Functional addressing
        if request_id == 0x7DF:
            return 0x7E8  # Primary ECU response
        
        # For other IDs, typically add 0x8
        return request_id + 0x8
    
    def format_can_message(self, frames: List[Dict[str, any]]) -> str:
        """
        Format CAN message(s) for display
        
        Args:
            frames: List of CAN frames
            
        Returns:
            Formatted string
        """
        lines = []
        
        for i, frame in enumerate(frames):
            lines.append(f"Frame {i+1}:")
            lines.append(f"  CAN ID: {frame['id_hex']} ({frame['description']})")
            lines.append(f"  Data: [{frame['data_hex']}]")
            lines.append(f"  DLC: {frame['dlc']}")
            
            if frame.get('extended'):
                lines.append(f"  Extended ID: Yes")
            
            # Add ISO-TP info if decoded
            if 'iso_tp' in frame and frame['iso_tp']:
                iso_tp = frame['iso_tp']
                lines.append(f"  ISO-TP: {iso_tp['type']}")
                if 'length' in iso_tp:
                    lines.append(f"    Length: {iso_tp['length']}")
                if 'total_length' in iso_tp:
                    lines.append(f"    Total Length: {iso_tp['total_length']}")
                if 'sequence' in iso_tp:
                    lines.append(f"    Sequence: {iso_tp['sequence']}")
            
            lines.append("")
        
        return "\n".join(lines)
    
    def build_uds_request(self, service: int, data: List[int] = []) -> List[int]:
        """
        Build UDS request data
        
        Args:
            service: UDS service ID
            data: Additional data bytes
            
        Returns:
            Complete UDS message data
        """
        return [service] + data
    
    def parse_hex_string(self, hex_str: str) -> List[int]:
        """
        Parse hex string to byte list
        
        Args:
            hex_str: Hex string (e.g., "01 02 03" or "010203")
            
        Returns:
            List of bytes
        """
        # Remove common separators and prefixes
        hex_str = hex_str.replace(' ', '').replace(':', '').replace('-', '')
        hex_str = hex_str.replace('0x', '').replace('0X', '')
        
        # Parse pairs of hex digits
        if len(hex_str) % 2 != 0:
            raise ValueError("Hex string must have even number of digits")
        
        bytes_list = []
        for i in range(0, len(hex_str), 2):
            bytes_list.append(int(hex_str[i:i+2], 16))
        
        return bytes_list

def main():
    parser = argparse.ArgumentParser(description='CAN Message Tool')
    subparsers = parser.add_subparsers(dest='command', help='Commands')
    
    # Build command
    build_parser = subparsers.add_parser('build', help='Build CAN message')
    build_parser.add_argument('can_id', type=lambda x: int(x, 0), 
                            help='CAN ID (hex or decimal)')
    build_parser.add_argument('data', help='Data bytes (hex string)')
    build_parser.add_argument('-e', '--extended', action='store_true',
                            help='Extended CAN ID')
    build_parser.add_argument('-m', '--multi', action='store_true',
                            help='Build multi-frame message')
    
    # Decode command
    decode_parser = subparsers.add_parser('decode', help='Decode CAN message')
    decode_parser.add_argument('can_id', type=lambda x: int(x, 0),
                             help='CAN ID (hex or decimal)')
    decode_parser.add_argument('data', help='Data bytes (hex string)')
    
    # UDS command
    uds_parser = subparsers.add_parser('uds', help='Build UDS message')
    uds_parser.add_argument('service', type=lambda x: int(x, 0),
                          help='UDS service ID (hex or decimal)')
    uds_parser.add_argument('can_id', type=lambda x: int(x, 0),
                          help='CAN ID for the message')
    uds_parser.add_argument('-d', '--data', default='',
                          help='Additional data bytes (hex string)')
    
    # Info command
    info_parser = subparsers.add_parser('info', help='Show protocol information')
    info_parser.add_argument('topic', nargs='?', choices=['ids', 'services', 'protocols'],
                           help='Information topic')
    
    # Interactive command
    interactive_parser = subparsers.add_parser('interactive', help='Interactive mode')
    
    args = parser.parse_args()
    
    tool = CANMessageTool()
    
    if args.command == 'build':
        try:
            data = tool.parse_hex_string(args.data)
            
            if args.multi:
                frames = tool.build_multi_frame_message(args.can_id, data)
                print(tool.format_can_message(frames))
            else:
                frame = tool.build_can_frame(args.can_id, data, args.extended)
                print(tool.format_can_message([frame]))
                
        except Exception as e:
            print(f"Error: {e}")
            sys.exit(1)
    
    elif args.command == 'decode':
        try:
            data = tool.parse_hex_string(args.data)
            result = tool.decode_can_frame(args.can_id, data)
            
            print(f"CAN ID: {result['can_id_hex']} ({result['id_description']})")
            print(f"Data: [{result['data_hex']}]")
            print(f"DLC: {result['dlc']}")
            
            if result.get('type'):
                print(f"Type: {result['type']}")
            
            if result.get('ecu'):
                print(f"ECU: {result['ecu']}")
            
            if result.get('iso_tp'):
                iso_tp = result['iso_tp']
                print(f"\nISO-TP Frame:")
                print(f"  Type: {iso_tp['type']}")
                for key, value in iso_tp.items():
                    if key not in ['type', 'pci', 'pci_hex', 'payload']:
                        print(f"  {key.replace('_', ' ').title()}: {value}")
                
                if iso_tp.get('payload'):
                    payload_hex = ' '.join(f"{b:02X}" for b in iso_tp['payload'])
                    print(f"  Payload: [{payload_hex}]")
            
            if result.get('uds_service'):
                print(f"\nUDS Service: {result['uds_service']}")
                
        except Exception as e:
            print(f"Error: {e}")
            sys.exit(1)
    
    elif args.command == 'uds':
        try:
            # Build UDS data
            additional_data = tool.parse_hex_string(args.data) if args.data else []
            uds_data = tool.build_uds_request(args.service, additional_data)
            
            # Build CAN frames
            frames = tool.build_multi_frame_message(args.can_id, uds_data)
            
            # Display service info
            service_name = tool.uds_services.get(args.service, 'Unknown Service')
            print(f"UDS Request: {service_name} (0x{args.service:02X})")
            print(f"Response CAN ID: 0x{tool.calculate_can_id_response(args.can_id):03X}")
            print()
            
            # Display frames
            print(tool.format_can_message(frames))
            
        except Exception as e:
            print(f"Error: {e}")
            sys.exit(1)
    
    elif args.command == 'info':
        if args.topic == 'ids' or not args.topic:
            print("Common CAN IDs:")
            print("-" * 50)
            for can_id, desc in sorted(tool.common_can_ids.items()):
                print(f"  0x{can_id:03X}: {desc}")
        
        if args.topic == 'services' or not args.topic:
            print("\nUDS Services:")
            print("-" * 50)
            for sid, name in sorted(tool.uds_services.items()):
                print(f"  0x{sid:02X}: {name}")
        
        if args.topic == 'protocols' or not args.topic:
            print("\nAutomotive Protocols:")
            print("-" * 50)
            for proto, desc in tool.protocols.items():
                print(f"  {proto}: {desc}")
    
    elif args.command == 'interactive':
        print("CAN Message Tool - Interactive Mode")
        print("Commands: 'build', 'decode', 'uds', 'info', 'help', 'quit'")
        print()
        
        while True:
            try:
                cmd = input("can> ").strip().split()
                if not cmd:
                    continue
                
                if cmd[0] == 'quit':
                    break
                
                elif cmd[0] == 'help':
                    print("\nCommands:")
                    print("  build <can_id> <data>   - Build CAN frame")
                    print("  decode <can_id> <data>  - Decode CAN frame")
                    print("  uds <service> <can_id>  - Build UDS message")
                    print("  info [topic]            - Show information")
                    print("  quit                    - Exit")
                    print("\nExamples:")
                    print("  build 0x7E0 02 01 0C")
                    print("  decode 0x7E8 03 41 0C 12 34")
                    print("  uds 0x22 0x7E0")
                
                elif cmd[0] == 'build' and len(cmd) >= 3:
                    can_id = int(cmd[1], 0)
                    data = tool.parse_hex_string(' '.join(cmd[2:]))
                    frames = tool.build_multi_frame_message(can_id, data)
                    print(tool.format_can_message(frames))
                
                elif cmd[0] == 'decode' and len(cmd) >= 3:
                    can_id = int(cmd[1], 0)
                    data = tool.parse_hex_string(' '.join(cmd[2:]))
                    result = tool.decode_can_frame(can_id, data)
                    
                    # Format output
                    print(f"\nCAN ID: {result['can_id_hex']} ({result['id_description']})")
                    print(f"Data: [{result['data_hex']}]")
                    
                    if result.get('iso_tp'):
                        iso_tp = result['iso_tp']
                        print(f"ISO-TP: {iso_tp['type']}")
                        if iso_tp.get('payload'):
                            payload_hex = ' '.join(f"{b:02X}" for b in iso_tp['payload'])
                            print(f"Payload: [{payload_hex}]")
                    
                    if result.get('uds_service'):
                        print(f"UDS Service: {result['uds_service']}")
                
                elif cmd[0] == 'uds' and len(cmd) >= 3:
                    service = int(cmd[1], 0)
                    can_id = int(cmd[2], 0)
                    additional_data = []
                    
                    if len(cmd) > 3:
                        additional_data = tool.parse_hex_string(' '.join(cmd[3:]))
                    
                    uds_data = tool.build_uds_request(service, additional_data)
                    frames = tool.build_multi_frame_message(can_id, uds_data)
                    
                    service_name = tool.uds_services.get(service, 'Unknown Service')
                    print(f"\nUDS Request: {service_name} (0x{service:02X})")
                    print(tool.format_can_message(frames))
                
                elif cmd[0] == 'info':
                    topic = cmd[1] if len(cmd) > 1 else None
                    if topic in ['ids', None]:
                        print("\nCommon CAN IDs:")
                        for can_id, desc in sorted(list(tool.common_can_ids.items())[:10]):
                            print(f"  0x{can_id:03X}: {desc}")
                        print("  ... (use 'info ids' for full list)")
                    
                    if topic in ['services', None]:
                        print("\nUDS Services:")
                        for sid, name in sorted(list(tool.uds_services.items())[:10]):
                            print(f"  0x{sid:02X}: {name}")
                        print("  ... (use 'info services' for full list)")
                
                else:
                    print("Invalid command. Type 'help' for help.")
                
                print()
                
            except Exception as e:
                print(f"Error: {e}\n")
    
    else:
        parser.print_help()
        print("\nExamples:")
        print("  # Build single frame CAN message")
        print("  can_message_tool.py build 0x7E0 '02 01 0C'")
        print()
        print("  # Decode CAN frame")
        print("  can_message_tool.py decode 0x7E8 '03 41 0C 12 34'")
        print()
        print("  # Build UDS request")
        print("  can_message_tool.py uds 0x22 0x7E0 -d 'F1 90'")

if __name__ == '__main__':
    main()