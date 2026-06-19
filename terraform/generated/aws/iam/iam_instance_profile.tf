resource "aws_iam_instance_profile" "tfer--linclean-ec2-role" {
  name = "linclean-ec2-role"
  path = "/"
  role = "linclean-ec2-role"
}
