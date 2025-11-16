package com.obd.diagnostics.examples

import com.obd.diagnostics.analyzer.DataAnalyzer
import com.obd.diagnostics.analyzer.MotorAnalyzer
import com.obd.diagnostics.pid.MockPIDReader
import com.obd.diagnostics.pid.PIDType
import com.obd.diagnostics.router.PIDRouter
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.take
import kotlinx.coroutines.runBlocking

/**
 * Örnek kullanım senaryoları - 3 yeni opsiyonel özellik
 */
object ExampleUsage {
    
    @JvmStatic
    fun main(args: Array<String>) = runBlocking {
        println("=".repeat(60))
        println("OBD Diagnostics - Enhanced Features Demo")
        println("=".repeat(60))
        println()
        
        // Mock PID reader oluştur
        val pidReader = MockPIDReader()
        
        // Demo 1: Yakıt Tüketimi İzleme
        demonstrateFuelConsumption(pidReader)
        
        println()
        
        // Demo 2: Rejeneratif Fren İzleme
        demonstrateRegenBraking(pidReader)
        
        println()
        
        // Demo 3: Araç Marka Tespiti
        demonstrateVehicleDetection(pidReader)
    }
    
    /**
     * DEMO 1: Gerçek Zamanlı Yakıt Tüketimi
     */
    private suspend fun demonstrateFuelConsumption(pidReader: MockPIDReader) {
        println("┌─ DEMO 1: Yakıt Tüketimi İzleme (Motor Analizi)")
        println("└─ Özellik: Motor analizinde gerçek yakıt PID'i (artık 0.0 değil!)")
        println()
        
        // Gerçekçi değerler ayarla
        pidReader.setMockValue(PIDType.ENGINE_RPM, 2500.0)
        pidReader.setMockValue(PIDType.VEHICLE_SPEED, 80.0)
        pidReader.setMockValue(PIDType.THROTTLE_POSITION, 60.0)
        pidReader.setMockValue(PIDType.MAF, 18.5) // g/s
        pidReader.setMockValue(PIDType.FUEL_RATE, 0.0) // Force MAF calculation
        
        val motorAnalyzer = MotorAnalyzer(pidReader)
        
        println("📊 Motor Verileri (5 okuma):")
        println("-".repeat(60))
        
        // 5 okuma yap
        motorAnalyzer.monitorMotorData()
            .take(5)
            .collect { data ->
                println("""
                    Hız: ${data.speed.toInt()} km/h | RPM: ${data.rpm.toInt()} rpm
                    Gaz: ${data.throttlePosition.toInt()}% | Yük: ${data.engineLoad.toInt()}%
                    ⛽ Yakıt Tüketimi: ${"%.2f".format(data.fuelConsumption)} L/h
                    💧 Anlık Tüketim: ${"%.2f".format(data.instantFuelRate)} L/100km
                    🌪️  MAF: ${"%.1f".format(data.maf)} g/s
                    ${"─".repeat(60)}
                """.trimIndent())
                delay(100) // Simulate time passing
            }
        
        // Ortalama hesaplama örneği
        val avgFuel = motorAnalyzer.getAverageFuelConsumption(1000L)
        println("📈 1 saniyelik ortalama: ${"%.2f".format(avgFuel)} L/h")
        
        // Farklı sürüş senaryoları
        println("\n🚗 Farklı Sürüş Senaryoları:")
        
        // Rölanti
        pidReader.setMockValue(PIDType.VEHICLE_SPEED, 0.0)
        pidReader.setMockValue(PIDType.ENGINE_RPM, 850.0)
        pidReader.setMockValue(PIDType.MAF, 2.5)
        val idleData = motorAnalyzer.monitorMotorData().take(1).toList()[0]
        println("   Rölanti: ${"%.1f".format(idleData.fuelConsumption)} L/h")
        
        // Otoyol
        pidReader.setMockValue(PIDType.VEHICLE_SPEED, 120.0)
        pidReader.setMockValue(PIDType.ENGINE_RPM, 3000.0)
        pidReader.setMockValue(PIDType.MAF, 25.0)
        val highwayData = motorAnalyzer.monitorMotorData().take(1).toList()[0]
        println("   Otoyol: ${"%.2f".format(highwayData.instantFuelRate)} L/100km")
        
        // Agresif sürüş
        pidReader.setMockValue(PIDType.VEHICLE_SPEED, 60.0)
        pidReader.setMockValue(PIDType.ENGINE_RPM, 5000.0)
        pidReader.setMockValue(PIDType.MAF, 45.0)
        pidReader.setMockValue(PIDType.THROTTLE_POSITION, 95.0)
        val aggressiveData = motorAnalyzer.monitorMotorData().take(1).toList()[0]
        println("   Agresif: ${"%.2f".format(aggressiveData.instantFuelRate)} L/100km")
    }
    
