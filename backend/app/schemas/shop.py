from pydantic import BaseModel

from app.schemas.user import UserStatsSummary


class FlexItem(BaseModel):
    id: str
    name: str
    price: int
    emoji: str
    category: str
    description: str


class BuyRequest(BaseModel):
    userId: str


class BuyResponse(BaseModel):
    purchasedItem: FlexItem
    userStats: UserStatsSummary


class PurchasedItem(FlexItem):
    purchasedAt: str
