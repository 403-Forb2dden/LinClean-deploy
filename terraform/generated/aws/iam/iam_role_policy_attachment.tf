resource "aws_iam_role_policy_attachment" "tfer--github-actions-deploy_linclean-deploy-ssm" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/linclean-deploy-ssm"
  role       = "github-actions-deploy"
}

resource "aws_iam_role_policy_attachment" "tfer--linclean-ec2-role_AmazonSSMManagedInstanceCore" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = "linclean-ec2-role"
}

resource "aws_iam_role_policy_attachment" "tfer--linclean-ec2-role_linclean-ec2-ssm-read" {
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/linclean-ec2-ssm-read"
  role       = "linclean-ec2-role"
}
