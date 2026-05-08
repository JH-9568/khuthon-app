from fastapi import APIRouter, HTTPException

from app.schemas.common import ApiResponse
from app.schemas.compare import CompareRequest
from app.services.llm_recipe_service import generate_recipe
from app.services.reward_service import calculate_rewards

router = APIRouter(tags=["compare"])


@router.post("/compare", response_model=ApiResponse, response_model_exclude_none=True)
async def compare(req: CompareRequest) -> ApiResponse:
    try:
        recipe_data = await generate_recipe(req.menuName, req.eatingOutPrice)
        rewards = calculate_rewards(req.eatingOutPrice, recipe_data["homeCookingCost"])
        data = {
            **recipe_data,
            **rewards,
            "menuName": req.menuName,
            "eatingOutPrice": req.eatingOutPrice,
        }
        return ApiResponse(success=True, data=data)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
