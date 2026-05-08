from typing import Literal

from pydantic import BaseModel, Field

from app.schemas.user import UserStatsSummary


class DecisionRequest(BaseModel):
    userId: str
    menuName: str = Field(..., min_length=1)
    eatingOutPrice: int = Field(..., ge=0)
    homeCookingCost: int = Field(..., ge=0)
    savingAmount: int
    rewardPoint: int = Field(..., ge=0)
    choice: Literal["cook", "eat_out"]
    message: str


class ConsumptionRecord(BaseModel):
    id: str
    userId: str
    menuName: str
    eatingOutPrice: int
    homeCookingCost: int
    savingAmount: int
    rewardPoint: int
    choice: Literal["cook", "eat_out"]
    message: str | None = None
    createdAt: str


class DecisionData(BaseModel):
    record: ConsumptionRecord
    userStats: UserStatsSummary
    characterState: str
