# SCREEN_FLOW.md

## Main User Flow

1. User opens the mobile app.
2. User enters a nickname on the login screen.
3. App calls POST /api/users/login.
4. Backend creates or returns the user from Supabase.
5. App stores the userId locally for the session.
6. User lands on the home screen.
7. Home screen shows current virtual balance, reward points, and character state.
8. User enters a food name.
9. User enters the eating-out price.
10. User taps the compare button.
11. App calls POST /api/compare.
12. Backend uses LLM or fallback to generate home-cooking cost, ingredients, recipe, and warning message.
13. App shows the comparison result.
14. User chooses either cook at home or eat out.
15. App calls POST /api/decisions.
16. Backend saves the decision to consumption_records.
17. Backend updates user stats in users.
18. App shows updated virtual balance, reward points, and character state.
19. User can open records screen to view past decisions.
20. User can open ranking screen to compare total saved amount with other users.
21. User can open flex shop screen.
22. User buys an item with reward points.
23. Backend saves the purchase in user_items.
24. App displays owned items.

## Screens

### 1. Login Screen

Purpose:
- Let the user start quickly with nickname-based login.

Components:
- App title
- Short concept description
- Nickname input
- Start button
- Error message area

Backend:
- POST /api/users/login

Success behavior:
- Store userId in app state.
- Navigate to Home Screen.

### 2. Home Screen

Purpose:
- Show user's current status and start a new spending comparison.

Components:
- User nickname
- Virtual balance summary
- Reward point summary
- Character status preview
- Food name input
- Eating-out price input
- Compare button
- Navigation buttons: Ranking, Records, Flex Shop

Backend:
- GET /api/users/{user_id}/stats
- POST /api/compare

### 3. Compare Result Screen

Purpose:
- Show eating-out price vs home-cooking cost.
- Let the user make the final decision.

Components:
- Eating-out price card
- Home-cooking cost card
- Saving amount card
- Reward point card
- Ingredient list
- Recipe steps
- Warning message
- Source badge: LLM or fallback
- Cook at home button
- Eat out button

Backend:
- POST /api/decisions

### 4. Account / Character Screen

Purpose:
- Visualize the user's virtual financial state.

Components:
- Virtual balance
- Total saved amount
- Reward points
- Character visual
- Character state message
- Owned flex item preview

Backend:
- GET /api/users/{user_id}/stats
- GET /api/users/{user_id}/items

Character state rules:
- cumulativeRewardPoint = totalSavedAmount * 10
- cumulativeRewardPoint < 300000: neutral
- cumulativeRewardPoint >= 300000: rich_getting_better
- cumulativeRewardPoint >= 600000: poor_getting_worse
- cumulativeRewardPoint >= 900000: bankrupt_warning
- Item purchases do not downgrade the character because upgrades use cumulative points.

### 5. Records Screen

Purpose:
- Show past spending decisions.

Components:
- Record list
- Menu name
- Eating-out price
- Home-cooking cost
- Saving amount
- Choice badge
- Created date

Backend:
- GET /api/users/{user_id}/records

### 6. Ranking Screen

Purpose:
- Show users ranked by total saved amount.

Components:
- Rank number
- Nickname
- Total saved amount
- Reward points
- Current user's rank highlight if possible

Backend:
- GET /api/rankings

### 7. Flex Shop Screen

Purpose:
- Let users spend reward points on in-app flex items.

Components:
- Reward point balance
- Item cards
- Item emoji
- Item name
- Item price
- Buy button
- Owned state
- Not enough points message

Backend:
- GET /api/flex-items
- POST /api/flex-items/{item_id}/purchase
- GET /api/users/{user_id}/items
