package com.obd.diagnostics.ui

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.obd.diagnostics.router.PIDRouter
import java.text.SimpleDateFormat
import java.util.*

/**
 * Debug UI component to display vehicle brand detection
 * Can be toggled on/off and positioned as floating overlay
 */
@Composable
fun VehicleDebugPanel(
    pidRouter: PIDRouter,
    modifier: Modifier = Modifier,
    onClose: () -> Unit = {}
) {
    val detectionResult = remember { mutableStateOf<PIDRouter.VehicleDetectionResult?>(null) }
    val isExpanded = remember { mutableStateOf(true) }
    
    LaunchedEffect(Unit) {
        // Detect vehicle on component mount
        detectionResult.value = pidRouter.detectVehicle()
    }
    
    Card(
        modifier = modifier
            .padding(8.dp)
            .widthIn(max = 400.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 8.dp),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surface.copy(alpha = 0.95f)
        ),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(
            modifier = Modifier.padding(12.dp)
        ) {
            // Header
            Row(
                modifier = Modifier.fillMaxWidth(),
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(
                        imageVector = Icons.Default.Build,
                        contentDescription = "Debug",
                        tint = MaterialTheme.colorScheme.primary,
                        modifier = Modifier.size(20.dp)
                    )
                    Spacer(modifier = Modifier.width(8.dp))
                    Text(
                        text = "Vehicle Detection Debug",
                        style = MaterialTheme.typography.titleMedium,
                        fontWeight = FontWeight.Bold
                    )
                }
                Row {
                    IconButton(
                        onClick = { isExpanded.value = !isExpanded.value },
                        modifier = Modifier.size(32.dp)
                    ) {
                        Icon(
                            imageVector = if (isExpanded.value) Icons.Default.KeyboardArrowUp 
                                         else Icons.Default.KeyboardArrowDown,
                            contentDescription = "Expand/Collapse"
                        )
                    }
                    IconButton(
                        onClick = onClose,
                        modifier = Modifier.size(32.dp)
                    ) {
                        Icon(
                            imageVector = Icons.Default.Close,
                            contentDescription = "Close"
                        )
                    }
                }
            }
            
            AnimatedVisibility(
                visible = isExpanded.value,
                enter = fadeIn(),
                exit = fadeOut()
            ) {
                detectionResult.value?.let { result ->
                    Column(modifier = Modifier.padding(top = 12.dp)) {
                        // Main brand display
                        VehicleBrandDisplay(result)
                        
                        Spacer(modifier = Modifier.height(12.dp))
                        
                        // Detection methods
                        DetectionMethodsList(result)
                        
                        Spacer(modifier = Modifier.height(12.dp))
                        
                        // Stats
                        DetectionStats(result)
                    }
                } ?: run {
                    // Loading state
                    Box(
                        modifier = Modifier
                            .fillMaxWidth()
                            .padding(24.dp),
                        contentAlignment = Alignment.Center
                    ) {
                        CircularProgressIndicator()
                    }
                }
            }
        }
    }
}

@Composable
private fun VehicleBrandDisplay(result: PIDRouter.VehicleDetectionResult) {
    Surface(
        modifier = Modifier.fillMaxWidth(),
        color = getColorForConfidence(result.confidence),
        shape = RoundedCornerShape(8.dp)
    ) {
        Column(
            modifier = Modifier.padding(16.dp),
            horizontalAlignment = Alignment.CenterHorizontally
        ) {
            Icon(
                imageVector = Icons.Default.DirectionsCar,
                contentDescription = "Vehicle",
                modifier = Modifier.size(48.dp),
                tint = Color.White
            )
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = result.brand.displayName,
                fontSize = 24.sp,
                fontWeight = FontWeight.Bold,
                color = Color.White
            )
            result.model?.let { model ->
                Text(
                    text = "Model: $model",
                    fontSize = 14.sp,
                    color = Color.White.copy(alpha = 0.9f)
                )
            }
            Spacer(modifier = Modifier.height(4.dp))
            Text(
                text = "${result.confidence}% Confidence",
                fontSize = 12.sp,
                color = Color.White.copy(alpha = 0.8f)
            )
        }
    }
}

@Composable
private fun DetectionMethodsList(result: PIDRouter.VehicleDetectionResult) {
    Card(
        modifier = Modifier.fillMaxWidth(),
        colors = CardDefaults.cardColors(
            containerColor = MaterialTheme.colorScheme.surfaceVariant
        )
    ) {
        Column(modifier = Modifier.padding(12.dp)) {
            Text(
                text = "Detection Methods",
                style = MaterialTheme.typography.titleSmall,
                fontWeight = FontWeight.Bold
            )
            Spacer(modifier = Modifier.height(8.dp))
            
            if (result.detectionMethods.isEmpty()) {
                Text(
                    text = "No detection methods available",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.6f)
                )
            } else {
                result.detectionMethods.forEach { method ->
                    DetectionMethodItem(method)
                    Spacer(modifier = Modifier.height(4.dp))
                }
            }
        }
    }
}

