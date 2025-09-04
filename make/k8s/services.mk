k8s-db-up:
	@kubectl apply -f $(K8S_DIR)/db-deployment.yaml
	@kubectl apply -f $(K8S_DIR)/db-service.yaml

k8s-rabbitmq-up:
	@kubectl apply -f $(K8S_DIR)/rabbitmq-deployment.yaml
	@kubectl apply -f $(K8S_DIR)/rabbitmq-service.yaml

k8s-fastapi-up:
	@kubectl apply -f $(K8S_DIR)/fastapi-app-deployment.yaml
	@kubectl apply -f $(K8S_DIR)/fastapi-app-service.yaml