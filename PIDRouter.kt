package com.obd.diagnostics.router

import com.obd.diagnostics.pid.PIDReader
import com.obd.diagnostics.pid.PIDType
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

/**
 * PIDRouter - Detects vehicle brand/manufacturer and routes appropriate PIDs
 * Now exposes detected brand for UI debugging
 */
class PIDRouter(private val pidReader: PIDReader) {
    
    private var _detectedBrand: VehicleBrand? = null
    private var _detectedModel: String? = null
    private var _detectionTimestamp: Long = 0
    
    /**
     * Get detected vehicle brand for UI display
     */
    val detectedBrand: VehicleBrand?
        get() = _detectedBrand
    
    val detectedModel: String?
        get() = _detectedModel
    
    val detectionTimestamp: Long
        get() = _detectionTimestamp
    
    /**
     * Vehicle brand enum with supported manufacturers
     */
    enum class VehicleBrand(
        val displayName: String,
        val manufacturers: List<String>
    ) {
        NISSAN("Nissan", listOf("NISSAN", "INFINITI")),
        RENAULT("Renault", listOf("RENAULT", "DACIA")),
        HYUNDAI("Hyundai", listOf("HYUNDAI")),
        KIA("Kia", listOf("KIA")),
        BMW("BMW", listOf("BMW")),
        MINI("Mini", listOf("MINI")),
        TESLA("Tesla", listOf("TESLA")),
        MERCEDES("Mercedes-Benz", listOf("MERCEDES", "MERCEDES-BENZ", "DAIMLER")),
        AUDI("Audi", listOf("AUDI")),
        VOLKSWAGEN("Volkswagen", listOf("VOLKSWAGEN", "VW")),
        PORSCHE("Porsche", listOf("PORSCHE")),
        VOLVO("Volvo", listOf("VOLVO")),
        TOYOTA("Toyota", listOf("TOYOTA", "LEXUS")),
        HONDA("Honda", listOf("HONDA", "ACURA")),
        BYD("BYD", listOf("BYD")),
        MG("MG Motor", listOf("MG", "SAIC")),
        TOGG("TOGG", listOf("TOGG")),
        PSA("PSA Group", listOf("PEUGEOT", "CITROEN", "OPEL", "VAUXHALL", "DS")),
        FORD("Ford", listOf("FORD", "LINCOLN")),
        GM("General Motors", listOf("CHEVROLET", "GMC", "CADILLAC", "BUICK")),
        STELLANTIS("Stellantis", listOf("FIAT", "JEEP", "DODGE", "RAM", "CHRYSLER", "ALFA ROMEO")),
        UNKNOWN("Unknown", listOf());
        
        companion object {
            fun fromVIN(vin: String): VehicleBrand {
                if (vin.length < 3) return UNKNOWN
                
                // VIN World Manufacturer Identifier (WMI) - first 3 characters
                val wmi = vin.substring(0, 3).uppercase()
                
                return when {
                    // Nissan
                    wmi.startsWith("JN") -> NISSAN
                    // Renault
                    wmi.startsWith("VF1") -> RENAULT
                    // Hyundai
                    wmi.startsWith("KM") || wmi.startsWith("MAL") -> HYUNDAI
                    // Kia
                    wmi.startsWith("KNA") || wmi.startsWith("KND") -> KIA
                    // BMW
                    wmi.startsWith("WBA") || wmi.startsWith("WBS") -> BMW
                    // Mini
                    wmi.startsWith("WMW") -> MINI
                    // Tesla
                    wmi.startsWith("5YJ") || wmi.startsWith("7SA") -> TESLA
                    // Mercedes
                    wmi.startsWith("WDD") || wmi.startsWith("WDB") -> MERCEDES
                    // Audi
                    wmi.startsWith("WAU") -> AUDI
                    // VW
                    wmi.startsWith("WVW") || wmi.startsWith("3VW") -> VOLKSWAGEN
                    // Porsche
                    wmi.startsWith("WP0") -> PORSCHE
                    // Volvo
                    wmi.startsWith("YV1") -> VOLVO
                    // Toyota
                    wmi.startsWith("JT") || wmi.startsWith("5T") -> TOYOTA
                    // Honda
                    wmi.startsWith("JHM") || wmi.startsWith("1HG") -> HONDA
                    // BYD
                    wmi.startsWith("LGB") -> BYD
                    // MG
                    wmi.startsWith("LSV") -> MG
                    // TOGG
                    wmi.startsWith("NMT") -> TOGG
                    // PSA
                    wmi.startsWith("VF3") || wmi.startsWith("VF7") -> PSA
                    // Ford
                    wmi.startsWith("1F") || wmi.startsWith("3F") -> FORD
                    // GM
                    wmi.startsWith("1G") || wmi.startsWith("2G") -> GM
                    // Stellantis
                    wmi.startsWith("ZFA") || wmi.startsWith("1C4") -> STELLANTIS
                    else -> UNKNOWN
                }
            }
            
            fun fromName(name: String): VehicleBrand {
                val upperName = name.uppercase()
                return values().firstOrNull { brand ->
                    brand.manufacturers.any { upperName.contains(it) }
                } ?: UNKNOWN
            }
        }
    }
    
