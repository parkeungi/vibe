# 바이브 스토어 (Vibe Store) 병렬 개발 구현 계획서

`prd.md` 문서를 바탕으로 바이브 스토어의 원활한 구현을 위해 **프론트엔드(Antigravity)**와 **백엔드(Claude)**가 동시에 병렬로 작업할 수 있도록 작성한 세부 계획서입니다.

## User Review Required

> [!IMPORTANT]
> 본 계획서는 프론트엔드와 백엔드의 완전한 독립적, 병렬적 개발을 목표로 합니다.
> 클라우드(Claude)에게 백엔드 개발을 요청하실 때, 본 계획서의 **[API 인터페이스 명세]**와 **[백엔드(Claude) 작업 범위]** 부분을 먼저 전달하여 상호 동일한 규격으로 개발이 진행되도록 해주셔야 합니다.

## Open Questions

> [!WARNING]
> 원활한 개발 시작을 위해 다음 항목들에 대한 사용자님의 확인이 필요합니다.
> 1. **Next.js 라우터 방식:** Pages Router와 App Router 중 어떤 방식을 선호하시나요? (최근 트렌드인 App Router(`app/` 디렉토리 방식) 사용을 권장합니다.)
> 2. **상태 관리 도구:** 전역 상태 관리가 필요할 경우 Zustand를 사용할지, 혹은 React Context API만으로 진행할지 결정이 필요합니다.
> 3. **초기 Mock 데이터 포맷:** 프론트엔드가 먼저 화면을 그릴 수 있도록 아래 정의한 API 명세 및 Mock 데이터 포맷으로 진행해도 괜찮을까요?

---

## 🚀 프론트엔드/백엔드 병렬 개발 전략

병렬 작업 중 발생할 수 있는 오류나 에러를 방지하기 위해 아래 전략을 엄격히 따릅니다.

1. **API 우선주의 (API-First Design):** 개발 시작 전, 두 작업자가 통신할 API의 주소, 요청(Request), 응답(Response) 데이터 구조를 완벽히 합의합니다.
2. **Mock 데이터 활용 (프론트엔드):** 프론트엔드(Antigravity)는 백엔드가 완성되지 않은 상태에서도 멈추지 않고 작업할 수 있도록, 합의된 데이터 형태의 **Mock (가짜) 데이터**를 사용하여 화면과 로직을 먼저 연동합니다.
3. **독립적 컴포넌트 단위 개발:** 프론트엔드는 UI/UX 명세에 따라 API 통신부와 UI 컴포넌트 렌더링부를 분리하여 개발합니다.

---

## 🔗 사전 정의 API 인터페이스 명세 (합의안)

두 에이전트 간의 통신 규약입니다. 프론트엔드는 이 구조를 바탕으로 Mocking을 진행하며, 백엔드는 이 구조를 반환하도록 API를 구현해야 합니다.

### 1. 사용자 인증 (Auth)
- `POST /api/auth/login` : 소셜 로그인 (응답: `{ "user": { "id", "email", "name", "role" }, "token" }`)
- `GET /api/auth/me` : 내 정보 가져오기

### 2. 상품 관리 (Products)
- `GET /api/products` : 전체 상품 목록 조회 (응답: `[{ "id", "title", "thumbnail", "price", "rating", "reviewCount" }]`)
- `GET /api/products/:id` : 개별 상품 상세 조회 (응답: `{ "id", "title", "description", "content", "price", "rating", "reviews": [...] }`)
- `POST /api/admin/products` : 상품 등록 (관리자용)
- `PUT /api/admin/products/:id` : 상품 수정 (관리자용)

### 3. 주문/결제 및 파일 (Orders & Files)
- `POST /api/payments/verify` : 결제 검증 (포트원 연동)
- `GET /api/orders/my` : 내 구매 내역 조회
- `GET /api/products/:id/download` : 보안 파일 다운로드 스트림 반환 (결제 여부 서버 검증 필수)

### 4. 대시보드 (Dashboard)
- `GET /api/admin/dashboard` : 대시보드 통계 (응답: `{ "totalSales", "todaySalesCount", "salesChart": [...] }`)

---

