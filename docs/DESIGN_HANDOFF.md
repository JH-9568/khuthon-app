# Flex 앱 Flutter 개발 인수인계 문서

## 1. 전체 화면 목록

| 화면 이름 | 화면 목적 | 주요 컴포넌트 | 다음 화면 이동 흐름 |
|---|---|---|---|
| **로그인/온보딩 화면** | 사용자에게 앱의 컨셉을 소개하고 이름 입력 및 시작 | AppLogo, SproutMascot (슬픈 표정), 이름 입력 필드, 정보 카드, 시작하기 버튼 | 메인 화면으로 이동 |
| **메인 화면** | 사용자의 현재 포인트, 절약 금액, 주간 랭킹 정보 제공 | AppLogo, SproutMascot (기쁜 표정), StatCard (현재 포인트, 절약 금액), RankingTile (주간 랭킹), AppBottomNavigation | 기록, 비교 툴, 플렉스 샵, 랭킹 화면으로 이동 |
| **캐릭터 환경 화면** | 마스코트 포리의 방을 꾸미고 아이템 관리 | SproutMascot, 아이템 목록 (악세서리, 가구), 옷장/차고 버튼, AppBottomNavigation | 플렉스 샵으로 이동 |
| **랭킹 화면** | 사용자 랭킹 및 동기 부여 메시지 제공 | RankingTile (상위 랭킹), 나의 랭킹 카드, AppBottomNavigation | (없음) |
| **기록 화면** | 절약/지출 내역 상세 기록 및 비교 정보 제공 | StatCard (오늘 절약 금액, 누적 절약 금액), CompareResultCard (상세 내역), AppBottomNavigation | (없음) |
| **비교 툴 화면** | 외식/집밥 가격 비교 입력 및 유행 메뉴 추천 | CompareInputCard (메뉴 이름, 외식 가격 입력), 유행 메뉴 목록, AppBottomNavigation | 비교 결과 화면으로 이동 |
| **비교 결과 화면** | 외식/집밥 비교 결과 및 레시피 제공 | CompareResultCard (절약 금액, 재료, 레시피), 외식할래요/집밥 선택 버튼 | 기록 화면으로 이동 (집밥 선택 시) |
| **플렉스 샵 화면** | 마스코트 아이템 구매 및 관리 | AppLogo, SproutMascot, FlexItemCard (아이템 목록), AppBottomNavigation | 캐릭터 환경 화면으로 이동 (아이템 구매 시) |

## 2. 디자인 토큰

### 2.1. 컬러 팔레트 (Hex Code)

| 용도 | 색상 (Hex) | 설명 |
|---|---|---|
| Primary Green | `#6B9E4D` | 주요 버튼, 아이콘, 로고 등 핵심 요소 |
| Light Green | `#A0D468` | 보조 버튼, 배경 요소, 강조 |
| Pastel Green | `#D9EDC8` | 배경, 카드 배경 |
| Cream | `#F8F5EB` | 주 배경, 카드 배경 |
| Dark Text | `#333333` | 기본 텍스트, 제목 |
| Light Text | `#666666` | 보조 텍스트, 설명 |
| Accent Gold | `#FFD700` | 포인트, 랭킹, 코인 아이콘 |
| Accent Red | `#FF6B6B` | 부정적인 값 (지출) |
| Accent Blue | `#6B9EFF` | 정보성 강조 |
| Background White | `#FFFFFF` | 최상위 배경 |

### 2.2. 폰트/타이포그래피

*   **기본 폰트**: 시스템 기본 폰트 (예: Apple SD Gothic Neo 또는 Noto Sans KR)
*   **굵기**: Light, Regular, Medium, SemiBold, Bold
*   **크기**: 12pt, 14pt, 16pt, 18pt, 20pt, 24pt, 32pt (세부 조정 필요)

### 2.3. 카드 Radius

*   **기본 카드**: `16.0` (모든 모서리)
*   **작은 카드/버튼**: `8.0` - `12.0` (세부 조정 필요)

### 2.4. 버튼 Radius

*   **주요 버튼**: `12.0` - `16.0` (세부 조정 필요)
*   **작은 버튼**: `8.0`

### 2.5. Shadow

*   **카드/버튼**: `color: Colors.black.withOpacity(0.1)`, `offset: Offset(0, 4)`, `blurRadius: 8.0` (세부 조정 필요)

### 2.6. Spacing

*   **기본 간격**: `8.0`, `16.0`, `24.0` (세부 조정 필요)
*   **화면 섹션 간**: `24.0` - `32.0`

### 2.7. Screen Padding

*   **수평**: `16.0` - `20.0`
*   **수직**: `16.0` - `24.0`

### 2.8. Icon Size

*   **기본 아이콘**: `24.0`
*   **작은 아이콘**: `16.0` - `20.0`
*   **대형 아이콘**: `32.0` - `48.0`

### 2.9. Bottom Navigation Style

*   **배경**: `Cream` (`#F8F5EB`)
*   **아이콘/텍스트 색상**: `Dark Text` (`#333333`)
*   **활성 상태**: `Primary Green` (`#6B9E4D`)
*   **높이**: `60.0` - `70.0`
*   **아이콘 크기**: `24.0`
*   **텍스트 크기**: `12.0` - `14.0`

## 3. 화면별 레이아웃 스펙

### 3.1. 로그인/온보딩 화면 (Login/Onboarding Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  AppLogo (상단 중앙)
    2.  SproutMascot (슬픈 표정, 흰색 Flex 티셔츠, 깨진 저금통 옆)
    3.  텍스트: "당신의 이름은 무엇인가요?"
    4.  이름 입력 필드
    5.  정보 카드 (두쫀쿠 이미지, 파산 스토리)
    6.  시작하기 버튼
*   **컴포넌트 크기**:
    *   AppLogo: `width: 100-120pt`, `height: 40-50pt`
    *   SproutMascot: `width: 150-200pt`, `height: 150-200pt` (비율 유지)
    *   입력 필드: `height: 50pt`
    *   정보 카드: `width: 300-350pt`, `height: 150-200pt`
    *   시작하기 버튼: `width: 300-350pt`, `height: 50pt`
*   **margin/padding**:
    *   상단 AppLogo: `padding-top: 80pt`
    *   SproutMascot: `margin-top: 40pt`
    *   텍스트: `margin-top: 30pt`
    *   입력 필드: `margin-top: 16pt`, `horizontal padding: 20pt`
    *   정보 카드: `margin-top: 24pt`, `horizontal padding: 20pt`
    *   시작하기 버튼: `margin-top: 32pt`, `horizontal padding: 20pt`, `padding-bottom: 40pt`
*   **alignment**: 모든 요소 중앙 정렬
*   **text style**:
    *   "당신의 이름은 무엇인가요?": `fontSize: 24pt`, `fontWeight: SemiBold`, `color: Dark Text`
    *   입력 필드 Placeholder: `fontSize: 16pt`, `color: Light Text`
    *   정보 카드 제목: `fontSize: 16pt`, `fontWeight: SemiBold`
    *   정보 카드 내용: `fontSize: 14pt`, `color: Light Text`
*   **asset name**:
    *   `app_logo.png`
    *   `pori_sad_flex_tshirt.png`
    *   `broken_piggy_bank.png`
    *   `dujjonku_product.png`
*   **button style**: `backgroundColor: Primary Green`, `textColor: Background White`, `borderRadius: 12.0`

### 3.2. 메인 화면 (Home Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (AppLogo, 연속 일수, 알림 아이콘, 포인트)
    2.  StatCard (계좌 잔고, 현재 포인트, 절약한 금액)
    3.  SproutMascot (기쁜 표정, 흰색 Flex 티셔츠)
    4.  RankingTile (주간 랭킹 상위 3개)
    5.  나의 랭킹 섹션
    6.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   StatCard: `width: 160pt`, `height: 120pt` (대략)
    *   SproutMascot: `width: 100-120pt`, `height: 100-120pt` (비율 유지)
    *   RankingTile: `width: 100pt`, `height: 150pt` (대략)
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   StatCard 그룹: `margin-top: 16pt`
    *   SproutMascot (카드 내): `margin-bottom: 8pt`
    *   주간 랭킹 섹션: `margin-top: 24pt`
    *   나의 랭킹 섹션: `margin-top: 16pt`
