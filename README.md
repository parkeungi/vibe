# 바이브 스토어 (Vibe Store)

나만의 지식 상품(전자책, 가이드북, 템플릿 등)을 편리하게 판매하고, 데이터 기반으로 매출을 관리하는 1인 비즈니스 커머스 플랫폼

## 주요 기능

### 구매자
- 소셜 로그인 (구글, 카카오)
- 지식 상품 목록 조회 및 상세 페이지
- 토스페이먼츠 / 카카오페이 결제
- 마이페이지에서 구매 내역 확인 및 보안 파일 다운로드
- 실제 구매자 대상 리뷰 및 별점 작성

### 판매자 (관리자)
- 상품 등록 / 수정 / 삭제 및 디지털 파일 업로드
- 실시간 매출 대시보드 (총 매출, 판매 건수, 매출 추이 그래프)
- 미들웨어 기반 관리자 페이지 접근 제어

## 기술 스택

| 영역 | 기술 |
|------|------|
| 프레임워크 | Next.js (App Router) |
| 스타일링 | Tailwind CSS |
| 데이터베이스 & 스토리지 | Supabase |
| 결제 | 포트원 (Portone) |
| 배포 | Vercel |

## 화면 구성

```
/                       # 메인 - 상품 목록 그리드
/products/:id           # 상품 상세 페이지
/login                  # 소셜 로그인
/mypage                 # 구매 내역 및 파일 다운로드

/admin/login            # 관리자 로그인
/admin/dashboard        # 매출 대시보드
/admin/products         # 상품 관리 목록
/admin/products/new     # 상품 등록 / 수정
```

## API 명세

| 메서드 | 엔드포인트 | 설명 |
|--------|-----------|------|
| POST | `/api/auth/login` | 소셜 로그인 |
| GET | `/api/auth/me` | 내 정보 조회 |
| GET | `/api/products` | 상품 목록 조회 |
| GET | `/api/products/:id` | 상품 상세 조회 |
| POST | `/api/admin/products` | 상품 등록 (관리자) |
| PUT | `/api/admin/products/:id` | 상품 수정 (관리자) |
| POST | `/api/payments/verify` | 결제 검증 |
| GET | `/api/orders/my` | 내 구매 내역 |
| GET | `/api/products/:id/download` | 보안 파일 다운로드 |
| GET | `/api/admin/dashboard` | 대시보드 통계 |

## 시작하기

```bash
# 의존성 설치
npm install

# 환경변수 설정
cp .env.example .env.local

# 개발 서버 실행
npm run dev
```

## 환경변수

```env
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
PORTONE_API_SECRET=
RESEND_API_KEY=
```

## 제약사항

- Vercel / Supabase Free Tier 범위 내 운영
- 업로드 가능한 개별 파일 최대 크기: **50MB**
- `/admin/*` 경로는 미들웨어에서 비인가 접근 차단