## 💻 프론트엔드 (Antigravity) 작업 범위 및 계획

**목표:** 반응형 웹 UI 컴포넌트 개발, 라우팅 설정, 상태 관리, Mock 데이터를 이용한 데이터 바인딩 적용.

### Phase 1: 기반 세팅 및 공통 UI 컴포넌트 개발
- **기술 스택:** Next.js (App Router), Tailwind CSS.
- **디자인 시스템 구축:** `tailwind.config.js`에 PRD의 컬러 시스템(Pure White, Light Gray, Charcoal Black, Sleek Indigo Blue 등) 반영.
- **공통 컴포넌트:** Button, Input, Card (상품용 라운딩 처리된 카드), Header, Footer 등 재사용 컴포넌트 제작.

### Phase 2: Client-side (구매자용) 페이지 구현
- **`/` (메인/상품 목록):** 지식 상품 그리드 레이아웃, Mock 데이터 기반 상품 리스트 렌더링.
- **`/products/:id` (상품 상세):** Hero Section (썸네일, 가격, 바로 구매하기), 하단 리뷰 리스트 등 레이아웃 구성.
- **`/login`:** 소셜 로그인 UI 구성.
- **`/mypage`:** 구매 내역 리스트 및 조건부 다운로드 버튼(Mock 상태 기준) 활성화 UI 구성.

### Phase 3: Admin-side (판매자용) 페이지 구현
- **`/admin/login`:** 관리자 전용 인증 UI.
- **`/admin/dashboard`:** 매출 요약 카드 UI 및 차트 라이브러리(Recharts 등)를 활용한 통계 그래프 구현.
- **`/admin/products`:** 관리자용 상품 리스트, 등록/수정 폼 레이아웃 구현.
- 관리자 라우트 접근 제어 로직(Middleware 기본 틀) 작성.

---

## ⚙️ 백엔드 (Claude) 작업 범위 및 계획

**목표:** 데이터베이스 모델링, 비즈니스 로직(API) 및 인증/인가 시스템 구현, 결제 모듈 연동.

### Phase 1: DB 모델링 및 Supabase 세팅
- **테이블 설계:** `Users` (일반/관리자 구분), `Products` (상품 정보), `Orders` (주문/결제 상태), `Reviews` (리뷰).
- **스토리지 세팅:** Supabase Storage 버킷 생성 및 50MB 용량 제한 룰 적용.

### Phase 2: 인증 및 핵심 API 개발
- **인증:** Supabase Auth를 활용한 소셜 로그인 연동 로직.
- **상품 API:** 상품 목록 조회, 상세 조회, 관리자용 CRUD API 개발.
- **리뷰 API:** 실제 구매 내역 기반 리뷰 작성 권한 체크(1회 제한) 로직 포함.

### Phase 3: 결제 연동 및 보안 파일 다운로드
- **포트원 연동:** 포트원 웹훅 처리 및 결제 검증 API 로직 개발.
- **이메일 알림:** 결제 승인 시 구매 확인 이메일 자동 발송 로직(Nodemailer 또는 Resend 등 활용).
- **파일 보안:** 세션/토큰을 기반으로 실제 결제 완료 유저인지 판별 후 파일 다운로드 스트림 제공 로직.

---

## 🧪 통합 및 검증 계획 (Verification Plan)

각자의 역할(프론트/백엔드)이 완료된 후, 프론트엔드의 Mock 데이터를 실제 백엔드 엔드포인트 주소로 치환하여 통합 테스트를 진행합니다.

1. **API 연결 테스트:** 프론트엔드의 `fetch` 또는 `axios` 호출 대상을 로컬 Mock에서 실제 백엔드 API 주소로 변경하여 정상 통신 여부 확인.
2. **결제 시나리오 테스트:** 상품 상세 페이지 -> 포트원 결제 모의 환경 연동 -> 결제 완료 -> 마이페이지 다운로드 버튼 활성화 -> 실제 파일 다운로드 동작 확인.
3. **권한 접근 제어 테스트:** 비로그인/일반 유저의 `/admin` 접근 시도 시 튕겨냄 확인, 비구매자의 리뷰 작성 차단 확인.