    /**
     * DEMO 2: Rejeneratif Fren İzleme
     */
    private suspend fun demonstrateRegenBraking(pidReader: MockPIDReader) {
        println("\n┌─ DEMO 2: Rejeneratif Fren İzleme (EV Analizi)")
        println("└─ Özellik: EV tarafında regen için ayrı PID desteği")
        println()
        
        // EV değerleri ayarla
        pidReader.setMockValue(PIDType.BATTERY_SOC, 65.0)
        pidReader.setMockValue(PIDType.BATTERY_VOLTAGE, 375.0)
        pidReader.setMockValue(PIDType.BATTERY_CURRENT, 10.0) // Normal sürüş
        pidReader.setMockValue(PIDType.BATTERY_TEMP, 28.0)
        pidReader.setMockValue(PIDType.REGEN_POWER, 0.0)
        pidReader.setMockValue(PIDType.REGEN_ENERGY_TOTAL, 125.5)
        
        val dataAnalyzer = DataAnalyzer(pidReader, "Nissan")
        
        println("🔋 EV Verileri - Normal Sürüş:")
        println("-".repeat(60))
        
        // Normal sürüş
        val normalData = dataAnalyzer.monitorEVData().take(1).toList()[0]
        println("""
            SOC: ${normalData.soc.toInt()}% | Voltaj: ${"%.1f".format(normalData.voltage)} V
            Güç: ${"%.1f".format(normalData.power)} kW | Sıcaklık: ${normalData.batteryTemp.toInt()}°C
            ⚡ Regen: ${if (normalData.isRegenerating) "AKTİF" else "PASİF"}
            🔌 Regen Gücü: ${"%.1f".format(normalData.regenPower)} kW
        """.trimIndent())
        
        println("\n🛑 Fren Basılıyor - REGEN AKTİF!")
        println("-".repeat(60))
        
        // Regen aktif
        pidReader.setMockValue(PIDType.BATTERY_CURRENT, -35.0) // Negatif = şarj
        pidReader.setMockValue(PIDType.REGEN_POWER, 25.0) // 25 kW geri kazanım
        pidReader.setMockValue(PIDType.REGEN_CURRENT, 65.0)
        pidReader.setMockValue(PIDType.MOTOR_TORQUE, -80.0) // Negatif tork
        
        val regenData = dataAnalyzer.monitorEVData().take(1).toList()[0]
        println("""
            SOC: ${regenData.soc.toInt()}% | Voltaj: ${"%.1f".format(regenData.voltage)} V
            Güç: ${"%.1f".format(regenData.power)} kW | Akım: ${"%.1f".format(regenData.current)} A
            ⚡ Regen: ${if (regenData.isRegenerating) "✅ AKTİF" else "❌ PASİF"}
            🔌 Regen Gücü: ${"%.1f".format(regenData.regenPower)} kW
            🔋 Regen Akımı: ${"%.1f".format(regenData.regenCurrent)} A
            ⚙️  Motor Torku: ${"%.0f".format(regenData.motorTorque)} Nm
            📊 Toplam Regen: ${"%.2f".format(regenData.regenEnergyTotal)} kWh
        """.trimIndent())
        
        // Farklı regen seviyeleri
        println("\n📊 Farklı Regen Seviyeleri:")
        
        val regenScenarios = listOf(
            Triple(5.0, 15.0, "Hafif Regen (Gaz Bırakma)"),
            Triple(15.0, 40.0, "Orta Regen (Hafif Fren)"),
            Triple(35.0, 90.0, "Maksimum Regen (Sert Fren)")
        )
        
        regenScenarios.forEach { (power, current, description) ->
            pidReader.setMockValue(PIDType.REGEN_POWER, power)
            pidReader.setMockValue(PIDType.REGEN_CURRENT, current)
            val data = dataAnalyzer.monitorEVData().take(1).toList()[0]
            println("   $description: ${"%.1f".format(data.regenPower)} kW")
        }
        
        // Verimlilik hesaplama
        println("\n📈 Regen Verimliliği Analizi:")
        val stats = dataAnalyzer.calculateRegenEfficiency(1000L)
        println("""
            Geri Kazanılan: ${"%.3f".format(stats.totalRecovered)} kWh
            Harcanan: ${"%.3f".format(stats.totalConsumed)} kWh
            Verimlilik: ${"%.1f".format(stats.efficiency)}%
            Regen Olay Sayısı: ${stats.regenEvents}
            Kümülatif: ${"%.2f".format(stats.cumulativeRegen)} kWh
        """.trimIndent())
    }
    
