K8S_DIR=./k8s

include make/tpl/base.mk
include make/docker/base.mk
include make/minikube/base.mk
include make/k8s/services.mk

load-env:
	@echo "Создаём ConfigMap..."
	@TMP_FILE=k8s/.env-configmap.yaml.tmp; \
	TARGET_FILE=k8s/.env-configmap.yaml; \
	if [ -f $$TMP_FILE ]; then \
		cp $$TMP_FILE $$TARGET_FILE; \
	fi; \
	{ \
		echo "apiVersion: v1"; \
		echo "kind: ConfigMap"; \
		echo "metadata:"; \
		echo "  name: app-env"; \
		echo "data:"; \
		awk -F= '/^[A-Za-z_][A-Za-z0-9_]*=/{gsub(/"/,"\\\""); print "  " $$1 ": \"" $$2 "\""}' .env; \
	} > $$TARGET_FILE; \
	kubectl apply -f $$TARGET_FILE

k8s-up: d-build mk-safe-start mk-load load-env tpl-render k8s-up-all
	@echo "Kubernetes кластер запущен и настроен."

k8s-down: k8s-down-all mk-safe-stop
	@echo "Kubernetes кластер остановлен."

k8s-logs:
	kubectl logs -l app=myapp -n default

k8s-debug:
	kubectl describe pod -l app=myapp -n default

url:
	kubectl port-forward svc/fastapi-app 8000:8000

db-url:
	kubectl port-forward svc/postgres-db 5433:5432