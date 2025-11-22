#!/usr/bin/env python3
"""
UDS (Unified Diagnostic Services) Helper Tool
Builds and decodes UDS messages according to ISO 14229
"""

import argparse
import struct

class UDSHelper:
    def __init__(self):
        self.services = {
            0x10: {'name': 'DiagnosticSessionControl', 'has_subfunction': True},
            0x11: {'name': 'ECUReset', 'has_subfunction': True},
            0x14: {'name': 'ClearDiagnosticInformation', 'has_subfunction': False},
            0x19: {'name': 'ReadDTCInformation', 'has_subfunction': True},
            0x22: {'name': 'ReadDataByIdentifier', 'has_subfunction': False},
            0x23: {'name': 'ReadMemoryByAddress', 'has_subfunction': False},
            0x24: {'name': 'ReadScalingDataByIdentifier', 'has_subfunction': False},
            0x27: {'name': 'SecurityAccess', 'has_subfunction': True},
            0x28: {'name': 'CommunicationControl', 'has_subfunction': True},
            0x2A: {'name': 'ReadDataByPeriodicIdentifier', 'has_subfunction': False},
            0x2C: {'name': 'DynamicallyDefineDataIdentifier', 'has_subfunction': True},
            0x2E: {'name': 'WriteDataByIdentifier', 'has_subfunction': False},
            0x2F: {'name': 'InputOutputControlByIdentifier', 'has_subfunction': False},
            0x31: {'name': 'RoutineControl', 'has_subfunction': True},
            0x34: {'name': 'RequestDownload', 'has_subfunction': False},
            0x35: {'name': 'RequestUpload', 'has_subfunction': False},
            0x36: {'name': 'TransferData', 'has_subfunction': False},
            0x37: {'name': 'RequestTransferExit', 'has_subfunction': False},
            0x38: {'name': 'RequestFileTransfer', 'has_subfunction': True},
            0x3D: {'name': 'WriteMemoryByAddress', 'has_subfunction': False},
            0x3E: {'name': 'TesterPresent', 'has_subfunction': True},
            0x83: {'name': 'AccessTimingParameter', 'has_subfunction': True},
            0x84: {'name': 'SecuredDataTransmission', 'has_subfunction': True},
            0x85: {'name': 'ControlDTCSetting', 'has_subfunction': True},
            0x86: {'name': 'ResponseOnEvent', 'has_subfunction': True},
            0x87: {'name': 'LinkControl', 'has_subfunction': True},
        }
        
        self.negative_response_codes = {
            0x10: 'generalReject',
            0x11: 'serviceNotSupported',
            0x12: 'subFunctionNotSupported',
            0x13: 'incorrectMessageLengthOrInvalidFormat',
            0x14: 'responseTooLong',
            0x21: 'busyRepeatRequest',
            0x22: 'conditionsNotCorrect',
            0x24: 'requestSequenceError',
            0x25: 'noResponseFromSubnetComponent',
            0x26: 'failurePreventsExecutionOfRequestedAction',
            0x31: 'requestOutOfRange',
            0x33: 'securityAccessDenied',
            0x35: 'invalidKey',
            0x36: 'exceedNumberOfAttempts',
            0x37: 'requiredTimeDelayNotExpired',
            0x70: 'uploadDownloadNotAccepted',
            0x71: 'transferDataSuspended',
            0x72: 'generalProgrammingFailure',
            0x73: 'wrongBlockSequenceCounter',
            0x78: 'requestCorrectlyReceived-ResponsePending',
            0x7E: 'subFunctionNotSupportedInActiveSession',
            0x7F: 'serviceNotSupportedInActiveSession',
            0x81: 'rpmTooHigh',
            0x82: 'rpmTooLow',
            0x83: 'engineIsRunning',
            0x84: 'engineIsNotRunning',
            0x85: 'engineRunTimeTooLow',
            0x86: 'temperatureTooHigh',
            0x87: 'temperatureTooLow',
            0x88: 'vehicleSpeedTooHigh',
            0x89: 'vehicleSpeedTooLow',
            0x8A: 'throttle/PedalTooHigh',
            0x8B: 'throttle/PedalTooLow',
            0x8C: 'transmissionRangeNotInNeutral',
            0x8D: 'transmissionRangeNotInGear',
            0x8F: 'brakeSwitch(es)NotClosed',
            0x90: 'shifterLeverNotInPark',
            0x91: 'torqueConverterClutchLocked',
            0x92: 'voltageTooHigh',
            0x93: 'voltageTooLow',
        }
        
        self.session_types = {
            0x01: 'defaultSession',
            0x02: 'programmingSession',
            0x03: 'extendedDiagnosticSession',
            0x04: 'safetySystemDiagnosticSession',
        }
        
        self.reset_types = {
            0x01: 'hardReset',
            0x02: 'keyOffOnReset',
            0x03: 'softReset',
            0x04: 'enableRapidPowerShutDown',
            0x05: 'disableRapidPowerShutDown',
        }
        
        self.dtc_subfunctions = {
            0x01: 'reportNumberOfDTCByStatusMask',
            0x02: 'reportDTCByStatusMask',
            0x03: 'reportDTCSnapshotIdentification',
            0x04: 'reportDTCSnapshotRecordByDTCNumber',
            0x05: 'reportDTCStoredDataByRecordNumber',
            0x06: 'reportDTCExtDataRecordByDTCNumber',
            0x07: 'reportNumberOfDTCBySeverityMaskRecord',
            0x08: 'reportDTCBySeverityMaskRecord',
            0x09: 'reportSeverityInformationOfDTC',
            0x0A: 'reportSupportedDTC',
            0x0B: 'reportFirstTestFailedDTC',
            0x0C: 'reportFirstConfirmedDTC',
            0x0D: 'reportMostRecentTestFailedDTC',
            0x0E: 'reportMostRecentConfirmedDTC',
            0x14: 'reportDTCFaultDetectionCounter',
            0x15: 'reportDTCWithPermanentStatus',
        }
        
        self.routine_subfunctions = {
            0x01: 'startRoutine',
            0x02: 'stopRoutine',
            0x03: 'requestRoutineResults',
        }
        
        self.common_dids = {
            0xF186: 'ActiveDiagnosticSession',
            0xF187: 'VehicleManufacturerSparePartNumber',
            0xF188: 'VehicleManufacturerECUSoftwareNumber',
            0xF189: 'VehicleManufacturerECUSoftwareVersionNumber',
            0xF18A: 'SystemSupplierSpecific',
            0xF190: 'VINDataIdentifier',
            0xF191: 'VehicleManufacturerECUHardwareNumber',
            0xF192: 'SystemSupplierECUHardwareNumber',
            0xF197: 'SystemName',
            0xF199: 'ProgrammingDate',
        }
    
    def build_request(self, service, subfunction=None, data=[]):
        """Build a UDS request message"""
        message = [service]
        
        if subfunction is not None:
            message.append(subfunction)
        
        message.extend(data)
        
        return message
    
    def decode_response(self, response):
        """Decode a UDS response message"""
        if not response:
            return "Empty response"
        
        # Check for negative response
        if response[0] == 0x7F:
            if len(response) < 3:
                return "Invalid negative response"
            
            service = response[1]
            nrc = response[2]
            
            service_name = self.services.get(service, {}).get('name', f'Unknown(0x{service:02X})')
            nrc_name = self.negative_response_codes.get(nrc, f'Unknown(0x{nrc:02X})')
            
            return f"Negative Response: {service_name} - {nrc_name}"
        
        # Positive response (service + 0x40)
        response_sid = response[0] - 0x40
        
        if response_sid not in self.services:
            return f"Unknown service response: 0x{response[0]:02X}"
        
        service_name = self.services[response_sid]['name']
        
        # Decode based on service
        if response_sid == 0x10:  # DiagnosticSessionControl
            if len(response) >= 2:
                session_type = self.session_types.get(response[1], f'Unknown(0x{response[1]:02X})')
                timing_params = ""
                if len(response) >= 6:
                    p2_server_max = (response[2] << 8) | response[3]
                    p2_star_server_max = ((response[4] << 8) | response[5]) * 10
                    timing_params = f", P2: {p2_server_max}ms, P2*: {p2_star_server_max}ms"
                return f"{service_name}: {session_type}{timing_params}"
        
        elif response_sid == 0x11:  # ECUReset
            if len(response) >= 2:
                reset_type = self.reset_types.get(response[1], f'Unknown(0x{response[1]:02X})')
                return f"{service_name}: {reset_type}"
        
        elif response_sid == 0x22:  # ReadDataByIdentifier
            if len(response) >= 3:
                did = (response[1] << 8) | response[2]
                did_name = self.common_dids.get(did, f'0x{did:04X}')
                data_hex = ' '.join([f'{b:02X}' for b in response[3:]])
                return f"{service_name}: {did_name} = {data_hex}"
        
        elif response_sid == 0x27:  # SecurityAccess
            if len(response) >= 2:
                level = response[1]
                if level % 2 == 1:  # Odd = seed
                    seed = ' '.join([f'{b:02X}' for b in response[2:]])
                    return f"{service_name}: Seed (Level {level//2 + 1}) = {seed}"
                else:  # Even = key accepted
                    return f"{service_name}: Key Accepted (Level {level//2})"
        
        else:
            # Generic positive response
            data_hex = ' '.join([f'{b:02X}' for b in response[1:]])
            return f"{service_name} Response: {data_hex}"
        
        return f"{service_name} Response: " + ' '.join([f'{b:02X}' for b in response])
    
    def calculate_seed_key(self, seed, algorithm='simple'):
        """Calculate security key from seed"""
        if algorithm == 'simple':
            # Simple XOR with constant
            key = []
            secret = 0x1234  # Example secret
            for i, byte in enumerate(seed):
                key.append((byte ^ (secret >> (8 * (i % 2)))) & 0xFF)
            return key
        
        elif algorithm == 'add':
            # Add constant
            seed_value = int.from_bytes(seed, 'big')
            key_value = (seed_value + 0x87654321) & 0xFFFFFFFF
            return list(key_value.to_bytes(4, 'big'))
        
        else:
            return None
    
    def print_service_list(self):
        """Print all supported services"""
        print("\nUDS Services:")
        print("-" * 60)
        for sid, info in sorted(self.services.items()):
            print(f"0x{sid:02X}: {info['name']}")
    
    def print_common_dids(self):
        """Print common DIDs"""
        print("\nCommon DIDs:")
        print("-" * 60)
        for did, name in sorted(self.common_dids.items()):
            print(f"0x{did:04X}: {name}")

