resource "aws_s3_bucket" "api" {
  bucket        = "rest-api-gw-${local.suffix}-api"
  force_destroy = true
}

resource "aws_s3_bucket" "mp3" {
  bucket        = "rest-api-gw-${local.suffix}-mp3"
  force_destroy = true
}

resource "aws_s3_bucket" "web_testlogin" {
  bucket        = "rest-api-gw-${local.suffix}-web-testlogin"
  force_destroy = true
}

locals {
  source_testlogin = "${path.module}/external/web_testlogin"

  files = [
    for file in fileset(local.source_testlogin, "**/*") : {
      path = "${local.source_testlogin}/${file}",
      dest = file
    }
  ]

  content_types = {
    ".html" = "text/html",
    ".css"  = "text/css",
    ".js"   = "application/javascript",
    ".jpg"  = "image/jpeg",
    ".jpeg" = "image/jpeg",
    ".png"  = "image/png",
    ".json" = "application/json",
  }
}

resource "aws_s3_object" "web_testlogin" {
  for_each = { for file in local.files : file.path => file }
  bucket   = aws_s3_bucket.web_testlogin.id
  key      = each.value.dest
  source   = each.value.path
  etag     = filemd5(each.value.path)
  content_type = lookup(
    local.content_types,
    ".${split(".", each.value.dest)[length(split(".", each.value.dest)) - 1]}",
    "application/octet-stream"
  )
}

resource "aws_s3_bucket_website_configuration" "web_testlogin" {
  bucket = aws_s3_bucket.web_testlogin.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_versioning" "web_testlogin" {
  bucket = aws_s3_bucket.web_testlogin.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "web_testlogin" {
  bucket = aws_s3_bucket.web_testlogin.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "web_testlogin" {
  bucket                  = aws_s3_bucket.web_testlogin.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

data "aws_iam_policy_document" "s3_allow_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.web_testlogin.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "s3_allow_access" {
  bucket = aws_s3_bucket.web_testlogin.id
  policy = data.aws_iam_policy_document.s3_allow_access.json
}
