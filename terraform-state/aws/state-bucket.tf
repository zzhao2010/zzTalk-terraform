resource "aws_s3_bucket" "terraform_state" {
  bucket = "zztalk-${var.env}-tf-state"
  force_destroy = true
  # Prevent accidental deletion of this bucket
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "zztalk-${var.env}-tf-state"
    Environment = "${var.env}"
  }
}

resource "aws_s3_bucket_versioning" "enabled" {
  bucket = aws_s3_bucket.terraform_state.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

# Turn server-side encryption on by default for all data written to this bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "default" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "bucket_access" {
  bucket = aws_s3_bucket.terraform_state.id
  acl = "private"
}

resource "aws_s3_bucket_policy" "secure_transport_policy" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.secure_transport.json
}

data "aws_iam_policy_document" "secure_transport" {
  statement {
    principals {
      type = "*"
      identifiers = ["*"]
    }
    sid = "DenyUnSecureCommunications"
    effect = "Deny"
    actions = ["s3:*"]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.terraform_state.id}",
      "arn:aws:s3:::${aws_s3_bucket.terraform_state.id}/*"
    ]

    // Deny all S3 actions on the bucket and its contents if the request is not over SSL
    condition {
      test = "Bool"
      variable = "aws:Secure"
      values = ["false"]
    }
  }
}

// MUST create a DynamoDB table that has a primary key called "LockID"
resource "aws_dynamodb_table" "terraform_locks" {
  name = "terraform_locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}