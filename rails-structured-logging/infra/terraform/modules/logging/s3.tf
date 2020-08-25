resource "aws_s3_bucket" "log" {
  bucket = "${local.base_name}-log"
  acl    = "private"

  tags = {
    Name = "${local.base_name}:s3:log"
    App  = local.app
    Env  = local.env
  }
}
resource "aws_s3_bucket_policy" "log" {
  bucket = aws_s3_bucket.log.id

  policy = <<POLICY
{
    "Id": "LogBucketPolicy",
    "Version": "2012-10-17",
    "Statement": [
        {
          "Sid": "ELBLogPermission",
          "Action": [ "s3:PutObject" ],
          "Effect": "Allow",
          "Resource": "${aws_s3_bucket.log.arn}/app-alb/AWSLogs/${data.aws_caller_identity.self.account_id}/*",
          "Principal": {
              "AWS": "${data.aws_elb_service_account.self.arn}"
          }
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.ap-northeast-1.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "${aws_s3_bucket.log.arn}"
        },
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "logs.ap-northeast-1.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.log.arn}/app/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
POLICY
}
data "aws_caller_identity" "self" {}
data "aws_elb_service_account" "self" {}
