package com.obd.diagnostics.analyzer

import com.obd.diagnostics.pid.PIDReader
import com.obd.diagnostics.pid.PIDType
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.delay

/**
 * Enhanced DataAnalyzer for EV with regenerative braking support
 */
class DataAnalyzer(
    private val pidReader: PIDReader,
    private val vehicleBrand: String = "Unknown"
) {
    
    data class EVData(
        val soc: Double,
        val voltage: Double,
        val current: Double,
        val power: Double, // kW
        val batteryTemp: Double,
        val range: Double, // Estimated range in km
        
        // REGENERATIVE BRAKING DATA - NEW
        val regenPower: Double, // kW - power being recovered
        val regenCurrent: Double, // A - current from regen
        val regenEnergyTotal: Double, // kWh - total energy recovered
        val isRegenerating: Boolean,
        val motorTorque: Double, // Nm - motor torque (negative when regen)
        
        val timestamp: Long = System.currentTimeMillis()
    )
    
    /**
     * Monitor EV data with regenerative braking metrics
     */
    fun monitorEVData(): Flow<EVData> = flow {
        while (true) {
            // Standard battery PIDs
            val soc = pidReader.readPID(PIDType.BATTERY_SOC)
            val voltage = pidReader.readPID(PIDType.BATTERY_VOLTAGE)
            val current = pidReader.readPID(PIDType.BATTERY_CURRENT)
            val batteryTemp = pidReader.readPID(PIDType.BATTERY_TEMP)
            
            // Calculate power (kW) = V * I / 1000
            val power = (voltage * current) / 1000.0
            
            // REGENERATIVE BRAKING PIDs - Brand-specific selection
            val (regenPower, regenCurrent, motorTorque) = getRegenData()
            
            // Get total regen energy
            val regenEnergyTotal = pidReader.readPID(PIDType.REGEN_ENERGY_TOTAL)
            
            // Determine if currently regenerating
            // Negative current or positive regen power indicates regeneration
            val isRegenerating = regenPower > 0.1 || current < -1.0
            
            // Estimate range (simplified: kWh remaining / average consumption)
            val batteryCapacity = estimateBatteryCapacity()
            val remainingKwh = batteryCapacity * (soc / 100.0)
            val estimatedRange = remainingKwh * 5.0 // Assume 5 km/kWh average
            
            emit(EVData(
                soc = soc,
                voltage = voltage,
                current = current,
                power = power,
                batteryTemp = batteryTemp,
                range = estimatedRange,
                regenPower = regenPower,
                regenCurrent = regenCurrent,
                regenEnergyTotal = regenEnergyTotal,
                isRegenerating = isRegenerating,
                motorTorque = motorTorque
            ))
            
            delay(200) // Update every 200ms for responsive regen display
        }
    }
    
    /**
     * Get regenerative braking data based on vehicle brand
     * Tries brand-specific PID first, then falls back to generic
     */
    private suspend fun getRegenData(): Triple<Double, Double, Double> {
        val regenPower: Double
        val regenCurrent: Double
        val motorTorque: Double
        
        when (vehicleBrand.uppercase()) {
            "NISSAN", "RENAULT" -> {
                regenPower = pidReader.readPID(PIDType.REGEN_NISSAN).toDouble()
                regenCurrent = pidReader.readPID(PIDType.REGEN_CURRENT)
                motorTorque = pidReader.readPID(PIDType.MOTOR_TORQUE)
            }
            "HYUNDAI", "KIA" -> {
                regenPower = pidReader.readPID(PIDType.REGEN_HYUNDAI)
                regenCurrent = pidReader.readPID(PIDType.REGEN_CURRENT)
                motorTorque = pidReader.readPID(PIDType.MOTOR_TORQUE)
            }
            "BMW", "MINI" -> {
                regenPower = pidReader.readPID(PIDType.REGEN_BMW)
                regenCurrent = pidReader.readPID(PIDType.REGEN_CURRENT)
                motorTorque = pidReader.readPID(PIDType.MOTOR_TORQUE)
            }
            "TESLA" -> {
                regenPower = pidReader.readPID(PIDType.REGEN_TESLA)
                regenCurrent = pidReader.readPID(PIDType.REGEN_CURRENT)
                motorTorque = pidReader.readPID(PIDType.MOTOR_TORQUE)
            }
            else -> {
                // Generic regen PIDs for unknown brands
                regenPower = pidReader.readPID(PIDType.REGEN_POWER)
                regenCurrent = pidReader.readPID(PIDType.REGEN_CURRENT)
                motorTorque = pidReader.readPID(PIDType.MOTOR_TORQUE)
            }
        }
        
        return Triple(regenPower, regenCurrent, motorTorque)
    }
    
    /**
     * Calculate regeneration efficiency over time
     */
    suspend fun calculateRegenEfficiency(durationMs: Long): RegenStats {
        var totalEnergyConsumed = 0.0
        var totalEnergyRecovered = 0.0
        var regenEvents = 0
        val startTime = System.currentTimeMillis()
        var lastRegenEnergy = 0.0
        
        monitorEVData().collect { data ->
            if (System.currentTimeMillis() - startTime > durationMs) {
                return@collect
            }
            
            // Track energy consumption
            if (data.power > 0) {
                totalEnergyConsumed += data.power * (0.2 / 3600.0) // Convert to kWh
            }
            
            // Track regen events
            if (data.isRegenerating) {
                regenEvents++
                totalEnergyRecovered += data.regenPower * (0.2 / 3600.0)
            }
            
            lastRegenEnergy = data.regenEnergyTotal
        }
        
        val efficiency = if (totalEnergyConsumed > 0) {
            (totalEnergyRecovered / totalEnergyConsumed) * 100.0
        } else {
            0.0
        }
        
        return RegenStats(
            totalRecovered = totalEnergyRecovered,
            totalConsumed = totalEnergyConsumed,
            efficiency = efficiency,
            regenEvents = regenEvents,
            cumulativeRegen = lastRegenEnergy
        )
    }
    
    private fun estimateBatteryCapacity(): Double {
        // Brand-specific battery capacities (kWh)
        return when (vehicleBrand.uppercase()) {
            "NISSAN" -> 40.0 // Leaf
            "RENAULT" -> 52.0 // Zoe
            "HYUNDAI", "KIA" -> 64.0 // Kona/Niro
            "BMW" -> 42.2 // i3
            "TESLA" -> 75.0 // Model 3 LR
            "TOGG" -> 88.5 // T10X
            else -> 60.0 // Generic estimate
        }
    }
    
    data class RegenStats(
        val totalRecovered: Double, // kWh
        val totalConsumed: Double, // kWh
        val efficiency: Double, // %
        val regenEvents: Int,
        val cumulativeRegen: Double // kWh lifetime
    )
}
