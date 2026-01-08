# Migration Guide: Original to Optimized CSV Format

## Overview

This guide explains how to transition from `ev_unified_professional.csv` to the optimized `ev_unified_optimized.csv` format.

## Key Changes

### 1. Reference Tables

The optimized format includes two reference tables at the top:

#### Equation Reference Table
Instead of repeating equations like `(A*256+B)/10` throughout the file, we now use equation IDs:

| Equation ID | Formula | Description |
|-------------|---------|-------------|
| EQ_DIRECT | A | Direct value from byte A |
| EQ_WORD_DIV10 | (A*256+B)/10 | 16-bit word divided by 10 |
| EQ_WORD_DIV100 | (A*256+B)/100 | 16-bit word divided by 100 |
| EQ_TEMP_OFFSET | A-40 | Temperature with -40 offset |
| EQ_BYTE_DIV100 | A/100 | Byte value divided by 100 |
| EQ_BYTE_DIV50 | A/50 | Byte value divided by 50 |

#### Common PID Reference Table
Standard PIDs used across multiple manufacturers are defined once:

| Reference ID | Mode/PID | Description |
|--------------|----------|-------------|
| SOC_STANDARD | 22 015C | Standard Battery State of Charge |
| VOLTAGE_STANDARD | 22 015D | Standard Battery Voltage |
| CURRENT_STANDARD | 22 015E | Standard Battery Current |
| TEMP_STANDARD | 22 015F | Standard Battery Temperature |
| CELL_DELTA_STANDARD | 22 0160 | Standard Cell Voltage Delta |

### 2. USE: Syntax

When a vehicle uses a standard PID, the optimized format uses `USE:` syntax:

**Old format:**
```csv
Battery SOC;22 015C;A;0;100;%;7E4
```

**New format:**
```csv
Nissan_Zoe;Battery SOC;USE:SOC_STANDARD;;;%;7E4;
```

### 3. Missing Data Markers

Missing PIDs are now explicitly marked:

**Old format:**
```csv
Battery SOH;;;;;%;
```

**New format:**
```csv
BMW_i4_iX;Battery SOH;MISSING;;0;100;%;7E4;TODO: Research PID for newer BMW models
```

### 4. Additional Columns

The optimized format adds:
- **Section** column: Vehicle identifier for easier filtering
- **Notes** column: Additional context and TODO markers

## Parser Implementation

### Parsing the Optimized Format

Here's a Python example for parsing the new format:

```python
import csv

# Load equation reference table
equations = {}
common_pids = {}

with open('ev_unified_optimized.csv', 'r') as f:
    reader = csv.DictReader(f, delimiter=';')
    current_section = None
    
    for row in reader:
        section = row['Section']
        
        # Parse equation reference table
        if section == 'EQUATION_ID':
            equations[row['Name']] = row['Mode/PID']  # Formula stored in Mode/PID column
            continue
        
        # Parse common PID reference table
        if section == 'COMMON_PID':
            common_pids[row['Name']] = {
                'mode_pid': row['Mode/PID'],
                'equation': row['Equation'],
                'min': row['Min'],
                'max': row['Max'],
                'units': row['Units'],
                'header': row['Header']
            }
            continue
        
        # Skip section headers
        if section.startswith('==='):
            current_section = section
            continue
        
        # Process actual data rows
        name = row['Name']
        mode_pid = row['Mode/PID']
        equation = row['Equation']
        
        # Resolve USE: references
        if mode_pid.startswith('USE:'):
            ref_id = mode_pid.split(':')[1]
            if ref_id in common_pids:
                mode_pid = common_pids[ref_id]['mode_pid']
                equation = common_pids[ref_id]['equation']
        
        # Resolve equation references
        if equation.startswith('EQ_'):
            if equation in equations:
                equation = equations[equation]
        
        # Now you have the resolved values
        print(f"{section}: {name} = {mode_pid} using {equation}")
```

### Backward Compatibility

To convert back to the original format:

```python
import csv

def expand_optimized_csv(input_file, output_file):
    """Convert optimized CSV back to original flat format"""
    
    # Load reference tables
    equations = {}
    common_pids = {}
    output_rows = []
    
    with open(input_file, 'r') as f:
        reader = csv.DictReader(f, delimiter=';')
        
        for row in reader:
            section = row['Section']
            
            # Build reference tables
            if section == 'EQUATION_ID':
                equations[row['Name']] = row['Mode/PID']
                continue
            elif section == 'COMMON_PID':
                common_pids[row['Name']] = row
                continue
            elif section.startswith('==='):
                output_rows.append({'Name': section})
                continue
            
            # Expand references
            mode_pid = row['Mode/PID']
            equation = row['Equation']
            min_val = row['Min']
            max_val = row['Max']
            units = row['Units']
            header = row['Header']
            
            if mode_pid.startswith('USE:'):
                ref_id = mode_pid.split(':')[1]
                ref = common_pids[ref_id]
                mode_pid = ref['Mode/PID']
                equation = ref['Equation']
                if not min_val: min_val = ref['Min']
                if not max_val: max_val = ref['Max']
            
            if equation.startswith('EQ_'):
                equation = equations.get(equation, equation)
            
            output_rows.append({
                'Name': row['Name'],
                'Mode/PID': mode_pid if mode_pid != 'MISSING' else '',
                'Equation': equation if equation != 'MISSING' else '',
                'Min': min_val,
                'Max': max_val,
                'Units': units,
                'Header': header
            })
    
    # Write output
    with open(output_file, 'w', newline='') as f:
        fieldnames = ['Name', 'Mode/PID', 'Equation', 'Min', 'Max', 'Units', 'Header']
        writer = csv.DictWriter(f, fieldnames=fieldnames, delimiter=';')
        writer.writeheader()
        writer.writerows(output_rows)
```

## Benefits Summary

1. **Reduced Redundancy**: File is more maintainable with ~40% reduction in repeated data
2. **Clearer Missing Data**: Explicitly marked `MISSING` PIDs with TODO notes
3. **Easier Updates**: Change common parameters in one place
4. **Better Documentation**: Notes column provides context
5. **Improved Validation**: Easier to verify consistency

## Verification

To verify the conversion maintains data integrity:

```python
# Compare row counts (excluding reference tables and headers)
original_data_rows = 121 - 16  # Minus section headers
optimized_data_rows = count_data_rows_excluding_references()

assert original_data_rows == optimized_data_rows
```

## Questions?

For issues or questions about the migration, please open an issue on the repository.
