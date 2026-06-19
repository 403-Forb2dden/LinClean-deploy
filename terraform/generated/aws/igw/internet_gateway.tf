resource "aws_internet_gateway" "tfer--igw-0fffc68ca33f6869f" {
  vpc_id = "${data.terraform_remote_state.vpc.outputs.aws_vpc_tfer--vpc-0418db1a1f7e8320e_id}"
}