*   **alignment**: 헤더 요소들은 좌우 정렬, 카드 및 랭킹은 중앙 또는 그리드 정렬
*   **text style**:
    *   현재 포인트: `fontSize: 24pt`, `fontWeight: Bold`, `color: Dark Text`
    *   절약한 금액: `fontSize: 18pt`, `fontWeight: SemiBold`, `color: Primary Green`
    *   랭킹 이름: `fontSize: 14pt`, `fontWeight: Medium`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `gold_coin_illustration.png`
    *   `pori_happy_flex_tshirt.png`
    *   `crown_gold.png`, `crown_silver.png`, `crown_bronze.png`
    *   `pori_avatar.png`, `dinosaur_avatar.png`, `penguin_avatar.png`
*   **button style**: (없음)

### 3.3. 캐릭터 환경 화면 (Character Room Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (뒤로가기, Flex 로고, 연속 일수, 알림 아이콘)
    2.  SproutMascot (기쁜 표정, 방 배경, 아이템 착용)
    3.  말풍선: "기분 최고! 오늘도 절약 성공!"
    4.  아이템 섹션 (악세서리, 가구)
    5.  옷장/차고 버튼
    6.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   SproutMascot: `width: 200-250pt`, `height: 200-250pt` (비율 유지)
    *   아이템 카드: `width: 60pt`, `height: 60pt` (대략)
    *   옷장/차고 버튼: `width: 150pt`, `height: 50pt`
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   SproutMascot: `margin-top: 20pt`
    *   말풍선: `margin-top: 16pt`
    *   아이템 섹션: `margin-top: 24pt`
    *   옷장/차고 버튼: `margin-top: 24pt`
*   **alignment**: 중앙 정렬, 아이템 그리드 정렬
*   **text style**:
    *   말풍선: `fontSize: 16pt`, `color: Dark Text`
    *   섹션 제목: `fontSize: 18pt`, `fontWeight: SemiBold`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_happy_flex_tshirt.png`
    *   `room_background.png`
    *   `accessory_leaf_scarf.png`, `accessory_ribbon.png`, `accessory_hat.png` 등
    *   `furniture_sofa.png`, `furniture_lamp.png`, `furniture_plant.png` 등
*   **button style**: `backgroundColor: Primary Green`, `textColor: Background White`, `borderRadius: 12.0`

### 3.4. 랭킹 화면 (Ranking Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (뒤로가기, Flex 로고, 연속 일수, 알림 아이콘)
    2.  RankingTile (상위 3개 포디움 스타일)
    3.  랭킹 리스트 (4위~8위)
    4.  나의 랭킹 카드
    5.  동기 부여 메시지
    6.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   RankingTile (포디움): `width: 100pt`, `height: 150pt` (대략)
    *   랭킹 리스트 항목: `height: 50pt`
    *   나의 랭킹 카드: `height: 80pt`
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   포디움 랭킹: `margin-top: 20pt`
    *   랭킹 리스트: `margin-top: 24pt`
    *   나의 랭킹 카드: `margin-top: 16pt`
    *   동기 부여 메시지: `margin-top: 24pt`
*   **alignment**: 중앙 정렬, 리스트 좌측 정렬
*   **text style**:
    *   랭킹 번호: `fontSize: 18pt`, `fontWeight: Bold`
    *   사용자 이름: `fontSize: 16pt`, `fontWeight: Medium`
    *   절약 금액: `fontSize: 14pt`, `color: Primary Green`
    *   동기 부여 메시지: `fontSize: 14pt`, `color: Light Text`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `crown_gold.png`, `crown_silver.png`, `crown_bronze.png`
    *   `pori_avatar.png`, `dinosaur_avatar.png`, `penguin_avatar.png` 등
*   **button style**: (없음)

### 3.5. 기록 화면 (History Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (뒤로가기, Flex 로고, 연속 일수, 알림 아이콘)
    2.  상단 요약 카드 (오늘 절약 금액, 누적 절약 금액, 포리 일러스트)
    3.  CompareResultCard (상세 내역 리스트)
    4.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   상단 요약 카드: `height: 150pt`
    *   CompareResultCard 항목: `height: 80-100pt`
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   상단 요약 카드: `margin-top: 16pt`
    *   CompareResultCard 리스트: `margin-top: 20pt`
*   **alignment**: 좌측 정렬, 리스트 항목 내부 요소 정렬
*   **text style**:
    *   오늘 절약 금액: `fontSize: 24pt`, `fontWeight: Bold`, `color: Primary Green`
    *   누적 절약 금액: `fontSize: 16pt`, `color: Light Text`
    *   메뉴 이름: `fontSize: 16pt`, `fontWeight: Medium`
    *   날짜/시간: `fontSize: 12pt`, `color: Light Text`
    *   외식가/집밥가: `fontSize: 12pt`, `color: Light Text`
    *   절약/지출 금액: `fontSize: 18pt`, `fontWeight: Bold`, `color: Primary Green` (절약), `color: Accent Red` (지출)
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_writing_notebook.png`
    *   `food_icon_kimchijjigae.png`, `food_icon_chicken.png` 등
*   **button style**: (없음)

### 3.6. 비교 툴 화면 (Compare Tool Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (뒤로가기, Flex 로고, 연속 일수, 알림 아이콘)
    2.  텍스트: "비교 도구", "식비 절약의 시작! 메뉴와 가격을 입력하고 포리와 비교해보세요."
    3.  SproutMascot (기쁜 표정, 음식 일러스트 옆)
    4.  CompareInputCard (메뉴 이름, 외식 가격 입력 필드)
    5.  비교하기 버튼
    6.  텍스트: "요즘 유행하는 메뉴"
    7.  유행 메뉴 목록 (수평 스크롤)
    8.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   SproutMascot: `width: 100-120pt`, `height: 100-120pt` (비율 유지)
    *   입력 필드: `height: 50pt`
    *   비교하기 버튼: `width: 300-350pt`, `height: 50pt`
    *   유행 메뉴 카드: `width: 120pt`, `height: 150pt` (대략)
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   "비교 도구" 텍스트: `margin-top: 20pt`
    *   SproutMascot: `margin-top: 20pt`
    *   CompareInputCard: `margin-top: 24pt`
    *   비교하기 버튼: `margin-top: 24pt`
    *   "요즘 유행하는 메뉴" 텍스트: `margin-top: 32pt`
    *   유행 메뉴 목록: `margin-top: 16pt`
*   **alignment**: 중앙 정렬, 유행 메뉴 수평 스크롤
*   **text style**:
    *   "비교 도구": `fontSize: 24pt`, `fontWeight: Bold`, `color: Dark Text`
    *   설명 텍스트: `fontSize: 14pt`, `color: Light Text`
    *   입력 필드 Placeholder: `fontSize: 16pt`, `color: Light Text`
    *   유행 메뉴 이름: `fontSize: 14pt`, `fontWeight: Medium`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_happy_food.png`
    *   `food_illustration_steak.png`
    *   `trending_dujjonku.png`, `trending_shanghai_tteok.png` 등
*   **button style**: `backgroundColor: Primary Green`, `textColor: Background White`, `borderRadius: 12.0`

### 3.7. 비교 결과 화면 (Compare Result Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (뒤로가기, Flex 로고, 연속 일수, 알림 아이콘)
    2.  축하 메시지 (절약 금액, 포리 일러스트)
    3.  비교 결과 요약 (외식 가격, 집밥 가격, 차액)
    4.  포인트 적립 정보
    5.  레시피 재료 목록
    6.  추천 레시피 미리보기
    7.  레시피 요리 방법 (상세 단계)
    8.  포리의 팁
    9.  외식할래요/집밥 선택 버튼
*   **컴포넌트 크기**:
    *   SproutMascot: `width: 80-100pt`, `height: 80-100pt` (비율 유지)
    *   비교 결과 요약 카드: `height: 80pt`
    *   재료 목록 항목: `height: 30pt`
    *   레시피 미리보기: `width: 150pt`, `height: 100pt`
    *   버튼: `width: 150pt`, `height: 50pt`
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   축하 메시지: `margin-top: 20pt`
    *   비교 결과 요약: `margin-top: 24pt`
    *   포인트 적립: `margin-top: 16pt`
    *   레시피 재료: `margin-top: 24pt`
    *   레시피 요리 방법: `margin-top: 24pt`
    *   포리의 팁: `margin-top: 16pt`
    *   하단 버튼 그룹: `margin-top: 32pt`, `padding-bottom: 40pt`
*   **alignment**: 중앙 정렬, 리스트 좌측 정렬
*   **text style**:
    *   절약 금액: `fontSize: 32pt`, `fontWeight: Bold`, `color: Primary Green`
    *   외식/집밥 가격: `fontSize: 16pt`, `color: Light Text`
    *   차액: `fontSize: 18pt`, `fontWeight: Bold`, `color: Primary Green`
    *   재료 목록: `fontSize: 14pt`, `color: Dark Text`
    *   레시피 단계: `fontSize: 14pt`, `color: Dark Text`
    *   포리의 팁: `fontSize: 12pt`, `color: Light Text`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_happy_confetti.png`
    *   `ingredient_chicken.png`, `ingredient_broccoli.png` 등
    *   `recipe_preview_chicken_rice.png`
