resource "aws_instance" "tfer--i-0175957e300c3ccd9_linclean-app" {
  ami                         = "ami-0596f7562954deb8e"
  associate_public_ip_address = "true"
  availability_zone           = "ap-northeast-2a"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_core_count = "1"

  cpu_options {
    core_count       = "1"
    threads_per_core = "2"
  }

  cpu_threads_per_core = "2"

  credit_specification {
    cpu_credits = "unlimited"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "true"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = "linclean-ec2-role"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.small"
  ipv6_address_count                   = "0"
  key_name                             = "linclean-key"

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "optional"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "false"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = "172.31.10.100"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    iops                  = "3000"
    throughput            = "125"
    volume_size           = "30"
    volume_type           = "gp3"
  }

  security_groups   = ["app-sg"]
  source_dest_check = "false"
  subnet_id         = "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-00b08863bb393665d_id}"

  tags = {
    Name = "linclean-app"
  }

  tags_all = {
    Name = "linclean-app"
  }

  tenancy                = "default"
  vpc_security_group_ids = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--app-sg_sg-01eb4b595c6303b33_id}"]
}

resource "aws_instance" "tfer--i-087e8229818de4182_linclean-db" {
  ami                         = "ami-0596f7562954deb8e"
  associate_public_ip_address = "false"
  availability_zone           = "ap-northeast-2a"

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }

  cpu_core_count = "1"

  cpu_options {
    core_count       = "1"
    threads_per_core = "2"
  }

  cpu_threads_per_core = "2"

  credit_specification {
    cpu_credits = "unlimited"
  }

  disable_api_stop        = "false"
  disable_api_termination = "false"
  ebs_optimized           = "true"

  enclave_options {
    enabled = "false"
  }

  get_password_data                    = "false"
  hibernation                          = "false"
  iam_instance_profile                 = "linclean-ec2-role"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t3.micro"
  ipv6_address_count                   = "0"
  key_name                             = "linclean-key"

  maintenance_options {
    auto_recovery = "default"
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "optional"
    instance_metadata_tags      = "disabled"
  }

  monitoring                 = "false"
  placement_partition_number = "0"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "false"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  private_ip = "172.31.67.93"

  root_block_device {
    delete_on_termination = "true"
    encrypted             = "false"
    iops                  = "3000"
    throughput            = "125"
    volume_size           = "30"
    volume_type           = "gp3"
  }

  security_groups   = ["db-sg"]
  source_dest_check = "true"
  subnet_id         = "${data.terraform_remote_state.subnet.outputs.aws_subnet_tfer--subnet-0632d2f0a805011b3_id}"

  tags = {
    Name = "linclean-db"
  }

  tags_all = {
    Name = "linclean-db"
  }

  tenancy                = "default"
  vpc_security_group_ids = ["${data.terraform_remote_state.sg.outputs.aws_security_group_tfer--db-sg_sg-01d7376ba980bf2e6_id}"]
}