    /**
     * DEMO 3: Araç Marka Tespiti
     */
    private suspend fun demonstrateVehicleDetection(pidReader: MockPIDReader) {
        println("\n┌─ DEMO 3: Araç Marka Tespiti (Debug UI)")
        println("└─ Özellik: PIDRouter marka tespitini UI'da gösterme")
        println()
        
        val pidRouter = PIDRouter(pidReader)
        
        println("🔍 Araç Tespiti Başlatılıyor...")
        println("-".repeat(60))
        
        // Tespit yap
        val result = pidRouter.detectVehicle()
        
        println("""
            🚗 Tespit Edilen Araç
            ═══════════════════════════════════════════════════════
            Marka: ${result.brand.displayName}
            Model Kodu: ${result.model ?: "Bilinmiyor"}
            Güven Seviyesi: ${result.confidence}% ${getConfidenceBadge(result.confidence)}
            Tespit Zamanı: ${java.text.SimpleDateFormat("HH:mm:ss").format(java.util.Date(result.timestamp))}
        """.trimIndent())
        
        println("\n📋 Kullanılan Tespit Yöntemleri:")
        if (result.detectionMethods.isEmpty()) {
            println("   ⚠️  Tespit yöntemi bulunamadı")
        } else {
            result.detectionMethods.forEachIndexed { index, method ->
                val icon = when (method) {
                    is PIDRouter.DetectionMethod.VIN -> "🔢"
                    is PIDRouter.DetectionMethod.ECU -> "⚙️"
                    is PIDRouter.DetectionMethod.PIDTest -> "🧪"
                }
                println("   ${index + 1}. $icon ${method.source} - ${method.confidence}%")
                when (method) {
                    is PIDRouter.DetectionMethod.VIN -> 
                        println("      └─ VIN: ${method.vin}")
                    is PIDRouter.DetectionMethod.ECU -> 
                        println("      └─ ECU: ${method.ecuName}")
                    is PIDRouter.DetectionMethod.PIDTest -> 
                        println("      └─ Sonuç: ${method.testResult}")
                }
            }
        }
        
        // PID konfigürasyonu
        val config = pidRouter.getVehiclePIDConfig()
        println("\n⚙️  Araç PID Konfigürasyonu:")
        println("   Header: ${config.header}")
        println("   Update Interval: ${config.updateInterval}ms")
        println("   Desteklenen PID'ler: ${config.supportedPIDs.size} adet")
        config.supportedPIDs.take(5).forEach { pid ->
            println("      • ${pid.description}")
        }
        if (config.supportedPIDs.size > 5) {
            println("      ... ve ${config.supportedPIDs.size - 5} adet daha")
        }
        
        // Farklı markalar için tespit örnekleri
        println("\n🌍 Örnek VIN Tespitleri:")
        val vinExamples = mapOf(
            "JN1AZ4EH5GM350645" to "Nissan Leaf",
            "KMHC65LC5HU123456" to "Hyundai Ioniq",
            "WBA8E1C50GK123456" to "BMW i3",
            "5YJ3E1EA0HF123456" to "Tesla Model 3",
            "NMT12345678901234" to "TOGG T10X",
            "VF1AG000123456789" to "Renault Zoe"
        )
        
        vinExamples.forEach { (vin, model) ->
            val brand = PIDRouter.VehicleBrand.fromVIN(vin)
            val emoji = when(brand) {
                PIDRouter.VehicleBrand.NISSAN -> "🇯🇵"
                PIDRouter.VehicleBrand.HYUNDAI -> "🇰🇷"
                PIDRouter.VehicleBrand.BMW -> "🇩🇪"
                PIDRouter.VehicleBrand.TESLA -> "🇺🇸"
                PIDRouter.VehicleBrand.TOGG -> "🇹🇷"
                PIDRouter.VehicleBrand.RENAULT -> "🇫🇷"
                else -> "🌐"
            }
            println("   $emoji $model -> ${brand.displayName}")
        }
        
        // UI Entegrasyonu bilgisi
        println("\n📱 UI Entegrasyonu:")
        println("""
            Uygulamada 2 UI bileşeni mevcut:
            
            1. VehicleDebugBadge (Kompakt)
               └─ App bar'da minimal gösterim
               └─ Marka adı + ikonu
               └─ Renkli arka plan (güven seviyesine göre)
               
            2. VehicleDebugPanel (Detaylı)
               └─ Floating overlay panel
               └─ Tüm tespit detayları
               └─ Genişletilip daraltılabilir
               └─ Gerçek zamanlı güncelleme
               
            Kullanım: MainActivity.kt dosyasına bakın
        """.trimIndent())
    }
    
    private fun getConfidenceBadge(confidence: Int): String {
        return when {
            confidence >= 90 -> "🟢 Mükemmel"
            confidence >= 70 -> "🔵 İyi"
            confidence >= 50 -> "🟡 Orta"
            else -> "🔴 Düşük"
        }
    }
}

/**
 * Extension function - Flow'u List'e çevirme yardımcısı
 */
suspend fun <T> kotlinx.coroutines.flow.Flow<T>.toList(): List<T> {
    val list = mutableListOf<T>()
    collect { list.add(it) }
    return list
}
