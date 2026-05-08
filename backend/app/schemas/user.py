from pydantic import BaseModel, Field


class LoginRequest(BaseModel):
    nickname: str = Field(..., min_length=1, max_length=30)


class UserData(BaseModel):
    id: str
    nickname: str
    totalSavedAmount: int
    totalRewardPoint: int
    virtualBalance: int
    createdAt: str


class UserStats(BaseModel):
    userId: str
    nickname: str
    totalSavedAmount: int
    totalRewardPoint: int
    virtualBalance: int
    ownedItemCount: int
    recordCount: int


class UserStatsSummary(BaseModel):
    totalSavedAmount: int
    totalRewardPoint: int
    virtualBalance: int