@Composable
private fun DetectionMethodItem(method: PIDRouter.DetectionMethod) {
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .background(
                color = MaterialTheme.colorScheme.surface,
                shape = RoundedCornerShape(4.dp)
            )
            .padding(8.dp),
        horizontalArrangement = Arrangement.SpaceBetween,
        verticalAlignment = Alignment.CenterVertically
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Icon(
                imageVector = when (method) {
                    is PIDRouter.DetectionMethod.VIN -> Icons.Default.Info
                    is PIDRouter.DetectionMethod.ECU -> Icons.Default.Settings
                    is PIDRouter.DetectionMethod.PIDTest -> Icons.Default.PlayArrow
                },
                contentDescription = method.source,
                modifier = Modifier.size(16.dp),
                tint = MaterialTheme.colorScheme.primary
            )
            Spacer(modifier = Modifier.width(8.dp))
            Column {
                Text(
                    text = method.source,
                    fontSize = 12.sp,
                    fontWeight = FontWeight.Medium
                )
                when (method) {
                    is PIDRouter.DetectionMethod.VIN -> {
                        Text(
                            text = "VIN: ${method.vin}",
                            fontSize = 10.sp,
                            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                        )
                    }
                    is PIDRouter.DetectionMethod.ECU -> {
                        Text(
                            text = "ECU: ${method.ecuName}",
                            fontSize = 10.sp,
                            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                        )
                    }
                    is PIDRouter.DetectionMethod.PIDTest -> {
                        Text(
                            text = "Result: ${method.testResult}",
                            fontSize = 10.sp,
                            color = MaterialTheme.colorScheme.onSurface.copy(alpha = 0.6f)
                        )
                    }
                }
            }
        }
        ConfidenceBadge(method.confidence)
    }
}

@Composable
private fun ConfidenceBadge(confidence: Int) {
    Surface(
        color = getColorForConfidence(confidence),
        shape = RoundedCornerShape(12.dp)
    ) {
        Text(
            text = "$confidence%",
            fontSize = 10.sp,
            fontWeight = FontWeight.Bold,
            color = Color.White,
            modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp)
        )
    }
}

@Composable
private fun DetectionStats(result: PIDRouter.VehicleDetectionResult) {
    val dateFormat = remember { SimpleDateFormat("HH:mm:ss", Locale.getDefault()) }
    val timeStr = remember(result.timestamp) {
        dateFormat.format(Date(result.timestamp))
    }
    
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .background(
                color = MaterialTheme.colorScheme.surfaceVariant.copy(alpha = 0.5f),
                shape = RoundedCornerShape(4.dp)
            )
            .padding(8.dp)
    ) {
        StatRow("Detection Time", timeStr)
        StatRow("Methods Used", "${result.detectionMethods.size}")
        StatRow("Brand Code", result.brand.name)
    }
}

@Composable
private fun StatRow(label: String, value: String) {
    Row(
        modifier = Modifier.fillMaxWidth(),
        horizontalArrangement = Arrangement.SpaceBetween
    ) {
        Text(
            text = label,
            fontSize = 11.sp,
            color = MaterialTheme.colorScheme.onSurfaceVariant.copy(alpha = 0.7f)
        )
        Text(
            text = value,
            fontSize = 11.sp,
            fontWeight = FontWeight.Medium,
            color = MaterialTheme.colorScheme.onSurfaceVariant
        )
    }
}

private fun getColorForConfidence(confidence: Int): Color {
    return when {
        confidence >= 90 -> Color(0xFF4CAF50) // Green
        confidence >= 70 -> Color(0xFF2196F3) // Blue
        confidence >= 50 -> Color(0xFFFFC107) // Amber
        else -> Color(0xFFF44336) // Red
    }
}

/**
 * Minimal compact version for status bar
 */
@Composable
fun VehicleDebugBadge(
    pidRouter: PIDRouter,
    onClick: () -> Unit,
    modifier: Modifier = Modifier
) {
    val brand = pidRouter.detectedBrand
    val confidence = remember { mutableStateOf(0) }
    
    LaunchedEffect(brand) {
        if (brand != null) {
            val result = pidRouter.detectVehicle()
            confidence.value = result.confidence
        }
    }
    
    Surface(
        modifier = modifier
            .clickable(onClick = onClick)
            .padding(4.dp),
        color = brand?.let { getColorForConfidence(confidence.value) } 
            ?: MaterialTheme.colorScheme.surfaceVariant,
        shape = RoundedCornerShape(16.dp)
    ) {
        Row(
            modifier = Modifier.padding(horizontal = 12.dp, vertical = 6.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(
                imageVector = Icons.Default.DirectionsCar,
                contentDescription = "Vehicle",
                modifier = Modifier.size(16.dp),
                tint = Color.White
            )
            Spacer(modifier = Modifier.width(6.dp))
            Text(
                text = brand?.displayName ?: "Detecting...",
                fontSize = 12.sp,
                fontWeight = FontWeight.Medium,
                color = Color.White
            )
        }
    }
}
