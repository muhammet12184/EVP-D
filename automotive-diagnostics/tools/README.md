# Automotive Diagnostic Tools

This directory contains Python-based diagnostic tools for automotive diagnostics. All tools support both command-line and interactive modes.

## Available Tools

### 1. PID Decoder (`pid_decoder.py`)
Decodes OBD-II PID responses into human-readable values.

**Features:**
- Decode individual PID responses
- Parse full CAN messages
- Convert DTC bytes to standard format
- Support for all standard Mode 01 PIDs

**Usage:**
```bash
# Decode a single PID
./pid_decoder.py 0x0C 12 34

# Decode from CAN message
./pid_decoder.py --can 7E8 04 41 0C 12 34

# Decode DTC
./pid_decoder.py --dtc 01 43

# Interactive mode
./pid_decoder.py -i
```

### 2. UDS Helper (`uds_helper.py`)
Build and decode UDS (ISO 14229) messages.

**Features:**
- Build UDS service requests
- Decode UDS responses
- Handle negative response codes
- Security access key calculation
- Support for all standard UDS services

**Usage:**
```bash
# Build a UDS request
./uds_helper.py build 0x22 F190

# Decode a UDS response
./uds_helper.py decode 62 F1 90 57 56 57 5A 5A 5A

# Calculate security key
./uds_helper.py key 12345678

# Interactive mode
./uds_helper.py -i
```

### 3. DTC Lookup Tool (`dtc_lookup.py`)
Comprehensive DTC information and lookup.

**Features:**
- Decode DTCs from bytes
- Look up DTC descriptions
- Search DTCs by keyword
- Show related DTCs
- Decode DTC status bytes
- Support for P/C/B/U codes

**Usage:**
```bash
# Look up a DTC
./dtc_lookup.py P0301

# Decode from bytes
./dtc_lookup.py -b 0x01 0x01

# Search for DTCs
./dtc_lookup.py -f misfire

# Decode status byte
./dtc_lookup.py -s 0xFF

# Show related DTCs
./dtc_lookup.py P0171 -r

# Interactive mode
./dtc_lookup.py -i
```

### 4. CAN Message Tool (`can_message_tool.py`)
Build and decode CAN messages with ISO-TP support.

**Features:**
- Build single and multi-frame CAN messages
- Decode CAN frames with ISO-TP
- Support for standard and extended CAN IDs
- UDS message building
- Common CAN ID database

**Usage:**
```bash
# Build a CAN frame
./can_message_tool.py build 0x7E0 "02 01 0C"

# Decode a CAN frame
./can_message_tool.py decode 0x7E8 "03 41 0C 12 34"

# Build UDS message with ISO-TP
./can_message_tool.py uds 0x22 0x7E0 -d "F1 90"

# Show protocol info
./can_message_tool.py info ids

# Interactive mode
./can_message_tool.py interactive
```

### 5. Diagnostic Scanner (`diagnostic_scanner.py`)
Comprehensive diagnostic scanner combining all capabilities.

**Features:**
- Vehicle connection simulation
- Read/clear DTCs
- Scan supported PIDs
- Live data monitoring
- Freeze frame data
- Actuator tests
- Module scanning
- Readiness status
- UDS diagnostic sessions

**Usage:**
```bash
# Quick scan (non-interactive)
./diagnostic_scanner.py

# Interactive mode with auto-detection
./diagnostic_scanner.py -i

# Specify protocol
./diagnostic_scanner.py -i -p ISO15765

# Specify device
./diagnostic_scanner.py -i -d /dev/ttyUSB0
```

## Common Use Cases

### 1. Decode Engine RPM
```bash
# If you receive: 7E8 04 41 0C 1A F8
./can_message_tool.py decode 0x7E8 "04 41 0C 1A F8"
# Or directly decode the PID:
./pid_decoder.py 0x0C 1A F8
# Result: Engine Speed = 1726.0 rpm
```

### 2. Read Vehicle VIN
```bash
# Build the request
./uds_helper.py build 0x22 F190
# Result: Request: 22 F1 90

# Decode the response
./uds_helper.py decode "62 F1 90 57 56 57 5A 5A 5A 33 43 5A 4A 45 30 30 30 30 30 31"
# Result: VIN = WVWZZZ3CZJE00001
```

### 3. Check for Misfires
```bash
# Search for misfire-related DTCs
./dtc_lookup.py -f misfire

# Look up specific misfire code
./dtc_lookup.py P0301
```

### 4. Build Multi-Frame UDS Request
```bash
# Long UDS message (e.g., Write Data)
./can_message_tool.py uds 0x2E 0x7E0 -d "F1 90 57 56 57 5A 5A 5A 33 43 5A 4A 45 30 30 30 30 30 31"
# Will generate multiple CAN frames with ISO-TP
```

### 5. Complete Vehicle Scan
```bash
# Use the diagnostic scanner in interactive mode
./diagnostic_scanner.py -i
# Then select options:
# 1 - Vehicle Information
# 2 - Read DTCs
# 4 - Scan PIDs
# 8 - Module Scan
```

## Tool Integration

The tools can be used together in scripts:

```python
#!/usr/bin/env python3
import subprocess
import json

# Read DTCs
dtc_result = subprocess.run(['./dtc_lookup.py', 'P0171'], 
                          capture_output=True, text=True)

# Build UDS request
uds_result = subprocess.run(['./uds_helper.py', 'build', '0x19', '0x02'], 
                          capture_output=True, text=True)

# Decode CAN message
can_result = subprocess.run(['./can_message_tool.py', 'decode', '0x7E8', '03 41 0D 37'], 
                          capture_output=True, text=True)
```

## Notes

1. **These are educational tools** - Real vehicle communication requires proper hardware interfaces
2. **The diagnostic scanner simulates responses** - Useful for learning and testing
3. **Always follow safety procedures** when working with real vehicles
4. **Some functions require elevated permissions** or specific hardware
5. **Extended/manufacturer-specific functions** may require additional documentation

## Error Codes

Common error patterns:
- `0x7F XX 11`: Service not supported
- `0x7F XX 12`: Sub-function not supported
- `0x7F XX 13`: Incorrect message length
- `0x7F XX 22`: Conditions not correct
- `0x7F XX 33`: Security access denied
- `0x7F XX 35`: Invalid key
- `0x7F XX 78`: Response pending

## Contributing

When adding new tools:
1. Follow the existing pattern of CLI + interactive mode
2. Include comprehensive help text
3. Add error handling for invalid inputs
4. Support both hex and decimal inputs where applicable
5. Include examples in the tool's help output