d-build:
	docker build -t $(PROJECT_DIR)-fastapi-app:latest ./app
	docker build -t $(PROJECT_DIR)-celery-worker:latest ./app
	docker build -t $(PROJECT_DIR)-celery-beat:latest ./app