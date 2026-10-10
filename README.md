# Flex

**오늘의 외식 대신 집밥, 얼마나 아낄 수 있을까?**

먹고 싶은 메뉴를 입력하면 집밥 레시피와 예상 재료비를 제안하고, 외식 비용과 비교해 절약 선택을 기록하는 해커톤 앱입니다.

[프로젝트 소개](https://jinhyeong-studio.jinhyeong9568-663.workers.dev/projects/khuthon)

## 주요 기능

- 메뉴에 맞는 집밥 레시피와 예상 재료비
- 외식·집밥 비용 비교와 선택 기록
- 절약 금액에 따른 **가상 포인트**
- 포인트로 꾸미는 방, 상점과 랭킹

## 구현

**Flutter · FastAPI · Pydantic · Supabase**

LLM은 레시피와 비용 **추정**에 사용합니다. 절약 금액과 보상 계산은 백엔드에서 처리해 모델이 계산 규칙을 임의로 바꾸지 않도록 분리했습니다.

해커톤 데모용 fallback 응답이 포함된 MVP입니다. 실제 시세·실제 현금 절약을 보장하지 않으며, 포인트는 결제 수단이 아닙니다.

## 실행

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
# backend/.env.example을 참고해 .env 설정
uvicorn app.main:app --reload --port 8000
```

```bash
cd app
flutter pub get
# 앱 환경 변수에 API_BASE_URL 설정
flutter run
```

앱 API 주소에는 `/api` 경로를 포함합니다. Android 에뮬레이터는 `http://10.0.2.2:8000/api`, 같은 컴퓨터의 환경에서는 `http://localhost:8000/api`를 사용합니다.

## 문서

[제품](docs/PRODUCT.md) · [화면 흐름](docs/SCREEN_FLOW.md) · [API 계약](docs/API_CONTRACT.md) · [프롬프트](docs/PROMPTS.md)

환경 변수: [공통 예시](.env.example) · [백엔드 예시](backend/.env.example)
