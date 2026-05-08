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
    "totalRewardPoint": 1450000,
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
    "rewardPoint": 145000,
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
    "message": "You can save 14,500 KRW and earn 145,000 points by cooking this at home.",
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
    "rewardPoint": 140000,
    "ingredients": [
      {
        "name": "Main ingredient",
        "estimatedPrice": 5000
      },
      {
        "name": "Sauce and seasoning",
        "estimatedPrice": 2500
      },
      {
        "name": "Vegetables",
        "estimatedPrice": 1500
      }
    ],
    "recipe": [
      "Prepare the ingredients.",
      "Mix the sauce.",
      "Cook everything in a pan.",
      "Serve and enjoy."
    ],
    "message": "Cooking this at home can help you save money and still enjoy the meal.",
    "source": "fallback"
  }
}

### Calculation Rules

savingAmount = eatingOutPrice - homeCookingCost
rewardPoint = savingAmount * 10

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
  "rewardPoint": 145000,
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
      "rewardPoint": 145000,
      "choice": "cook",
      "createdAt": "2026-05-08T00:00:00"
    },
    "userStats": {
      "totalSavedAmount": 14500,
      "totalRewardPoint": 145000,
      "virtualBalance": 14500
    },
    "characterState": "rich_getting_better"
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
    "characterState": "poor_getting_worse"
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

cumulativeRewardPoint = totalSavedAmount * 10

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
      "rewardPoint": 145000,
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
      "totalRewardPoint": 2400000,
      "virtualBalance": 240000
    },
    {
      "rank": 2,
      "userId": "user_uuid_2",
      "nickname": "jinhyung",
      "totalSavedAmount": 145000,
      "totalRewardPoint": 1450000,
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
      "price": 300000,
      "emoji": "⌚",
      "category": "fashion",
      "description": "A shiny watch for safe in-app flex."
    },
    {
      "id": "item_uuid_2",
      "name": "Sports Car",
      "price": 3000000,
      "emoji": "🏎️",
      "category": "vehicle",
      "description": "A dream car bought with saved money points."
    },
    {
      "id": "item_uuid_3",
      "name": "Penthouse",
      "price": 10000000,
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
      "price": 300000,
      "emoji": "⌚",
      "category": "fashion",
      "description": "A shiny watch for safe in-app flex."
    },
    "userStats": {
      "totalSavedAmount": 145000,
      "totalRewardPoint": 1150000,
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
      "price": 300000,
      "emoji": "⌚",
      "category": "fashion",
      "description": "A shiny watch for safe in-app flex.",
      "purchasedAt": "2026-05-08T00:00:00"
    },
    {
      "id": "item_uuid_2",
      "name": "Sports Car",
      "price": 3000000,
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
