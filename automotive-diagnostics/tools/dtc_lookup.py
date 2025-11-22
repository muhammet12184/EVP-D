#!/usr/bin/env python3
"""
DTC (Diagnostic Trouble Code) Lookup Tool

This tool provides comprehensive information about DTCs including:
- Decoding DTC format (ISO 15031-6)
- Lookup of common DTC descriptions
- Brand-specific DTC information
- DTC status byte interpretation
"""

import argparse
import sys
from typing import Dict, List, Tuple, Optional

class DTCLookup:
    def __init__(self):
        # DTC system definitions
        self.dtc_systems = {
            'P': 'Powertrain',
            'C': 'Chassis',
            'B': 'Body',
            'U': 'Network/Communication'
        }
        
        # DTC type definitions (second character)
        self.dtc_types = {
            '0': 'ISO/SAE Controlled',
            '1': 'Manufacturer Controlled',
            '2': 'ISO/SAE Reserved',
            '3': 'ISO/SAE/Manufacturer Controlled'
        }
        
        # Common generic DTCs (P0xxx)
        self.generic_dtcs = {
            # Fuel and Air Metering
            'P0001': 'Fuel Volume Regulator Control Circuit/Open',
            'P0002': 'Fuel Volume Regulator Control Circuit Range/Performance',
            'P0003': 'Fuel Volume Regulator Control Circuit Low',
            'P0004': 'Fuel Volume Regulator Control Circuit High',
            'P0005': 'Fuel Shutoff Valve A Control Circuit/Open',
            'P0006': 'Fuel Shutoff Valve A Control Circuit Low',
            'P0007': 'Fuel Shutoff Valve A Control Circuit High',
            'P0008': 'Engine Position System Performance Bank 1',
            'P0009': 'Engine Position System Performance Bank 2',
            'P0010': 'A Camshaft Position Actuator Circuit Bank 1',
            'P0011': 'A Camshaft Position - Timing Over-Advanced or System Performance Bank 1',
            'P0012': 'A Camshaft Position - Timing Over-Retarded Bank 1',
            'P0013': 'B Camshaft Position Actuator Circuit Bank 1',
            'P0014': 'B Camshaft Position - Timing Over-Advanced or System Performance Bank 1',
            'P0015': 'B Camshaft Position - Timing Over-Retarded Bank 1',
            'P0016': 'Crankshaft Position - Camshaft Position Correlation Bank 1 Sensor A',
            'P0017': 'Crankshaft Position - Camshaft Position Correlation Bank 1 Sensor B',
            'P0018': 'Crankshaft Position - Camshaft Position Correlation Bank 2 Sensor A',
            'P0019': 'Crankshaft Position - Camshaft Position Correlation Bank 2 Sensor B',
            'P0020': 'A Camshaft Position Actuator Circuit Bank 2',
            
            # Ignition System
            'P0300': 'Random/Multiple Cylinder Misfire Detected',
            'P0301': 'Cylinder 1 Misfire Detected',
            'P0302': 'Cylinder 2 Misfire Detected',
            'P0303': 'Cylinder 3 Misfire Detected',
            'P0304': 'Cylinder 4 Misfire Detected',
            'P0305': 'Cylinder 5 Misfire Detected',
            'P0306': 'Cylinder 6 Misfire Detected',
            'P0307': 'Cylinder 7 Misfire Detected',
            'P0308': 'Cylinder 8 Misfire Detected',
            
            # Emission Control
            'P0401': 'Exhaust Gas Recirculation Flow Insufficient Detected',
            'P0402': 'Exhaust Gas Recirculation Flow Excessive Detected',
            'P0403': 'Exhaust Gas Recirculation Circuit Malfunction',
            'P0404': 'Exhaust Gas Recirculation Circuit Range/Performance',
            'P0405': 'Exhaust Gas Recirculation Sensor A Circuit Low',
            'P0406': 'Exhaust Gas Recirculation Sensor A Circuit High',
            
            # Speed and Idle Control
            'P0500': 'Vehicle Speed Sensor Malfunction',
            'P0501': 'Vehicle Speed Sensor Range/Performance',
            'P0502': 'Vehicle Speed Sensor Circuit Low Input',
            'P0503': 'Vehicle Speed Sensor Intermittent/Erratic/High',
            'P0505': 'Idle Control System Malfunction',
            'P0506': 'Idle Control System RPM Lower Than Expected',
            'P0507': 'Idle Control System RPM Higher Than Expected',
            
            # Computer and Output Circuit
            'P0600': 'Serial Communication Link Malfunction',
            'P0601': 'Internal Control Module Memory Check Sum Error',
            'P0602': 'Control Module Programming Error',
            'P0603': 'Internal Control Module Keep Alive Memory (KAM) Error',
            'P0604': 'Internal Control Module Random Access Memory (RAM) Error',
            'P0605': 'Internal Control Module Read Only Memory (ROM) Error',
            'P0606': 'PCM Processor Fault',
            'P0607': 'Control Module Performance',
            
            # Transmission
            'P0700': 'Transmission Control System Malfunction',
            'P0701': 'Transmission Control System Range/Performance',
            'P0702': 'Transmission Control System Electrical',
            'P0703': 'Torque Converter/Brake Switch B Circuit Malfunction',
            'P0704': 'Clutch Switch Input Circuit Malfunction',
            'P0705': 'Transmission Range Sensor Circuit Malfunction (PRNDL Input)',
            'P0706': 'Transmission Range Sensor Circuit Range/Performance',
            
            # Common O2 Sensor Codes
            'P0130': 'O2 Sensor Circuit Malfunction (Bank 1 Sensor 1)',
            'P0131': 'O2 Sensor Circuit Low Voltage (Bank 1 Sensor 1)',
            'P0132': 'O2 Sensor Circuit High Voltage (Bank 1 Sensor 1)',
            'P0133': 'O2 Sensor Circuit Slow Response (Bank 1 Sensor 1)',
            'P0134': 'O2 Sensor Circuit No Activity Detected (Bank 1 Sensor 1)',
            'P0135': 'O2 Sensor Heater Circuit Malfunction (Bank 1 Sensor 1)',
            'P0136': 'O2 Sensor Circuit Malfunction (Bank 1 Sensor 2)',
            'P0137': 'O2 Sensor Circuit Low Voltage (Bank 1 Sensor 2)',
            'P0138': 'O2 Sensor Circuit High Voltage (Bank 1 Sensor 2)',
            'P0139': 'O2 Sensor Circuit Slow Response (Bank 1 Sensor 2)',
            'P0140': 'O2 Sensor Circuit No Activity Detected (Bank 1 Sensor 2)',
            'P0141': 'O2 Sensor Heater Circuit Malfunction (Bank 1 Sensor 2)',
            
            # Fuel System
            'P0170': 'Fuel Trim Malfunction (Bank 1)',
            'P0171': 'System Too Lean (Bank 1)',
            'P0172': 'System Too Rich (Bank 1)',
            'P0173': 'Fuel Trim Malfunction (Bank 2)',
            'P0174': 'System Too Lean (Bank 2)',
            'P0175': 'System Too Rich (Bank 2)',
            
            # MAF/MAP Sensors
            'P0100': 'Mass or Volume Air Flow Circuit Malfunction',
            'P0101': 'Mass or Volume Air Flow Circuit Range/Performance Problem',
            'P0102': 'Mass or Volume Air Flow Circuit Low Input',
            'P0103': 'Mass or Volume Air Flow Circuit High Input',
            'P0104': 'Mass or Volume Air Flow Circuit Intermittent',
            'P0105': 'Manifold Absolute Pressure/Barometric Pressure Circuit Malfunction',
            'P0106': 'Manifold Absolute Pressure/Barometric Pressure Circuit Range/Performance Problem',
            'P0107': 'Manifold Absolute Pressure/Barometric Pressure Circuit Low Input',
            'P0108': 'Manifold Absolute Pressure/Barometric Pressure Circuit High Input',
            
            # Throttle/Pedal Position
            'P0120': 'Throttle/Pedal Position Sensor/Switch A Circuit Malfunction',
            'P0121': 'Throttle/Pedal Position Sensor/Switch A Circuit Range/Performance Problem',
            'P0122': 'Throttle/Pedal Position Sensor/Switch A Circuit Low Input',
            'P0123': 'Throttle/Pedal Position Sensor/Switch A Circuit High Input',
            'P0124': 'Throttle/Pedal Position Sensor/Switch A Circuit Intermittent',
            
            # Catalyst System
            'P0420': 'Catalyst System Efficiency Below Threshold (Bank 1)',
            'P0421': 'Warm Up Catalyst Efficiency Below Threshold (Bank 1)',
            'P0422': 'Main Catalyst Efficiency Below Threshold (Bank 1)',
            'P0423': 'Heated Catalyst Efficiency Below Threshold (Bank 1)',
            'P0424': 'Heated Catalyst Temperature Below Threshold (Bank 1)',
            'P0430': 'Catalyst System Efficiency Below Threshold (Bank 2)',
            
            # EVAP System
            'P0440': 'Evaporative Emission Control System Malfunction',
            'P0441': 'Evaporative Emission Control System Incorrect Purge Flow',
            'P0442': 'Evaporative Emission Control System Leak Detected (small leak)',
            'P0443': 'Evaporative Emission Control System Purge Control Valve Circuit Malfunction',
            'P0444': 'Evaporative Emission Control System Purge Control Valve Circuit Open',
            'P0445': 'Evaporative Emission Control System Purge Control Valve Circuit Shorted',
            'P0446': 'Evaporative Emission Control System Vent Control Circuit Malfunction',
            'P0447': 'Evaporative Emission Control System Vent Control Circuit Open',
            'P0448': 'Evaporative Emission Control System Vent Control Circuit Shorted',
            'P0449': 'Evaporative Emission Control System Vent Valve/Solenoid Circuit Malfunction',
            'P0450': 'Evaporative Emission Control System Pressure Sensor Malfunction',
            'P0451': 'Evaporative Emission Control System Pressure Sensor Range/Performance',
            'P0452': 'Evaporative Emission Control System Pressure Sensor Low Input',
            'P0453': 'Evaporative Emission Control System Pressure Sensor High Input',
            'P0454': 'Evaporative Emission Control System Pressure Sensor Intermittent',
            'P0455': 'Evaporative Emission Control System Leak Detected (large leak)',
            'P0456': 'Evaporative Emission Control System Leak Detected (very small leak)',
            'P0457': 'Evaporative Emission Control System Leak Detected (fuel cap loose/off)'
        }
        
        # Common manufacturer-specific DTCs
        self.manufacturer_dtcs = {
            # VAG (Volkswagen Group)
            'P1296': '[VAG] Cooling System Malfunction',
            'P1297': '[VAG] Connection Turbocharger - Throttle Valve Pressure Hose',
            'P1545': '[VAG] Throttle Position Control Malfunction',
            'P1546': '[VAG] Boost Pressure Control Valve Short to B+',
            'P1547': '[VAG] Boost Pressure Control Valve Short to Ground',
            'P1548': '[VAG] Boost Pressure Control Valve Open',
            'P1549': '[VAG] Boost Pressure Control Valve Stuck Closed',
            'P1550': '[VAG] Boost Pressure Control Valve Stuck Open',
            
            # BMW
            'P1083': '[BMW] Fuel Control Mixture Lean (Bank 1 Sensor 1)',
            'P1084': '[BMW] Fuel Control Mixture Rich (Bank 1 Sensor 1)',
            'P1085': '[BMW] Fuel Control Mixture Lean (Bank 2 Sensor 1)',
            'P1086': '[BMW] Fuel Control Mixture Rich (Bank 2 Sensor 1)',
            'P1087': '[BMW] O2 Control (Bank 1 Sensor 1) Mixture Too Lean',
            'P1088': '[BMW] O2 Control (Bank 1 Sensor 1) Mixture Too Rich',
            
            # Mercedes-Benz
            'P1400': '[Mercedes] EGR Valve Circuit Malfunction',
            'P1401': '[Mercedes] EGR Valve Circuit Range/Performance',
            'P1402': '[Mercedes] EGR Valve Circuit Low',
            'P1403': '[Mercedes] EGR Valve Circuit High',
            'P1404': '[Mercedes] EGR System Performance',
            
            # Ford
            'P1000': '[Ford] OBD Systems Readiness Test Not Complete',
            'P1131': '[Ford] Lack of HO2S11 Switch - Sensor Indicates Lean',
            'P1132': '[Ford] Lack of HO2S11 Switch - Sensor Indicates Rich',
            'P1400': '[Ford] DPFE Circuit Low Input',
            'P1401': '[Ford] DPFE Circuit High Input',
            'P1404': '[Ford] EGR Valve Stuck Open',
            'P1405': '[Ford] DPFE Sensor Upstream Hose Off or Plugged',
            'P1406': '[Ford] DPFE Sensor Downstream Hose Off or Plugged',
            
            # Toyota
            'P1300': '[Toyota] Igniter Circuit Malfunction (Bank 1)',
            'P1305': '[Toyota] Igniter Circuit Malfunction (Bank 2)',
            'P1310': '[Toyota] Igniter Circuit Malfunction (Bank 3)',
            'P1315': '[Toyota] Igniter Circuit Malfunction (Bank 4)',
            'P1320': '[Toyota] Ignition Signal - Circuit Malfunction',
            'P1335': '[Toyota] Crankshaft Position Sensor Circuit Malfunction',
            'P1340': '[Toyota] Camshaft Position Sensor Circuit Malfunction',
            'P1345': '[Toyota] VVT Sensor/Camshaft Position Sensor Circuit Malfunction',
            'P1346': '[Toyota] VVT Sensor/Camshaft Position Sensor Circuit Range/Performance',
            'P1349': '[Toyota] VVT System Malfunction',
            
            # Honda
            'P1106': '[Honda] Barometric Pressure Circuit Range/Performance',
            'P1107': '[Honda] Barometric Pressure Circuit Low Input',
            'P1108': '[Honda] Barometric Pressure Circuit High Input',
            'P1121': '[Honda] Throttle Position Lower Than Expected',
            'P1122': '[Honda] Throttle Position Higher Than Expected',
            'P1128': '[Honda] Manifold Absolute Pressure Lower Than Expected',
            'P1129': '[Honda] Manifold Absolute Pressure Higher Than Expected',
            'P1259': '[Honda] VTEC System Malfunction',
            'P1361': '[Honda] Top Dead Center Sensor Intermittent Interruption',
            'P1362': '[Honda] Top Dead Center Sensor No Signal',
            
            # GM
            'P1125': '[GM] APP System - Throttle Position Disagree',
            'P1133': '[GM] HO2S Insufficient Switching (Bank 1 Sensor 1)',
            'P1134': '[GM] HO2S Transition Time Ratio (Bank 1 Sensor 1)',
            'P1153': '[GM] HO2S Insufficient Switching (Bank 2 Sensor 1)',
            'P1154': '[GM] HO2S Transition Time Ratio (Bank 2 Sensor 1)',
            'P1174': '[GM] Fuel Trim Lean (Bank 1)',
            'P1175': '[GM] Fuel Trim Rich (Bank 1)'
        }
        
        # DTC status byte bits (ISO 14229-1)
        self.status_bits = {
            0: 'Test Failed',
            1: 'Test Failed This Operation Cycle',
            2: 'Pending DTC',
            3: 'Confirmed DTC',
            4: 'Test Not Completed Since Last Clear',
            5: 'Test Failed Since Last Clear',
            6: 'Test Not Completed This Operation Cycle',
            7: 'Warning Indicator Requested'
        }
        
        # Common B-codes (Body)
        self.body_dtcs = {
            'B0001': 'Driver Frontal Stage 1 Deployment Control',
            'B0002': 'Driver Frontal Stage 2 Deployment Control',
            'B0003': 'Driver Frontal Stage 3 Deployment Control',
            'B0010': 'Passenger Frontal Stage 1 Deployment Control',
            'B0011': 'Passenger Frontal Stage 2 Deployment Control',
            'B0012': 'Passenger Frontal Stage 3 Deployment Control',
            'B1000': 'ECU Malfunction',
            'B1001': 'Option Configuration Error',
            'B1004': 'LCP Lower Control Panel Communication Error',
            'B1007': 'Synchronization Switch Input Circuit Failure',
            'B1008': 'Synchronization Switch Input Short to Battery',
            'B1009': 'EEPROM Checksum Error',
            'B1200': 'Climate Control Pushbutton Circuit Failure',
            'B1201': 'Fuel Sender Circuit Failure',
            'B1213': 'Anti-Theft Transceiver Fault',
            'B1214': 'Running Board Lamp Circuit Failure',
            'B1215': 'Running Board Lamp Circuit Short to Ground',
            'B1216': 'Emergency and Road Side Assistance Switch Circuit Short to Ground',
            'B1217': 'Horn Relay Coil Circuit Failure',
            'B1218': 'Horn Relay Coil Circuit Short to Battery',
            'B1342': 'ECU Malfunction',
            'B1600': 'PATS Ignition Key Transponder Signal Not Received',
            'B1601': 'PATS Received Incorrect Key Code From Ignition Key Transponder'
        }
        
        # Common C-codes (Chassis)
        self.chassis_dtcs = {
            'C0035': 'Left Front Wheel Speed Sensor Circuit',
            'C0040': 'Right Front Wheel Speed Sensor Circuit',
            'C0041': 'Right Front Wheel Speed Sensor Circuit Range/Performance',
            'C0045': 'Left Rear Wheel Speed Sensor Circuit',
            'C0046': 'Left Rear Wheel Speed Sensor Circuit Range/Performance',
            'C0050': 'Right Rear Wheel Speed Sensor Circuit',
            'C0051': 'Right Rear Wheel Speed Sensor Circuit Range/Performance',
            'C0060': 'Left Front ABS Solenoid Circuit',
            'C0065': 'Right Front ABS Solenoid Circuit',
            'C0070': 'Left Rear ABS Solenoid Circuit',
            'C0075': 'Right Rear ABS Solenoid Circuit',
            'C0080': 'Left Front TCS Solenoid Circuit',
            'C0085': 'Right Front TCS Solenoid Circuit',
            'C0090': 'Left Rear TCS Solenoid Circuit',
            'C0095': 'Right Rear TCS Solenoid Circuit',
            'C0110': 'Pump Motor Circuit',
            'C0121': 'Valve Relay Circuit',
            'C0128': 'Low Brake Fluid Circuit',
            'C0161': 'ABS/TCS Brake Switch Circuit',
            'C0200': 'Anti-Lock Brake System Configuration Error',
            'C0265': 'EBCM Relay Circuit',
            'C0281': 'Stop Lamp Switch Circuit',
            'C0550': 'ECU Malfunction',
            'C1095': 'ABS Hydraulic Pump Motor Circuit Failure',
            'C1096': 'ABS Hydraulic Pump Motor Circuit Open',
            'C1097': 'ABS Hydraulic Pump Motor Circuit Short to Ground',
            'C1098': 'ABS Hydraulic Pump Motor Circuit Short to Battery'
        }
        
        # Common U-codes (Network)
        self.network_dtcs = {
            'U0001': 'High Speed CAN Communication Bus',
            'U0002': 'High Speed CAN Communication Bus Performance',
            'U0003': 'High Speed CAN Communication Bus Open',
            'U0004': 'High Speed CAN Communication Bus Low',
            'U0005': 'High Speed CAN Communication Bus High',
            'U0006': 'High Speed CAN Communication Bus Shorted to Battery',
            'U0007': 'High Speed CAN Communication Bus Shorted to Ground',
            'U0008': 'High Speed CAN Communication Bus Shorted to Bus',
            'U0009': 'High Speed CAN Communication Bus Shorted to Bus',
            'U0010': 'Medium Speed CAN Communication Bus',
            'U0011': 'Medium Speed CAN Communication Bus Performance',
            'U0012': 'Medium Speed CAN Communication Bus Low',
            'U0013': 'Medium Speed CAN Communication Bus High',
            'U0100': 'Lost Communication With ECM/PCM',
            'U0101': 'Lost Communication With TCM',
            'U0102': 'Lost Communication With Transfer Case Control Module',
            'U0103': 'Lost Communication With Gear Shift Control Module',
            'U0104': 'Lost Communication With Cruise Control Module',
            'U0105': 'Lost Communication With Fuel Injector Control Module',
            'U0106': 'Lost Communication With Glow Plug Control Module',
            'U0107': 'Lost Communication With Throttle Actuator Control Module',
            'U0108': 'Lost Communication With Alternative Fuel Control Module',
            'U0109': 'Lost Communication With Fuel Pump Control Module',
            'U0110': 'Lost Communication With Drive Motor Control Module',
            'U0111': 'Lost Communication With Battery Energy Control Module A',
            'U0112': 'Lost Communication With Battery Energy Control Module B',
            'U0113': 'Lost Communication With Emissions Critical Control Information',
            'U0114': 'Lost Communication With Four-Wheel Drive Clutch Control Module',
            'U0115': 'Lost Communication With ECM/PCM B',
            'U0121': 'Lost Communication With Anti-Lock Brake System (ABS) Control Module',
            'U0122': 'Lost Communication With Vehicle Dynamics Control Module',
            'U0123': 'Lost Communication With Yaw Rate Sensor Module',
            'U0124': 'Lost Communication With Lateral Acceleration Sensor Module',
            'U0125': 'Lost Communication With Multi-Axis Acceleration Sensor Module',
            'U0126': 'Lost Communication With Steering Angle Sensor Module',
            'U0127': 'Lost Communication With Tire Pressure Monitor Module',
            'U0128': 'Lost Communication With Park Brake Control Module',
            'U0129': 'Lost Communication With Brake System Control Module',
            'U0130': 'Lost Communication With Steering Effort Control Module',
            'U0131': 'Lost Communication With Power Steering Control Module',
            'U0140': 'Lost Communication With Body Control Module',
            'U0141': 'Lost Communication With Body Control Module A',
            'U0142': 'Lost Communication With Body Control Module B',
            'U0143': 'Lost Communication With Body Control Module C',
            'U0144': 'Lost Communication With Body Control Module D',
            'U0145': 'Lost Communication With Body Control Module E',
            'U0146': 'Lost Communication With Gateway A',
            'U0147': 'Lost Communication With Gateway B',
            'U0148': 'Lost Communication With Gateway C',
            'U0149': 'Lost Communication With Gateway D',
            'U0150': 'Lost Communication With Gateway E',
            'U0151': 'Lost Communication With Restraints Control Module',
            'U0152': 'Lost Communication With Left Restraints Control Module',
            'U0153': 'Lost Communication With Right Restraints Control Module',
            'U0154': 'Lost Communication With Restraints Occupant Classification System Module',
            'U0155': 'Lost Communication With Instrument Panel Cluster (IPC) Control Module',
            'U0156': 'Lost Communication With Information Center A',
            'U0157': 'Lost Communication With Information Center B',
            'U0158': 'Lost Communication With Head Up Display',
            'U0159': 'Lost Communication With Parking Assist Control Module',
            'U0160': 'Lost Communication With Audible Alert Control Module',
            'U0161': 'Lost Communication With Compass Module',
            'U0162': 'Lost Communication With Navigation Display Module',
            'U0163': 'Lost Communication With Navigation Control Module',
            'U0164': 'Lost Communication With HVAC Control Module'
        }
    
    def decode_dtc_from_bytes(self, byte1: int, byte2: int) -> str:
        """
        Decode DTC from two bytes according to ISO 15031-6
        
        Args:
            byte1: First byte of DTC
            byte2: Second byte of DTC
            
        Returns:
            5-character DTC string (e.g., 'P0301')
        """
        # Extract system (first 2 bits of byte1)
        systems = ['P', 'C', 'B', 'U']
        system = systems[(byte1 >> 6) & 0x03]
        
        # Extract first digit (next 2 bits of byte1)
        first_digit = (byte1 >> 4) & 0x03
        
        # Extract remaining digits
        second_digit = byte1 & 0x0F
        third_digit = (byte2 >> 4) & 0x0F
        fourth_digit = byte2 & 0x0F
        
        return f"{system}{first_digit:X}{second_digit:X}{third_digit:X}{fourth_digit:X}"
    
    def encode_dtc_to_bytes(self, dtc: str) -> Tuple[int, int]:
        """
        Encode DTC string to two bytes
        
        Args:
            dtc: DTC string (e.g., 'P0301')
            
        Returns:
            Tuple of (byte1, byte2)
        """
        if len(dtc) != 5:
            raise ValueError(f"Invalid DTC format: {dtc}")
        
        # Map system character to bits
        system_map = {'P': 0, 'C': 1, 'B': 2, 'U': 3}
        if dtc[0] not in system_map:
            raise ValueError(f"Invalid DTC system: {dtc[0]}")
        
        system_bits = system_map[dtc[0]]
        
        # Parse digits
        try:
            digits = [int(c, 16) for c in dtc[1:]]
        except ValueError:
            raise ValueError(f"Invalid DTC format: {dtc}")
        
        # Construct bytes
        byte1 = (system_bits << 6) | (digits[0] << 4) | digits[1]
        byte2 = (digits[2] << 4) | digits[3]
        
        return byte1, byte2
    
    def decode_status_byte(self, status: int) -> Dict[str, bool]:
        """
        Decode DTC status byte according to ISO 14229-1
        
        Args:
            status: Status byte value
            
        Returns:
            Dictionary of status bit meanings
        """
        status_dict = {}
        for bit, meaning in self.status_bits.items():
            status_dict[meaning] = bool(status & (1 << bit))
        return status_dict
    
    def lookup_dtc(self, dtc: str) -> Optional[str]:
        """
        Look up DTC description
        
        Args:
            dtc: DTC string (e.g., 'P0301')
            
        Returns:
            Description if found, None otherwise
        """
        # Check generic DTCs first
        if dtc in self.generic_dtcs:
            return self.generic_dtcs[dtc]
        
        # Check manufacturer-specific DTCs
        if dtc in self.manufacturer_dtcs:
            return self.manufacturer_dtcs[dtc]
        
        # Check body codes
        if dtc in self.body_dtcs:
            return self.body_dtcs[dtc]
        
        # Check chassis codes
        if dtc in self.chassis_dtcs:
            return self.chassis_dtcs[dtc]
        
        # Check network codes
        if dtc in self.network_dtcs:
            return self.network_dtcs[dtc]
        
        return None
    
    def get_dtc_info(self, dtc: str) -> Dict[str, str]:
        """
        Get comprehensive information about a DTC
        
        Args:
            dtc: DTC string (e.g., 'P0301')
            
        Returns:
            Dictionary with DTC information
        """
        info = {
            'code': dtc,
            'system': 'Unknown',
            'type': 'Unknown',
            'description': 'Unknown DTC'
        }
        
        if len(dtc) >= 2:
            # Get system
            if dtc[0] in self.dtc_systems:
                info['system'] = self.dtc_systems[dtc[0]]
            
            # Get type
            if dtc[1] in self.dtc_types:
                info['type'] = self.dtc_types[dtc[1]]
        
        # Get description
        description = self.lookup_dtc(dtc)
        if description:
            info['description'] = description
        
        return info
    
    def search_dtcs(self, keyword: str) -> List[Tuple[str, str]]:
        """
        Search for DTCs containing keyword in description
        
        Args:
            keyword: Search keyword
            
        Returns:
            List of (dtc, description) tuples
        """
        results = []
        keyword_lower = keyword.lower()
        
        # Search all DTC dictionaries
        all_dtcs = {
            **self.generic_dtcs,
            **self.manufacturer_dtcs,
            **self.body_dtcs,
            **self.chassis_dtcs,
            **self.network_dtcs
        }
        
        for dtc, desc in all_dtcs.items():
            if keyword_lower in desc.lower():
                results.append((dtc, desc))
        
        return sorted(results)
    
    def get_related_dtcs(self, dtc: str) -> List[Tuple[str, str]]:
        """
        Get DTCs related to the given DTC (same subsystem)
        
        Args:
            dtc: DTC string
            
        Returns:
            List of related (dtc, description) tuples
        """
        if len(dtc) < 5:
            return []
        
        # Get base code (first 3 characters for subsystem grouping)
        base = dtc[:3]
        results = []
        
        # Search all DTC dictionaries
        all_dtcs = {
            **self.generic_dtcs,
            **self.manufacturer_dtcs,
            **self.body_dtcs,
            **self.chassis_dtcs,
            **self.network_dtcs
        }
        
        for code, desc in all_dtcs.items():
            if code.startswith(base) and code != dtc:
                results.append((code, desc))
        
        return sorted(results)
    
    def format_dtc_report(self, dtc: str, include_related: bool = False) -> str:
        """
        Format a comprehensive DTC report
        
        Args:
            dtc: DTC string
            include_related: Include related DTCs
            
        Returns:
            Formatted report string
        """
        report = []
        
        # Get basic info
        info = self.get_dtc_info(dtc)
        
        report.append(f"DTC Report: {dtc}")
        report.append("=" * 40)
        report.append(f"System: {info['system']}")
        report.append(f"Type: {info['type']}")
        report.append(f"Description: {info['description']}")
        
        # Add byte representation
        try:
            byte1, byte2 = self.encode_dtc_to_bytes(dtc)
            report.append(f"Byte representation: 0x{byte1:02X} 0x{byte2:02X}")
        except ValueError:
            pass
        
        # Add related DTCs if requested
        if include_related:
            related = self.get_related_dtcs(dtc)
            if related:
                report.append("\nRelated DTCs:")
                report.append("-" * 40)
                for code, desc in related[:10]:  # Limit to 10
                    report.append(f"{code}: {desc}")
        
        return "\n".join(report)