    /**
     * Detect vehicle brand from VIN
     * This is the primary method - VIN should be read from Bluetooth/OBD service first
     * Returns detection result with confidence level
     */
    suspend fun detectVehicle(vin: String? = null): VehicleDetectionResult = withContext(Dispatchers.IO) {
        val detectionMethods = mutableListOf<DetectionMethod>()
        
        // Method 1: Use provided VIN or read VIN
        val vinToUse = vin ?: try {
            pidReader.readVIN()
        } catch (e: Exception) {
            ""
        }
        
        if (vinToUse.isNotEmpty() && vinToUse.length >= 17) {
            val brandFromVIN = VehicleBrand.fromVIN(vinToUse)
            if (brandFromVIN != VehicleBrand.UNKNOWN) {
                detectionMethods.add(DetectionMethod.VIN(vinToUse, brandFromVIN, 100))
                _detectedBrand = brandFromVIN
                _detectedModel = extractModelFromVIN(vinToUse)
                _detectionTimestamp = System.currentTimeMillis()
                
                return@withContext VehicleDetectionResult(
                    brand = brandFromVIN,
                    model = _detectedModel,
                    detectionMethods = detectionMethods,
                    confidence = 100,
                    timestamp = _detectionTimestamp
                )
            }
        }
        
        // Method 2: Read ECU Name
        try {
            val ecuName = pidReader.readECUName()
            if (ecuName.isNotEmpty()) {
                val brandFromECU = VehicleBrand.fromName(ecuName)
                if (brandFromECU != VehicleBrand.UNKNOWN) {
                    detectionMethods.add(DetectionMethod.ECU(ecuName, brandFromECU, 80))
                    if (_detectedBrand == null) {
                        _detectedBrand = brandFromECU
                    }
                }
            }
        } catch (e: Exception) {
            // ECU read failed
        }
        
        // Method 3: Test brand-specific PIDs
        if (_detectedBrand == null) {
            _detectedBrand = detectByPIDResponse()
            if (_detectedBrand != null && _detectedBrand != VehicleBrand.UNKNOWN) {
                detectionMethods.add(
                    DetectionMethod.PIDTest(_detectedBrand!!.displayName, _detectedBrand!!, 60)
                )
            }
        }
        
        _detectionTimestamp = System.currentTimeMillis()
        
        VehicleDetectionResult(
            brand = _detectedBrand ?: VehicleBrand.UNKNOWN,
            model = _detectedModel,
            detectionMethods = detectionMethods,
            confidence = detectionMethods.maxOfOrNull { it.confidence } ?: 0,
            timestamp = _detectionTimestamp
        )
    }
    
    /**
     * Detect vehicle by testing brand-specific PID responses
     */
    private suspend fun detectByPIDResponse(): VehicleBrand {
        // Test Nissan Leaf specific PID
        if (testPID("22 015B", "7E4")) return VehicleBrand.NISSAN
        
        // Test Hyundai/Kia specific PID
        if (testPID("22 0170", "7E4")) return VehicleBrand.HYUNDAI
        
        // Test BMW specific PID
        if (testPID("22 2A38", "7E4")) return VehicleBrand.BMW
        
        // Test Tesla specific PID
        if (testPID("22 1187", "7E4")) return VehicleBrand.TESLA
        
        // Test TOGG specific PID
        if (testPID("22 2101", "7E4")) return VehicleBrand.TOGG
        
        return VehicleBrand.UNKNOWN
    }
    
    private suspend fun testPID(pid: String, header: String): Boolean {
        return try {
            val response = pidReader.sendRawCommand(pid, header)
            response.isNotEmpty() && !response.contains("NO DATA") && !response.contains("ERROR")
        } catch (e: Exception) {
            false
        }
    }
    
    private fun extractModelFromVIN(vin: String): String {
        // VDS (Vehicle Descriptor Section) is characters 4-9
        if (vin.length < 9) return "Unknown"
        return vin.substring(3, 9)
    }
    
    /**
     * Get appropriate PID configuration for detected vehicle
     */
    fun getVehiclePIDConfig(): VehiclePIDConfig {
        val brand = _detectedBrand ?: VehicleBrand.UNKNOWN
        
        return VehiclePIDConfig(
            brand = brand,
            header = getHeaderForBrand(brand),
            supportedPIDs = getSupportedPIDsForBrand(brand),
            updateInterval = getUpdateIntervalForBrand(brand)
        )
    }
    
