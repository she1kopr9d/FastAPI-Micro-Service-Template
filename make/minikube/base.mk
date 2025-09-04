mk-safe-start:
	@if ! minikube status | grep -q "host: Running"; then minikube start; fi

mk-safe-stop:
	@if minikube status | grep -q "host: Running"; then minikube stop; fi

docker-env:
	@eval $$(minikube docker-env)

docker-env-d:
	@eval $$(minikube docker-env -u)

mk-load:
	minikube image load $(PROJECT_DIR)-fastapi-app:latest
	minikube image load $(PROJECT_DIR)-celery-worker:latest
	minikube image load $(PROJECT_DIR)-celery-beat:latest