package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetOBDData(c *gin.Context) {
	// TODO: Retrieve real-time OBD data from IoT
	c.JSON(http.StatusOK, gin.H{
		"engine_rpm":         2500,
		"vehicle_speed":      60,
		"engine_coolant_temp": 85,
		"intake_air_temp":    25,
		"throttle_position":  35,
		"fuel_level":         65,
		"fuel_consumption_rate": 7.5,
		"trouble_codes":      []string{},
		"timestamp":          "2024-01-15T10:30:00Z",
	})
}

func GetFuelStations(c *gin.Context) {
	lat := c.Query("lat")
	lng := c.Query("lng")
	fuelType := c.Query("fuel_type")

	if lat == "" || lng == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "lat and lng required"})
		return
	}

	// TODO: Implement fuel station search with price comparison
	c.JSON(http.StatusOK, gin.H{
		"stations": []gin.H{
			{
				"id":              "station_1",
				"name":            "BP Station",
				"latitude":        41.0082,
				"longitude":       28.9784,
				"price_per_liter": 35.50,
				"fuel_type":       fuelType,
				"distance":        2.5,
				"rating":          4.5,
			},
		},
	})
}

func InitiateFuelPayment(c *gin.Context) {
	var req struct {
		StationID string  `json:"station_id" binding:"required"`
		PumpID    string  `json:"pump_id" binding:"required"`
		Amount    float64 `json:"amount" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// TODO: Implement mobile payment
	c.JSON(http.StatusOK, gin.H{"status": "payment_initiated"})
}

func CalculateEVSavings(c *gin.Context) {
	var req struct {
		MonthlyFuelCost   float64 `json:"monthly_fuel_cost" binding:"required"`
		AverageMonthlyKm  float64 `json:"average_monthly_km" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	// TODO: Implement EV savings calculation
	monthlyEVCost := req.AverageMonthlyKm * 0.15 // Assuming 15 kuruş per km
	monthlySavings := req.MonthlyFuelCost - monthlyEVCost
	annualSavings := monthlySavings * 12

	c.JSON(http.StatusOK, gin.H{
		"monthly_ev_cost":   monthlyEVCost,
		"monthly_savings":   monthlySavings,
		"annual_savings":    annualSavings,
		"co2_reduction_kg":  req.AverageMonthlyKm * 0.12, // kg CO2 per km
	})
}
