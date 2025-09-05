# FastAPI Micro Service Template

Шаблон микросервиса на FastAPI для быстрого старта новых проектов.

## Возможности

- Быстрый запуск FastAPI приложения
- Структурированный код для масштабирования
- Docker поддержка

## Установка

1. Клонируйте репозиторий:
   ```bash
   git clone https://github.com/she1kopr9d/FastAPI-Micro-Service-Template.git
   cd FastAPI-Micro-Service-Template
   ```

## Работа через docker-compose

1. Сделать билд
   ```bash
   make dc-build
   ```

2. Запустить проект
   ```bash
   make dc-up
   ```

3. Завершить проект
   ```bash
   make dc-down
   ```

4. Создать миграцию (спросит название миграции после)
   ```
   make dc-makemigration
   ```

## Работа через k8s (minikube)

1. Запуск проекта
   ```bash
   make k8s-up
   ```

2. Выключение проекта
   ```bash
   make k8s-down
   ```

3. Применение миграции
   ```
   make k8s-migrate
   ```

4. Получение доступа с проекту
   4.1. К серверу
      ```bash
      make url
      ```
   4.2. К базе данных
      ```bash
      make db-url
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

## Требование для работоспособность модулей

### Router

- чтобы router корректно инициализировался в проекте, он должен быть в папке app/services/<название-сервиса>/
- он должен наследоваться от дочерних классов utils.linked_routers.base_router.BaseRouter

### Model

- чтобы model корректно инициализировался в проекте, он должен быть импортирован в файле app/migrations/env.py

   ```python
   # app/migrations/env.py

   import services.example_service.models  # noqa: F401
   ```
