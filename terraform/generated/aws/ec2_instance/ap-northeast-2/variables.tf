data "terraform_remote_state" "ebs" {
  backend = "local"

  config = {
    path = "../../../../generated/aws/ebs/ap-northeast-2/terraform.tfstate"
  }
}

data "terraform_remote_state" "sg" {
  backend = "local"

  config = {
    path = "../../../../generated/aws/sg/ap-northeast-2/terraform.tfstate"
  }
}

data "terraform_remote_state" "subnet" {
  backend = "local"

  config = {
    path = "../../../../generated/aws/subnet/ap-northeast-2/terraform.tfstate"
  }
}