*   **button style**: `backgroundColor: Primary Green` (집밥 선택), `backgroundColor: Light Green` (외식할래요), `textColor: Background White`, `borderRadius: 12.0`

### 3.8. 플렉스 샵 화면 (Flex Shop Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (Flex 로고, 연속 일수, 알림 아이콘, 포인트)
    2.  텍스트: "플렉스 샵", "포리와 함께 포인트로 특별한 아이템을 만나보세요!"
    3.  SproutMascot (기쁜 표정, 아이템 선택 말풍선)
    4.  카테고리 탭 (모자, 악세서리, 자동차, 인테리어)
    5.  FlexItemCard (아이템 목록 그리드)
    6.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   SproutMascot: `width: 100-120pt`, `height: 100-120pt` (비율 유지)
    *   카테고리 탭: `height: 40pt`
    *   FlexItemCard: `width: 150pt`, `height: 200pt` (대략)
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   "플렉스 샵" 텍스트: `margin-top: 20pt`
    *   SproutMascot: `margin-top: 20pt`
    *   카테고리 탭: `margin-top: 24pt`
    *   FlexItemCard 그리드: `margin-top: 16pt`
*   **alignment**: 중앙 정렬, 아이템 그리드 정렬
*   **text style**:
    *   "플렉스 샵": `fontSize: 24pt`, `fontWeight: Bold`, `color: Dark Text`
    *   설명 텍스트: `fontSize: 14pt`, `color: Light Text`
    *   아이템 이름: `fontSize: 14pt`, `fontWeight: Medium`
    *   아이템 가격: `fontSize: 14pt`, `color: Accent Gold`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_happy_item_select.png`
    *   `poiri_shop_sign.png`
    *   `category_hat_icon.png`, `category_accessory_icon.png` 등
    *   `item_leaf_cap.png`, `item_straw_hat.png` 등
*   **button style**: `backgroundColor: Primary Green`, `textColor: Background White`, `borderRadius: 8.0`

### 3.5. 기록 화면 (History Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (뒤로가기, Flex 로고, 연속 일수, 알림 아이콘)
    2.  상단 요약 카드 (오늘 절약 금액, 누적 절약 금액, 포리 일러스트)
    3.  CompareResultCard (상세 내역 리스트)
    4.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   상단 요약 카드: `height: 150pt`
    *   CompareResultCard 항목: `height: 80-100pt`
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   상단 요약 카드: `margin-top: 16pt`
    *   CompareResultCard 리스트: `margin-top: 20pt`
*   **alignment**: 좌측 정렬, 리스트 항목 내부 요소 정렬
*   **text style**:
    *   오늘 절약 금액: `fontSize: 24pt`, `fontWeight: Bold`, `color: Primary Green`
    *   누적 절약 금액: `fontSize: 16pt`, `color: Light Text`
    *   메뉴 이름: `fontSize: 16pt`, `fontWeight: Medium`
    *   날짜/시간: `fontSize: 12pt`, `color: Light Text`
    *   외식가/집밥가: `fontSize: 12pt`, `color: Light Text`
    *   절약/지출 금액: `fontSize: 18pt`, `fontWeight: Bold`, `color: Primary Green` (절약), `color: Accent Red` (지출)
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_writing_notebook.png`
    *   `food_icon_kimchijjigae.png`, `food_icon_chicken.png` 등
*   **button style**: (없음)

### 3.6. 비교 툴 화면 (Compare Tool Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (뒤로가기, Flex 로고, 연속 일수, 알림 아이콘)
    2.  텍스트: "비교 도구", "식비 절약의 시작! 메뉴와 가격을 입력하고 포리와 비교해보세요."
    3.  SproutMascot (기쁜 표정, 음식 일러스트 옆)
    4.  CompareInputCard (메뉴 이름, 외식 가격 입력 필드)
    5.  비교하기 버튼
    6.  텍스트: "요즘 유행하는 메뉴"
    7.  유행 메뉴 목록 (수평 스크롤)
    8.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   SproutMascot: `width: 100-120pt`, `height: 100-120pt` (비율 유지)
    *   입력 필드: `height: 50pt`
    *   비교하기 버튼: `width: 300-350pt`, `height: 50pt`
    *   유행 메뉴 카드: `width: 120pt`, `height: 150pt` (대략)
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   "비교 도구" 텍스트: `margin-top: 20pt`
    *   SproutMascot: `margin-top: 20pt`
    *   CompareInputCard: `margin-top: 24pt`
    *   비교하기 버튼: `margin-top: 24pt`
    *   "요즘 유행하는 메뉴" 텍스트: `margin-top: 32pt`
    *   유행 메뉴 목록: `margin-top: 16pt`
*   **alignment**: 중앙 정렬, 유행 메뉴 수평 스크롤
*   **text style**:
    *   "비교 도구": `fontSize: 24pt`, `fontWeight: Bold`, `color: Dark Text`
    *   설명 텍스트: `fontSize: 14pt`, `color: Light Text`
    *   입력 필드 Placeholder: `fontSize: 16pt`, `color: Light Text`
    *   유행 메뉴 이름: `fontSize: 14pt`, `fontWeight: Medium`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_happy_food.png`
    *   `food_illustration_steak.png`
    *   `trending_dujjonku.png`, `trending_shanghai_tteok.png` 등
*   **button style**: `backgroundColor: Primary Green`, `textColor: Background White`, `borderRadius: 12.0`

### 3.7. 비교 결과 화면 (Compare Result Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (뒤로가기, Flex 로고, 연속 일수, 알림 아이콘)
    2.  축하 메시지 (절약 금액, 포리 일러스트)
    3.  비교 결과 요약 (외식 가격, 집밥 가격, 차액)
    4.  포인트 적립 정보
    5.  레시피 재료 목록
    6.  추천 레시피 미리보기
    7.  레시피 요리 방법 (상세 단계)
    8.  포리의 팁
    9.  외식할래요/집밥 선택 버튼
*   **컴포넌트 크기**:
    *   SproutMascot: `width: 80-100pt`, `height: 80-100pt` (비율 유지)
    *   비교 결과 요약 카드: `height: 80pt`
    *   재료 목록 항목: `height: 30pt`
    *   레시피 미리보기: `width: 150pt`, `height: 100pt`
    *   버튼: `width: 150pt`, `height: 50pt`
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   축하 메시지: `margin-top: 20pt`
    *   비교 결과 요약: `margin-top: 24pt`
    *   포인트 적립: `margin-top: 16pt`
    *   레시피 재료: `margin-top: 24pt`
    *   레시피 요리 방법: `margin-top: 24pt`
    *   포리의 팁: `margin-top: 16pt`
    *   하단 버튼 그룹: `margin-top: 32pt`, `padding-bottom: 40pt`
*   **alignment**: 중앙 정렬, 리스트 좌측 정렬
*   **text style**:
    *   절약 금액: `fontSize: 32pt`, `fontWeight: Bold`, `color: Primary Green`
    *   외식/집밥 가격: `fontSize: 16pt`, `color: Light Text`
    *   차액: `fontSize: 18pt`, `fontWeight: Bold`, `color: Primary Green`
    *   재료 목록: `fontSize: 14pt`, `color: Dark Text`
    *   레시피 단계: `fontSize: 14pt`, `color: Dark Text`
    *   포리의 팁: `fontSize: 12pt`, `color: Light Text`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_happy_confetti.png`
    *   `ingredient_chicken.png`, `ingredient_broccoli.png` 등
    *   `recipe_preview_chicken_rice.png`
