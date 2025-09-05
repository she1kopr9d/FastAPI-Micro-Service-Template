dc-build:
	docker-compose build

dc-up:
	docker-compose up -d

dc-down:
	docker-compose down

dc-logs:
	docker-compose logs -f

dc-makemigration:
	@read -p "🔧 Введите сообщение для миграции: " MSG; \
	docker-compose -f docker-compose.yml run fastapi-app alembic revision --autogenerate -m "$$MSG"