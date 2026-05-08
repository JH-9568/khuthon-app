from fastapi import APIRouter, HTTPException

from app.schemas.common import ApiResponse
from app.schemas.decision import DecisionRequest
from app.services.decision_service import save_decision

router = APIRouter(tags=["decisions"])


@router.post("/decisions", response_model=ApiResponse)
async def decisions(req: DecisionRequest) -> ApiResponse:
    try:
        return ApiResponse(success=True, data=await save_decision(req))
    except ValueError as exc:
        raise HTTPException(status_code=400, detail=str(exc)) from exc
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc)) from exc
