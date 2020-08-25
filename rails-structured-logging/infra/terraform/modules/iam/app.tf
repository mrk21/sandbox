resource "aws_iam_role" "app" {
  name               = "${local.base_name}-app"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
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
resource "aws_iam_role_policy_attachment" "app_AmazonEC2ContainerServiceforEC2Role_policy_attachment" {
  role       = aws_iam_role.app.name
  policy_arn = data.aws_iam_policy.AmazonEC2ContainerServiceforEC2Role.arn
}
resource "aws_iam_instance_profile" "app" {
  name = "${local.base_name}-app"
  role = aws_iam_role.app.name
}
