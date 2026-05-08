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