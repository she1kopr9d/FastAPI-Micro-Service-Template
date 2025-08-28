## ===== Docker section =====
dc-build:
	docker-compose build

dc-up:
	docker-compose up -d

dc-upb:
	docker-compose up -d

dc-down:
	docker-compose -f docker-compose.yml down

dc-logs:
	docker-compose -f docker-compose.yml logs -f

## ===== Kubernetes section =====
k8s-apply:
	kubectl apply -f k8s/

k8s-delete:
	kubectl delete -f k8s/

k8s-logs:
	kubectl logs -l app=myapp -n default

k8s-debug:
	kubectl describe pod -l app=myapp -n default