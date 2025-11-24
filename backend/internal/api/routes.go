package api

import (
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/mongo"
	"github.com/redis/go-redis/v9"
	"super-app/backend/internal/config"
	"super-app/backend/internal/iot"
)

func SetupRoutes(
	router *gin.Engine,
	db *mongo.Database,
	redis *redis.Client,
	iotClient *iot.AWSIoTClient,
	cfg *config.Config,
) {
	v1 := router.Group("/api/v1")
	
	// Health check
	v1.GET("/health", healthCheck)
	
	// Authentication routes
	auth := v1.Group("/auth")
	{
		auth.POST("/register", registerHandler)
		auth.POST("/login", loginHandler)
		auth.POST("/refresh", refreshTokenHandler)
	}
	
	// Vehicle routes
	vehicles := v1.Group("/vehicles")
	vehicles.Use(authMiddleware(cfg.JWTSecret))
	{
		vehicles.GET("", getVehiclesHandler)
		vehicles.POST("", createVehicleHandler)
		vehicles.GET("/:id", getVehicleHandler)
		vehicles.PUT("/:id", updateVehicleHandler)
		vehicles.GET("/:id/data", getVehicleDataHandler)
		vehicles.POST("/:id/obd/connect", connectOBDHandler)
	}
	
	// EV specific routes
	ev := v1.Group("/ev")
	ev.Use(authMiddleware(cfg.JWTSecret))
	{
		ev.GET("/:id/range", getEVRangeHandler)
		ev.POST("/:id/charge", initiateChargeHandler)
		ev.GET("/:id/battery-passport", getBatteryPassportHandler)
		ev.POST("/:id/v2l", initiateV2LHandler)
	}
	
	// ICE specific routes
	ice := v1.Group("/ice")
	ice.Use(authMiddleware(cfg.JWTSecret))
	{
		ice.GET("/:id/fuel-stations", getFuelStationsHandler)
		ice.POST("/:id/payment", initiateFuelPaymentHandler)
		ice.GET("/:id/diagnostics", getDiagnosticsHandler)
		ice.GET("/:id/ev-simulation", getEVSimulationHandler)
	}
	
	// AI Assistant routes
	ai := v1.Group("/ai")
	ai.Use(authMiddleware(cfg.JWTSecret))
	{
		ai.POST("/chat", chatHandler)
		ai.POST("/emotion", analyzeEmotionHandler)
		ai.GET("/persona", getPersonaHandler)
		ai.PUT("/persona", updatePersonaHandler)
		ai.POST("/contextual", contextualCommandHandler)
	}
	
	// Finance routes
	finance := v1.Group("/finance")
	finance.Use(authMiddleware(cfg.JWTSecret))
	{
		finance.GET("/wallet", getWalletHandler)
		finance.POST("/payment", createPaymentHandler)
		finance.GET("/transactions", getTransactionsHandler)
		finance.POST("/p2p/rent", createP2PRentHandler)
	}
	
	// Community routes
	community := v1.Group("/community")
	community.Use(authMiddleware(cfg.JWTSecret))
	{
		community.POST("/imece/request", createImeceRequestHandler)
		community.GET("/imece/nearby", getNearbyImeceRequestsHandler)
		community.POST("/imece/:id/help", helpImeceRequestHandler)
		community.GET("/imece/rewards", getImeceRewardsHandler)
	}
	
	// Gamification routes
	gamification := v1.Group("/gamification")
	gamification.Use(authMiddleware(cfg.JWTSecret))
	{
		gamification.GET("/leaderboard", getLeaderboardHandler)
		gamification.GET("/eco-coins", getEcoCoinsHandler)
		gamification.GET("/achievements", getAchievementsHandler)
	}
	
	// Map routes
	maps := v1.Group("/maps")
	maps.Use(authMiddleware(cfg.JWTSecret))
	{
		maps.GET("/charging-stations", getChargingStationsHandler)
		maps.GET("/fuel-stations", getFuelStationsMapHandler)
		maps.GET("/points-of-interest", getPointsOfInterestHandler)
	}
	
	// WebSocket for real-time updates
	router.GET("/ws", websocketHandler(iotClient))
}
