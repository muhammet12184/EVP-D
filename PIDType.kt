package com.obd.diagnostics.pid

/**
 * Extended PID types including fuel consumption PIDs
 */
enum class PIDType(
    val mode: String,
    val pid: String,
    val equation: String,
    val description: String
) {
    // Standard OBD-II PIDs
    ENGINE_RPM("01", "0C", "((A*256)+B)/4", "Engine RPM"),
    VEHICLE_SPEED("01", "0D", "A", "Vehicle Speed"),
    THROTTLE_POSITION("01", "11", "A*100/255", "Throttle Position"),
    ENGINE_LOAD("01", "04", "A*100/255", "Engine Load"),
    COOLANT_TEMP("01", "05", "A-40", "Coolant Temperature"),
    INTAKE_TEMP("01", "0F", "A-40", "Intake Air Temperature"),
    
    // FUEL CONSUMPTION PIDs - REAL-TIME
    FUEL_RATE("01", "5E", "(A*256+B)*0.05", "Fuel Rate L/h"),
    MAF("01", "10", "((A*256)+B)/100", "Mass Air Flow g/s"),
    FUEL_PRESSURE("01", "0A", "A*3", "Fuel Pressure kPa"),
    FUEL_LEVEL("01", "2F", "A*100/255", "Fuel Level %"),
    
    // Alternative fuel PIDs for different manufacturers
    FUEL_RATE_GENERIC("01", "9D", "A*256+B", "Generic Fuel Rate"),
    FUEL_CONSUMPTION_RATE("22", "F40F", "(A*256+B)/1000", "Manufacturer Specific Fuel"),
    
    // EV PIDs
    BATTERY_SOC("22", "015C", "A", "Battery State of Charge"),
    BATTERY_VOLTAGE("22", "015D", "(A*256+B)/100", "Battery Voltage"),
    BATTERY_CURRENT("22", "015E", "(A*256+B)/10", "Battery Current"),
    BATTERY_TEMP("22", "015F", "A-40", "Battery Temperature"),
    
    // REGEN BRAKING PIDs - NEW
    REGEN_POWER("22", "0180", "(A*256+B)/10", "Regenerative Braking Power"),
    REGEN_CURRENT("22", "0181", "(A*256+B)/10", "Regen Current"),
    REGEN_ENERGY_TOTAL("22", "0182", "(A*256+B)/100", "Total Regen Energy kWh"),
    MOTOR_TORQUE("22", "0183", "(A*256+B)-32768", "Motor Torque Nm"),
    
    // Manufacturer-specific regen PIDs
    REGEN_NISSAN("22", "0190", "A", "Nissan Regen Level"),
    REGEN_HYUNDAI("22", "0175", "(A*256+B)/10", "Hyundai Regen Power"),
    REGEN_BMW("22", "2A40", "(A*256+B)/10", "BMW Regen Power"),
    REGEN_TESLA("22", "118B", "(A*256+B)/10", "Tesla Regen Power"),
    
    // Vehicle identification
    VIN("09", "02", "ASCII", "Vehicle Identification Number"),
    ECU_NAME("09", "0A", "ASCII", "ECU Name");
    
    fun getFullCommand(header: String = "7DF"): String {
        return "$mode$pid"
    }
}
