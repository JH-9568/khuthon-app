# app/AGENTS.md

## Scope

This folder contains the Flutter mobile app.

Work only inside `/app` unless explicitly instructed otherwise.

## Required References

Before implementing UI or app logic, always read:

- ../DESIGN.md
- ../docs/PRODUCT.md
- ../docs/SCREEN_FLOW.md
- ../docs/API_CONTRACT.md
- ../docs/TASKS.md
- ../docs/PROMPTS.md

## Responsibilities

Implement:

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

## Design Reference

Follow the Wise-inspired fintech design direction from `../DESIGN.md`.

The UI should be:

- mobile-first
- clear
- friendly
- money-aware
- demo-friendly
- simple enough to finish during the hackathon

## App Rules

1. Follow `../docs/API_CONTRACT.md` exactly.
2. Do not modify backend files.
3. Use mock data if backend is not ready.
4. Keep all API calls isolated in `lib/services/api_service.dart`.
5. Use `API_BASE_URL` from `/app/.env`.
6. Use `shared_preferences` to store userId and nickname locally.
7. Add loading and error states.
8. Keep UI simple, demo-friendly, and mobile-first.
9. Run `flutter analyze` before finishing.
10. Do not commit or push.