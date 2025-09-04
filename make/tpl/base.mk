tpl-render:
	@sed "s|{{PROJECT_DIR}}|$(PROJECT_DIR)|g" $(K8S_DIR)/fastapi-app-deployment.yaml.tpl > $(K8S_DIR)/fastapi-app-deployment.yaml
	@sed "s|{{PROJECT_DIR}}|$(PROJECT_DIR)|g" $(K8S_DIR)/celery-worker-deployment.yaml.tpl > $(K8S_DIR)/celery-worker-deployment.yaml
	@sed "s|{{PROJECT_DIR}}|$(PROJECT_DIR)|g" $(K8S_DIR)/celery-beat-deployment.yaml.tpl > $(K8S_DIR)/celery-beat-deployment.yaml