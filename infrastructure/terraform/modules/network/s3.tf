#Buckets require for Site

variable kops_state_bucket {}
variable env               {}

resource "aws_s3_bucket" "kops_state" {
  bucket = "${var.kops_state_bucket}"
  acl    = "private"

  tags {
    Name        = "KOPs State Bucket"
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_policy" "kops_state_policy" {
  bucket = "${aws_s3_bucket.kops_state.id}"
  policy =<<POLICY
{
  "Version": "2012-10-17",
  "Id": "KOPSSTATEPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "arn:aws:s3:::${var.kops_state_bucket}/*",
      "Condition": {
         "IpAddress": {"aws:SourceIp": "${var.vpc_cidr}"}
      } 
    } 
  ]
}
POLICY
}
