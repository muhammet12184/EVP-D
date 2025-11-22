# UDS Protocol Examples and Implementation Guide

## Common UDS Communication Examples

### 1. Diagnostic Session Control

#### Enter Extended Diagnostic Session
```
Request:  02 10 03
Response: 02 50 03

Where:
- 02: Length
- 10: DiagnosticSessionControl service
- 03: Extended diagnostic session
- 50: Positive response (10 + 40)
```

#### Enter Programming Session
```
Request:  02 10 02
Response: 06 50 02 00 32 01 F4

Where:
- Response includes:
  - 50 02: Positive response with session type
  - 00 32: P2 timing (50ms)
  - 01 F4: P2* timing (500ms)
```

### 2. Security Access

#### Request Seed (Level 1)
```
Request:  02 27 01
Response: 04 67 01 12 34

Where:
- 27: SecurityAccess service
- 01: Request seed for level 1
- 67: Positive response
- 12 34: Seed value
```

#### Send Key (Level 1)
```
Request:  04 27 02 AB CD
Response: 02 67 02

Where:
- 02: Send key for level 1
- AB CD: Calculated key
- 67 02: Positive response
```

### 3. Read Data By Identifier

#### Read VIN
```
Request:  03 22 F1 90
Response: 14 62 F1 90 57 42 41 5A 5A 5A 38 5A 35 46 41 30 30 30 30 30 31

Where:
- 22: ReadDataByIdentifier service
- F1 90: VIN DID
- 62: Positive response
- 57 42 41...: VIN data (WBAZZZ8Z5FA00001)
```

#### Read Multiple DIDs
```
Request:  05 22 F1 90 F1 8C
Response: 1A 62 F1 90 57 42 41 5A 5A 5A 38 5A 35 46 41 30 30 30 30 30 31 F1 8C 31 32 33 34

Where:
- F1 90: VIN
- F1 8C: ECU Serial Number
```

### 4. Write Data By Identifier

#### Write Coding Data
```
Request:  10 08 2E F1 00 01 02 03 04 05
Response: 03 6E F1 00

Where:
- 2E: WriteDataByIdentifier service
- F1 00: Coding DID
- 01 02 03 04 05: New coding data
- 6E: Positive response
```

### 5. Read DTC Information

#### Read Number of DTCs
```
Request:  03 19 01 08
Response: 06 59 01 08 00 00 02

Where:
- 19: ReadDTCInformation service
- 01: reportNumberOfDTCByStatusMask
- 08: Status mask (confirmed DTCs)
- 00 00 02: 2 DTCs found
```

#### Read DTCs by Status Mask
```
Request:  03 19 02 08
Response: 0B 59 02 08 01 23 45 08 02 34 56 08

Where:
- 02: reportDTCByStatusMask
- 01 23 45 08: First DTC (P012345, status 08)
- 02 34 56 08: Second DTC (P023456, status 08)
```

### 6. Clear DTCs
```
Request:  04 14 FF FF FF
Response: 01 54

Where:
- 14: ClearDiagnosticInformation service
- FF FF FF: Clear all DTCs
- 54: Positive response
```

### 7. Routine Control

#### Start Routine - Erase Memory
```
Request:  04 31 01 FF 00
Response: 05 71 01 FF 00 01

Where:
- 31: RoutineControl service
- 01: Start routine
- FF 00: Routine identifier
- 71: Positive response
- 01: Routine status
```

#### Request Routine Results
```
Request:  04 31 03 FF 00
Response: 06 71 03 FF 00 00 64

Where:
- 03: Request results
- 00 64: Result (100%)
```

### 8. Tester Present
```
Request:  02 3E 00
Response: 02 7E 00

Or with suppress positive response:
Request:  02 3E 80
Response: (No response expected)
```

### 9. ECU Reset

#### Hard Reset
```
Request:  02 11 01
Response: 02 51 01

Where:
- 11: ECUReset service
- 01: Hard reset type
```

### 10. Control DTC Setting

#### Disable DTC Setting
```
Request:  02 85 02
Response: 02 C5 02

Where:
- 85: ControlDTCSetting service
- 02: Off (disable)
```

## Multi-Frame Messages (ISO-TP)

### First Frame (FF)
```
10 14 22 F1 90 F1 91 F1

Where:
- 1: First frame indicator
- 0 14: Data length (20 bytes)
- 22 F1 90...: Start of data
```

### Consecutive Frame (CF)
```
21 92 F1 93 F1 94 F1 95
22 F1 96 F1 97 00 00 00

Where:
- 21, 22: Sequence numbers
- Data continues...
```

### Flow Control (FC)
```
30 00 14

Where:
- 30: Flow control
- 00: Continue to send
- 14: Block size (20 frames)
```

## Common Security Algorithms

### Simple XOR Algorithm
```python
def calculate_key_xor(seed, secret_key):
    """
    Simple XOR algorithm
    seed: 2 or 4 byte seed from ECU
    secret_key: Manufacturer specific key
    """
    key = []
    for i, byte in enumerate(seed):
        key.append(byte ^ secret_key[i % len(secret_key)])
    return key
```

### Seed + Constant Algorithm
```python
def calculate_key_add(seed, constant):
    """
    Add constant to seed
    """
    seed_value = int.from_bytes(seed, 'big')
    key_value = (seed_value + constant) & 0xFFFFFFFF
    return key_value.to_bytes(4, 'big')
```

### Bit Manipulation Algorithm
```python
def calculate_key_bitwise(seed):
    """
    Complex bit manipulation
    """
    seed_value = int.from_bytes(seed, 'big')
    
    # Example: Rotate left, XOR, add constant
    key = seed_value
    key = ((key << 5) | (key >> 27)) & 0xFFFFFFFF  # ROL 5
    key = key ^ 0x12345678  # XOR with constant
    key = (key + 0x87654321) & 0xFFFFFFFF  # Add constant
    
    return key.to_bytes(4, 'big')
```

