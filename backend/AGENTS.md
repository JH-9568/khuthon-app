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
- Google Gemini API (recipe/cost generation via `google-generativeai`)

---

## Architecture

All code follows a strict **router → service** layer structure.

```
routers/compare.py                 # HTTP only: parse request, serialize response
    ↓ calls
services/llm_recipe_service.py     # Business logic: LLM call, fallback
services/reward_service.py         # savingAmount, rewardPoint calculation
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
│   ├── database.py              # Supabase client singleton
│   ├── api/
│   │   ├── users.py
│   │   ├── compare.py
│   │   ├── decisions.py
│   │   ├── rankings.py
│   │   └── shop.py              # flex items + purchase
│   ├── schemas/
│   │   ├── user.py
│   │   ├── compare.py
│   │   ├── decision.py
│   │   ├── shop.py              # FlexItem, BuyRequest, BuyResponse
│   │   └── common.py            # ApiResponse base schema
│   ├── services/
│   │   ├── llm_recipe_service.py
│   │   ├── fallback_recipe_service.py
│   │   └── reward_service.py
│   └── utils/
│       └── safe_json.py
├── requirements.txt
└── .env.example
```

---

## Implementation Order

For every new endpoint, follow this order:

```
1. schemas/{name}.py           — Pydantic request/response models
2. services/{name}_service.py  — Business logic
3. api/{name}.py               — Router (calls service)
4. main.py                     — Register router
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
import os
import google.generativeai as genai
from app.services.fallback_recipe_service import get_fallback
from app.utils.safe_json import parse_json_safe

genai.configure(api_key=os.environ["LLM_API_KEY"])
model = genai.GenerativeModel(os.environ.get("LLM_MODEL", "gemini-1.5-flash"))

async def generate_recipe(menu_name: str, eating_out_price: int) -> dict:
    try:
        prompt = RECIPE_PROMPT.format(menu_name=menu_name, eating_out_price=eating_out_price)
        response = model.generate_content(prompt)
        result = parse_json_safe(response.text)
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

router = APIRouter(tags=["compare"])  # prefix set in main.py when registering: app.include_router(router, prefix="/api")

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

Singleton lives in `app/database.py` (not `utils/supabase_client.py`).

```python
# database.py
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
from app.database import supabase

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

Source of truth: docs/SCREEN_FLOW.md.
Always match this exactly — Flutter uses the same string values.

```python
def get_character_state(virtual_balance: int) -> str:
    if virtual_balance >= 5_000_000:
        return "rich_5"
    elif virtual_balance >= 1_000_000:
        return "rich_4"
    elif virtual_balance >= 500_000:
        return "rich_3"
    elif virtual_balance >= 100_000:
        return "rich_2"
    elif virtual_balance >= 10_000:
        return "rich_1"
    elif virtual_balance >= -10_000:
        return "normal"
    elif virtual_balance >= -100_000:
        return "poor_1"
    elif virtual_balance >= -500_000:
        return "poor_2"
    else:
        return "poor_3"
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
LLM_API_KEY=your_gemini_api_key   # Google AI Studio key (AIzaSy...)
LLM_MODEL=gemini-1.5-flash        # Google Gemini model
```

- Never hardcode secrets
- Use `.env` locally
- Never commit `.env`

---

## Key Gotchas

- Calculate `savingAmount` and `rewardPoint` in `reward_service.py`, never in LLM
- Always wrap LLM calls in try/except and return fallback on any failure
- Supabase client is a singleton — import from `app.database`
- CORS must be configured in `main.py` for Flutter emulator access
- `10.0.2.2:8000` is Android emulator's localhost — configure CORS accordingly