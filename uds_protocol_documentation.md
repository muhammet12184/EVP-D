# UDS (Unified Diagnostic Services) Protocol Documentation

## ISO 14229 - UDS Protocol Standard

### Service IDs (SIDs)

| Service ID | Service Name | Description |
|------------|-------------|-------------|
| 0x10 | Diagnostic Session Control | Start/stop diagnostic sessions |
| 0x11 | ECU Reset | Reset ECU |
| 0x14 | Clear Diagnostic Information | Clear DTCs |
| 0x19 | Read DTC Information | Read diagnostic trouble codes |
| 0x22 | Read Data By Identifier | Read data using PIDs |
| 0x23 | Read Memory By Address | Read memory locations |
| 0x27 | Security Access | Unlock protected functions |
| 0x28 | Communication Control | Control communication |
| 0x2E | Write Data By Identifier | Write data using PIDs |
| 0x2F | Input Output Control By Identifier | Control I/O |
| 0x31 | Routine Control | Execute routines |
| 0x34 | Request Download | Initiate data download |
| 0x35 | Request Upload | Initiate data upload |
| 0x36 | Transfer Data | Transfer data blocks |
| 0x37 | Request Transfer Exit | End data transfer |
| 0x3D | Write Memory By Address | Write to memory |
| 0x3E | Tester Present | Keep session active |
| 0x85 | Control DTC Setting | Enable/disable DTC storage |

### Diagnostic Session Types (Sub-functions of 0x10)

| Session Type | Hex Value | Description |
|--------------|-----------|-------------|
| Default Session | 0x01 | Normal operation mode |
| Programming Session | 0x02 | ECU programming/flashing |
| Extended Diagnostic Session | 0x03 | Extended diagnostics |
| Safety System Diagnostic Session | 0x04 | Safety-related diagnostics |

### ECU Reset Types (Sub-functions of 0x11)

| Reset Type | Hex Value | Description |
|------------|-----------|-------------|
| Hard Reset | 0x01 | Power cycle simulation |
| Key Off/On Reset | 0x02 | Ignition cycle simulation |
| Soft Reset | 0x03 | Software reset |

### Security Access Levels (Service 0x27)

| Level | Request | Response | Description |
|-------|---------|----------|-------------|
| Level 1 | 0x01 | 0x02 | Seed/Key level 1 |
| Level 3 | 0x03 | 0x04 | Seed/Key level 3 |
| Level 5 | 0x05 | 0x06 | Seed/Key level 5 |

### Common CAN Headers

| ECU Type | CAN ID (Hex) | Response ID |
|----------|--------------|-------------|
| Engine ECU | 0x7E0 | 0x7E8 |
| Transmission | 0x7E1 | 0x7E9 |
| ABS/ESP | 0x7E2 | 0x7EA |
| Airbag | 0x7E3 | 0x7EB |
| Battery Management (EV) | 0x7E4 | 0x7EC |
| Instrument Cluster | 0x7E5 | 0x7ED |
| Body Control Module | 0x7E6 | 0x7EE |
| Gateway | 0x7E7 | 0x7EF |

### UDS Request Format

```
[CAN ID] [Length] [Service ID] [Sub-function/PID] [Data...]
```

Example: Read Battery SOC
```
7E4 02 22 015C
```

### UDS Response Format

```
[Response ID] [Length] [Service ID + 0x40] [Sub-function/PID] [Data...]
```

Example Response:
```
7EC 03 62 015C 64  (SOC = 100%)
```

### Negative Response Codes (NRC)

| Code | Name | Description |
|------|------|-------------|
| 0x10 | General Reject | General rejection |
| 0x11 | Service Not Supported | Service not available |
| 0x12 | Sub-function Not Supported | Sub-function not available |
| 0x13 | Incorrect Message Length | Wrong length |
| 0x22 | Conditions Not Correct | Conditions not met |
| 0x31 | Request Out Of Range | Invalid request |
| 0x33 | Security Access Denied | Security not unlocked |
| 0x35 | Invalid Key | Wrong security key |
| 0x36 | Exceed Number Of Attempts | Too many attempts |
| 0x37 | Required Time Delay Not Expired | Wait required |
| 0x78 | Request Correctly Received - Response Pending | Processing |

## Common UDS Sequences

### Reading PIDs
1. Start extended diagnostic session: `10 03`
2. Read data by identifier: `22 [PID]`

### Clearing DTCs
1. Start extended diagnostic session: `10 03`
2. Clear diagnostic information: `14 FFFFFF`

### Security Access
1. Request seed: `27 01`
2. Send key: `27 02 [KEY]`

### Tester Present (Keep session alive)
- Send every 2-5 seconds: `3E 00`
