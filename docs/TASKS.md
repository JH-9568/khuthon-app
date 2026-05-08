# TASKS.md

## Owner Rules

- [DOCS] Planning and documentation
- [APP] Flutter app
- [BE] FastAPI backend
- [DB] Supabase database
- [AI] LLM integration
- [INT] Integration
- [POLISH] Demo polish

## Phase 0. Planning

- [ ] [DOCS] Complete PRODUCT.md
- [ ] [DOCS] Complete SCREEN_FLOW.md
- [ ] [DOCS] Complete API_CONTRACT.md
- [ ] [DOCS] Complete TASKS.md
- [ ] [DOCS] Finalize demo scenario

## Phase 1. Database

- [ ] [DB] Create Supabase project
- [ ] [DB] Create users table
- [ ] [DB] Create consumption_records table
- [ ] [DB] Create flex_items table
- [ ] [DB] Create user_items table
- [ ] [DB] Seed flex_items
- [ ] [DB] Prepare SUPABASE_URL and SUPABASE_KEY

## Phase 2. FastAPI Backend

- [ ] [BE] Create FastAPI project
- [ ] [BE] Configure CORS
- [ ] [BE] Connect Supabase client
- [ ] [BE] Implement POST /api/users/login
- [ ] [BE] Implement GET /api/users/{user_id}/stats
- [ ] [BE] Implement POST /api/compare
- [ ] [BE] Implement POST /api/decisions
- [ ] [BE] Implement GET /api/users/{user_id}/records
- [ ] [BE] Implement GET /api/rankings
- [ ] [BE] Implement GET /api/flex-items
- [ ] [BE] Implement POST /api/flex-items/{item_id}/purchase
- [ ] [BE] Implement GET /api/users/{user_id}/items

## Phase 3. LLM

- [ ] [AI] Write recipe/cost LLM prompt
- [ ] [AI] Generate home-cooking cost
- [ ] [AI] Generate ingredients
- [ ] [AI] Generate recipe steps
- [ ] [AI] Generate warning message
- [ ] [AI] Parse LLM JSON safely
- [ ] [AI] Add fallback data when LLM fails

## Phase 4. Flutter App

- [ ] [APP] Create Flutter project
- [ ] [APP] Implement login screen
- [ ] [APP] Implement home screen
- [ ] [APP] Implement compare result screen
- [ ] [APP] Implement decision buttons
- [ ] [APP] Implement virtual account card
- [ ] [APP] Implement character status widget
- [ ] [APP] Implement records screen
- [ ] [APP] Implement ranking screen
- [ ] [APP] Implement flex shop screen
- [ ] [APP] Implement owned items display
- [ ] [APP] Implement API service layer

## Phase 5. Integration

- [ ] [INT] Connect login API
- [ ] [INT] Connect stats API
- [ ] [INT] Connect compare API
- [ ] [INT] Connect decision API
- [ ] [INT] Connect records API
- [ ] [INT] Connect ranking API
- [ ] [INT] Connect flex shop API
- [ ] [INT] Connect purchase API
- [ ] [INT] Test full demo flow

## Phase 6. Polish

- [x] [POLISH] Prepare demo user data
- [x] [POLISH] Improve UI copy
- [x] [POLISH] Improve character visuals
- [ ] [POLISH] Prepare presentation script
