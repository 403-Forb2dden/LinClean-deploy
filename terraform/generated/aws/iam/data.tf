# 공개 레포에 계정 ID 평문 노출을 피하기 위해 ARN의 account_id 부분을 동적으로 참조한다.
data "aws_caller_identity" "current" {}