    /**
     * Get vehicle header automatically based on detected brand
     * Headers are automatically determined from vehicle brand detection
     */
    fun getHeaderForBrand(brand: VehicleBrand): String {
        return when (brand) {
            VehicleBrand.HONDA -> "7E2"
            VehicleBrand.NISSAN, VehicleBrand.RENAULT -> "7E4"
            VehicleBrand.HYUNDAI, VehicleBrand.KIA -> "7E4"
            VehicleBrand.BMW, VehicleBrand.MINI -> "7E4"
            VehicleBrand.MERCEDES -> "7E4"
            VehicleBrand.AUDI, VehicleBrand.VOLKSWAGEN, VehicleBrand.PORSCHE -> "7E4"
            VehicleBrand.VOLVO -> "7E4"
            VehicleBrand.TOYOTA -> "7E4"
            VehicleBrand.TESLA -> "7E4"
            VehicleBrand.BYD, VehicleBrand.MG -> "7E4"
            VehicleBrand.TOGG -> "7E4"
            VehicleBrand.PSA -> "7E4"
            else -> "7E4" // Default for most EVs
        }
    }
    
    /**
     * Get vehicle header automatically - uses detected brand
     */
    fun getVehicleHeader(): String {
        return getHeaderForBrand(_detectedBrand ?: VehicleBrand.UNKNOWN)
    }
    
    private fun getSupportedPIDsForBrand(brand: VehicleBrand): List<PIDType> {
        val common = listOf(
            PIDType.BATTERY_SOC,
            PIDType.BATTERY_VOLTAGE,
            PIDType.BATTERY_CURRENT,
            PIDType.BATTERY_TEMP
        )
        
        val regenPID = when (brand) {
            VehicleBrand.NISSAN, VehicleBrand.RENAULT -> PIDType.REGEN_NISSAN
            VehicleBrand.HYUNDAI, VehicleBrand.KIA -> PIDType.REGEN_HYUNDAI
            VehicleBrand.BMW, VehicleBrand.MINI -> PIDType.REGEN_BMW
            VehicleBrand.TESLA -> PIDType.REGEN_TESLA
            else -> PIDType.REGEN_POWER
        }
        
        return common + regenPID
    }
    
    private fun getUpdateIntervalForBrand(brand: VehicleBrand): Long {
        // Some brands can handle faster polling
        return when (brand) {
            VehicleBrand.TESLA -> 100L // Tesla can handle fast polling
            VehicleBrand.BMW -> 150L
            else -> 200L // Conservative default
        }
    }
    
    /**
     * Detection result data class
     */
    data class VehicleDetectionResult(
        val brand: VehicleBrand,
        val model: String?,
        val detectionMethods: List<DetectionMethod>,
        val confidence: Int,
        val timestamp: Long
    )
    
    /**
     * Detection method sealed class
     */
    sealed class DetectionMethod(
        open val source: String,
        open val brand: VehicleBrand,
        open val confidence: Int
    ) {
        data class VIN(
            val vin: String,
            override val brand: VehicleBrand,
            override val confidence: Int
        ) : DetectionMethod("VIN", brand, confidence)
        
        data class ECU(
            val ecuName: String,
            override val brand: VehicleBrand,
            override val confidence: Int
        ) : DetectionMethod("ECU", brand, confidence)
        
        data class PIDTest(
            val testResult: String,
            override val brand: VehicleBrand,
            override val confidence: Int
        ) : DetectionMethod("PID Test", brand, confidence)
    }
    
    data class VehiclePIDConfig(
        val brand: VehicleBrand,
        val header: String,
        val supportedPIDs: List<PIDType>,
        val updateInterval: Long
    )
}

/**
 * Extension functions for PIDReader
 * 
 * VIN okuma işlemi burada yapılıyor - Bluetooth/OBD servisinden VIN okunur
 * Bu extension function PIDReader interface'ini implement eden herhangi bir sınıf tarafından kullanılabilir
 * (BluetoothPIDReader, USBPIDReader, WiFiPIDReader, vs.)
 */
suspend fun PIDReader.readVIN(): String {
    return try {
        // OBD-II Mode 09 PID 02: Read VIN
        // Header "7DF" broadcast address - tüm ECU'lara gönderilir
        val response = sendRawCommand("09 02", "7DF")
        // Response'u parse et ve VIN'i döndür
        // Gerçek implementasyonda response parsing yapılmalı
        response.trim()
    } catch (e: Exception) {
        ""
    }
}

suspend fun PIDReader.readECUName(): String {
    return try {
        sendRawCommand("09 0A", "7DF")
    } catch (e: Exception) {
        ""
    }
}
