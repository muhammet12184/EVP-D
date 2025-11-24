package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func CreateHelpRequest(c *gin.Context) {
	var req struct {
		Type        string  `json:"type" binding:"required"`
		Description string  `json:"description" binding:"required"`
		Latitude    float64 `json:"latitude" binding:"required"`
		Longitude   float64 `json:"longitude" binding:"required"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID, _ := c.Get("user_id")

	// TODO: Save to database
	c.JSON(http.StatusCreated, gin.H{
		"id":           "request_123",
		"user_id":      userID,
		"type":         req.Type,
		"status":       "active",
		"reward_points": 500,
		"created_at":   "2024-01-15T10:30:00Z",
	})
}

func GetNearbyHelpRequests(c *gin.Context) {
	lat := c.Query("lat")
	lng := c.Query("lng")
	radius := c.Query("radius")

	if lat == "" || lng == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "lat and lng required"})
		return
	}

	// TODO: Query database for nearby requests
	c.JSON(http.StatusOK, gin.H{
		"requests": []gin.H{
			{
				"id":          "request_1",
				"type":        "flat_tire",
				"description": "Lastik patladı, yardım lazım",
				"latitude":    41.0082,
				"longitude":   28.9784,
				"distance":    1.2,
				"reward_points": 500,
				"created_at":  "2024-01-15T10:25:00Z",
			},
		},
	})
}

func AcceptHelpRequest(c *gin.Context) {
	requestID := c.Param("id")
	userID, _ := c.Get("user_id")

	// TODO: Update request status
	c.JSON(http.StatusOK, gin.H{
		"status":        "accepted",
		"accepted_by":   userID,
		"accepted_at":   "2024-01-15T10:35:00Z",
	})
}

func CompleteHelpRequest(c *gin.Context) {
	requestID := c.Param("id")
	userID, _ := c.Get("user_id")

	// TODO: Complete request and award points
	c.JSON(http.StatusOK, gin.H{
		"status":        "completed",
		"completed_by":  userID,
		"points_awarded": 500,
		"completed_at":  "2024-01-15T10:45:00Z",
	})
}
