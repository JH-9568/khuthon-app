def get_fallback(menu_name: str, eating_out_price: int) -> dict:
    home_cooking_cost = min(max(eating_out_price // 2, 6_000), 12_000)
    return {
        "homeCookingCost": home_cooking_cost,
        "ingredients": [
            {"name": "Main ingredient", "estimatedPrice": 5_000},
            {"name": "Sauce and seasoning", "estimatedPrice": 2_500},
            {"name": "Vegetables", "estimatedPrice": 1_500},
        ],
        "recipe": [
            "Prepare the ingredients.",
            "Mix the sauce.",
            "Cook everything in a pan.",
            "Serve and enjoy.",
        ],
        "message": (
            f"Cooking {menu_name} at home can help you save money "
            "and still enjoy the meal."
        ),
    }
