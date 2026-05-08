# PROMPTS.md

## Flutter App Agent Prompt

Read all project docs first:
- AGENTS.md
- docs/PRODUCT.md
- docs/SCREEN_FLOW.md
- docs/API_CONTRACT.md
- docs/TASKS.md

Task:
Implement the Flutter MVP app based on API_CONTRACT.md.

Build:
- Login screen
- Home screen
- Compare result screen
- Decision buttons
- Virtual account card
- Character status widget
- Records screen
- Ranking screen
- Flex shop screen
- Owned items display
- API service layer

Rules:
- Work only in /app
- Use mock data if backend is not ready
- Do not modify /backend
- Match API_CONTRACT.md exactly
- Do not commit or push

## FastAPI Backend Agent Prompt

Read all project docs first:
- AGENTS.md
- docs/PRODUCT.md
- docs/SCREEN_FLOW.md
- docs/API_CONTRACT.md
- docs/TASKS.md

Task:
Implement the FastAPI backend with Supabase.

Build:
- Supabase client
- POST /api/users/login
- GET /api/users/{user_id}/stats
- POST /api/compare
- POST /api/decisions
- GET /api/users/{user_id}/records
- GET /api/rankings
- GET /api/flex-items
- POST /api/flex-items/{item_id}/purchase
- GET /api/users/{user_id}/items

Rules:
- Work only in /backend
- Do not modify /app
- Use .env
- Do not hardcode secrets
- Keep LLM fallback
- Match API_CONTRACT.md exactly
- Do not commit or push

## Integration Agent Prompt

Read all project docs first.

Task:
Connect Flutter app to FastAPI backend.

Rules:
- Use Android emulator base URL when needed: http://10.0.2.2:8000/api
- Use localhost for iOS simulator or local web test
- Add loading states
- Add error states
- Do not change API response shape
- Do not add new features during integration