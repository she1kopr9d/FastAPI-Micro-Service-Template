dc-build:
	docker-compose build

dc-up:
	docker-compose up -d

dc-down:
	docker-compose down

dc-logs:
	docker-compose logs -f