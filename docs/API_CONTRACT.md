# API_CONTRACT.md

## Base URL

### Android Emulator

http://10.0.2.2:8000/api

### Local Web / iOS Simulator

http://localhost:8000/api

---

## Common Response Format

### Success

{
  "success": true,
  "data": {}
}

### Error

{
  "success": false,
  "message": "Error message"
}

---

## Data Types

### User

type User = {
  id: string;
  nickname: string;
  totalSavedAmount: number;
  totalRewardPoint: number;
  virtualBalance: number;
  createdAt: string;
};

### UserStats

type UserStats = {
  userId: string;
  nickname: string;
  totalSavedAmount: number;
  totalRewardPoint: number;
  virtualBalance: number;
  ownedItemCount: number;
  recordCount: number;
};

### Ingredient

type Ingredient = {
  name: string;
  estimatedPrice: number;
};

### CompareResult

type CompareResult = {
  menuName: string;
  eatingOutPrice: number;
  homeCookingCost: number;
  savingAmount: number;
  rewardPoint: number;
  ingredients: Ingredient[];
  recipe: string[];
  message: string;
  source: "llm" | "fallback";
};

### ConsumptionRecord

type ConsumptionRecord = {
  id: string;
  userId: string;
  menuName: string;
  eatingOutPrice: number;
  homeCookingCost: number;
  savingAmount: number;
  rewardPoint: number;
  choice: "cook" | "eat_out";
  message: string;
  createdAt: string;
};

### FlexItem

type FlexItem = {
  id: string;
  name: string;
  price: number;
  emoji: string;
  category: string;
  description: string;
};

### RankingUser

type RankingUser = {
  rank: number;
  userId: string;
  nickname: string;
  totalSavedAmount: number;
  totalRewardPoint: number;
  virtualBalance: number;
};

### PurchasedItem

type PurchasedItem = FlexItem & {
  purchasedAt: string;
};

### CharacterState

type CharacterState =
  | "rich_getting_better"
  | "neutral"
  | "poor_getting_worse"
  | "bankrupt_warning";

---

## Endpoints

---

## POST /users/login

Nickname-based login. Creates a user if the nickname does not exist. If the nickname already exists, returns the existing user.

### Request

{
  "nickname": "jinhyung"
}

### Response

{
  "success": true,
  "data": {
    "id": "user_uuid",
    "nickname": "jinhyung",
    "totalSavedAmount": 0,
    "totalRewardPoint": 0,
    "virtualBalance": 0,
    "createdAt": "2026-05-08T00:00:00"
  }
}

### Validation

- nickname is required.
- nickname max length is 30.
- trim nickname before saving.

---

## GET /users/{user_id}/stats

Returns user statistics.

### Path Parameters

user_id: string

### Response

{
  "success": true,
  "data": {
    "userId": "user_uuid",
    "nickname": "jinhyung",
    "totalSavedAmount": 145000,
    "totalRewardPoint": 725000,
    "virtualBalance": 145000,
    "ownedItemCount": 2,
    "recordCount": 8
  }
}

---

## POST /compare

Generates home-cooking comparison data using LLM or fallback.

This endpoint does not save the user's final decision.

### Request

{
  "menuName": "닭발",
  "eatingOutPrice": 23000
}

### Response

{
  "success": true,
  "data": {
    "menuName": "닭발",
    "eatingOutPrice": 23000,
    "homeCookingCost": 8500,
    "savingAmount": 14500,
    "rewardPoint": 72500,
    "ingredients": [
      {
        "name": "닭발",
        "estimatedPrice": 5000
      },
      {
        "name": "고추장",
        "estimatedPrice": 1000
      },
      {
        "name": "마늘",
        "estimatedPrice": 800
      },
      {
        "name": "양파",
        "estimatedPrice": 1700
      }
    ],
    "recipe": [
      "Clean the chicken feet.",
      "Make the spicy sauce.",
      "Stir-fry the chicken feet with the sauce.",
      "Add vegetables and finish."
    ],
    "message": "You can save 14,500 KRW and earn 72,500 points by cooking this at home.",
    "source": "llm"
  }
}

### Fallback Response

If the LLM call fails, return the same response shape with source fallback.

