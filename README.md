# EVP-D: Electric Vehicle Parameter Database

## Overview

This repository contains OBD-II PID (Parameter ID) definitions for various electric vehicles. These definitions are used for diagnostic purposes and monitoring battery health, state of charge, temperature, and other critical parameters.

## Files

### Data Files

- **`ev_unified_professional.csv`** - Original CSV format with all EV PID definitions
  - 122 lines covering 16 different EV manufacturers/models
  - Standard format: Name, Mode/PID, Equation, Min, Max, Units, Header
  - Contains some missing data for newer vehicle models

- **`ev_unified_optimized.csv`** - Optimized CSV format (NEW)
  - Includes equation and common PID reference tables
  - Reduces redundancy by ~40%
  - Explicitly marks missing PIDs with TODO notes
  - Easier to maintain and update

### Documentation

- **`OPTIMIZATION_REPORT.md`** - Detailed analysis of inefficiencies and improvements
  - Identifies 18.4% empty fields in original data
  - Documents missing Battery SOH PIDs for 12 vehicle models
  - Shows repeated PIDs and equations (11-21 occurrences)
  - Provides performance impact analysis

- **`MIGRATION_GUIDE.md`** - Guide for transitioning between formats
  - Explains new reference table structure
  - Provides parser implementation examples
  - Shows backward compatibility conversion
  - Includes verification steps

## Supported Vehicles

### Complete PID Definitions
1. ✅ Nissan Leaf / Renault Zoe
2. ✅ Hyundai / Kia (Kona, Ioniq, Niro, EV6)
3. ✅ PSA (Peugeot / Opel / Citroën)
4. ✅ BMW i3

### Partial PID Definitions (Missing Battery SOH)
5. ⚠️ BMW i4 / iX
6. ⚠️ Mercedes EQ (EQA, EQB, EQE, EQS)
7. ⚠️ Audi e-tron (Q4, Q8, GT)
8. ⚠️ Volvo Recharge (EX30, C40, XC40)
9. ⚠️ Porsche Taycan
10. ⚠️ BYD (Atto 3, Dolphin, Seal)
11. ⚠️ MG (ZS EV, MG4)
12. ⚠️ Tesla Model S / 3 / X / Y
13. ⚠️ TOGG T10X
14. ⚠️ Honda e
15. ⚠️ Toyota bZ4X
16. ⚠️ Mini Cooper SE

## Common Parameters

Most vehicles support these standard parameters:

| Parameter | Typical PID | Description |
|-----------|-------------|-------------|
| Battery SOC | 22 015C | State of Charge (0-100%) |
| Battery Voltage | 22 015D | Voltage in Volts |
| Battery Current | 22 015E | Current in Amperes |
| Battery Temp | 22 015F | Temperature in Celsius |
| Cell Voltage Delta | 22 0160 | Difference between min/max cell voltage |

## Usage

### Reading the Original Format

```python
import csv

with open('ev_unified_professional.csv', 'r') as f:
    reader = csv.DictReader(f, delimiter=';')
    for row in reader:
        if not row['Name'].startswith('==='):
            print(f"{row['Name']}: PID={row['Mode/PID']}, Equation={row['Equation']}")
```

### Reading the Optimized Format

See `MIGRATION_GUIDE.md` for detailed parser implementation that resolves references.

## Contributing

Contributions are welcome! Priority areas:

1. **Missing Battery SOH PIDs**: Research and add missing PIDs for newer vehicles
2. **New Vehicle Models**: Add definitions for additional EV models
3. **Validation**: Add test scripts to verify data integrity
4. **Enhanced Features**: Additional parameters beyond basic battery metrics

### Adding New Vehicles

When adding new vehicle definitions:

1. Use the optimized format (`ev_unified_optimized.csv`)
2. Reference common PIDs when possible using `USE:` syntax
3. Use equation IDs (EQ_DIRECT, EQ_WORD_DIV10, etc.)
4. Mark unknown PIDs as `MISSING` with TODO notes
5. Add notes for vehicle-specific quirks

## Data Sources

This database is compiled from:
- OBD-II specification documents
- Manufacturer technical documentation
- Community contributions and testing
- Reverse engineering efforts

**Note**: Always verify PIDs with your specific vehicle before use.

## License

Please check with the repository owner regarding usage rights.

## Credits

Created by: @muhammet12184  
Instagram: @magicmotorsport_tr

## Changelog

### 2026-01-08 - Optimization Update
- Added `ev_unified_optimized.csv` with normalized structure
- Created `OPTIMIZATION_REPORT.md` documenting inefficiencies
- Added `MIGRATION_GUIDE.md` for format transition
- Identified 28 missing PIDs across 12 vehicle models
- Reduced data redundancy by ~40%

### 2025-11-08 - Initial Release
- Created initial `ev_unified_professional.csv`
- 122 lines covering 16 vehicle types
- Basic PID definitions for common parameters
