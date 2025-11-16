package com.obd.diagnostics.analyzer

import com.obd.diagnostics.pid.PIDReader
import com.obd.diagnostics.pid.PIDType
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.delay

/**
 * Motor/ICE (Internal Combustion Engine) analyzer
 * Now includes real-time fuel consumption monitoring
 */
class MotorAnalyzer(private val pidReader: PIDReader) {
    
    data class MotorData(
        val rpm: Double,
        val speed: Double,
        val throttlePosition: Double,
        val engineLoad: Double,
        val coolantTemp: Double,
        val intakeTemp: Double,
        val fuelConsumption: Double, // L/h - NOW REAL-TIME, not placeholder
        val instantFuelRate: Double, // L/100km - instantaneous consumption
        val maf: Double, // Mass Air Flow - helps calculate fuel
        val timestamp: Long = System.currentTimeMillis()
    )
    
    /**
     * Monitors motor data with REAL fuel consumption PIDs
     */
    fun monitorMotorData(): Flow<MotorData> = flow {
        while (true) {
            val rpm = pidReader.readPID(PIDType.ENGINE_RPM)
            val speed = pidReader.readPID(PIDType.VEHICLE_SPEED)
            val throttle = pidReader.readPID(PIDType.THROTTLE_POSITION)
            val load = pidReader.readPID(PIDType.ENGINE_LOAD)
            val coolant = pidReader.readPID(PIDType.COOLANT_TEMP)
            val intake = pidReader.readPID(PIDType.INTAKE_TEMP)
            
            // OPTION 1: Direct fuel flow rate PID (Mode 01, PID 5E)
            val fuelRate = pidReader.readPID(PIDType.FUEL_RATE) // L/h
            
            // OPTION 2: Calculate from MAF if direct PID not available
            val maf = pidReader.readPID(PIDType.MAF) // g/s
            val calculatedFuelRate = if (fuelRate == 0.0 && maf > 0) {
                // Fuel rate (L/h) = MAF (g/s) / 14.7 / 0.74 / 1000 * 3600
                // 14.7 = stoichiometric ratio, 0.74 = fuel density
                (maf / 14.7 / 0.74) * 3.6
            } else {
                fuelRate
            }
            
            // Calculate instantaneous consumption (L/100km)
            val instantConsumption = if (speed > 0) {
                (calculatedFuelRate / speed) * 100
            } else {
                calculatedFuelRate // L/h when idle
            }
            
            emit(MotorData(
                rpm = rpm,
                speed = speed,
                throttlePosition = throttle,
                engineLoad = load,
                coolantTemp = coolant,
                intakeTemp = intake,
                fuelConsumption = calculatedFuelRate,
                instantFuelRate = instantConsumption,
                maf = maf
            ))
            
            delay(500) // Update every 500ms
        }
    }
    
    /**
     * Get average fuel consumption over time period
     */
    suspend fun getAverageFuelConsumption(durationMs: Long): Double {
        var totalFuel = 0.0
        var samples = 0
        val startTime = System.currentTimeMillis()
        
        monitorMotorData().collect { data ->
            if (System.currentTimeMillis() - startTime > durationMs) {
                return@collect
            }
            totalFuel += data.fuelConsumption
            samples++
        }
        
        return if (samples > 0) totalFuel / samples else 0.0
    }
}
