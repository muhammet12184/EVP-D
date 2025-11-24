package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetLeaderboard(c *gin.Context) {
	// TODO: Retrieve leaderboard from database
	c.JSON(http.StatusOK, gin.H{
		"leaderboard": []gin.H{
			{
				"rank":         1,
				"user_id":      "user_1",
				"user_name":    "Eco Driver",
				"eco_coins":    15000,
				"total_km":     5000,
				"efficiency":   95.5,
			},
		},
	})
}

func GetEcoCoins(c *gin.Context) {
	userID, _ := c.Get("user_id")

	// TODO: Retrieve eco coins from database
	c.JSON(http.StatusOK, gin.H{
		"user_id":   userID,
		"eco_coins": 3500,
		"total_earned": 5000,
		"total_spent": 1500,
	})
}

func GetAchievements(c *gin.Context) {
	userID, _ := c.Get("user_id")

	// TODO: Retrieve achievements from database
	c.JSON(http.StatusOK, gin.H{
		"user_id": userID,
		"achievements": []gin.H{
			{
				"id":          "eco_master",
				"name":        "Eko Ustası",
				"description": "1000 km ekonomik sürüş",
				"unlocked_at": "2024-01-10T08:00:00Z",
			},
		},
	})
}
