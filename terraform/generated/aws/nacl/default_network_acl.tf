resource "aws_default_network_acl" "tfer--acl-0e1493ae5e8cc8c98" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  subnet_ids = ["${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-00b08863bb393665d_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-014c415046105e05e_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-03ffeb8e049eec145_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-0632d2f0a805011b3_id}", "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-0ca72f19a480af2c8_id}"]
}
