from fastapi import APIRouter, HTTPException

from app.schemas.common import ApiResponse
from app.services.ranking_service import get_rankings

router = APIRouter(tags=["rankings"])


@router.get("/rankings", response_model=ApiResponse, response_model_exclude_none=True)
async def rankings() -> ApiResponse:
    try:
        return ApiResponse(success=True, data=await get_rankings())
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
