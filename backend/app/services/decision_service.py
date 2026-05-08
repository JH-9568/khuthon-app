from typing import Any

from app.database import supabase
from app.schemas.decision import DecisionRequest
from app.services.format_service import record_to_api, user_stats_to_api
from app.services.reward_service import get_character_state


async def save_decision(decision: DecisionRequest) -> dict[str, Any]:
    user = supabase.table("users").select("*").eq("id", decision.userId).limit(1).execute()
    if not user.data:
        raise ValueError("User not found.")

    current = user.data[0]
    record_reward = (
        max(decision.savingAmount, 0) * 5
        if decision.choice == "cook"
        else 0
    )
    record = _insert_record(decision, record_reward)
    updated_user = _update_user_stats(current, decision, record_reward)

    return {
        "record": record_to_api(record),
        "userStats": user_stats_to_api(updated_user),
        "characterState": get_character_state(
            updated_user.get("total_saved_amount", 0) * 5
        ),
    }


async def get_user_records(user_id: str) -> list[dict[str, Any]]:
    records = (
        supabase.table("consumption_records")
        .select("*")
        .eq("user_id", user_id)
        .order("created_at", desc=True)
        .execute()
    )
    return [record_to_api(row) for row in records.data]


def _insert_record(decision: DecisionRequest, reward_point: int) -> dict[str, Any]:
    result = (
        supabase.table("consumption_records")
        .insert(
            {
                "user_id": decision.userId,
                "menu_name": decision.menuName,
                "eating_out_price": decision.eatingOutPrice,
                "home_cooking_cost": decision.homeCookingCost,
                "saving_amount": decision.savingAmount,
                "reward_point": reward_point,
                "choice": decision.choice,
                "message": decision.message,
            }
        )
        .execute()
    )
    return result.data[0]


def _update_user_stats(
    user: dict[str, Any],
    decision: DecisionRequest,
    reward_point: int,
) -> dict[str, Any]:
    updates = _build_user_updates(user, decision, reward_point)
    result = (
        supabase.table("users")
        .update(updates)
        .eq("id", decision.userId)
        .execute()
    )
    return result.data[0]


def _build_user_updates(
    user: dict[str, Any],
    decision: DecisionRequest,
    reward_point: int,
) -> dict[str, int]:
    if decision.choice == "cook":
        return {
            "total_saved_amount": user.get("total_saved_amount", 0) + decision.savingAmount,
            "total_reward_point": user.get("total_reward_point", 0) + reward_point,
            "virtual_balance": user.get("virtual_balance", 0) + decision.savingAmount,
        }
    return {"virtual_balance": user.get("virtual_balance", 0) - decision.eatingOutPrice}
