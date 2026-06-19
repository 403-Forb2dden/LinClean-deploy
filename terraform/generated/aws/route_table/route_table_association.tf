resource "aws_route_table_association" "tfer--subnet-0632d2f0a805011b3" {
  route_table_id = "${data.terraform_remote_state.route_table.outputs.aws_route_table_tfer--rtb-0bad7bb3776ec2f72_id}"
  subnet_id      = "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-0632d2f0a805011b3_id}"
}
