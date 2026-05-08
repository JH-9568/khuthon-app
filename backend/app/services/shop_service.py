from typing import Any

from app.database import supabase
from app.services.format_service import flex_item_price, flex_item_to_api, user_stats_to_api


async def get_flex_items() -> list[dict[str, Any]]:
    result = supabase.table("flex_items").select("*").order("price").execute()
    return [flex_item_to_api(row) for row in result.data]


async def purchase_item(item_id: str, user_id: str) -> dict[str, Any]:
    user = _get_one("users", "id", user_id, "User not found.")
    item = _get_one("flex_items", "id", item_id, "Item not found.")
    _ensure_not_owned(user_id, item_id)

    if user.get("total_reward_point", 0) < flex_item_price(item):
        raise ValueError("Not enough reward points.")

    updated_user = _spend_points(user, item)
    (
        supabase.table("user_items")
        .insert({"user_id": user_id, "item_id": item_id})
        .execute()
    )
    return {
        "purchasedItem": flex_item_to_api(item),
        "userStats": user_stats_to_api(updated_user),
    }


async def get_user_items(user_id: str) -> list[dict[str, Any]]:
    result = (
        supabase.table("user_items")
        .select("purchased_at, flex_items(*)")
        .eq("user_id", user_id)
        .order("purchased_at", desc=True)
        .execute()
    )
    return [_purchased_item_to_api(row) for row in result.data]


def _get_one(table: str, column: str, value: str, error: str) -> dict[str, Any]:
    result = supabase.table(table).select("*").eq(column, value).limit(1).execute()
    if not result.data:
        raise ValueError(error)
    return result.data[0]


def _ensure_not_owned(user_id: str, item_id: str) -> None:
    result = (
        supabase.table("user_items")
        .select("item_id")
        .eq("user_id", user_id)
        .eq("item_id", item_id)
        .limit(1)
        .execute()
    )
    if result.data:
        raise ValueError("Item already purchased.")


def _spend_points(user: dict[str, Any], item: dict[str, Any]) -> dict[str, Any]:
    updated_points = user.get("total_reward_point", 0) - flex_item_price(item)
    result = (
        supabase.table("users")
        .update({"total_reward_point": updated_points})
        .eq("id", user["id"])
        .execute()
    )
    return result.data[0]


def _purchased_item_to_api(row: dict[str, Any]) -> dict[str, Any]:
    item = flex_item_to_api(row["flex_items"])
    return {**item, "purchasedAt": row["purchased_at"]}
