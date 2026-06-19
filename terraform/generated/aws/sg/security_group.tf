resource "aws_security_group" "tfer--app-sg_sg-01eb4b595c6303b33" {
  description = "LinClean app server"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "443"
    protocol    = "tcp"
    self        = "false"
    to_port     = "443"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "80"
    protocol    = "tcp"
    self        = "false"
    to_port     = "80"
  }

  ingress {
    cidr_blocks = ["116.121.87.170/32"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    cidr_blocks = ["172.31.64.0/20"]
    description = "DB-subnet-NAT"
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  name   = "app-sg"
  vpc_id = "vpc-0418db1a1f7e8320e"
}

resource "aws_security_group" "tfer--db-sg_sg-01d7376ba980bf2e6" {
  description = "LinClean db server"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    cidr_blocks = ["116.121.87.170/32"]
    from_port   = "22"
    protocol    = "tcp"
    self        = "false"
    to_port     = "22"
  }

  ingress {
    from_port       = "5432"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--app-sg_sg-01eb4b595c6303b33_id}"]
    self            = "false"
    to_port         = "5432"
  }

  ingress {
    from_port       = "6379"
    protocol        = "tcp"
    security_groups = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--app-sg_sg-01eb4b595c6303b33_id}"]
    self            = "false"
    to_port         = "6379"
  }

  name   = "db-sg"
  vpc_id = "vpc-0418db1a1f7e8320e"
}

resource "aws_security_group" "tfer--default_sg-0a0b640ab1ee6c2e5" {
  description = "default VPC security group"

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = "0"
    protocol    = "-1"
    self        = "false"
    to_port     = "0"
  }

  ingress {
    from_port = "0"
    protocol  = "-1"
    self      = "true"
    to_port   = "0"
  }

  name   = "default"
  vpc_id = "vpc-0418db1a1f7e8320e"
}