*   **button style**: `backgroundColor: Primary Green` (집밥 선택), `backgroundColor: Light Green` (외식할래요), `textColor: Background White`, `borderRadius: 12.0`

### 3.8. 플렉스 샵 화면 (Flex Shop Screen)

*   **기준 캔버스 사이즈**: 393 x 852 pt
*   **컴포넌트 순서**:
    1.  상단 헤더 (Flex 로고, 연속 일수, 알림 아이콘, 포인트)
    2.  텍스트: "플렉스 샵", "포리와 함께 포인트로 특별한 아이템을 만나보세요!"
    3.  SproutMascot (기쁜 표정, 아이템 선택 말풍선)
    4.  카테고리 탭 (모자, 악세서리, 자동차, 인테리어)
    5.  FlexItemCard (아이템 목록 그리드)
    6.  AppBottomNavigation
*   **컴포넌트 크기**:
    *   SproutMascot: `width: 100-120pt`, `height: 100-120pt` (비율 유지)
    *   카테고리 탭: `height: 40pt`
    *   FlexItemCard: `width: 150pt`, `height: 200pt` (대략)
*   **margin/padding**:
    *   전체 화면: `horizontal padding: 16pt`
    *   상단 헤더: `padding-top: 16pt`, `padding-bottom: 16pt`
    *   "플렉스 샵" 텍스트: `margin-top: 20pt`
    *   SproutMascot: `margin-top: 20pt`
    *   카테고리 탭: `margin-top: 24pt`
    *   FlexItemCard 그리드: `margin-top: 16pt`
*   **alignment**: 중앙 정렬, 아이템 그리드 정렬
*   **text style**:
    *   "플렉스 샵": `fontSize: 24pt`, `fontWeight: Bold`, `color: Dark Text`
    *   설명 텍스트: `fontSize: 14pt`, `color: Light Text`
    *   아이템 이름: `fontSize: 14pt`, `fontWeight: Medium`
    *   아이템 가격: `fontSize: 14pt`, `color: Accent Gold`
*   **asset name**:
    *   `app_logo.png`
    *   `fire_streak_icon.png`
    *   `notification_bell_icon.png`
    *   `pori_happy_item_select.png`
    *   `poiri_shop_sign.png`
    *   `category_hat_icon.png`, `category_accessory_icon.png` 등
    *   `item_leaf_cap.png`, `item_straw_hat.png` 등
*   **button style**: `backgroundColor: Primary Green`, `textColor: Background White`, `borderRadius: 8.0`

## 4. 재사용 컴포넌트 스펙

### 4.1. AppLogo

*   **Props**:
    *   `color`: `Color` (선택 사항, 기본값: Primary Green)
    *   `fontSize`: `double` (선택 사항, 기본값: 24.0)
*   **Layout**:
    *   "Flex" 텍스트와 작은 잎 아이콘 조합
    *   잎 아이콘은 "x" 글자 위에 위치
*   **States**: (없음)

### 4.2. SproutMascot

*   **Props**:
    *   `expression`: `MascotExpression` (enum: `sad`, `happy`, `writing`, `food`, `item_select`, `confetti`)
    *   `outfit`: `MascotOutfit` (enum: `flex_tshirt`, `hoodie`, `none`)
    *   `size`: `double` (선택 사항, 기본값: 100.0)
*   **Layout**:
    *   크림색 몸체, 초록색 잎 귀, 초록색 잎 스카프
    *   표정에 따라 눈, 입 모양 변화
    *   의상에 따라 이미지 변경
*   **States**:
    *   `expression`과 `outfit`에 따라 이미지 에셋 변경

### 4.3. StatCard

*   **Props**:
    *   `title`: `String`
    *   `value`: `String`
    *   `description`: `String` (선택 사항)
    *   `icon`: `IconData` 또는 `String` (에셋 경로)
    *   `isPrimary`: `bool` (선택 사항, 기본값: false, 배경색/텍스트 색상 변경)
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   내부 패딩 `16.0`
    *   제목, 값, 설명, 아이콘 순서로 배치
*   **States**: (없음)

### 4.4. MissionCard

*   **Props**:
    *   `title`: `String`
    *   `progress`: `double` (0.0 ~ 1.0)
    *   `reward`: `String`
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   내부 패딩 `16.0`
    *   제목, 진행률 바, 보상 정보 배치
*   **States**: (없음)

### 4.5. CompareInputCard

*   **Props**:
    *   `menuNameController`: `TextEditingController`
    *   `priceController`: `TextEditingController`
    *   `onComparePressed`: `VoidCallback`
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   메뉴 이름 입력 필드, 외식 가격 입력 필드
    *   "비교하기" 버튼
*   **States**:
    *   입력 필드 값 변경
    *   버튼 활성화/비활성화 (입력 값 유효성 검사)

### 4.6. CompareResultCard

*   **Props**:
    *   `foodName`: `String`
    *   `date`: `String`
    *   `time`: `String`
    *   `eatOutPrice`: `String`
    *   `homeCookPrice`: `String`
    *   `savedAmount`: `String`
    *   `isSaved`: `bool`
    *   `tag`: `String` (예: "집밥", "외식")
    *   `iconAsset`: `String` (음식 아이콘 에셋 경로)
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   좌측: 음식 아이콘, 메뉴 이름, 날짜/시간
    *   중앙: 외식가, 집밥가 비교 (`외식가 10,000원 > 집밥가 3,000원` 형식)
    *   우측: 절약/지출 금액 (초록/빨강 색상)
*   **States**: (없음)

### 4.7. RankingTile

*   **Props**:
    *   `rank`: `int`
    *   `userName`: `String`
    *   `amount`: `String`
    *   `avatarAsset`: `String` (아바타 이미지 에셋 경로)
    *   `isMyRank`: `bool` (선택 사항, 기본값: false, 나의 랭킹 카드 스타일 변경)
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   랭킹 번호, 아바타, 사용자 이름, 금액
    *   상위 3위는 포디움 스타일, 그 외는 리스트 스타일
*   **States**: (없음)

### 4.8. FlexItemCard

