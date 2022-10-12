## IAM SSM Group
resource "aws_iam_group" "ssm" {
  name = var.ssm_group_name
}

resource "aws_iam_group_policy_attachment" "ssm" {
  group      = aws_iam_group.ssm.name
  policy_arn = aws_iam_policy.ssm.arn
}

resource "aws_iam_policy" "ssm" {
  name        = "${var.ssm_group_name}Policy"
  path        = "/"
  description = "${var.ssm_group_name} Policy"
  policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ssm:StartSession",
            "Resource": [
                "${module.ec2.arn[0]}",
                "arn:aws:ssm:*:*:document/AWS-StartSSHSession"
            ]
        }
    ]
}
EOF
}
