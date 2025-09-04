K8S_DIR=./k8s

include make/tpl/base.mk
include make/docker/base.mk
include make/minikube/base.mk
include make/k8s/services.mk

load-env:
	@echo "apiVersion: v1" > k8s/.env-configmap.yaml
	@echo "kind: ConfigMap" >> k8s/.env-configmap.yaml
	@echo "metadata:" >> k8s/.env-configmap.yaml
	@echo "  name: app-env" >> k8s/.env-configmap.yaml
	@echo "data:" >> k8s/.env-configmap.yaml
	@awk -F= '/^[A-Za-z_][A-Za-z0-9_]*=/{gsub(/"/, "\\\""); print "  " $$1 ": \"" $$2 "\"" }' .env >> k8s/.env-configmap.yaml

k8s-up: d-build mk-load load-env mk-safe-start tpl-render k8s-db-up k8s-rabbitmq-up k8s-fastapi-up

k8s-down:
	@kubectl delete -f $(K8S_DIR)
	@minikube stop

k8s-logs:
	kubectl logs -l app=myapp -n default

k8s-debug:
	kubectl describe pod -l app=myapp -n default