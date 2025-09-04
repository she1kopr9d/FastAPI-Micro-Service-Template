ENV_FILE=.env

include .env

export PROJECT_DIR
## ===== Docker section =====
dc-build:
	docker-compose build

dc-up:
	docker-compose up -d

dc-down:
	docker-compose down

dc-logs:
	docker-compose logs -f

docker-env:
	@eval $$(minikube docker-env)

docker-env-d:
	@eval $$(minikube docker-env -u)

d-build:
	docker build -t $(PROJECT_DIR)-fastapi-app:latest ./app
	docker build -t $(PROJECT_DIR)-celery-worker:latest ./app
	docker build -t $(PROJECT_DIR)-celery-beat:latest ./app

mk-load:
	minikube image load $(PROJECT_DIR)-fastapi-app:latest
	minikube image load $(PROJECT_DIR)-celery-worker:latest
	minikube image load $(PROJECT_DIR)-celery-beat:latest

## ===== Kubernetes section =====
K8S_DIR=./k8s

load-env:
	@echo "apiVersion: v1" > k8s/.env-configmap.yaml
	@echo "kind: ConfigMap" >> k8s/.env-configmap.yaml
	@echo "metadata:" >> k8s/.env-configmap.yaml
	@echo "  name: app-env" >> k8s/.env-configmap.yaml
	@echo "data:" >> k8s/.env-configmap.yaml
	@awk -F= '/^[A-Za-z_][A-Za-z0-9_]*=/{gsub(/"/, "\\\""); print "  " $$1 ": \"" $$2 "\"" }' .env >> k8s/.env-configmap.yaml

k8s-up: d-build mk-load load-env
	@if ! minikube status | grep -q "host: Running"; then minikube start; fi
	@sed "s|{{PROJECT_DIR}}|$(PROJECT_DIR)|g" $(K8S_DIR)/fastapi-app-deployment.yaml.tpl > $(K8S_DIR)/fastapi-app-deployment.yaml
	@sed "s|{{PROJECT_DIR}}|$(PROJECT_DIR)|g" $(K8S_DIR)/celery-worker-deployment.yaml.tpl > $(K8S_DIR)/celery-worker-deployment.yaml
	@sed "s|{{PROJECT_DIR}}|$(PROJECT_DIR)|g" $(K8S_DIR)/celery-beat-deployment.yaml.tpl > $(K8S_DIR)/celery-beat-deployment.yaml
	@kubectl apply -f $(K8S_DIR) --validate=false

k8s-down:
	@kubectl delete -f $(K8S_DIR)
	@minikube stop

k8s-logs:
	kubectl logs -l app=myapp -n default

k8s-debug:
	kubectl describe pod -l app=myapp -n default

url:
	@minikube service fastapi-app --url

.PHONY: dc-build dc-up dc-down dc-logs d-build mk-load k8s-build k8s-up k8s-down k8s-test load-env