from fastapi import FastAPI
import os

app = FastAPI()

@app.get("/")
def read_root():
    return {
        "status": "success",
        "message": "Hello from Modern DevOps Stack!",
        "environment": os.getenv("ENV_NAME", "local-dev")
    }

