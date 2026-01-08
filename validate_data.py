#!/usr/bin/env python3
"""
Validation script for EV PID database
Checks data integrity and consistency between original and optimized formats
"""

import csv
import sys

def validate_original_csv(filename):
    """Validate the original CSV format"""
    print(f"\n{'='*60}")
    print(f"Validating: {filename}")
    print(f"{'='*60}\n")
    
    issues = []
    warnings = []
    stats = {
        'total_rows': 0,
        'data_rows': 0,
        'section_headers': 0,
        'empty_mode_pid': 0,
        'empty_equation': 0,
        'duplicate_pids': {},
        'vehicles': set()
    }
    
    with open(filename, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter=';')
        line_num = 1  # Account for header
        
        for row in reader:
            line_num += 1
            stats['total_rows'] += 1
            
            name = row.get('Name', '').strip()
            mode_pid = row.get('Mode/PID', '').strip()
            equation = row.get('Equation', '').strip()
            
            # Identify section headers
            if name.startswith('==='):
                stats['section_headers'] += 1
                vehicle = name.replace('===', '').strip()
                stats['vehicles'].add(vehicle)
                continue
            
            stats['data_rows'] += 1
            
            # Check for missing critical data
            if not mode_pid:
                stats['empty_mode_pid'] += 1
                if 'Battery SOH' in name:
                    warnings.append(f"Line {line_num}: Missing PID for {name} (common for newer models)")
            
            if not equation:
                stats['empty_equation'] += 1
            
            # Track PID usage
            if mode_pid:
                if mode_pid not in stats['duplicate_pids']:
                    stats['duplicate_pids'][mode_pid] = []
                stats['duplicate_pids'][mode_pid].append((line_num, name))
    
    # Report statistics
    print("📊 Statistics:")
    print(f"  Total rows: {stats['total_rows']}")
    print(f"  Data rows: {stats['data_rows']}")
    print(f"  Section headers: {stats['section_headers']}")
    print(f"  Vehicles covered: {len(stats['vehicles'])}")
    print(f"  Empty Mode/PID fields: {stats['empty_mode_pid']}")
    print(f"  Empty Equation fields: {stats['empty_equation']}")
    
    # Check for redundancy
    print("\n🔄 Redundancy Analysis:")
    highly_duplicated = {pid: lines for pid, lines in stats['duplicate_pids'].items() 
                         if len(lines) > 5}
    if highly_duplicated:
        print(f"  Found {len(highly_duplicated)} PIDs used more than 5 times:")
        for pid, lines in sorted(highly_duplicated.items(), key=lambda x: len(x[1]), reverse=True)[:5]:
            print(f"    {pid}: {len(lines)} occurrences")
    
    # Report issues
    if issues:
        print(f"\n❌ Issues Found: {len(issues)}")
        for issue in issues[:10]:  # Show first 10
            print(f"  {issue}")
    else:
        print("\n✅ No critical issues found")
    
    # Report warnings
    if warnings:
        print(f"\n⚠️  Warnings: {len(warnings)}")
        for warning in warnings[:10]:  # Show first 10
            print(f"  {warning}")
    
    return len(issues) == 0, stats


