# 바이브 스토어 백엔드 설계 문서

**날짜:** 2026-05-17  
**프레임워크:** Next.js 15 (App Router)  
**DB/Auth/Storage:** Supabase  
**결제:** Portone V2  
**이메일:** Resend  

---

## 1. 아키텍처

Next.js Route Handlers를 API 레이어로 사용. Supabase가 DB·Auth·Storage를 모두 담당하므로 별도 서버 없이 Vercel 단일 배포로 운영한다.

```
Client → Next.js Route Handlers → Supabase (DB / Auth / Storage)
                               → Portone V2 API (결제 검증)
                               → Resend (이메일)
```

---

## 2. DB 스키마

### profiles
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | uuid (PK) | auth.users.id 참조 |
| email | text | 이메일 |
| name | text | 이름 |
| avatar_url | text | 프로필 이미지 |
| role | text | 'user' \| 'admin' (기본값: 'user') |
| created_at | timestamptz | |

### products
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | uuid (PK) | |
| title | text | 상품명 |
| description | text | 짧은 소개 |
| content | text | 상세 설명 (Markdown) |
| thumbnail_url | text | 썸네일 이미지 URL |
| file_path | text | Storage 내 파일 경로 (비공개) |
| file_name | text | 다운로드 시 표시될 파일명 |
| price | integer | 가격 (원) |
| is_active | boolean | 판매 활성 여부 (기본값: true) |
| created_at | timestamptz | |

### orders
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | uuid (PK) | |
| user_id | uuid | profiles.id 참조 |
| product_id | uuid | products.id 참조 |
| status | text | 'pending' \| 'paid' \| 'failed' |
| payment_id | text | Portone payment_id |
| amount | integer | 결제 금액 |
| created_at | timestamptz | |

### reviews
| 컬럼 | 타입 | 설명 |
|------|------|------|
| id | uuid (PK) | |
| user_id | uuid | profiles.id 참조 |
| product_id | uuid | products.id 참조 |
| order_id | uuid | orders.id 참조 (1주문 1리뷰 보장) |
| rating | integer | 1~5 |
| content | text | 리뷰 내용 |
| created_at | timestamptz | |

---

## 3. RLS 정책

| 테이블 | SELECT | INSERT | UPDATE | DELETE |
|--------|--------|--------|--------|--------|
| profiles | 본인만 | 본인만 | 본인만 | ✗ |
| products | 전체 (is_active=true) | admin만 | admin만 | admin만 |
| orders | 본인만 | 본인만 | ✗ (서버에서만) | ✗ |
| reviews | 전체 | 구매자만 (paid 확인) | 본인만 | 본인만 |

---

## 4. API 엔드포인트

### 인증
- `GET /api/auth/me` — 현재 로그인 유저 정보 반환

### 상품
- `GET /api/products` — 활성 상품 목록 (id, title, thumbnail_url, price, rating, reviewCount)
- `GET /api/products/[id]` — 상품 상세 + 리뷰 목록

### 주문/결제
- `POST /api/payments/verify` — Portone V2 결제 서버 검증 후 order status → paid 업데이트, 확인 이메일 발송
- `GET /api/orders/my` — 내 구매 내역

### 파일 다운로드
- `GET /api/products/[id]/download` — 세션 검증(paid order 존재) 후 Supabase Signed URL(60초) 발급

### 관리자
- `POST /api/admin/products` — 상품 등록 (파일 업로드 포함)
- `PUT /api/admin/products/[id]` — 상품 수정
- `DELETE /api/admin/products/[id]` — 상품 비활성화 (is_active=false)
- `GET /api/admin/dashboard` — 총 매출, 오늘 판매 건수, 최근 30일 일별 매출 차트 데이터

---

## 5. 결제 흐름 (Portone V2)

1. 클라이언트에서 Portone V2 SDK로 결제창 호출
2. 결제 완료 후 `payment_id` 수신
3. `POST /api/payments/verify` 호출 — 서버에서 Portone V2 REST API로 결제 상태 검증
4. 검증 성공: order status → paid, Resend로 구매 확인 이메일 발송
5. 검증 실패: order status → failed 처리

---

## 6. 파일 보안

- Supabase Storage 버킷: `product-files` (비공개, RLS 차단)
- 다운로드 API에서 서버 세션으로 paid order 존재 여부 확인
- 검증 통과 시 `createSignedUrl()` 60초 URL 발급 후 클라이언트에 반환
- URL 직접 접근 시 Storage RLS가 차단

---

## 7. 관리자 인가

- `middleware.ts`에서 `/api/admin/*`, `/admin/*` 경로 감지
- Supabase 세션 쿠키로 user 조회 → `profiles.role = 'admin'` 확인
- 미인가 시 401 반환

---

## 8. 구현 순서

1. Next.js 프로젝트 초기화 + 환경변수 설정
2. Supabase DB 마이그레이션 (테이블 + RLS)
3. Supabase Storage 버킷 + 정책 설정
4. Supabase Auth 설정 (Google/Kakao OAuth)
5. Middleware (관리자 인가)
6. 공통 Supabase 클라이언트 유틸
7. 상품 API (GET /api/products, GET /api/products/[id])
8. 결제 API (POST /api/payments/verify)
9. 주문 API (GET /api/orders/my)
10. 다운로드 API (GET /api/products/[id]/download)
11. 관리자 API (products CRUD, dashboard)
12. 이메일 (Resend 구매 확인 템플릿)
