package com.obd.diagnostics

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.obd.diagnostics.analyzer.DataAnalyzer
import com.obd.diagnostics.analyzer.MotorAnalyzer
import com.obd.diagnostics.pid.MockPIDReader
import com.obd.diagnostics.router.PIDRouter
import com.obd.diagnostics.ui.VehicleDebugBadge
import com.obd.diagnostics.ui.VehicleDebugPanel
import kotlinx.coroutines.launch

/**
 * Main Activity - Demonstrates the three new optional features:
 * 1. Real-time fuel consumption in MotorAnalyzer
 * 2. Regenerative braking in DataAnalyzer
 * 3. Vehicle brand detection UI
 */
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        setContent {
            MaterialTheme {
                MainScreen()
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MainScreen() {
    val pidReader = remember { MockPIDReader() }
    val scope = rememberCoroutineScope()
    
    var showDebugPanel by remember { mutableStateOf(true) }
    var selectedTab by remember { mutableStateOf(0) }
    
    val pidRouter = remember { PIDRouter(pidReader) }
    val motorAnalyzer = remember { MotorAnalyzer(pidReader) }
    
    // Initialize vehicle detection
    LaunchedEffect(Unit) {
        pidRouter.detectVehicle()
    }
    
    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("OBD Diagnostics - Enhanced") },
                actions = {
                    // Compact vehicle badge in app bar
                    VehicleDebugBadge(
                        pidRouter = pidRouter,
                        onClick = { showDebugPanel = !showDebugPanel }
                    )
                }
            )
        }
    ) { paddingValues ->
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(paddingValues)
        ) {
            Column(modifier = Modifier.fillMaxSize()) {
                // Tab selector
                TabRow(selectedTabIndex = selectedTab) {
                    Tab(
                        selected = selectedTab == 0,
                        onClick = { selectedTab = 0 },
                        text = { Text("Motor Analysis") }
                    )
                    Tab(
                        selected = selectedTab == 1,
                        onClick = { selectedTab = 1 },
                        text = { Text("EV Analysis") }
                    )
                }
                
                // Content
                when (selectedTab) {
                    0 -> MotorAnalysisScreen(motorAnalyzer)
                    1 -> EVAnalysisScreen(pidReader, pidRouter)
                }
            }
            
            // Floating debug panel
            if (showDebugPanel) {
                Box(
                    modifier = Modifier
                        .align(Alignment.BottomEnd)
                        .padding(16.dp)
                ) {
                    VehicleDebugPanel(
                        pidRouter = pidRouter,
                        onClose = { showDebugPanel = false }
                    )
                }
            }
        }
    }
}

@Composable
fun MotorAnalysisScreen(motorAnalyzer: MotorAnalyzer) {
    val motorData = remember { mutableStateOf<MotorAnalyzer.MotorData?>(null) }
    val scope = rememberCoroutineScope()
    
    LaunchedEffect(Unit) {
        scope.launch {
            motorAnalyzer.monitorMotorData().collect { data ->
                motorData.value = data
            }
        }
    }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text("Motor / ICE Analysis", style = MaterialTheme.typography.headlineMedium)
        Spacer(modifier = Modifier.height(16.dp))
        
        motorData.value?.let { data ->
            DataCard("Engine RPM", "${data.rpm.toInt()}", "rpm")
            DataCard("Speed", "${data.speed.toInt()}", "km/h")
            DataCard("Throttle", "${data.throttlePosition.toInt()}", "%")
            
            // NEW: Real-time fuel consumption
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                colors = CardDefaults.cardColors(
                    containerColor = MaterialTheme.colorScheme.primaryContainer
                )
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        "REAL-TIME FUEL CONSUMPTION",
                        style = MaterialTheme.typography.titleSmall,
                        color = MaterialTheme.colorScheme.primary
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        "%.2f L/h".format(data.fuelConsumption),
                        style = MaterialTheme.typography.headlineMedium
                    )
                    Text(
                        "Instantaneous: %.2f L/100km".format(data.instantFuelRate),
                        style = MaterialTheme.typography.bodyMedium
                    )
                    Text(
                        "MAF: %.1f g/s".format(data.maf),
                        style = MaterialTheme.typography.bodySmall
                    )
                }
            }
        } ?: CircularProgressIndicator()
    }
}

@Composable
fun EVAnalysisScreen(pidReader: MockPIDReader, pidRouter: PIDRouter) {
    val brand = pidRouter.detectedBrand?.displayName ?: "Unknown"
    val dataAnalyzer = remember { DataAnalyzer(pidReader, brand) }
    val evData = remember { mutableStateOf<DataAnalyzer.EVData?>(null) }
    val scope = rememberCoroutineScope()
    
    LaunchedEffect(Unit) {
        scope.launch {
            dataAnalyzer.monitorEVData().collect { data ->
                evData.value = data
            }
        }
    }
    
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(16.dp)
    ) {
        Text("EV Analysis ($brand)", style = MaterialTheme.typography.headlineMedium)
        Spacer(modifier = Modifier.height(16.dp))
        
        evData.value?.let { data ->
            DataCard("State of Charge", "${data.soc.toInt()}", "%")
            DataCard("Battery Voltage", "%.1f".format(data.voltage), "V")
            DataCard("Power", "%.1f".format(data.power), "kW")
            
            // NEW: Regenerative braking display
            Card(
                modifier = Modifier
                    .fillMaxWidth()
                    .padding(vertical = 8.dp),
                colors = CardDefaults.cardColors(
                    containerColor = if (data.isRegenerating) 
                        MaterialTheme.colorScheme.tertiaryContainer 
                    else MaterialTheme.colorScheme.surfaceVariant
                )
            ) {
                Column(modifier = Modifier.padding(16.dp)) {
                    Text(
                        "REGENERATIVE BRAKING ${if (data.isRegenerating) "ACTIVE" else "IDLE"}",
                        style = MaterialTheme.typography.titleSmall,
                        color = if (data.isRegenerating) 
                            MaterialTheme.colorScheme.tertiary 
                        else MaterialTheme.colorScheme.onSurfaceVariant
                    )
                    Spacer(modifier = Modifier.height(8.dp))
                    Text(
                        "%.1f kW".format(data.regenPower),
                        style = MaterialTheme.typography.headlineMedium
                    )
                    Text(
                        "Current: %.1f A".format(data.regenCurrent),
                        style = MaterialTheme.typography.bodyMedium
                    )
                    Text(
                        "Total Recovered: %.2f kWh".format(data.regenEnergyTotal),
                        style = MaterialTheme.typography.bodySmall
                    )
                    Text(
                        "Motor Torque: %.0f Nm".format(data.motorTorque),
                        style = MaterialTheme.typography.bodySmall
                    )
                }
            }
        } ?: CircularProgressIndicator()
    }
}

@Composable
fun DataCard(label: String, value: String, unit: String) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp)
    ) {
        Row(
            modifier = Modifier
                .padding(16.dp)
                .fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween
        ) {
            Text(label, style = MaterialTheme.typography.bodyLarge)
            Text("$value $unit", style = MaterialTheme.typography.bodyLarge)
        }
    }
}
