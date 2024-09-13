
data "aws_region" "current" {}

data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "certs" {
  count  = var.certs == null ? 0 : 1
  bucket = var.certs.bucket
}

data "aws_s3_object" "certs" {
  count  = var.certs == null ? 0 : 1
  bucket = data.aws_s3_bucket.certs[0].bucket
  key    = var.certs.key
}
