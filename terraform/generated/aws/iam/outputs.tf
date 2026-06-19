output "aws_iam_instance_profile_tfer--linclean-ec2-role_id" {
  value = "${aws_iam_instance_profile.tfer--linclean-ec2-role.id}"
}

output "aws_iam_policy_tfer--linclean-deploy-ssm_id" {
  value = "${aws_iam_policy.tfer--linclean-deploy-ssm.id}"
}

output "aws_iam_policy_tfer--linclean-ec2-ssm-read_id" {
  value = "${aws_iam_policy.tfer--linclean-ec2-ssm-read.id}"
}

output "aws_iam_role_policy_attachment_tfer--github-actions-deploy_linclean-deploy-ssm_id" {
  value = "${aws_iam_role_policy_attachment.tfer--github-actions-deploy_linclean-deploy-ssm.id}"
}

output "aws_iam_role_policy_attachment_tfer--linclean-ec2-role_AmazonSSMManagedInstanceCore_id" {
  value = "${aws_iam_role_policy_attachment.tfer--linclean-ec2-role_AmazonSSMManagedInstanceCore.id}"
}

output "aws_iam_role_policy_attachment_tfer--linclean-ec2-role_linclean-ec2-ssm-read_id" {
  value = "${aws_iam_role_policy_attachment.tfer--linclean-ec2-role_linclean-ec2-ssm-read.id}"
}

output "aws_iam_role_tfer--github-actions-deploy_id" {
  value = "${aws_iam_role.tfer--github-actions-deploy.id}"
}

output "aws_iam_role_tfer--linclean-ec2-role_id" {
  value = "${aws_iam_role.tfer--linclean-ec2-role.id}"
}
