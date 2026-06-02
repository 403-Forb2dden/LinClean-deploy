# LinClean — Infra & Deploy

> 악성·피싱 URL 탐지 서비스 **LinClean**의 백엔드 인프라·배포 자동화 레포지토리.
> Expo 모바일 앱 → **HTTPS API(Spring Boot)** → 내부 **AI 분석 엔진(FastAPI)** 구조를
> AWS 위에서 Docker Compose · nginx · GitHub Actions로 운영한다.

이 레포는 애플리케이션을 직접 빌드하지 않는다. Spring/FastAPI 이미지는 Docker Hub에서 pull 하고,
이 레포는 **그것들을 어떤 인프라 위에 어떻게 띄우고 보호하고 갱신하는지**를 정의한다.

---

## 🛠️ 기술 스택

| 영역 | 사용 기술 |
| --- | --- |
| **Cloud / Infra** | AWS EC2, VPC(public·private subnet), Elastic IP, Route 53, SSM Parameter Store, IAM(OIDC) |
| **Container** | Docker, Docker Compose |
| **Reverse Proxy / TLS** | nginx, certbot (Let's Encrypt) |
| **Data** | PostgreSQL (pgvector), Valkey (Redis 호환) |
| **배포 대상 App** | Spring Boot (`backend`), FastAPI (`ai`) |
| **CI/CD** | GitHub Actions (OIDC), Docker Hub |
| **Auth** | Clerk (Production) |

---

## 🏗️ 아키텍처

```
                    [ Expo 모바일 앱 ]
                     │ 로그인            │ API 호출
                     ▼                   ▼
              Clerk (Production)   https://api.linclean.kr
            clerk.linclean.kr            │  Route53(DNS) → Elastic IP
                                         │  app-sg(80/443) → nginx (TLS 종단)
                                         ▼
   ┌─────────────────────────────────────────────────────────┐
   │  App EC2  (public subnet · Elastic IP)                   │
   │                                                          │
   │   nginx ──TLS 종단──▶ backend (Spring) ──내부 호출──▶ ai  │
   │     │                  :8080                  (FastAPI)   │
   │   certbot(자동 갱신)                            :8000      │
   │                                                          │
   │   * 동시에 NAT 인스턴스 역할 → DB의 인터넷 출구 제공        │
   └───────────────────────────┬─────────────────────────────┘
                               │ 내부망 (사설 IP)
                               ▼
   ┌─────────────────────────────────────────────────────────┐
   │  DB EC2  (private subnet · 공인 IP 없음)                  │
   │                                                          │
   │   PostgreSQL (pgvector)        Valkey (Redis 호환)        │
   │   :5432                        :6379                      │
   │                                                          │
   │   * db-sg 는 app-sg 에서 오는 5432/6379 만 허용           │
   └─────────────────────────────────────────────────────────┘
```

- **App EC2** — 유일한 공개 진입점. nginx가 TLS를 종단하고 `backend:8080`으로 프록시한다.
  `ai`(FastAPI)는 외부에 노출하지 않고 Spring의 내부 호출로만 사용한다.
- **DB EC2** — 공인 IP가 없는 완전 private 인스턴스. 인터넷 접근은 App EC2의 NAT를 경유한다.
- 두 인스턴스의 컨테이너 네트워크는 `linclean-network`(App) / `linclean-db-network`(DB)로 분리한다.

---

## 💡 핵심 설계 의사결정

| 결정 | 이유 |
| --- | --- |
| **DB를 완전 private 로 두고 App EC2 를 NAT 인스턴스로 사용** | 관리형 NAT Gateway 비용(~$32/월)을 회피하면서, 공인 IP 없는 DB로 공격면을 최소화 |
| **시크릿은 SSM Parameter Store(SecureString·KMS) + EC2 IAM Role 로 런타임 주입** | 레포·Docker 이미지에 장기 시크릿을 저장하지 않음. 컨테이너 기동 시점에만 주입 |
| **CI/CD 인증을 GitHub OIDC 로 처리** | AWS 정적 액세스 키를 GitHub에 두지 않고, 신뢰하는 레포/브랜치만 단기 자격증명으로 역할 assume |
| **운영 접근은 SSM Session Manager 기반** | 키리스(keyless) 접근. SSH 22 의존도를 낮춰 운영 채널을 단일화 |
| **앱 컨테이너 포트는 `expose`(내부 전용)** | `backend`·`ai`의 호스트 publish 제거. 외부로는 nginx(80/443)만 열어 공격면 축소 |
| **TLS를 certbot으로 자동화** | Let's Encrypt 인증서를 무인 발급·갱신. 최초 발급의 닭-달걀 문제는 `init-letsencrypt.sh`로 해결 |
| **DNS는 Route 53, 도메인 등록은 가비아 유지(NS 위임)** | 도메인 등록처는 그대로 두면서 DNS 운영을 AWS로 통합 |

---

## 🔒 보안 설계

- **네트워크** — public/private 서브넷 분리. DB는 공인 IP가 없고, `db-sg`는 `app-sg`에서 오는
  5432/6379 트래픽만 허용한다. 외부에 열린 포트는 nginx의 80/443 뿐.
- **시크릿** — SSM Parameter Store의 SecureString(KMS 암호화) + EC2 IAM Role로 주입. 정적
  클라우드 키 없이 GitHub OIDC로 배포 자격증명을 단기 발급한다.
- **전송 구간** — 전 구간 HTTPS. nginx에서 TLS 종단, `http → https` 301 리다이렉트, ACME
  챌린지(`/.well-known/acme-challenge/`)만 80에서 처리한다.

---

## 🚀 CI/CD 파이프라인

```
앱 레포 push / workflow_dispatch
        │
        ▼
GitHub Actions ──(OIDC)──▶ AWS 역할 assume   ← 정적 키 없음
        │
        ▼
Docker 이미지 빌드 & push  →  Docker Hub (sunm2ni/linclean-backend, sunm2ni/linclean-ai)
        │
        ▼
SSM send-command  →  App EC2 에서  `docker compose pull && docker compose up -d`
```

이미지 빌드는 각 애플리케이션 레포(Spring / FastAPI)의 워크플로에서 수행되고, 이 레포의
Compose 정의가 그 이미지를 받아 App EC2에 무중단으로 반영한다.

---

## 📁 레포 구조

```
.
├── db/
│   └── docker-compose.yml        # DB EC2: PostgreSQL(pgvector) + Valkey
└── service/
    ├── docker-compose.yml        # App EC2: backend + ai + nginx + certbot
    ├── init-letsencrypt.sh       # Let's Encrypt 최초 인증서 발급 부트스트랩
    └── nginx/
        └── conf.d/
            └── api.conf          # api.linclean.kr TLS 종단 + backend 리버스 프록시
```

- **`service/docker-compose.yml`** — 공통 설정을 `x-common` 앵커로 묶고, `backend`·`ai`는
  `expose`로만 내부 노출, `nginx`만 80/443 공개. `certbot`은 갱신 루프로 상주한다.
- **`nginx/conf.d/api.conf`** — 80은 ACME 챌린지 + 443 리다이렉트, 443은 TLS 종단 후
  `http://backend:8080`으로 프록시(`ai`는 프록시하지 않음).
- **`init-letsencrypt.sh`** — 더미 자가서명 인증서로 nginx를 먼저 띄운 뒤 certbot으로 실제
  인증서를 발급하고 reload 하는, 최초 1회용 부트스트랩 스크립트.

---
