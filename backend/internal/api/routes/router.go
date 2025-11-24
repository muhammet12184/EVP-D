package routes

import (
	"super-mobility-backend/internal/api/handlers"
	"super-mobility-backend/internal/api/middleware"
	"super-mobility-backend/internal/config"

	"github.com/gin-gonic/gin"
)

func SetupRouter(cfg *config.Config) *gin.Engine {
	router := gin.Default()

	// Middleware
	router.Use(middleware.CORS())
	router.Use(middleware.Logger())

	// Health check
	router.GET("/health", handlers.HealthCheck)

	// API v1
	v1 := router.Group("/api/v1")
	{
		// Authentication
		auth := v1.Group("/auth")
		{
			auth.POST("/register", handlers.Register)
			auth.POST("/login", handlers.Login)
			auth.POST("/refresh", handlers.RefreshToken)
		}

		// Protected routes
		protected := v1.Group("")
		protected.Use(middleware.AuthMiddleware(cfg.JWTSecret))
		{
			// EV Management
			ev := protected.Group("/ev")
			{
				ev.GET("/battery-state", handlers.GetBatteryState)
				ev.POST("/plug-and-charge/initiate", handlers.InitiatePlugAndCharge)
				ev.POST("/plug-and-charge/complete-payment", handlers.CompletePlugAndChargePayment)
				ev.GET("/range-estimate", handlers.GetRangeEstimate)
				ev.GET("/battery-passport", handlers.GetBatteryPassport)
				ev.POST("/battery-passport/certify", handlers.CertifyBatteryHealth)
			}

			// ICE Management
			ice := protected.Group("/ice")
			{
				ice.GET("/obd-data", handlers.GetOBDData)
				ice.GET("/fuel-stations", handlers.GetFuelStations)
				ice.POST("/fuel-stations/payment", handlers.InitiateFuelPayment)
				ice.POST("/ev-savings-simulation", handlers.CalculateEVSavings)
			}

			// AI Services
			ai := protected.Group("/ai")
			{
				ai.POST("/mechanic/explain-trouble-code", handlers.ExplainTroubleCode)
				ai.POST("/assistant/analyze-emotion", handlers.AnalyzeEmotion)
				ai.POST("/assistant/contextual-command", handlers.ProcessContextualCommand)
			}

			// Finance
			finance := protected.Group("/finance")
			{
				finance.GET("/wallet", handlers.GetWallet)
				finance.POST("/payment", handlers.ProcessPayment)
				finance.GET("/transactions", handlers.GetTransactions)
			}

			// İmece (Community Help)
			imece := protected.Group("/imece")
			{
				imece.POST("/help-requests", handlers.CreateHelpRequest)
				imece.GET("/help-requests/nearby", handlers.GetNearbyHelpRequests)
				imece.POST("/help-requests/:id/accept", handlers.AcceptHelpRequest)
				imece.POST("/help-requests/:id/complete", handlers.CompleteHelpRequest)
			}

			// Gamification
			gamification := protected.Group("/gamification")
			{
				gamification.GET("/leaderboard", handlers.GetLeaderboard)
				gamification.GET("/eco-coins", handlers.GetEcoCoins)
				gamification.GET("/achievements", handlers.GetAchievements)
			}
		}
	}

	return router
}
