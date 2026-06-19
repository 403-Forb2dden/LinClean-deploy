data "terraform_remote_state" "route_table" {
  backend = "local"

  config = {
    path = "../../../../generated/aws/route_table/ap-northeast-2/terraform.tfstate"
  }
}

data "terraform_remote_state" "subnet" {
  backend = "local"

  config = {
    path = "../../../../generated/aws/subnet/ap-northeast-2/terraform.tfstate"
  }
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../../../../generated/aws/vpc/ap-northeast-2/terraform.tfstate"
  }
}
