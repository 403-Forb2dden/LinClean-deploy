resource "aws_iam_policy" "tfer--linclean-deploy-ssm" {
  name = "linclean-deploy-ssm"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": "ssm:SendCommand",
      "Effect": "Allow",
      "Resource": [
        "arn:aws:ssm:ap-northeast-2::document/AWS-RunShellScript",
        "arn:aws:ec2:ap-northeast-2:${data.aws_caller_identity.current.account_id}:instance/*"
      ],
      "Sid": "SendDeployCommand"
    },
    {
      "Action": "ssm:GetCommandInvocation",
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "ReadCommandResult"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}

resource "aws_iam_policy" "tfer--linclean-ec2-ssm-read" {
  name = "linclean-ec2-ssm-read"
  path = "/"

  policy = <<POLICY
{
  "Statement": [
    {
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParametersByPath"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:ssm:ap-northeast-2:${data.aws_caller_identity.current.account_id}:parameter/linclean/prod/*",
      "Sid": "ReadLinCleanParams"
    },
    {
      "Action": "kms:Decrypt",
      "Effect": "Allow",
      "Resource": "*",
      "Sid": "DecryptSecureString"
    }
  ],
  "Version": "2012-10-17"
}
POLICY
}
