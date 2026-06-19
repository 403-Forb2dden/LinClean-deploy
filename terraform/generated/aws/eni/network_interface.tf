resource "aws_network_interface" "tfer--eni-004ca4335ea1baf2c" {
  attachment {
    device_index = "0"
    instance     = "i-087e8229818de4182"
  }

  interface_type     = "interface"
  ipv4_prefix_count  = "0"
  ipv6_address_count = "0"
  ipv6_prefix_count  = "0"
  private_ip         = "172.31.67.93"
  private_ip_list    = ["172.31.67.93"]
  private_ips        = ["172.31.67.93"]
  private_ips_count  = "0"
  security_groups    = ["sg-01d7376ba980bf2e6"]
  source_dest_check  = "true"
  subnet_id          = "subnet-0632d2f0a805011b3"
}

resource "aws_network_interface" "tfer--eni-01e3526fd0a19ee2d" {
  attachment {
    device_index = "0"
    instance     = "i-0175957e300c3ccd9"
  }

  interface_type     = "interface"
  ipv4_prefix_count  = "0"
  ipv6_address_count = "0"
  ipv6_prefix_count  = "0"
  private_ip         = "172.31.10.100"
  private_ip_list    = ["172.31.10.100"]
  private_ips        = ["172.31.10.100"]
  private_ips_count  = "0"
  security_groups    = ["sg-01eb4b595c6303b33"]
  source_dest_check  = "false"
  subnet_id          = "subnet-00b08863bb393665d"
}
