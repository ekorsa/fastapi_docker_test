from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator
import os

app = FastAPI()

# Prometheus metrics
Instrumentator().instrument(app).expose(app)

@app.get("/")
def read_root():
    return {
        "status": "success",
        "message": "Hello from Modern DevOps Stack!",
        "environment": os.getenv("ENV_NAME", "local-dev")
    }

