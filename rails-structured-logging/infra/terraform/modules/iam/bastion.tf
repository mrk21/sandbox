resource "aws_iam_role" "bastion" {
  path               = "/${local.app}/${local.env}/"
  name               = "${local.base_name}-bastion"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
resource "aws_iam_role_policy" "bastion" {
  name   = "${local.base_name}-bastion"
  role   = aws_iam_role.bastion.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:DescribeInstances",
            "Resource": "*"
        }
    ]
}
EOF
}
resource "aws_iam_instance_profile" "bastion" {
  path = "/${local.app}/${local.env}/"
  name = "${local.base_name}-bastion"
  role = aws_iam_role.bastion.name
}
