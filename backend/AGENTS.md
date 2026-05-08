# backend/AGENTS.md

## Scope

- Work only in /backend
- Do not modify /app or root docs
- Read docs/API_CONTRACT.md before implementing any endpoint

---

## Stack

- FastAPI
- Python
- Pydantic
- Supabase (PostgreSQL via supabase-py)
- LLM API (recipe/cost generation)

---

## Architecture

All code follows a strict **router → service** layer structure.

```
routers/compare.py        # HTTP only: parse request, serialize response
    ↓ calls
services/llm_recipe_service.py   # Business logic: LLM call, fallback
services/reward_service.py       # savingAmount, rewardPoint calculation
```

Rules:
- Router functions must not exceed 20 lines
- Service functions must never receive a `request` object
- All service functions require type hints
- `HTTPException` is raised in routers only — services raise plain exceptions

---

## File Structure

```
backend/
├── app/
│   ├── main.py
│   ├── api/
│   │   ├── users.py
│   │   ├── compare.py
│   │   ├── decisions.py
│   │   ├── rankings.py
│   │   ├── flex_items.py
│   │   └── records.py
│   ├── schemas/
│   │   ├── user.py
│   │   ├── compare.py
│   │   ├── decision.py
│   │   ├── flex_item.py
│   │   └── common.py
│   ├── services/
│   │   ├── user_service.py
│   │   ├── llm_recipe_service.py
│   │   ├── fallback_recipe_service.py
│   │   └── reward_service.py
│   └── utils/
│       ├── supabase_client.py
│       └── safe_json.py
├── requirements.txt
└── .env.example
```

---

## Implementation Order

For every new endpoint, follow this order:

```
1. schemas/{name}.py          — Pydantic request/response models
2. services/{name}_service.py — Business logic
3. api/{name}.py              — Router (calls service)
4. main.py                    — Register router
```

---

## API Response Format

All endpoints return this structure:

```python
{"success": True,  "data": {...}, "error": None}
{"success": False, "data": None,  "error": "error message"}
```

Pydantic base schema:

```python
# schemas/common.py
from pydantic import BaseModel
from typing import Any

class ApiResponse(BaseModel):
    success: bool
    data: Any = None
    error: str | None = None
```

---

## Schema Template

```python
# schemas/compare.py
from pydantic import BaseModel
from typing import Literal

class CompareRequest(BaseModel):
    menuName: str
    eatingOutPrice: int

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
```

---

## Service Template

```python
# services/llm_recipe_service.py
from services.fallback_recipe_service import get_fallback
from utils.safe_json import parse_json_safe

async def generate_recipe(menu_name: str, eating_out_price: int) -> dict:
    try:
        # LLM call here
        raw = await call_llm(menu_name, eating_out_price)
        result = parse_json_safe(raw)
        return {**result, "source": "llm"}
    except Exception:
        return {**get_fallback(), "source": "fallback"}
```

---

## Router Template

```python
# api/compare.py
from fastapi import APIRouter, HTTPException
from schemas.compare import CompareRequest
from schemas.common import ApiResponse
from services.llm_recipe_service import generate_recipe
from services.reward_service import calculate_rewards

router = APIRouter(prefix="/api", tags=["compare"])

@router.post("/compare", response_model=ApiResponse)
async def compare(req: CompareRequest):
    try:
        recipe_data = await generate_recipe(req.menuName, req.eatingOutPrice)
        rewards = calculate_rewards(req.eatingOutPrice, recipe_data["homeCookingCost"])
        return ApiResponse(success=True, data={**recipe_data, **rewards})
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
```

---

## Supabase Client

```python
# utils/supabase_client.py
import os
from supabase import create_client, Client
from dotenv import load_dotenv

load_dotenv()

supabase: Client = create_client(
    os.environ["SUPABASE_URL"],
    os.environ["SUPABASE_KEY"]
)
```

Usage in services:

```python
from utils.supabase_client import supabase

async def get_user(nickname: str):
    result = supabase.table("users").select("*").eq("nickname", nickname).execute()
    return result.data[0] if result.data else None
```

---

## Reward Calculation

Never delegate this to LLM. Always calculate in code:

```python
# services/reward_service.py
def calculate_rewards(eating_out_price: int, home_cooking_cost: int) -> dict:
    saving_amount = eating_out_price - home_cooking_cost
    reward_point = saving_amount * 30
    return {"savingAmount": saving_amount, "rewardPoint": reward_point}
```

---

## Character State Rules

```python
def get_character_state(virtual_balance: int) -> str:
    if virtual_balance >= 100000:
        return "rich_getting_better"
    elif virtual_balance >= 0:
        return "neutral"
    elif virtual_balance >= -100000:
        return "poor_getting_worse"
    else:
        return "bankrupt_warning"
```

---

## Decision Update Rules

```python
# If choice == "cook"
user.total_saved_amount += saving_amount
user.total_reward_point += reward_point
user.virtual_balance += saving_amount

# If choice == "eat_out"
user.virtual_balance -= eating_out_price
# totalRewardPoint is unchanged — no points added this turn
```

---

## LLM Fallback Rule

LLM failure must never break the demo.

```
LLM call fails
→ JSON parse fails
→ Any exception
→ Return fallback mock data with source = "fallback"
→ Demo continues
```

---

## LLM Prompt

```python
RECIPE_PROMPT = """
You are a recipe and cost estimation engine for a mindful spending app.

Given a Korean food name, estimate the ingredients, ingredient prices,
home-cooking cost, simple recipe steps, and a soft warning message.

Rules:
- Use common Korean home-cooking assumptions.
- Do not use luxury or rare ingredients.
- Return JSON only. No explanation, no markdown.
- Do not calculate savingAmount or rewardPoint.
- The message should be friendly and motivating, not shaming.

Input:
menuName: {menu_name}
eatingOutPrice: {eating_out_price}

Return JSON:
{{
  "homeCookingCost": number,
  "ingredients": [{{"name": "string", "estimatedPrice": number}}],
  "recipe": ["string"],
  "message": "string"
}}
"""
```

---

## Environment Variables

```
SUPABASE_URL=your_supabase_url
SUPABASE_KEY=your_supabase_key
LLM_API_KEY=your_llm_api_key
LLM_MODEL=claude-haiku-4-5-20251001
```

- Never hardcode secrets
- Use `.env` locally
- Never commit `.env`

---

## Key Gotchas

- Calculate `savingAmount` and `rewardPoint` in `reward_service.py`, never in LLM
- Always wrap LLM calls in try/except and return fallback on any failure
- Supabase client is a singleton — import from `utils/supabase_client.py`
- CORS must be configured in `main.py` for Flutter emulator access
- `10.0.2.2:8000` is Android emulator's localhost — configure CORS accordingly