from typing import Any

from app.database import supabase
from app.services.format_service import user_to_api


async def login_user(nickname: str) -> dict[str, Any]:
    normalized = nickname.strip()
    if not normalized:
        raise ValueError("nickname is required.")

    existing = (
        supabase.table("users")
        .select("*")
        .eq("nickname", normalized)
        .limit(1)
        .execute()
    )
    if existing.data:
        return user_to_api(existing.data[0])

    created = (
        supabase.table("users")
        .insert(
            {
                "nickname": normalized,
                "total_saved_amount": 0,
                "total_reward_point": 0,
                "virtual_balance": 0,
            }
        )
        .execute()
    )
    return user_to_api(created.data[0])


async def get_user_stats(user_id: str) -> dict[str, Any]:
    user = supabase.table("users").select("*").eq("id", user_id).limit(1).execute()
    if not user.data:
        raise ValueError("User not found.")

    records = (
        supabase.table("consumption_records")
        .select("id", count="exact")
        .eq("user_id", user_id)
        .execute()
    )
    items = (
        supabase.table("user_items")
        .select("id", count="exact")
        .eq("user_id", user_id)
        .execute()
    )
    row = user.data[0]
    return {
        "userId": row["id"],
        "nickname": row["nickname"],
        "totalSavedAmount": row.get("total_saved_amount", 0),
        "totalRewardPoint": row.get("total_reward_point", 0),
        "virtualBalance": row.get("virtual_balance", 0),
        "ownedItemCount": items.count or 0,
        "recordCount": records.count or 0,
    }
