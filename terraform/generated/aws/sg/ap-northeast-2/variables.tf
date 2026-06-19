data "terraform_remote_state" "sg" {
  backend = "local"

  config = {
    path = "../../../../generated/aws/sg/ap-northeast-2/terraform.tfstate"
  }
}
