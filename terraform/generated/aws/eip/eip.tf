resource "aws_eip" "tfer--eipalloc-02a4533b598a1859a" {
  domain               = "vpc"
  instance             = "i-0175957e300c3ccd9"
  network_border_group = "ap-northeast-2"
  network_interface    = "eni-01e3526fd0a19ee2d"
  public_ipv4_pool     = "amazon"

  tags = {
    Name = "linclean-app-eip"
  }

  tags_all = {
    Name = "linclean-app-eip"
  }

  vpc = "true"
}
