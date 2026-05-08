from typing import Any

from app.database import supabase


async def get_rankings() -> list[dict[str, Any]]:
    result = (
        supabase.table("users")
        .select("*")
        .order("total_saved_amount", desc=True)
        .order("total_reward_point", desc=True)
        .limit(20)
        .execute()
    )
    return [
        {
            "rank": index + 1,
            "userId": row["id"],
            "nickname": row["nickname"],
            "totalSavedAmount": row.get("total_saved_amount", 0),
            "totalRewardPoint": row.get("total_reward_point", 0),
            "virtualBalance": row.get("virtual_balance", 0),
        }
        for index, row in enumerate(result.data)
    ]