{
  "success": true,
  "data": {
    "menuName": "닭발",
    "eatingOutPrice": 23000,
    "homeCookingCost": 9000,
    "savingAmount": 14000,
    "rewardPoint": 70000,
    "ingredients": [
      {
        "name": "닭발",
        "estimatedPrice": 5500
      },
      {
        "name": "고추장과 고춧가루",
        "estimatedPrice": 1500
      },
      {
        "name": "간장, 다진 마늘, 올리고당",
        "estimatedPrice": 1800
      },
      {
        "name": "양파, 대파, 청양고추",
        "estimatedPrice": 2200
      }
    ],
    "recipe": [
      "닭발을 깨끗이 씻고 끓는 물에 5~10분 정도 데친 뒤, 찬물에 헹궈 잡내와 불순물을 제거한다.",
      "고추장, 고춧가루, 간장, 다진 마늘, 설탕 또는 올리고당, 후추를 섞어 매콤한 양념장을 만든다.",
      "팬에 닭발과 양념장을 넣고 물을 조금 부은 뒤 중불에서 졸이듯이 볶는다. 양념이 잘 배도록 10~15분 정도 익힌다.",
      "양파, 대파, 청양고추 등을 넣고 한 번 더 볶은 뒤, 참기름과 깨를 뿌려 마무리한다."
    ],
    "message": "닭발 외식 대신 집에서 매콤한 닭발을 만들면 지출을 줄이고 포인트도 챙길 수 있어요.",
    "source": "fallback"
  }
}

### Calculation Rules

savingAmount = eatingOutPrice - homeCookingCost
rewardPoint = savingAmount * 5

### Important Rules

- Backend must calculate savingAmount and rewardPoint in code.
- Do not rely on LLM arithmetic.
- If savingAmount is negative, rewardPoint should be 0.
- LLM should only generate homeCookingCost, ingredients, recipe, and message.

---

## POST /decisions

Saves the user's final decision and updates user stats.

### Request

{
  "userId": "user_uuid",
  "menuName": "닭발",
  "eatingOutPrice": 23000,
  "homeCookingCost": 8500,
  "savingAmount": 14500,
  "rewardPoint": 72500,
  "choice": "cook",
  "message": "You can save 14,500 KRW."
}

### Response for cook

{
  "success": true,
  "data": {
    "record": {
      "id": "record_uuid",
      "userId": "user_uuid",
      "menuName": "닭발",
      "eatingOutPrice": 23000,
      "homeCookingCost": 8500,
      "savingAmount": 14500,
      "rewardPoint": 72500,
      "choice": "cook",
      "createdAt": "2026-05-08T00:00:00"
    },
    "userStats": {
      "totalSavedAmount": 14500,
      "totalRewardPoint": 72500,
      "virtualBalance": 14500
    },
    "characterState": "neutral"
  }
}

### Response for eat_out

{
  "success": true,
  "data": {
    "record": {
      "id": "record_uuid",
      "userId": "user_uuid",
      "menuName": "닭발",
      "eatingOutPrice": 23000,
      "homeCookingCost": 8500,
      "savingAmount": 14500,
      "rewardPoint": 0,
      "choice": "eat_out",
      "createdAt": "2026-05-08T00:00:00"
    },
    "userStats": {
      "totalSavedAmount": 0,
      "totalRewardPoint": 0,
      "virtualBalance": -23000
    },
    "characterState": "neutral"
  }
}

### Update Rules

If choice = cook:

totalSavedAmount += savingAmount
totalRewardPoint += rewardPoint
virtualBalance += savingAmount

If choice = eat_out:

virtualBalance -= eatingOutPrice
rewardPoint = 0
totalRewardPoint is unchanged
totalSavedAmount is unchanged

### Character State Rules

Character state is based on cumulative earned reward points, not the currently
spendable reward point balance. Item purchases do not downgrade the character.

cumulativeRewardPoint = totalSavedAmount * 5

cumulativeRewardPoint < 300000       -> neutral
cumulativeRewardPoint >= 300000      -> rich_getting_better
cumulativeRewardPoint >= 600000      -> poor_getting_worse
cumulativeRewardPoint >= 900000      -> bankrupt_warning

---

## GET /users/{user_id}/records

Returns the user's saved consumption decision records.

### Path Parameters

user_id: string

### Response

