def calculate_rewards(eating_out_price: int, home_cooking_cost: int) -> dict[str, int]:
    saving_amount = eating_out_price - home_cooking_cost
    reward_point = max(saving_amount, 0) * 10
    return {"savingAmount": saving_amount, "rewardPoint": reward_point}


def get_character_state(virtual_balance: int) -> str:
    if virtual_balance <= -50_000:
        return "bankrupt_warning"
    if virtual_balance < 0:
        return "poor_getting_worse"
    if virtual_balance == 0:
        return "neutral"
    return "rich_getting_better"
