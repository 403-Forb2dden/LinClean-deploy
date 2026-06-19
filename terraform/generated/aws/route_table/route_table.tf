resource "aws_route_table" "tfer--rtb-09b773d78201e7426" {
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "igw-0fffc68ca33f6869f"
  }

  vpc_id = "${data.terraform_remote_state.vpc.outputs.aws_vpc_tfer--vpc-0418db1a1f7e8320e_id}"
}

resource "aws_route_table" "tfer--rtb-0bad7bb3776ec2f72" {
  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = "eni-01e3526fd0a19ee2d"
  }

  tags = {
    Name = "linclean-db-private-rt"
  }

  tags_all = {
    Name = "linclean-db-private-rt"
  }

  vpc_id = "${data.terraform_remote_state.vpc.outputs.aws_vpc_tfer--vpc-0418db1a1f7e8320e_id}"
}