*   **Props**:
    *   `itemName`: `String`
    *   `itemPrice`: `String`
    *   `itemAsset`: `String` (아이템 이미지 에셋 경로)
    *   `rarity`: `ItemRarity` (enum: `legendary`, `epic`, `rare`, `uncommon`, `common`, `secret`)
    *   `isOwned`: `bool`
    *   `onPurchasePressed`: `VoidCallback`
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 8.0`)
    *   상단에 희귀도 배지
    *   아이템 이미지, 이름, 가격, 구매 버튼
*   **States**:
    *   `isOwned`에 따라 구매 버튼 텍스트/활성화 변경
    *   `rarity`에 따라 배지 색상 변경

### 4.9. AppBottomNavigation

*   **Props**:
    *   `currentIndex`: `int`
    *   `onTap`: `Function(int)`
*   **Layout**:
    *   고정된 하단 내비게이션 바
    *   아이콘과 텍스트 조합
    *   `홈`, `기록`, `비교 툴`, `플렉스 샵`, `랭킹` 5개 항목
*   **States**:
    *   `currentIndex`에 따라 활성 아이템 스타일 변경

## 5. 에셋 Export 목록

모든 이미지는 `assets/images/` 경로에 저장되며, `lowercase_snake_case` 파일명을 사용합니다. PNG 형식, 투명 배경을 기본으로 합니다.

### 5.1. 로고 및 아이콘

*   `app_logo.png`
*   `fire_streak_icon.png`
*   `notification_bell_icon.png`
*   `gold_coin_illustration.png`
*   `crown_gold.png`
*   `crown_silver.png`
*   `crown_bronze.png`
*   `category_hat_icon.png`
*   `category_accessory_icon.png`
*   `category_car_icon.png`
*   `category_interior_icon.png`
*   `icon_home.png`
*   `icon_history.png`
*   `icon_compare_tool.png`
*   `icon_flex_shop.png`
*   `icon_ranking.png`
*   `icon_back.png`
*   `icon_edit.png`
*   `icon_info.png`
*   `icon_check.png`
*   `icon_lock.png`

### 5.2. 마스코트 포리

*   `pori_sad_flex_tshirt.png` (로그인 화면)
*   `pori_happy_flex_tshirt.png` (메인, 비교 툴, 플렉스 샵)
*   `pori_happy_room.png` (캐릭터 환경 화면)
*   `pori_writing_notebook.png` (기록 화면)
*   `pori_happy_confetti.png` (비교 결과 화면)
*   `pori_happy_item_select.png` (플렉스 샵 상단)

### 5.3. 음식 및 재료

*   `dujjonku_product.png` (로그인 화면)
*   `food_illustration_steak.png` (비교 툴 화면)
*   `trending_dujjonku.png`
*   `trending_shanghai_tteok.png`
*   `trending_rose_pasta.png`
*   `trending_cream_castella.png`
*   `food_icon_kimchijjigae.png`
*   `food_icon_chicken.png`
*   `food_icon_pasta.png`
*   `food_icon_tteokbokki.png`
*   `food_icon_sandwich.png`
*   `food_icon_doenjangjjigae.png`
*   `food_icon_coffee.png`
*   `ingredient_chicken.png`
*   `ingredient_broccoli.png`
*   `ingredient_carrot.png`
*   `ingredient_garlic.png`
*   `ingredient_brown_rice.png`
*   `recipe_preview_chicken_rice.png`

### 5.4. 아바타 및 기타

*   `dinosaur_avatar.png`
*   `penguin_avatar.png`
*   `rabbit_avatar.png`
*   `squirrel_avatar.png`
*   `fox_avatar.png`
*   `hedgehog_avatar.png`
*   `turtle_avatar.png`
*   `room_background.png`
*   `accessory_leaf_scarf.png`
*   `accessory_ribbon.png`
*   `accessory_hat.png`
*   `item_leaf_cap.png`
*   `item_straw_hat.png`
*   `item_beanie.png`
*   `item_leaf_headband.png`
*   `item_flex_cap.png`
*   `item_secret.png`

## 6. 실제 화면 카피

### 6.1. 로그인/온보딩 화면

*   **제목**: 당신의 이름은 무엇인가요?
*   **입력 필드 Placeholder**: 이름을 입력해주세요
*   **정보 카드 내용**: 당신의 가상 캐릭터는 두쫀쿠를 하루에 10개씩 사먹어서 파산했습니다. 잔고 0원... FLEX를 통해 다시 시작해볼까요?
*   **버튼**: 시작하기

### 6.2. 메인 화면

*   **상단**: 12일 연속, 450,000
*   **좌측 카드**: 계좌 잔고, 현재 포인트, 1,250,000원, 절약한 금액, 450,000원
*   **우측 카드**: 포리, 기분 최고!, 오늘도 멋진 하루야 포리!
*   **주간 랭킹**: 주간 랭킹, 전체 랭킹 보기
*   **랭킹 항목**: 절약왕두두 250,000원, 포리짱 320,000원, 아끼는펭귄 180,000원
*   **나의 랭킹**: 나의 랭킹, 현재 나의 순위와 절약 금액을 확인해보세요!, 5위, 120,000원
*   **하단 메시지**: 작은 절약이 모여 큰 변화를 만들어요! 오늘도 멋진 절약 습관, 최고예요!

### 6.3. 캐릭터 환경 화면

*   **말풍선**: 기분 최고! 오늘도 절약 성공!
*   **섹션 제목**: 악세서리, 가구
*   **버튼**: 옷장, 차고

### 6.4. 랭킹 화면

*   **상단**: 주간 랭킹
*   **랭킹 항목**: (메인 화면과 동일한 형식으로 4위~8위)
*   **나의 랭킹**: 나의 랭킹, 현재 나의 순위와 절약 금액을 확인해보세요!, 5위, 120,000원
*   **하단 메시지**: 작은 절약이 모여 큰 변화를 만들어요! 오늘도 멋진 절약 습관, 최고예요!

### 6.5. 기록 화면

*   **상단 요약**: 오늘 절약 금액, 12,500원, 누적 절약 금액, 450,000원
*   **리스트 항목**: (예시) 김치찌개, 집밥, 2024.05.10 12:30, 외식가 10,000원 > 집밥가 3,000원, +7,000원

### 6.6. 비교 툴 화면

*   **제목**: 비교 도구
*   **설명**: 식비 절약의 시작! 메뉴와 가격을 입력하고 포리와 비교해보세요.
*   **입력 필드 Placeholder**: 메뉴 이름 (예시) 불고기 덮밥, 아메리카노, 외식 가격 (예시) 9,000원
*   **버튼**: 비교하기
*   **섹션 제목**: 요즘 유행하는 메뉴
*   **유행 메뉴**: 두쫀쿠, 상하이버터떡, 로제 마라 파스타, 생크림 카스테라

### 6.7. 비교 결과 화면

*   **상단**: 오늘도 스마트한 선택! 포리와 함께 450,000원 절약했어요!
*   **비교 요약**: 외식 가격, 650,000원, 집밥 가격, 200,000원, 차액 (절약 금액), 450,000원
*   **포인트 적립**: 포인트 적립!, 집밥 선택 시 450P 적립
*   **재료 목록 제목**: 이번 레시피에 필요한 재료
*   **재료 목록**: 닭가슴살 150g, 브로콜리 50g, 당근 1/4개 (약 30g), 마늘 1쪽 (5g), 현미밥 120g (1인분 기준)
*   **레시피 제목**: 레시피 요리 방법
*   **레시피 단계**: (예시) 1. 닭가슴살을 한입 크기로 썹니다. 2. 끓는 물에 브로콜리와 당근을 넣고 30초간 데친 후 건져 물기를 빼줍니다. 3. 팬에 올리브유를 두르고 다진 마늘을 볶아 향을 냅니다. 4. 닭가슴살을 넣고 겉면이 노릇해질 때까지 구워줍니다. 5. 데친 채소와 간장 1큰술을 넣고 1분간 볶아줍니다. 6. 그릇에 현미밥을 담고, 닭가슴살과 채소를 올려 완성합니다.
*   **포리의 팁**: 포리의 팁, 기호에 따라 참깨나 쪽파를 뿌리면 더 맛있어요!
*   **버튼**: 외식할래요, 집밥 선택하고 포인트 받기

### 6.8. 플렉스 샵 화면

*   **상단**: 플렉스 샵, 포리와 함께 포인트로 특별한 아이템을 만나보세요!
*   **말풍선**: 마음에 드는 아이템을 골라보리!
*   **카테고리**: 모자, 악세서리, 자동차, 인테리어
*   **아이템 목록**: 포리의 잎사귀 캡 (300,000), 초록 리본 밀짚모자 (180,000), 새싹 비니 (90,000), 나뭇잎 머리띠 (45,000), 플렉스 기본 캡 (20,000), 비밀 아이템 (특별한 조건을 달성하면 잠금 해제할 수 있어요! 미리보기)

## 7. 상태/인터랙션 규칙

### 7.1. 캐릭터 상태 변경 조건

*   **로그인/온보딩 화면**: 슬픈 표정의 포리 (파산 상태)
*   **메인 화면**: 기쁜 표정의 포리 (기본 상태)
*   **캐릭터 환경 화면**: 기쁜 표정의 포리 (아이템 착용 가능)
*   **비교 툴 화면**: 기쁜 표정의 포리 (음식 일러스트 옆)
*   **비교 결과 화면**: 기쁜 표정의 포리 (축하 효과)
*   **플렉스 샵 화면**: 기쁜 표정의 포리 (아이템 선택 말풍선)

### 7.2. 버튼 클릭 시 동작

*   **로그인 화면 '시작하기'**: 사용자 이름 입력 후 메인 화면으로 이동
*   **비교 툴 화면 '비교하기'**: 입력된 메뉴와 가격으로 비교 결과 화면 생성 및 이동
*   **비교 결과 화면 '외식할래요'**: 현재 화면 유지 또는 메인 화면으로 이동 (사용자 선택에 따라)
*   **비교 결과 화면 '집밥 선택하고 포인트 받기'**: 절약 금액에 해당하는 포인트 적립 후 기록 화면으로 이동
*   **플렉스 샵 '구매하기'**: 포인트 차감 후 아이템 구매 및 캐릭터 환경 화면에 반영
*   **플렉스 샵 '미리보기' (비밀 아이템)**: 잠금 해제 조건 팝업 또는 상세 정보 화면으로 이동
*   **하단 내비게이션 바**: 해당 화면으로 이동

### 7.3. Bottom Navigation 이동 규칙

*   각 탭 클릭 시 해당 화면으로 이동하며, 스택에 새로운 화면을 푸시하거나 기존 화면으로 팝하여 이동 (Flutter Navigator 2.0 또는 GoRouter 활용)
*   현재 활성화된 탭은 시각적으로 강조

### 7.4. 구매 가능/불가능/보유중 상태 규칙 (FlexItemCard)

*   **구매 가능**: 사용자의 현재 포인트가 아이템 가격보다 많을 경우, '구매하기' 버튼 활성화
*   **구매 불가능**: 사용자의 현재 포인트가 아이템 가격보다 적을 경우, '구매하기' 버튼 비활성화 (텍스트 변경 가능: '포인트 부족')
*   **보유중**: 이미 구매한 아이템일 경우, '구매하기' 버튼 대신 '보유중' 또는 '착용중' 텍스트 표시 및 버튼 비활성화
*   **비밀 아이템**: 잠금 해제 조건 충족 전까지 '미리보기' 버튼만 활성화, 구매 불가

## 8. Codex용 최종 구현 프롬프트

```
As an expert Flutter developer, refactor an existing Flutter application to match the provided UI/UX design specifications. The application currently uses Flutter for the frontend and FastAPI for the backend, and the API structure must remain unchanged. Your task is to implement the new UI based on the detailed design tokens, screen layouts, reusable components, asset lists, and interaction rules provided below. Focus on creating a clean, modular, and maintainable codebase.

