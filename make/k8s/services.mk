k8s-db-up:
	@kubectl apply -f $(K8S_DIR)/db-deployment.yaml
	@kubectl apply -f $(K8S_DIR)/db-service.yaml

k8s-db-down:
	@kubectl delete -f $(K8S_DIR)/db-service.yaml
	@kubectl delete -f $(K8S_DIR)/db-deployment.yaml

k8s-rabbitmq-up:
	@kubectl apply -f $(K8S_DIR)/rabbitmq-deployment.yaml
	@kubectl apply -f $(K8S_DIR)/rabbitmq-service.yaml

k8s-rabbitmq-down:
	@kubectl delete -f $(K8S_DIR)/rabbitmq-service.yaml
	@kubectl delete -f $(K8S_DIR)/rabbitmq-deployment.yaml

k8s-fastapi-up:
	@kubectl apply -f $(K8S_DIR)/fastapi-app-deployment.yaml
	@kubectl apply -f $(K8S_DIR)/fastapi-app-service.yaml

k8s-fastapi-down:
	@kubectl delete -f $(K8S_DIR)/fastapi-app-service.yaml
	@kubectl delete -f $(K8S_DIR)/fastapi-app-deployment.yaml

k8s-celery-worker-up:
	@kubectl apply -f $(K8S_DIR)/celery-worker-deployment.yaml
	@kubectl apply -f $(K8S_DIR)/celery-worker-service.yaml

k8s-celery-worker-down:
	@kubectl delete -f $(K8S_DIR)/celery-worker-service.yaml
	@kubectl delete -f $(K8S_DIR)/celery-worker-deployment.yaml

k8s-celery-beat-up:
	@kubectl apply -f $(K8S_DIR)/celery-beat-deployment.yaml
	@kubectl apply -f $(K8S_DIR)/celery-beat-service.yaml

k8s-celery-beat-down:
	@kubectl delete -f $(K8S_DIR)/celery-beat-service.yaml
	@kubectl delete -f $(K8S_DIR)/celery-beat-deployment.yaml

k8s-up-all: k8s-db-up k8s-rabbitmq-up k8s-fastapi-up k8s-celery-worker-up k8s-celery-beat-up
	@echo "Все компоненты Kubernetes подняты."

k8s-down-all:
	kubectl delete svc,deploy,job --all
	@echo "Все компоненты Kubernetes остановлены."

k8s-migrate:
	@echo "🚀 Запускаем миграции Alembic в Kubernetes..."
	@kubectl delete job alembic-migration --ignore-not-found
	@kubectl apply -f $(K8S_DIR)/alembic-job.yaml
	@echo "⌛ Ждём завершения миграций..."
	@kubectl wait --for=condition=complete --timeout=120s job/alembic-migration || \
		(kubectl logs job/alembic-migration && exit 1)
	@echo "📜 Логи миграции:"
	@kubectl logs job/alembic-migration
	@echo "✅ Миграции успешно применены!"