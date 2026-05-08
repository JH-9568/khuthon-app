# AGENTS.md

## Project Context

This is a hackathon mobile app project.

The service helps users rethink overconsumption influenced by popular culture, SNS, flex culture, and image-driven spending.

Users compare eating-out costs with home-cooking costs, save money, earn virtual reward points, store spending decisions, check rankings, and safely flex inside the app with virtual items.

## Final Tech Stack

App:
- Flutter
- Dart

Backend:
- FastAPI
- Python
- Pydantic

Database:
- Supabase PostgreSQL

AI:
- LLM API for recipe, ingredient, home-cooking cost estimation, and warning message generation
- fallback mock generator for demo safety

## Core Documents

Before implementation, always read:
- DESIGN.md
- docs/PRODUCT.md
- docs/SCREEN_FLOW.md
- docs/API_CONTRACT.md
- docs/TASKS.md
- docs/PROMPTS.md

## Project Structure

```txt
khuthon-app/
├── docs/
├── app/
└── backend/
```

## Main Development Rule

API contract comes first.

Do not change request or response shapes without updating:

```txt
docs/API_CONTRACT.md
```

Frontend and backend must both follow the same API contract.

## Scope Rules

Flutter app work stays in:

```txt
/app
```

FastAPI backend work stays in:

```txt
/backend
```

Documentation work stays in:

```txt
/docs
```

Do not rewrite unrelated files.

## Demo Safety Rules

1. Prioritize a working demo over perfect architecture.
2. Keep fallback data when LLM fails.
3. Do not hardcode API keys.
4. Use `.env` for secrets.
5. Do not commit `.env`.
6. Do not remove existing MVP flow.
7. Do not add large new features during integration.
8. Do not commit or push unless the user explicitly asks.

## LLM Rules

The LLM should only generate:

- homeCookingCost
- ingredients
- recipe
- warning message

The backend must calculate:

- savingAmount
- rewardPoint
- userStats updates

Do not rely on LLM arithmetic.

## API Response Rule

All API responses must follow this shape:

```json
{
  "success": true,
  "data": {}
}
```

or:

```json
{
  "success": false,
  "message": "Error message"
}
```

## Branch Rules

Branches:

- main: final stable demo branch
- frontend: Flutter app development
- backend: FastAPI + Supabase + LLM development

Work on the correct branch only.
