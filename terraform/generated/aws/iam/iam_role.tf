resource "aws_iam_role" "tfer--github-actions-deploy" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
        },
        "StringLike": {
          "token.actions.githubusercontent.com:sub": [
            "repo:403-Forb2dden/LinClean-BE-spring:ref:refs/heads/main",
            "repo:403-Forb2dden/LinClean-BE-spring:ref:refs/heads/dev",
            "repo:403-Forb2dden/LinClean-BE-fastapi:ref:refs/heads/main",
            "repo:403-Forb2dden/LinClean-BE-fastapi:ref:refs/heads/dev"
          ]
        }
      },
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  managed_policy_arns  = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/linclean-deploy-ssm"]
  max_session_duration = "3600"
  name                 = "github-actions-deploy"
  path                 = "/"
}

resource "aws_iam_role" "tfer--linclean-ec2-role" {
  assume_role_policy = <<POLICY
{
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ],
  "Version": "2012-10-17"
}
POLICY

  description          = "Allows EC2 instances to call AWS services on your behalf."
  managed_policy_arns  = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/linclean-ec2-ssm-read", "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
  max_session_duration = "3600"
  name                 = "linclean-ec2-role"
  path                 = "/"
}
