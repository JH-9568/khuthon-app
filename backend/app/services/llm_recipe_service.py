import os
from typing import Any

try:
    from google import genai
except ImportError:
    genai = None

from app.services.fallback_recipe_service import get_fallback
from app.utils.safe_json import parse_json_safe

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


def _fallback(menu_name: str, eating_out_price: int) -> dict[str, Any]:
    return {**get_fallback(menu_name, eating_out_price), "source": "fallback"}


async def generate_recipe(menu_name: str, eating_out_price: int) -> dict[str, Any]:
    api_key = os.getenv("LLM_API_KEY")
    if not api_key or genai is None:
        return _fallback(menu_name, eating_out_price)

    try:
        client = genai.Client(api_key=api_key)
        model_name = os.getenv("LLM_MODEL", "gemini-2.0-flash")
        prompt = RECIPE_PROMPT.format(
            menu_name=menu_name,
            eating_out_price=eating_out_price,
        )
        response = client.models.generate_content(model=model_name, contents=prompt)
        result = parse_json_safe(response.text)
        return {**result, "source": "llm"}
    except Exception:
        return _fallback(menu_name, eating_out_price)
