from typing import Literal

from pydantic import BaseModel, Field


class CompareRequest(BaseModel):
    menuName: str = Field(..., min_length=1)
    eatingOutPrice: int = Field(..., ge=0)


class Ingredient(BaseModel):
    name: str
    estimatedPrice: int


class CompareData(BaseModel):
    menuName: str
    eatingOutPrice: int
    homeCookingCost: int
    savingAmount: int
    rewardPoint: int
    ingredients: list[Ingredient]
    recipe: list[str]
    message: str
    source: Literal["llm", "fallback"]
