data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../../../../generated/aws/vpc/ap-northeast-2/terraform.tfstate"
  }
}
