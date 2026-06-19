resource "aws_main_route_table_association" "tfer--vpc-0418db1a1f7e8320e" {
  route_table_id = "${data.terraform_remote_state.route_table.outputs.aws_route_table_tfer--rtb-09b773d78201e7426_id}"
  vpc_id         = "${data.terraform_remote_state.vpc.outputs.aws_vpc_tfer--vpc-0418db1a1f7e8320e_id}"
}