def main():
    parser = argparse.ArgumentParser(description='UDS Protocol Helper')
    parser.add_argument('--build', type=str, help='Build request (e.g., "10 03" for extended session)')
    parser.add_argument('--decode', type=str, help='Decode response (e.g., "50 03 00 32 01 F4")')
    parser.add_argument('--seed-key', type=str, help='Calculate key from seed (e.g., "12 34 56 78")')
    parser.add_argument('--list-services', action='store_true', help='List all UDS services')
    parser.add_argument('--list-dids', action='store_true', help='List common DIDs')
    
    args = parser.parse_args()
    helper = UDSHelper()
    
    if args.list_services:
        helper.print_service_list()
        return
    
    if args.list_dids:
        helper.print_common_dids()
        return
    
    if args.seed_key:
        seed = [int(b, 16) for b in args.seed_key.split()]
        key = helper.calculate_seed_key(seed)
        if key:
            print(f"Seed: {' '.join([f'{b:02X}' for b in seed])}")
            print(f"Key:  {' '.join([f'{b:02X}' for b in key])}")
        return
    
    if args.build:
        parts = args.build.split()
        service = int(parts[0], 16)
        
        if len(parts) > 1 and helper.services.get(service, {}).get('has_subfunction'):
            subfunction = int(parts[1], 16)
            data = [int(b, 16) for b in parts[2:]]
            request = helper.build_request(service, subfunction, data)
        else:
            data = [int(b, 16) for b in parts[1:]]
            request = helper.build_request(service, data=data)
        
        print(f"Request: {' '.join([f'{b:02X}' for b in request])}")
        return
    
    if args.decode:
        response = [int(b, 16) for b in args.decode.split()]
        print(helper.decode_response(response))
        return
    
    # Interactive mode
    print("UDS Helper - Interactive Mode")
    print("Commands: build, decode, seed-key, list-services, list-dids, help, quit")
    print("-" * 60)
    
    while True:
        try:
            cmd = input("\nCommand: ").strip().lower()
            
            if cmd == 'quit':
                break
            elif cmd == 'help':
                print("\nCommands:")
                print("  build <hex>     - Build UDS request")
                print("  decode <hex>    - Decode UDS response")
                print("  seed-key <hex>  - Calculate key from seed")
                print("  list-services   - List UDS services")
                print("  list-dids       - List common DIDs")
                print("  quit            - Exit")
            elif cmd == 'list-services':
                helper.print_service_list()
            elif cmd == 'list-dids':
                helper.print_common_dids()
            elif cmd.startswith('build '):
                parts = cmd.split()[1:]
                service = int(parts[0], 16)
                
                if len(parts) > 1 and helper.services.get(service, {}).get('has_subfunction'):
                    subfunction = int(parts[1], 16)
                    data = [int(b, 16) for b in parts[2:]]
                    request = helper.build_request(service, subfunction, data)
                else:
                    data = [int(b, 16) for b in parts[1:]]
                    request = helper.build_request(service, data=data)
                
                print(f"Request: {' '.join([f'{b:02X}' for b in request])}")
            elif cmd.startswith('decode '):
                response = [int(b, 16) for b in cmd.split()[1:]]
                print(helper.decode_response(response))
            elif cmd.startswith('seed-key '):
                seed = [int(b, 16) for b in cmd.split()[1:]]
                key = helper.calculate_seed_key(seed)
                if key:
                    print(f"Seed: {' '.join([f'{b:02X}' for b in seed])}")
                    print(f"Key:  {' '.join([f'{b:02X}' for b in key])}")
            else:
                print("Unknown command. Type 'help' for usage.")
                
        except ValueError as e:
            print(f"Error: Invalid input - {e}")
        except KeyboardInterrupt:
            print("\nExiting...")
            break

if __name__ == "__main__":
    main()