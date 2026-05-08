from fastapi import APIRouter, HTTPException

from app.schemas.common import ApiResponse
from app.schemas.shop import BuyRequest
from app.services.shop_service import get_flex_items, get_user_items, purchase_item

router = APIRouter(tags=["shop"])


@router.get("/flex-items", response_model=ApiResponse)
async def flex_items() -> ApiResponse:
    try:
        return ApiResponse(success=True, data=await get_flex_items())
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.post("/flex-items/{item_id}/purchase", response_model=ApiResponse)
async def buy(item_id: str, req: BuyRequest) -> ApiResponse:
    try:
        return ApiResponse(success=True, data=await purchase_item(item_id, req.userId))
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc


@router.get("/users/{user_id}/items", response_model=ApiResponse)
async def user_items(user_id: str) -> ApiResponse:
    try:
        return ApiResponse(success=True, data=await get_user_items(user_id))
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