## DTC Format Conversion

### Convert DTC bytes to OBD Code
```python
def dtc_bytes_to_string(byte1, byte2, byte3):
    """
    Convert 3 DTC bytes to P/C/B/U code format
    """
    # First two bits determine system
    systems = ['P', 'C', 'B', 'U']
    system = systems[(byte1 & 0xC0) >> 6]
    
    # Next two bits are first digit
    first_digit = (byte1 & 0x30) >> 4
    
    # Remaining 12 bits are the code
    code = ((byte1 & 0x0F) << 8) | byte2
    
    return f"{system}{first_digit:01X}{code:03X}"
```

## Timing Considerations

### P2 and P2* Timing
```python
import time

def send_request_with_timeout(request, p2_time=50, p2_star_time=5000):
    """
    Send request and handle response pending
    """
    send_request(request)
    
    start_time = time.time()
    timeout = p2_time / 1000.0  # Convert to seconds
    
    while True:
        if time.time() - start_time > timeout:
            raise TimeoutError("No response received")
            
        response = receive_response()
        
        if response:
            if response[1] == 0x7F and response[3] == 0x78:
                # Response pending - switch to P2*
                timeout = p2_star_time / 1000.0
                start_time = time.time()
                continue
            else:
                return response
```

### Tester Present Keep-Alive
```python
import threading

class TesterPresent:
    def __init__(self, interval=4.0):
        self.interval = interval
        self.running = False
        self.thread = None
    
    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self._send_tester_present)
        self.thread.start()
    
    def stop(self):
        self.running = False
        if self.thread:
            self.thread.join()
    
    def _send_tester_present(self):
        while self.running:
            # Send tester present with suppress positive response
            send_request([0x02, 0x3E, 0x80])
            time.sleep(self.interval)
```

## Error Handling

### Negative Response Handling
```python
def handle_response(response):
    if len(response) >= 3 and response[0] == 0x7F:
        sid = response[1]
        nrc = response[2]
        
        nrc_descriptions = {
            0x10: "General Reject",
            0x11: "Service Not Supported",
            0x12: "Sub-Function Not Supported",
            0x13: "Incorrect Message Length",
            0x22: "Conditions Not Correct",
            0x33: "Security Access Denied",
            0x35: "Invalid Key",
            0x78: "Response Pending",
            # ... more NRCs
        }
        
        desc = nrc_descriptions.get(nrc, f"Unknown NRC: 0x{nrc:02X}")
        raise Exception(f"Negative Response for SID 0x{sid:02X}: {desc}")
```

## Diagnostic Job Examples

### Complete Programming Sequence
```python
def programming_sequence():
    # 1. Enter extended diagnostic session
    send_and_check([0x10, 0x03])
    
    # 2. Disable DTC recording
    send_and_check([0x85, 0x02])
    
    # 3. Request security access
    response = send_and_check([0x27, 0x09])  # Level 9 for programming
    seed = response[2:6]
    
    key = calculate_key(seed)
    send_and_check([0x27, 0x0A] + key)
    
    # 4. Enter programming session
    send_and_check([0x10, 0x02])
    
    # 5. Start tester present
    tp = TesterPresent()
    tp.start()
    
    # 6. Write fingerprint
    send_and_check([0x2E, 0xF1, 0x5A] + fingerprint_data)
    
    # 7. Erase memory
    send_and_check([0x31, 0x01, 0xFF, 0x00])
    wait_for_routine_complete([0x31, 0x03, 0xFF, 0x00])
    
    # 8. Request download
    send_and_check([0x34, 0x00, 0x44] + address + size)
    
    # 9. Transfer data
    block_counter = 1
    for block in data_blocks:
        send_and_check([0x36, block_counter] + block)
        block_counter = (block_counter + 1) & 0xFF
    
    # 10. Request transfer exit
    send_and_check([0x37])
    
    # 11. Check programming dependencies
    send_and_check([0x31, 0x01, 0xFF, 0x01])
    
    # 12. ECU Reset
    send_and_check([0x11, 0x01])
    
    tp.stop()
```

## CAN Frame Examples

### Standard CAN (11-bit ID)
```
CAN ID: 0x7E0 (Tester -> ECU)
CAN ID: 0x7E8 (ECU -> Tester)

Single Frame:
ID: 0x7E0, DLC: 8, Data: 02 10 03 00 00 00 00 00
ID: 0x7E8, DLC: 8, Data: 06 50 03 00 32 01 F4 00
```

### Extended CAN (29-bit ID)
```
CAN ID: 0x18DA00F1 (Tester -> ECU)
CAN ID: 0x18DAF100 (ECU -> Tester)
```

## Manufacturer Specific Examples

### BMW F-Series Coding
```
# Read I-Step
Request:  22 F1 01
Response: 62 F1 01 46 30 32 30 2D 31 36 2D 30 33 2D 35 30 32

# Write Vehicle Order (FA)
Request:  2E F1 02 [FA Data]
Response: 6E F1 02
```

### VAG (Volkswagen Group) Adaptations
```
# Read Adaptation Channel
Request:  22 F1 AA [Channel Number]
Response: 62 F1 AA [Channel Number] [Value]

# Write Adaptation
Request:  2E F1 AA [Channel Number] [New Value]
Response: 6E F1 AA
```

### Mercedes-Benz SCN Coding
```
# Start SCN Coding Session
Request:  10 86
Response: 50 86

# Transfer SCN Data
Request:  36 [Block Counter] [SCN Data]
Response: 76 [Block Counter]
```