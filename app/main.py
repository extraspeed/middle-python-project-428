from pathlib import Path

from fastapi import FastAPI

from app.routers import router as api_outer
from starlette.responses import FileResponse

PUBLIC_DIR = Path(__file__).resolve().parent.parent / "frontend" / "public"


def create_app():
    app = FastAPI()
    app.include_router(api_outer)

    @app.api_route("/{path:path}", methods=["GET", "HEAD"])
    def spa(path: str):
        file = (PUBLIC_DIR / path).resolve()
        if path and file.is_relative_to(PUBLIC_DIR) and file.is_file():
            return FileResponse(file)

        return FileResponse(PUBLIC_DIR / "index.html")

    return app
