def get_fallback(menu_name: str, eating_out_price: int) -> dict:
    home_cooking_cost = min(max(eating_out_price // 2, 8_000), 12_000)
    return {
        "homeCookingCost": home_cooking_cost,
        "ingredients": [
            {"name": "닭발", "estimatedPrice": 5_500},
            {"name": "고추장과 고춧가루", "estimatedPrice": 1_500},
            {"name": "간장, 다진 마늘, 올리고당", "estimatedPrice": 1_800},
            {"name": "양파, 대파, 청양고추", "estimatedPrice": 2_200},
        ],
        "recipe": [
            "닭발을 깨끗이 씻고 끓는 물에 5~10분 정도 데친 뒤, 찬물에 헹궈 잡내와 불순물을 제거한다.",
            "고추장, 고춧가루, 간장, 다진 마늘, 설탕 또는 올리고당, 후추를 섞어 매콤한 양념장을 만든다.",
            "팬에 닭발과 양념장을 넣고 물을 조금 부은 뒤 중불에서 졸이듯이 볶는다. 양념이 잘 배도록 10~15분 정도 익힌다.",
            "양파, 대파, 청양고추 등을 넣고 한 번 더 볶은 뒤, 참기름과 깨를 뿌려 마무리한다.",
        ],
        "message": (
            f"{menu_name} 외식 대신 집에서 매콤한 닭발을 만들면 지출을 줄이고 포인트도 챙길 수 있어요."
        ),
    }
