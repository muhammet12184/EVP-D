package com.obd.diagnostics.pid

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * PIDReader interface - implement this for your OBD-II connection
 * (Bluetooth, USB, WiFi, etc.)
 */
interface PIDReader {
    /**
     * Read a PID and return parsed value
     */
    suspend fun readPID(pidType: PIDType): Double
    
    /**
     * Send raw OBD command and get response
     */
    suspend fun sendRawCommand(command: String, header: String = "7DF"): String
    
    /**
     * Check if connection is active
     */
    suspend fun isConnected(): Boolean
}

/**
 * Mock implementation for testing
 */
class MockPIDReader : PIDReader {
    private var mockData = mutableMapOf<PIDType, Double>()
    
    override suspend fun readPID(pidType: PIDType): Double = withContext(Dispatchers.IO) {
        mockData.getOrPut(pidType) {
            when (pidType) {
                PIDType.ENGINE_RPM -> 2000.0
                PIDType.VEHICLE_SPEED -> 60.0
                PIDType.THROTTLE_POSITION -> 45.0
                PIDType.ENGINE_LOAD -> 35.0
                PIDType.COOLANT_TEMP -> 85.0
                PIDType.INTAKE_TEMP -> 25.0
                PIDType.FUEL_RATE -> 8.5 // Real fuel consumption
                PIDType.MAF -> 15.0
                PIDType.BATTERY_SOC -> 75.0
                PIDType.BATTERY_VOLTAGE -> 360.0
                PIDType.BATTERY_CURRENT -> -20.0
                PIDType.BATTERY_TEMP -> 30.0
                PIDType.REGEN_POWER -> 15.0 // Regenerating 15 kW
                PIDType.REGEN_CURRENT -> 40.0
                PIDType.MOTOR_TORQUE -> -50.0
                else -> 0.0
            }
        }
    }
    
    override suspend fun sendRawCommand(command: String, header: String): String = 
        withContext(Dispatchers.IO) {
            // Mock responses for VIN and ECU
            when {
                command.contains("09 02") -> "1HGCM82633A123456" // Mock VIN (Honda)
                command.contains("09 0A") -> "HONDA-ECU-2023"
                command.contains("22 015B") -> "62 015B 64" // Nissan response
                else -> "NO DATA"
            }
        }
    
    override suspend fun isConnected(): Boolean = true
    
    fun setMockValue(pidType: PIDType, value: Double) {
        mockData[pidType] = value
    }
}
