# FastAPI Micro Service Template

Шаблон микросервиса на FastAPI для быстрого старта новых проектов.

## Возможности

- Быстрый запуск FastAPI приложения
- Структурированный код для масштабирования
- Docker поддержка

## Установка и запуск

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/she1kopr9d/FastAPI-Micro-Service-Template.git
   cd FastAPI-Micro-Service-Template
   ```

2. Установите зависимости:
   ```bash
   pip install -r requirements/prod.txt
   ```

3. Запустите приложение:
   ```bash
   make up
   ```

## Фишки

1. utils/linked_routers

- Саленькое нововведение чтобы не надо было вписывать все импорты в main.py

2. utils/linked_settings

- Добавляет динамическое добавление настроек из .env в config.py. В settings/ будут находится все настройки, а по пути config.settings.название_файла_настроек.НАСТРОЙКА находится переменная окружения

3. utils/acelery

- Добавление асинхронного выполнения celery с одним event_loop
- Также внедрение брокера rabbit внутрь тасков

Пример

```python
# celery_app.py
import utils.acelery


app = utils.acelery.AsyncCelery(
    "worker",
    broker=config.settings.rabbitmq.rabbitmq_url,
    backend=config.settings.rabbitmq.rabbitmq_url,
    broker_instance=rabbit.broker,
)

import tasks  # noqa
```

```python
# tasks/some_task.py
import celery_app


@celery_app.app.async_task_with_broker(name="tasks.some_task")
async def some_task(data: dict):
    pass
```