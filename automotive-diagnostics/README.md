# Automotive Diagnostics Reference

A comprehensive collection of automotive diagnostic protocols, PIDs (Parameter IDs), and tools for various vehicle types including electric (EV), diesel, gasoline/petrol, and LPG vehicles.

## 📁 Directory Structure

```
automotive-diagnostics/
├── obd2-standard/          # Standard OBD-II PIDs and protocols
├── uds-protocols/          # UDS (ISO 14229) protocol documentation
├── vehicle-types/          # Vehicle type specific PIDs
│   ├── electric/           # EV specific parameters
│   ├── diesel/             # Diesel engine specific
│   ├── petrol/             # Gasoline/petrol specific
│   └── lpg/                # LPG system specific
├── brands/                 # Manufacturer specific protocols
│   ├── volkswagen-group/   # VAG (VW, Audi, Porsche, etc.)
│   ├── toyota/             # Toyota and Lexus
│   ├── mercedes/           # Mercedes-Benz
│   ├── bmw/                # BMW and MINI
│   └── others/             # Other manufacturers
├── tools/                  # Diagnostic utilities
└── documentation/          # Additional guides

```

## 🚗 Supported Vehicle Types

### Electric Vehicles (EV)
- Battery Management System (BMS) parameters
- Motor and inverter data
- Charging system diagnostics
- Thermal management
- High voltage safety systems

### Diesel Vehicles
- Common rail fuel system
- Turbocharger parameters
- EGR system data
- DPF/SCR aftertreatment
- Injection timing and quantity

### Petrol/Gasoline Vehicles
- Fuel injection systems (Port and Direct)
- Ignition system parameters
- Variable valve timing (VVT/VANOS)
- Knock detection
- Emission control systems

### LPG Vehicles
- Dual fuel system parameters
- LPG injection and pressure data
- Fuel switching logic
- Safety systems
- Consumption metrics

## 📊 Diagnostic Protocols

### OBD-II (SAE J1979)
- Standard PIDs (Mode 01-0A)
- Freeze frame data
- Diagnostic trouble codes (DTCs)
- Oxygen sensor tests
- Vehicle information

### UDS (ISO 14229)
- Diagnostic services (SIDs)
- Data identifiers (DIDs)
- Routine identifiers
- Security access procedures
- Flash programming

### Manufacturer Specific
- VAG measuring blocks
- Toyota enhanced PIDs
- Mercedes-Benz actual values
- BMW status information

## 🛠️ Quick Reference

### Common PIDs

| PID  | Description                    | Formula        |
|------|--------------------------------|----------------|
| 0x0C | Engine Speed                   | (256*A+B)/4    |
| 0x0D | Vehicle Speed                  | A              |
| 0x04 | Calculated Engine Load         | A/2.55         |
| 0x05 | Engine Coolant Temperature     | A-40           |
| 0x10 | Mass Air Flow Rate             | (256*A+B)/100  |

### CAN IDs (Standard)

| ID    | Function                       |
|-------|--------------------------------|
| 0x7DF | OBD-II Broadcast Request       |
| 0x7E0 | Engine Control Module Request  |
| 0x7E8 | Engine Control Module Response |
| 0x7E1 | Transmission Module Request    |
| 0x7E9 | Transmission Module Response   |

## 📖 Usage Examples

### Reading Engine RPM (OBD-II)
```
Request:  7DF 02 01 0C 00 00 00 00 00
Response: 7E8 04 41 0C 1A F8 00 00 00
RPM = (256 * 0x1A + 0xF8) / 4 = 1726 RPM
```

### UDS Read Data By Identifier
```
Request:  7E0 03 22 F1 90 00 00 00 00
Response: 7E8 13 62 F1 90 ... (VIN data)
```

## 🔧 Tools Included

- **PID Decoder**: Convert raw PID responses to human-readable values
- **DTC Lookup**: Decode diagnostic trouble codes
- **CAN Frame Analyzer**: Parse CAN messages
- **UDS Service Helper**: Build UDS requests
- **Unit Converter**: Convert between different measurement units

## ⚡ Safety Warning

When working with vehicle diagnostics:
- Never modify safety-critical parameters
- Be cautious with actuator tests
- Ensure stable power supply during programming
- Back up original settings before modifications
- Follow manufacturer guidelines

## 📚 Additional Resources

- [OBD-II PIDs Wikipedia](https://en.wikipedia.org/wiki/OBD-II_PIDs)
- [ISO 14229 Standard](https://www.iso.org/standard/72439.html)
- [SAE J1979 Standard](https://www.sae.org/standards/content/j1979_201408/)

## 🤝 Contributing

This is a reference collection. For corrections or additions:
1. Verify information accuracy
2. Include reliable sources
3. Follow existing format
4. Test formulas and calculations

## ⚖️ Disclaimer

This information is for educational and reference purposes only. Always use proper diagnostic tools and follow manufacturer procedures. Incorrect use may damage vehicle systems or compromise safety.

## 📄 License

This reference material is provided as-is for educational purposes. Vehicle manufacturers retain all rights to their proprietary protocols and specifications.