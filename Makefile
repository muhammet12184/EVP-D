.PHONY: help build run test clean docker-up docker-down

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# Backend
backend-build: ## Build Go backend
	cd backend && go build -o bin/api ./cmd/api

backend-run: ## Run Go backend
	cd backend && go run ./cmd/api/main.go

backend-test: ## Run Go backend tests
	cd backend && go test ./...

# AI Services
ai-install: ## Install Python AI dependencies
	cd ai-services && pip install -r requirements.txt

ai-run: ## Run Python AI services
	cd ai-services && uvicorn src.main:app --host 0.0.0.0 --port 8000 --reload

ai-test: ## Run Python AI tests
	cd ai-services && pytest tests/

# Flutter
flutter-install: ## Install Flutter dependencies
	cd mobile-app && flutter pub get

flutter-run: ## Run Flutter app
	cd mobile-app && flutter run

flutter-build-android: ## Build Flutter Android APK
	cd mobile-app && flutter build apk --release

flutter-build-ios: ## Build Flutter iOS app
	cd mobile-app && flutter build ios --release

# Docker
docker-up: ## Start all services with Docker Compose
	cd infrastructure && docker-compose up -d

docker-down: ## Stop all services
	cd infrastructure && docker-compose down

docker-logs: ## View Docker logs
	cd infrastructure && docker-compose logs -f

docker-build: ## Build all Docker images
	cd infrastructure && docker-compose build

# Development
dev-setup: ## Setup development environment
	@echo "Setting up development environment..."
	@make backend-build
	@make ai-install
	@make flutter-install
	@echo "Development environment ready!"

# Testing
test-all: ## Run all tests
	@make backend-test
	@make ai-test

# Cleanup
clean: ## Clean build artifacts
	rm -rf backend/bin/
	rm -rf mobile-app/build/
	rm -rf ai-services/__pycache__/
	rm -rf ai-services/*.pyc
	find . -type d -name "__pycache__" -exec rm -r {} +
	find . -type f -name "*.pyc" -delete

clean-all: clean ## Clean everything including dependencies
	rm -rf mobile-app/.dart_tool/
	rm -rf ai-services/venv/
	rm -rf ai-services/.venv/
