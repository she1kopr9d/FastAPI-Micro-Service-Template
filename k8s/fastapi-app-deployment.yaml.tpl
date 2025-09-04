apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: fastapi-app
  template:
    metadata:
      labels:
        app: fastapi-app
    spec:
      containers:
      - name: fastapi-app
        image: {{PROJECT_DIR}}-fastapi-app:latest
        imagePullPolicy: Never
        command: ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
        envFrom:
        - configMapRef:
            name: app-env