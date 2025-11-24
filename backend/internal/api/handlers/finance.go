package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GetWallet(c *gin.Context) {
	userID, _ := c.Get("user_id")

	// TODO: Retrieve wallet balance from database
	c.JSON(http.StatusOK, gin.H{
		"user_id": userID,
		"balance": 1250.50,
		"currency": "TRY",
		"cards": []gin.H{
			{
				"id":       "card_1",
				"last_four": "4242",
				"type":     "credit",
			},
		},
	})
}

func ProcessPayment(c *gin.Context) {
	var req struct {
		Amount      float64 `json:"amount" binding:"required"`
		Description string  `json:"description"`
		Category    string  `json:"category" binding:"required"` // fuel, charging, insurance, etc.
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID, _ := c.Get("user_id")

	// TODO: Process payment with Stripe
	c.JSON(http.StatusOK, gin.H{
		"transaction_id": "txn_123",
		"user_id":        userID,
		"amount":         req.Amount,
		"status":         "completed",
		"created_at":     "2024-01-15T10:30:00Z",
	})
}

func GetTransactions(c *gin.Context) {
	userID, _ := c.Get("user_id")

	// TODO: Retrieve transactions from database
	c.JSON(http.StatusOK, gin.H{
		"transactions": []gin.H{
			{
				"id":          "txn_1",
				"amount":     150.00,
				"description": "Şarj İstasyonu",
				"category":    "charging",
				"created_at":  "2024-01-15T09:00:00Z",
			},
		},
	})
}
