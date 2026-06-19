# Terraform (IaC) — 현재 인프라 스냅샷

운영 중인 AWS 인프라를 [terraformer](https://github.com/GoogleCloudPlatform/terraformer)로 떠낸 **초기 스냅샷**이다.
이 디렉터리는 brownfield IaC 전환의 시작점으로, 아직 모듈화/리팩터링 전의 자동 생성 코드다.

> ⚠️ 이 코드는 **아직 실물과 state로 연결되지 않았다.** `tofu plan`이 "No changes"가 되도록
> 정합성을 맞추는 작업은 후속 단계에서 진행한다. (issue 후속)

## 도구

| 도구 | 버전 | 비고 |
| --- | --- | --- |
| OpenTofu | 1.12.3 | IaC 엔진 (`tofu`) |
| terraformer | 0.8.30 | 기존 인프라 export (upstream archived, deprecated) |
| AWS provider | hashicorp/aws ~> 5.0 | |
| Region | `ap-northeast-2` | 서울 |

## 디렉터리 구조

```
terraform/
├── provider.tf              # OpenTofu + AWS provider 선언
└── generated/aws/           # terraformer 자동 생성 (서비스별 분리)
    ├── vpc/  subnet/  route_table/  igw/  eip/  nacl/   # 네트워크
    ├── ec2_instance/  eni/  sg/                          # 컴퓨트 + 보안그룹
    ├── route53/                                          # DNS
    └── iam/                                              # LinClean 관련 IAM만
```

## 스냅샷 범위 (50개 리소스)

| 서비스 | 개수 | 서비스 | 개수 |
| --- | --- | --- | --- |
| iam | 8 (정리 후) | route_table | 4 |
| route53 | 9 | sg | 3 |
| ec2_instance | 2 (app·db) | eni | 2 |
| subnet | 5 | vpc/igw/eip/nacl | 각 1 |

## 재현 방법

```bash
cd terraform
tofu init                                  # AWS provider 다운로드

# terraformer가 provider를 ~/.terraform.d/plugins 에서 찾으므로 바이너리 연결 필요
mkdir -p ~/.terraform.d/plugins/darwin_arm64
cp .terraform/providers/registry.opentofu.org/hashicorp/aws/*/darwin_arm64/terraform-provider-aws \
   ~/.terraform.d/plugins/darwin_arm64/terraform-provider-aws_v5.100.0_x5

# EC2 계열은 AWS_REGION 환경변수가 있어야 aws-global 오해석을 피함
AWS_REGION=ap-northeast-2 terraformer import aws \
  --resources=vpc,subnet,route_table,igw,eip,ec2_instance,eni,sg,nacl,route53 \
  --regions=ap-northeast-2 --connect=true

# iam/route53 는 글로벌 서비스라 별도 실행 (AWS_REGION 불필요)
terraformer import aws --resources=iam,route53 --regions=ap-northeast-2
```

## 알려진 한계 / 후속 작업

- [ ] **state 정합성**: 각 서비스별 분리된 tfstate를 통합하고 `tofu plan` "No changes" 검증
- [ ] **모듈화**: `tfer--` prefix의 자동 생성 코드를 의미 있는 모듈(network / compute / iam ...)로 리팩터링
- [ ] **OIDC provider 누락**: terraformer가 `aws_iam_openid_connect_provider`(GitHub Actions OIDC)를
      리소스로 export하지 못함. `github-actions-deploy` 역할의 trust policy에 ARN으로만 참조됨 → 수동 import 필요
- [ ] **SSM Parameter Store**: SecureString 값이 평문 노출되므로 스냅샷에서 의도적으로 제외함.
      값이 아닌 "껍데기/참조" 형태로 별도 관리 필요
- [ ] **IAM 정리됨**: terraformer는 계정 전체 IAM을 export하므로, LinClean 무관 사용자/access key/
      서비스 연결 역할은 제거하고 `github-actions-deploy`·`linclean-ec2-role` 관련만 남김
- [ ] **레거시 provider 주소**: terraformer가 `required_providers`에 `source`를 넣지 않은 구형(TF 0.12)
      형식으로 생성 → 현재 상태로는 `tofu init`이 실패함. 모듈화 시 루트 provider로 통합하며 해결
- [ ] **provider region/version 불일치**: 글로벌 서비스(iam/route53) provider.tf는 `us-east-1`,
      나머지는 `ap-northeast-2`. 버전 핀도 generated는 `~> 5.100.0`, 루트는 `~> 5.0`. 통합 시 일원화
      (글로벌 리소스라 동작엔 영향 없음 — 모듈화 때 정리)

## 주의

- `*.tfstate`, `.terraform/`, `*.tfvars`, `.terraform.lock.hcl` 은 `.gitignore` 처리됨 (민감정보 보호).
- **계정 ID 비노출**: 공개 레포라 IAM 정책/역할 ARN의 계정 ID를 평문 대신
  `data.aws_caller_identity.current.account_id`로 동적 참조한다 (`iam/data.tf`).
- 자동 생성 코드의 리소스 이름(`tfer--...`)은 후속 리팩터링에서 정리한다.
