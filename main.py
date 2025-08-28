import fastapi
import utils.linked_routers

app = fastapi.FastAPI()

for router in utils.linked_routers.BaseRouter.registry:
    app.include_router(router)