--- Flutter UI/UX Implementation Details ---

[Insert the entire content of sections 1, 2, 3, 4, 5, 6, and 7 from the handover document here]

--- Implementation Guidelines ---

1.  **Project Structure**: Organize the codebase into `lib/screens`, `lib/widgets`, `lib/models`, `lib/services`, `lib/utils`, `lib/assets` directories. Create separate files for each screen and reusable widget.
2.  **Design System**: Implement the design tokens (colors, typography, radii, shadows, spacing) as constants or a custom `ThemeData` in Flutter to ensure consistency across the application. Use `const` where possible.
3.  **Responsive Design**: Utilize `MediaQuery` or `LayoutBuilder` to ensure the UI adapts correctly to different screen sizes, especially given the target 393x852 pt resolution as a base. Focus on maintaining proportions and relative spacing.
4.  **Reusable Widgets**: Create dedicated Flutter widgets for each reusable component (AppLogo, SproutMascot, StatCard, MissionCard, CompareInputCard, CompareResultCard, RankingTile, FlexItemCard, AppBottomNavigation) as specified in Section 4. Ensure they are highly configurable via props.
5.  **Asset Management**: Integrate all listed image assets into the `pubspec.yaml` file and use them correctly within the widgets. Ensure transparent backgrounds are handled properly.
6.  **State Management**: Use a suitable state management solution (e.g., Provider, Riverpod, BLoC) for managing UI state and interactions. Integrate with the existing FastAPI backend through the `lib/services` layer.
7.  **Navigation**: Implement the navigation flow using Flutter's Navigator or a routing package like GoRouter, adhering to the specified screen transitions and bottom navigation rules.
8.  **Interaction Logic**: Implement the button click actions and character state changes as described in Section 7. Ensure purchase logic in Flex Shop correctly reflects user points and item ownership.
9.  **Code Quality**: Write clean, well-commented, and testable code. Adhere to Flutter's best practices and Dart's effective style guide.
10. **Accessibility**: Consider basic accessibility principles (e.g., semantic widgets, sufficient contrast).

Start by outlining the main `main.dart` file and the structure for the `lib/screens` and `lib/widgets` directories, then proceed with implementing the `LoginScreen` and its required components.
```

## 4. 재사용 컴포넌트 스펙

### 4.1. AppLogo

*   **Props**:
    *   `color`: `Color` (선택 사항, 기본값: Primary Green)
    *   `fontSize`: `double` (선택 사항, 기본값: 24.0)
*   **Layout**:
    *   "Flex" 텍스트와 작은 잎 아이콘 조합
    *   잎 아이콘은 "x" 글자 위에 위치
*   **States**: (없음)

### 4.2. SproutMascot

*   **Props**:
    *   `expression`: `MascotExpression` (enum: `sad`, `happy`, `writing`, `food`, `item_select`, `confetti`)
    *   `outfit`: `MascotOutfit` (enum: `flex_tshirt`, `hoodie`, `none`)
    *   `size`: `double` (선택 사항, 기본값: 100.0)
*   **Layout**:
    *   크림색 몸체, 초록색 잎 귀, 초록색 잎 스카프
    *   표정에 따라 눈, 입 모양 변화
    *   의상에 따라 이미지 변경
*   **States**:
    *   `expression`과 `outfit`에 따라 이미지 에셋 변경

### 4.3. StatCard

*   **Props**:
    *   `title`: `String`
    *   `value`: `String`
    *   `description`: `String` (선택 사항)
    *   `icon`: `IconData` 또는 `String` (에셋 경로)
    *   `isPrimary`: `bool` (선택 사항, 기본값: false, 배경색/텍스트 색상 변경)
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   내부 패딩 `16.0`
    *   제목, 값, 설명, 아이콘 순서로 배치
*   **States**: (없음)

### 4.4. MissionCard

*   **Props**:
    *   `title`: `String`
    *   `progress`: `double` (0.0 ~ 1.0)
    *   `reward`: `String`
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   내부 패딩 `16.0`
    *   제목, 진행률 바, 보상 정보 배치
*   **States**: (없음)

### 4.5. CompareInputCard

*   **Props**:
    *   `menuNameController`: `TextEditingController`
    *   `priceController`: `TextEditingController`
    *   `onComparePressed`: `VoidCallback`
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   메뉴 이름 입력 필드, 외식 가격 입력 필드
    *   "비교하기" 버튼
*   **States**:
    *   입력 필드 값 변경
    *   버튼 활성화/비활성화 (입력 값 유효성 검사)

### 4.6. CompareResultCard

*   **Props**:
    *   `foodName`: `String`
    *   `date`: `String`
    *   `time`: `String`
    *   `eatOutPrice`: `String`
    *   `homeCookPrice`: `String`
    *   `savedAmount`: `String`
    *   `isSaved`: `bool`
    *   `tag`: `String` (예: "집밥", "외식")
    *   `iconAsset`: `String` (음식 아이콘 에셋 경로)
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   좌측: 음식 아이콘, 메뉴 이름, 날짜/시간
    *   중앙: 외식가, 집밥가 비교 (`외식가 10,000원 > 집밥가 3,000원` 형식)
    *   우측: 절약/지출 금액 (초록/빨강 색상)
*   **States**: (없음)

### 4.7. RankingTile

*   **Props**:
    *   `rank`: `int`
    *   `userName`: `String`
    *   `amount`: `String`
    *   `avatarAsset`: `String` (아바타 이미지 에셋 경로)
    *   `isMyRank`: `bool` (선택 사항, 기본값: false, 나의 랭킹 카드 스타일 변경)
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 16.0`)
    *   랭킹 번호, 아바타, 사용자 이름, 금액
    *   상위 3위는 포디움 스타일, 그 외는 리스트 스타일
*   **States**: (없음)

### 4.8. FlexItemCard

*   **Props**:
    *   `itemName`: `String`
    *   `itemPrice`: `String`
    *   `itemAsset`: `String` (아이템 이미지 에셋 경로)
    *   `rarity`: `ItemRarity` (enum: `legendary`, `epic`, `rare`, `uncommon`, `common`, `secret`)
    *   `isOwned`: `bool`
    *   `onPurchasePressed`: `VoidCallback`
*   **Layout**:
    *   둥근 모서리 카드 (`borderRadius: 8.0`)
    *   상단에 희귀도 배지
    *   아이템 이미지, 이름, 가격, 구매 버튼
*   **States**:
    *   `isOwned`에 따라 구매 버튼 텍스트/활성화 변경
    *   `rarity`에 따라 배지 색상 변경

### 4.9. AppBottomNavigation