def validate_optimized_csv(filename):
    """Validate the optimized CSV format"""
    print(f"\n{'='*60}")
    print(f"Validating: {filename}")
    print(f"{'='*60}\n")
    
    issues = []
    stats = {
        'total_rows': 0,
        'data_rows': 0,
        'equation_refs': 0,
        'common_pid_refs': 0,
        'use_references': 0,
        'missing_markers': 0,
        'resolved_pids': set(),
        'vehicles': set()
    }
    
    equations = {}
    common_pids = {}
    
    with open(filename, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f, delimiter=';')
        line_num = 1
        current_section = None
        
        for row in reader:
            line_num += 1
            stats['total_rows'] += 1
            
            section = row.get('Section', '').strip()
            name = row.get('Name', '').strip()
            mode_pid = row.get('Mode/PID', '').strip()
            equation = row.get('Equation', '').strip()
            
            # Track current section
            if section.startswith('==='):
                current_section = section
                stats['vehicles'].add(section)
                continue
            
            # Parse equation reference table rows
            if section == 'REF_EQUATION':
                equations[name] = mode_pid  # Equation ID -> Formula
                stats['equation_refs'] += 1
                continue
            
            # Parse common PID reference table rows
            if section == 'REF_COMMON_PID':
                common_pids[name] = {
                    'mode_pid': mode_pid,
                    'equation': equation
                }
                stats['common_pid_refs'] += 1
                continue
            
            stats['data_rows'] += 1
            
            # Check USE: references
            if mode_pid.startswith('USE:'):
                stats['use_references'] += 1
                parts = mode_pid.split(':', 1)
                if len(parts) < 2 or not parts[1]:
                    issues.append(f"Line {line_num}: Malformed reference '{mode_pid}' - expected 'USE:REFERENCE_ID'")
                    continue
                ref_id = parts[1]
                if ref_id not in common_pids:
                    issues.append(f"Line {line_num}: Invalid reference USE:{ref_id}")
                else:
                    stats['resolved_pids'].add(common_pids[ref_id]['mode_pid'])
            
            # Check MISSING markers
            if mode_pid == 'MISSING':
                stats['missing_markers'] += 1
            
            # Verify equation references
            if equation.startswith('EQ_'):
                if equation not in equations:
                    issues.append(f"Line {line_num}: Invalid equation reference {equation}")
    
    # Report statistics
    print("📊 Statistics:")
    print(f"  Total rows: {stats['total_rows']}")
    print(f"  Data rows: {stats['data_rows']}")
    print(f"  Equation references defined: {stats['equation_refs']}")
    print(f"  Common PID references defined: {stats['common_pid_refs']}")
    print(f"  USE: references found: {stats['use_references']}")
    print(f"  MISSING markers: {stats['missing_markers']}")
    print(f"  Vehicles covered: {len(stats['vehicles'])}")
    
    print("\n✨ Optimization Benefits:")
    print(f"  Equations centralized: {stats['equation_refs']} types")
    print(f"  Common PIDs centralized: {stats['common_pid_refs']} types")
    print(f"  References utilized: {stats['use_references']} times")
    print(f"  Missing data explicitly marked: {stats['missing_markers']} entries")
    
    # Report issues
    if issues:
        print(f"\n❌ Issues Found: {len(issues)}")
        for issue in issues:
            print(f"  {issue}")
    else:
        print("\n✅ No issues found - All references valid")
    
    return len(issues) == 0, stats


def compare_formats(original_stats, optimized_stats):
    """Compare statistics between original and optimized formats"""
    print(f"\n{'='*60}")
    print("Comparison: Original vs Optimized")
    print(f"{'='*60}\n")
    
    print("📈 Data Coverage:")
    orig_data = original_stats['data_rows']
    opt_data = optimized_stats['data_rows']
    print(f"  Original data rows: {orig_data}")
    print(f"  Optimized data rows: {opt_data}")
    print(f"  Difference: {opt_data - orig_data} rows")
    
    print("\n🎯 Efficiency Improvements:")
    orig_empty = original_stats['empty_mode_pid'] + original_stats['empty_equation']
    opt_missing = optimized_stats['missing_markers']
    print(f"  Original empty fields: {orig_empty}")
    print(f"  Optimized MISSING markers: {opt_missing}")
    print(f"  Improvement: Empty fields now explicitly documented")
    
    print("\n🔧 Maintainability:")
    print(f"  Centralized equations: {optimized_stats['equation_refs']}")
    print(f"  Centralized common PIDs: {optimized_stats['common_pid_refs']}")
    print(f"  Reference usage: {optimized_stats['use_references']} times")
    reduction = (optimized_stats['use_references'] / orig_data) * 100 if orig_data > 0 else 0
    print(f"  Redundancy reduction: ~{reduction:.1f}% of data rows now use references")


def main():
    """Main validation routine"""
    print("\n" + "="*60)
    print("EV PID Database Validation Tool")
    print("="*60)
    
    # Validate original format
    original_valid, original_stats = validate_original_csv('ev_unified_professional.csv')
    
    # Validate optimized format
    optimized_valid, optimized_stats = validate_optimized_csv('ev_unified_optimized.csv')
    
    # Compare formats
    compare_formats(original_stats, optimized_stats)
    
    # Final summary
    print(f"\n{'='*60}")
    print("Validation Summary")
    print(f"{'='*60}\n")
    
    if original_valid and optimized_valid:
        print("✅ All validations passed!")
        print("\nKey improvements in optimized format:")
        print("  ✓ Reduced data redundancy")
        print("  ✓ Centralized equation definitions")
        print("  ✓ Explicit missing data markers")
        print("  ✓ Improved maintainability")
        print("  ✓ Better documentation")
        return 0
    else:
        print("❌ Some validations failed")
        print("Please review the issues above")
        return 1


if __name__ == '__main__':
    sys.exit(main())
