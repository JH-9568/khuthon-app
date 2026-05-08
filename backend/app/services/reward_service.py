def calculate_rewards(eating_out_price: int, home_cooking_cost: int) -> dict[str, int]:
    saving_amount = eating_out_price - home_cooking_cost
    reward_point = max(saving_amount, 0) * 5
    return {"savingAmount": saving_amount, "rewardPoint": reward_point}


def get_character_state(cumulative_reward_point: int) -> str:
    if cumulative_reward_point >= 900_000:
        return "bankrupt_warning"
    if cumulative_reward_point >= 600_000:
        return "poor_getting_worse"
    if cumulative_reward_point >= 300_000:
        return "rich_getting_better"
    return "neutral"