*   **Props**:
    *   `currentIndex`: `int`
    *   `onTap`: `Function(int)`
*   **Layout**:
    *   고정된 하단 내비게이션 바
    *   아이콘과 텍스트 조합
    *   `홈`, `기록`, `비교 툴`, `플렉스 샵`, `랭킹` 5개 항목
*   **States**:
    *   `currentIndex`에 따라 활성 아이템 스타일 변경

## 5. 에셋 Export 목록

모든 이미지는 `assets/images/` 경로에 저장되며, `lowercase_snake_case` 파일명을 사용합니다. PNG 형식, 투명 배경을 기본으로 합니다.

### 5.1. 로고 및 아이콘

*   `app_logo.png`
*   `fire_streak_icon.png`
*   `notification_bell_icon.png`
*   `gold_coin_illustration.png`
*   `crown_gold.png`
*   `crown_silver.png`
*   `crown_bronze.png`
*   `category_hat_icon.png`
*   `category_accessory_icon.png`
*   `category_car_icon.png`
*   `category_interior_icon.png`
*   `icon_home.png`
*   `icon_history.png`
*   `icon_compare_tool.png`
*   `icon_flex_shop.png`
*   `icon_ranking.png`
*   `icon_back.png`
*   `icon_edit.png`
*   `icon_info.png`
*   `icon_check.png`
*   `icon_lock.png`

### 5.2. 마스코트 포리

*   `pori_sad_flex_tshirt.png` (로그인 화면)
*   `pori_happy_flex_tshirt.png` (메인, 비교 툴, 플렉스 샵)
*   `pori_happy_room.png` (캐릭터 환경 화면)
*   `pori_writing_notebook.png` (기록 화면)
*   `pori_happy_confetti.png` (비교 결과 화면)
*   `pori_happy_item_select.png` (플렉스 샵 상단)

### 5.3. 음식 및 재료

*   `dujjonku_product.png` (로그인 화면)
*   `food_illustration_steak.png` (비교 툴 화면)
*   `trending_dujjonku.png`
*   `trending_shanghai_tteok.png`
*   `trending_rose_pasta.png`
*   `trending_cream_castella.png`
*   `food_icon_kimchijjigae.png`
*   `food_icon_chicken.png`
*   `food_icon_pasta.png`
*   `food_icon_tteokbokki.png`
*   `food_icon_sandwich.png`
*   `food_icon_doenjangjjigae.png`
*   `food_icon_coffee.png`
*   `ingredient_chicken.png`
*   `ingredient_broccoli.png`
*   `ingredient_carrot.png`
*   `ingredient_garlic.png`
*   `ingredient_brown_rice.png`
*   `recipe_preview_chicken_rice.png`

### 5.4. 아바타 및 기타

*   `dinosaur_avatar.png`
*   `penguin_avatar.png`
*   `rabbit_avatar.png`
*   `squirrel_avatar.png`
*   `fox_avatar.png`
*   `hedgehog_avatar.png`
*   `turtle_avatar.png`
*   `room_background.png`
*   `accessory_leaf_scarf.png`
*   `accessory_ribbon.png`
*   `accessory_hat.png`
*   `item_leaf_cap.png`
*   `item_straw_hat.png`
*   `item_beanie.png`
*   `item_leaf_headband.png`
*   `item_flex_cap.png`
*   `item_secret.png`

## 6. 실제 화면 카피

### 6.1. 로그인/온보딩 화면

*   **제목**: 당신의 이름은 무엇인가요?
*   **입력 필드 Placeholder**: 이름을 입력해주세요
*   **정보 카드 내용**: 당신의 가상 캐릭터는 두쫀쿠를 하루에 10개씩 사먹어서 파산했습니다. 잔고 0원... FLEX를 통해 다시 시작해볼까요?
*   **버튼**: 시작하기

### 6.2. 메인 화면

*   **상단**: 12일 연속, 450,000
*   **좌측 카드**: 계좌 잔고, 현재 포인트, 1,250,000원, 절약한 금액, 450,000원
*   **우측 카드**: 포리, 기분 최고!, 오늘도 멋진 하루야 포리!
*   **주간 랭킹**: 주간 랭킹, 전체 랭킹 보기
*   **랭킹 항목**: 절약왕두두 250,000원, 포리짱 320,000원, 아끼는펭귄 180,000원
*   **나의 랭킹**: 나의 랭킹, 현재 나의 순위와 절약 금액을 확인해보세요!, 5위, 120,000원
*   **하단 메시지**: 작은 절약이 모여 큰 변화를 만들어요! 오늘도 멋진 절약 습관, 최고예요!

### 6.3. 캐릭터 환경 화면

*   **말풍선**: 기분 최고! 오늘도 절약 성공!
*   **섹션 제목**: 악세서리, 가구
*   **버튼**: 옷장, 차고

### 6.4. 랭킹 화면

*   **상단**: 주간 랭킹
*   **랭킹 항목**: (메인 화면과 동일한 형식으로 4위~8위)
*   **나의 랭킹**: 나의 랭킹, 현재 나의 순위와 절약 금액을 확인해보세요!, 5위, 120,000원
*   **하단 메시지**: 작은 절약이 모여 큰 변화를 만들어요! 오늘도 멋진 절약 습관, 최고예요!

### 6.5. 기록 화면

*   **상단 요약**: 오늘 절약 금액, 12,500원, 누적 절약 금액, 450,000원
*   **리스트 항목**: (예시) 김치찌개, 집밥, 2024.05.10 12:30, 외식가 10,000원 > 집밥가 3,000원, +7,000원

### 6.6. 비교 툴 화면

*   **제목**: 비교 도구
*   **설명**: 식비 절약의 시작! 메뉴와 가격을 입력하고 포리와 비교해보세요.
*   **입력 필드 Placeholder**: 메뉴 이름 (예시) 불고기 덮밥, 아메리카노, 외식 가격 (예시) 9,000원
*   **버튼**: 비교하기
*   **섹션 제목**: 요즘 유행하는 메뉴
*   **유행 메뉴**: 두쫀쿠, 상하이버터떡, 로제 마라 파스타, 생크림 카스테라

### 6.7. 비교 결과 화면

*   **상단**: 오늘도 스마트한 선택! 포리와 함께 450,000원 절약했어요!
*   **비교 요약**: 외식 가격, 650,000원, 집밥 가격, 200,000원, 차액 (절약 금액), 450,000원
*   **포인트 적립**: 포인트 적립!, 집밥 선택 시 450P 적립
*   **재료 목록 제목**: 이번 레시피에 필요한 재료
*   **재료 목록**: 닭가슴살 150g, 브로콜리 50g, 당근 1/4개 (약 30g), 마늘 1쪽 (5g), 현미밥 120g (1인분 기준)
*   **레시피 제목**: 레시피 요리 방법
*   **레시피 단계**: (예시) 1. 닭가슴살을 한입 크기로 썹니다. 2. 끓는 물에 브로콜리와 당근을 넣고 30초간 데친 후 건져 물기를 빼줍니다. 3. 팬에 올리브유를 두르고 다진 마늘을 볶아 향을 냅니다. 4. 닭가슴살을 넣고 겉면이 노릇해질 때까지 구워줍니다. 5. 데친 채소와 간장 1큰술을 넣고 1분간 볶아줍니다. 6. 그릇에 현미밥을 담고, 닭가슴살과 채소를 올려 완성합니다.
*   **포리의 팁**: 포리의 팁, 기호에 따라 참깨나 쪽파를 뿌리면 더 맛있어요!
*   **버튼**: 외식할래요, 집밥 선택하고 포인트 받기

### 6.8. 플렉스 샵 화면

*   **상단**: 플렉스 샵, 포리와 함께 포인트로 특별한 아이템을 만나보세요!
*   **말풍선**: 마음에 드는 아이템을 골라보리!
*   **카테고리**: 모자, 악세서리, 자동차, 인테리어
*   **아이템 목록**: 포리의 잎사귀 캡 (300,000), 초록 리본 밀짚모자 (180,000), 새싹 비니 (90,000), 나뭇잎 머리띠 (45,000), 플렉스 기본 캡 (20,000), 비밀 아이템 (특별한 조건을 달성하면 잠금 해제할 수 있어요! 미리보기)

## 7. 상태/인터랙션 규칙

### 7.1. 캐릭터 상태 변경 조건