{
  "success": true,
  "data": [
    {
      "id": "record_uuid",
      "userId": "user_uuid",
      "menuName": "닭발",
      "eatingOutPrice": 23000,
      "homeCookingCost": 8500,
      "savingAmount": 14500,
      "rewardPoint": 72500,
      "choice": "cook",
      "message": "You can save 14,500 KRW.",
      "createdAt": "2026-05-08T00:00:00"
    },
    {
      "id": "record_uuid_2",
      "userId": "user_uuid",
      "menuName": "마라탕",
      "eatingOutPrice": 18000,
      "homeCookingCost": 12000,
      "savingAmount": 6000,
      "rewardPoint": 0,
      "choice": "eat_out",
      "message": "You chose to eat out this time.",
      "createdAt": "2026-05-08T01:00:00"
    }
  ]
}

### Empty Response

{
  "success": true,
  "data": []
}

### Rules

- Return records ordered by createdAt DESC.
- choice must be either "cook" or "eat_out".
- If the user has no records, return an empty array.

---

## GET /rankings

Returns top users ordered by total saved amount.

### Response

{
  "success": true,
  "data": [
    {
      "rank": 1,
      "userId": "user_uuid_1",
      "nickname": "savingKing",
      "totalSavedAmount": 240000,
      "totalRewardPoint": 1200000,
      "virtualBalance": 240000
    },
    {
      "rank": 2,
      "userId": "user_uuid_2",
      "nickname": "jinhyung",
      "totalSavedAmount": 145000,
      "totalRewardPoint": 725000,
      "virtualBalance": 145000
    }
  ]
}

### Rules

- Rank users by totalSavedAmount DESC.
- If totalSavedAmount is the same, rank by totalRewardPoint DESC.
- Return up to 20 users.
- rank starts from 1.

---

## GET /flex-items

Returns all available flex shop items.

### Response

{
  "success": true,
  "data": [
    {
      "id": "item_uuid_1",
      "name": "Luxury Watch",
      "price": 150000,
      "emoji": "⌚",
      "category": "fashion",
      "description": "A shiny watch for safe in-app flex."
    },
    {
      "id": "item_uuid_2",
      "name": "Sports Car",
      "price": 1500000,
      "emoji": "🏎️",
      "category": "vehicle",
      "description": "A dream car bought with saved money points."
    },
    {
      "id": "item_uuid_3",
      "name": "Penthouse",
      "price": 5000000,
      "emoji": "🏙️",
      "category": "real_estate",
      "description": "A luxury home for the ultimate flex."
    }
  ]
}

### Rules

- Return all flex_items ordered by price ASC.
- price means reward point price.

---

## POST /flex-items/{item_id}/purchase

Purchases a flex item with reward points.

### Path Parameters

item_id: string

### Request

{
  "userId": "user_uuid"
}

### Success Response

{
  "success": true,
  "data": {
    "purchasedItem": {
      "id": "item_uuid",
      "name": "Luxury Watch",
      "price": 150000,
      "emoji": "⌚",
      "category": "fashion",
      "description": "A shiny watch for safe in-app flex."
    },
    "userStats": {
      "totalSavedAmount": 145000,
      "totalRewardPoint": 575000,
      "virtualBalance": 145000
    }
  }
}

### Not Enough Points Error

{
  "success": false,
  "message": "Not enough reward points."
}

### Duplicate Purchase Error

{
  "success": false,
  "message": "Item already purchased."
}

### Rules

- If user.totalRewardPoint >= item.price:
  - subtract item.price from user.totalRewardPoint
  - insert purchase record into user_items
  - return purchasedItem and updated userStats

- If user.totalRewardPoint < item.price:
  - do not insert user_items
  - return error response

- Prevent duplicate purchase if the same user already owns the item.

---

## GET /users/{user_id}/items

Returns flex items purchased by the user.

### Path Parameters

user_id: string

### Response

{
  "success": true,
  "data": [
    {
      "id": "item_uuid_1",
      "name": "Luxury Watch",
      "price": 150000,
      "emoji": "⌚",
      "category": "fashion",
      "description": "A shiny watch for safe in-app flex.",
      "purchasedAt": "2026-05-08T00:00:00"
    },
    {
      "id": "item_uuid_2",
      "name": "Sports Car",
      "price": 1500000,
      "emoji": "🏎️",
      "category": "vehicle",
      "description": "A dream car bought with saved money points.",
      "purchasedAt": "2026-05-08T01:00:00"
    }
  ]
}

### Empty Response

{
  "success": true,
  "data": []
}

### Rules

- Return purchased items ordered by purchasedAt DESC.
- If the user has no purchased items, return an empty array.