def main():
    parser = argparse.ArgumentParser(description='DTC Lookup Tool')
    parser.add_argument('dtc', nargs='?', help='DTC code to look up (e.g., P0301)')
    parser.add_argument('-b', '--bytes', nargs=2, type=lambda x: int(x, 16),
                        help='Decode DTC from two hex bytes (e.g., -b 0x01 0x01)')
    parser.add_argument('-s', '--status', type=lambda x: int(x, 16),
                        help='Decode DTC status byte (hex)')
    parser.add_argument('-f', '--find', help='Search for DTCs containing keyword')
    parser.add_argument('-r', '--related', action='store_true',
                        help='Show related DTCs')
    parser.add_argument('-i', '--interactive', action='store_true',
                        help='Interactive mode')
    
    args = parser.parse_args()
    
    lookup = DTCLookup()
    
    if args.interactive:
        print("DTC Lookup Tool - Interactive Mode")
        print("Commands: 'lookup P0301', 'search misfire', 'decode 0x01 0x01', 'status 0xFF', 'quit'")
        print()
        
        while True:
            try:
                cmd = input("dtc> ").strip().split()
                if not cmd:
                    continue
                
                if cmd[0] == 'quit':
                    break
                elif cmd[0] == 'lookup' and len(cmd) > 1:
                    print(lookup.format_dtc_report(cmd[1], args.related))
                elif cmd[0] == 'search' and len(cmd) > 1:
                    results = lookup.search_dtcs(' '.join(cmd[1:]))
                    if results:
                        print(f"\nFound {len(results)} DTCs:")
                        for dtc, desc in results:
                            print(f"  {dtc}: {desc}")
                    else:
                        print("No DTCs found")
                elif cmd[0] == 'decode' and len(cmd) > 2:
                    byte1 = int(cmd[1], 16)
                    byte2 = int(cmd[2], 16)
                    dtc = lookup.decode_dtc_from_bytes(byte1, byte2)
                    print(lookup.format_dtc_report(dtc, args.related))
                elif cmd[0] == 'status' and len(cmd) > 1:
                    status = int(cmd[1], 16)
                    status_dict = lookup.decode_status_byte(status)
                    print(f"\nDTC Status Byte: 0x{status:02X}")
                    print("-" * 40)
                    for bit, active in status_dict.items():
                        print(f"  {bit}: {'YES' if active else 'NO'}")
                else:
                    print("Invalid command")
                print()
            except Exception as e:
                print(f"Error: {e}\n")
    
    elif args.bytes:
        # Decode from bytes
        dtc = lookup.decode_dtc_from_bytes(args.bytes[0], args.bytes[1])
        print(lookup.format_dtc_report(dtc, args.related))
    
    elif args.status is not None:
        # Decode status byte
        status_dict = lookup.decode_status_byte(args.status)
        print(f"DTC Status Byte: 0x{args.status:02X}")
        print("-" * 40)
        for bit, active in status_dict.items():
            print(f"{bit}: {'YES' if active else 'NO'}")
    
    elif args.find:
        # Search DTCs
        results = lookup.search_dtcs(args.find)
        if results:
            print(f"Found {len(results)} DTCs containing '{args.find}':")
            for dtc, desc in results:
                print(f"{dtc}: {desc}")
        else:
            print(f"No DTCs found containing '{args.find}'")
    
    elif args.dtc:
        # Look up specific DTC
        print(lookup.format_dtc_report(args.dtc, args.related))
    
    else:
        # Print usage
        parser.print_help()
        print("\nExample DTCs:")
        print("  P0301 - Cylinder 1 Misfire Detected")
        print("  P0171 - System Too Lean (Bank 1)")
        print("  P0420 - Catalyst System Efficiency Below Threshold")
        print("  U0100 - Lost Communication With ECM/PCM")
        print("  B0001 - Driver Frontal Stage 1 Deployment Control")
        print("  C0035 - Left Front Wheel Speed Sensor Circuit")

if __name__ == '__main__':
    main()