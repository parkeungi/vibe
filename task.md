# 바이브 스토어 (Vibe Store) 작업 명세서 (Task List)

이 문서는 `implementation_plan.md`를 바탕으로 **프론트엔드(Antigravity)**가 수행할 실제 작업 항목을 추적하기 위한 TODO 리스트입니다.
각 작업은 상태에 따라 `[ ]` (대기), `[/]` (진행 중), `[x]` (완료) 로 표기됩니다.

## 1. 사전 준비 및 환경 설정
- `[ ]` Next.js (App Router) 기반 프로젝트 초기화 (`npx create-next-app`)
- `[ ]` Tailwind CSS 설정 및 디자인 토큰 반영 (`tailwind.config.js`)
  - Pure White, Light Gray, Charcoal Black, Sleek Indigo Blue 등 PRD 컬러 반영
- `[ ]` 폴더 구조 세팅 (components, lib, types, app 등)
- `[ ]` 전역 상태 관리(Zustand 또는 Context) 초기 세팅

## 2. API 및 Mock 데이터 설계
- `[ ]` 백엔드 연동을 위한 전역 타입(Types/Interfaces) 정의
- `[ ]` 상품 데이터(Products) Mock JSON 구축
- `[ ]` 사용자(User/Auth) 및 구매 내역(Orders) Mock JSON 구축
- `[ ]` 대시보드 통계용 Mock 데이터 구축

## 3. 공통 UI 컴포넌트 개발
- `[ ]` Button, Input, Modal 등 기본 UI 요소 제작
- `[ ]` 상품 카드(Product Card) 컴포넌트 제작 (라우팅 적용)
- `[ ]` 공통 Layout (Header 네비게이션, Footer) 구현

## 4. Client-side (구매자용) 페이지 구현
- `[ ]` **메인 페이지 (`/`)**
  - Hero 배너 영역 및 상품 리스트(Grid) 렌더링
- `[ ]` **상품 상세 페이지 (`/products/[id]`)**
  - 상품 썸네일, 가격 정보 표시 및 [바로 구매하기] 버튼 (Mock 연동)
  - 상세 설명(Markdown 렌더링 등) 및 리뷰 리스트 UI
- `[ ]` **로그인 페이지 (`/login`)**
  - 구글/카카오 소셜 로그인 버튼 UI
- `[ ]` **마이페이지 (`/mypage`)**
  - 구매 내역 리스트 표시
  - 결제 완료 상태에 따른 [파일 다운로드] 버튼 활성화 로직 처리

## 5. Admin-side (판매자용) 페이지 구현
- `[ ]` **관리자 로그인 (`/admin/login`)**
  - 격리된 관리자 전용 폼 레이아웃
- `[ ]` **관리자 라우트 보호(Middleware)**
  - 인증되지 않은 사용자의 `/admin` 접근 차단 로직
- `[ ]` **대시보드 메인 (`/admin/dashboard`)**
  - 매출 요약 카드 (오늘 총 매출, 판매 건수 등)
  - 실시간 매출 추이 차트 시각화 (Recharts 등 활용)
- `[ ]` **상품 관리 (`/admin/products`)**
  - 등록 상품 리스트 (Table 또는 List UI)
- `[ ]` **상품 등록 및 수정 (`/admin/products/new`)**
  - 정보 입력 폼, 파일 업로드 영역(Drag & Drop 등) UI 구현

## 6. 통합 테스트 및 고도화
- `[ ]` 백엔드 API 완성을 가정한 Mock 데이터 -> Fetch 로직 교체 준비
- `[ ]` 모바일/태블릿 반응형 UI 교차 검증
- `[ ]` 포트원(Portone) 결제 테스트 모듈 프론트엔드 연동 준비
