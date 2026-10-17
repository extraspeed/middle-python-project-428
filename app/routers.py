from fastapi import APIRouter

router = APIRouter(prefix="/api")


@router.get("/health")
def cities():
    return {'status': 'ok'}


@router.get("/cities")
def cities():
    return []
