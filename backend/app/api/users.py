from fastapi import APIRouter, HTTPException

from app.schemas.common import ApiResponse
from app.schemas.user import LoginRequest
from app.services.decision_service import get_user_records
from app.services.user_service import get_user_stats, login_user

router = APIRouter(tags=["users"])


@router.post("/users/login", response_model=ApiResponse)
async def login(req: LoginRequest) -> ApiResponse:
    try:
        return ApiResponse(success=True, data=await login_user(req.nickname))
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.get("/users/{user_id}/stats", response_model=ApiResponse)
async def stats(user_id: str) -> ApiResponse:
    try:
        return ApiResponse(success=True, data=await get_user_stats(user_id))
    except ValueError as exc:
        raise HTTPException(status_code=404, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.get("/users/{user_id}/records", response_model=ApiResponse)
async def records(user_id: str) -> ApiResponse:
    try:
        return ApiResponse(success=True, data=await get_user_records(user_id))
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