*   **로그인/온보딩 화면**: 슬픈 표정의 포리 (파산 상태)
*   **메인 화면**: 기쁜 표정의 포리 (기본 상태)
*   **캐릭터 환경 화면**: 기쁜 표정의 포리 (아이템 착용 가능)
*   **비교 툴 화면**: 기쁜 표정의 포리 (음식 일러스트 옆)
*   **비교 결과 화면**: 기쁜 표정의 포리 (축하 효과)
*   **플렉스 샵 화면**: 기쁜 표정의 포리 (아이템 선택 말풍선)

### 7.2. 버튼 클릭 시 동작

*   **로그인 화면 '시작하기'**: 사용자 이름 입력 후 메인 화면으로 이동
*   **비교 툴 화면 '비교하기'**: 입력된 메뉴와 가격으로 비교 결과 화면 생성 및 이동
*   **비교 결과 화면 '외식할래요'**: 현재 화면 유지 또는 메인 화면으로 이동 (사용자 선택에 따라)
*   **비교 결과 화면 '집밥 선택하고 포인트 받기'**: 절약 금액에 해당하는 포인트 적립 후 기록 화면으로 이동
*   **플렉스 샵 '구매하기'**: 포인트 차감 후 아이템 구매 및 캐릭터 환경 화면에 반영
*   **플렉스 샵 '미리보기' (비밀 아이템)**: 잠금 해제 조건 팝업 또는 상세 정보 화면으로 이동
*   **하단 내비게이션 바**: 해당 화면으로 이동

### 7.3. Bottom Navigation 이동 규칙

*   각 탭 클릭 시 해당 화면으로 이동하며, 스택에 새로운 화면을 푸시하거나 기존 화면으로 팝하여 이동 (Flutter Navigator 2.0 또는 GoRouter 활용)
*   현재 활성화된 탭은 시각적으로 강조

### 7.4. 구매 가능/불가능/보유중 상태 규칙 (FlexItemCard)

*   **구매 가능**: 사용자의 현재 포인트가 아이템 가격보다 많을 경우, '구매하기' 버튼 활성화
*   **구매 불가능**: 사용자의 현재 포인트가 아이템 가격보다 적을 경우, '구매하기' 버튼 비활성화 (텍스트 변경 가능: '포인트 부족')
*   **보유중**: 이미 구매한 아이템일 경우, '구매하기' 버튼 대신 '보유중' 또는 '착용중' 텍스트 표시 및 버튼 비활성화
*   **비밀 아이템**: 잠금 해제 조건 충족 전까지 '미리보기' 버튼만 활성화, 구매 불가

## 8. Codex용 최종 구현 프롬프트

```
As an expert Flutter developer, refactor an existing Flutter application to match the provided UI/UX design specifications. The application currently uses Flutter for the frontend and FastAPI for the backend, and the API structure must remain unchanged. Your task is to implement the new UI based on the detailed design tokens, screen layouts, reusable components, asset lists, and interaction rules provided below. Focus on creating a clean, modular, and maintainable codebase.

--- Flutter UI/UX Implementation Details ---

[Insert the entire content of sections 1, 2, 3, 4, 5, 6, and 7 from the handover document here]

--- Implementation Guidelines ---

1.  **Project Structure**: Organize the codebase into `lib/screens`, `lib/widgets`, `lib/models`, `lib/services`, `lib/utils`, `lib/assets` directories. Create separate files for each screen and reusable widget.
2.  **Design System**: Implement the design tokens (colors, typography, radii, shadows, spacing) as constants or a custom `ThemeData` in Flutter to ensure consistency across the application. Use `const` where possible.
3.  **Responsive Design**: Utilize `MediaQuery` or `LayoutBuilder` to ensure the UI adapts correctly to different screen sizes, especially given the target 393x852 pt resolution as a base. Focus on maintaining proportions and relative spacing.
4.  **Reusable Widgets**: Create dedicated Flutter widgets for each reusable component (AppLogo, SproutMascot, StatCard, MissionCard, CompareInputCard, CompareResultCard, RankingTile, FlexItemCard, AppBottomNavigation) as specified in Section 4. Ensure they are highly configurable via props.
5.  **Asset Management**: Integrate all listed image assets into the `pubspec.yaml` file and use them correctly within the widgets. Ensure transparent backgrounds are handled properly.
6.  **State Management**: Use a suitable state management solution (e.g., Provider, Riverpod, BLoC) for managing UI state and interactions. Integrate with the existing FastAPI backend through the `lib/services` layer.
7.  **Navigation**: Implement the navigation flow using Flutter's Navigator or a routing package like GoRouter, adhering to the specified screen transitions and bottom navigation rules.
8.  **Interaction Logic**: Implement the button click actions and character state changes as described in Section 7. Ensure purchase logic in Flex Shop correctly reflects user points and item ownership.
9.  **Code Quality**: Write clean, well-commented, and testable code. Adhere to Flutter's best practices and Dart's effective style guide.
10. **Accessibility**: Consider basic accessibility principles (e.g., semantic widgets, sufficient contrast).

Start by outlining the main `main.dart` file and the structure for the `lib/screens` and `lib/widgets` directories, then proceed with implementing the `LoginScreen` and its required components.
```
말풍선**: 마음에 드는 아이템을 골라보리!
*   **카테고리**: 모자, 악세서리, 자동차, 인테리어
*   **아이템 목록**: 포리의 잎사귀 캡 (300,000), 초록 리본 밀짚모자 (180,000), 새싹 비니 (90,000), 나뭇잎 머리띠 (45,000), 플렉스 기본 캡 (20,000), 비밀 아이템 (특별한 조건을 달성하면 잠금 해제할 수 있어요! 미리보기)

## 8. Codex용 최종 구현 프롬프트

```
As an expert Flutter developer, refactor an existing Flutter application to match the provided UI/UX design specifications. The application currently uses Flutter for the frontend and FastAPI for the backend, and the API structure must remain unchanged. Your task is to implement the new UI based on the detailed design tokens, screen layouts, reusable components, asset lists, and interaction rules provided below. Focus on creating a clean, modular, and maintainable codebase.

--- Flutter UI/UX Implementation Details ---

[Insert the entire content of sections 1, 2, 3, 4, 5, 6, and 7 from the handover document here]

--- Implementation Guidelines ---

1.  **Project Structure**: Organize the codebase into `lib/screens`, `lib/widgets`, `lib/models`, `lib/services`, `lib/utils`, `lib/assets` directories. Create separate files for each screen and reusable widget.
2.  **Design System**: Implement the design tokens (colors, typography, radii, shadows, spacing) as constants or a custom `ThemeData` in Flutter to ensure consistency across the application. Use `const` where possible.
3.  **Responsive Design**: Utilize `MediaQuery` or `LayoutBuilder` to ensure the UI adapts correctly to different screen sizes, especially given the target 393x852 pt resolution as a base. Focus on maintaining proportions and relative spacing.
4.  **Reusable Widgets**: Create dedicated Flutter widgets for each reusable component (AppLogo, SproutMascot, StatCard, MissionCard, CompareInputCard, CompareResultCard, RankingTile, FlexItemCard, AppBottomNavigation) as specified in Section 4. Ensure they are highly configurable via props.
5.  **Asset Management**: Integrate all listed image assets into the `pubspec.yaml` file and use them correctly within the widgets. Ensure transparent backgrounds are handled properly.
6.  **State Management**: Use a suitable state management solution (e.g., Provider, Riverpod, BLoC) for managing UI state and interactions. Integrate with the existing FastAPI backend through the `lib/services` layer.
7.  **Navigation**: Implement the navigation flow using Flutter's Navigator or a routing package like GoRouter, adhering to the specified screen transitions and bottom navigation rules.
8.  **Interaction Logic**: Implement the button click actions and character state changes as described in Section 7. Ensure purchase logic in Flex Shop correctly reflects user points and item ownership.
9.  **Code Quality**: Write clean, well-commented, and testable code. Adhere to Flutter's best practices and Dart's effective style guide.
10. **Accessibility**: Consider basic accessibility principles (e.g., semantic widgets, sufficient contrast).

Start by outlining the main `main.dart` file and the structure for the `lib/screens` and `lib/widgets` directories, then proceed with implementing the `LoginScreen` and its required components.
```
