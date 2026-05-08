from typing import Any


def user_to_api(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": row["id"],
        "nickname": row["nickname"],
        "totalSavedAmount": row.get("total_saved_amount", 0),
        "totalRewardPoint": row.get("total_reward_point", 0),
        "virtualBalance": row.get("virtual_balance", 0),
        "createdAt": row["created_at"],
    }


def user_stats_to_api(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "totalSavedAmount": row.get("total_saved_amount", 0),
        "totalRewardPoint": row.get("total_reward_point", 0),
        "virtualBalance": row.get("virtual_balance", 0),
    }


def record_to_api(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": row["id"],
        "userId": row["user_id"],
        "menuName": row["menu_name"],
        "eatingOutPrice": row["eating_out_price"],
        "homeCookingCost": row["home_cooking_cost"],
        "savingAmount": row["saving_amount"],
        "rewardPoint": row["reward_point"],
        "choice": row["choice"],
        "message": row.get("message"),
        "createdAt": row["created_at"],
    }


def flex_item_to_api(row: dict[str, Any]) -> dict[str, Any]:
    return {
        "id": row["id"],
        "name": row["name"],
        "price": flex_item_price(row),
        "emoji": row["emoji"],
        "category": row["category"],
        "description": row["description"],
    }


def flex_item_price(row: dict[str, Any]) -> int:
    return int(row["price"] * 0.5)
