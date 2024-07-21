resource "aws_s3_bucket" "web" {
  bucket        = "rest-api-gw-${local.suffix}-web"
  force_destroy = true
}

locals {
  source_testlogin = "${path.module}/../02/external/web/build"

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

resource "aws_s3_object" "web" {
  for_each = { for file in local.files : file.path => file }
  bucket   = aws_s3_bucket.web.id
  key      = each.value.dest
  source   = each.value.path
  etag     = filemd5(each.value.path)
  content_type = lookup(
    local.content_types,
    ".${split(".", each.value.dest)[length(split(".", each.value.dest)) - 1]}",
    "application/octet-stream"
  )
}

resource "aws_s3_bucket_website_configuration" "web" {
  bucket = aws_s3_bucket.web.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_versioning" "web" {
  bucket = aws_s3_bucket.web.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_ownership_controls" "web" {
  bucket = aws_s3_bucket.web.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "web" {
  bucket                  = aws_s3_bucket.web.id
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
      "${aws_s3_bucket.web.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "s3_allow_access" {
  bucket = aws_s3_bucket.web.id
  policy = data.aws_iam_policy_document.s3_allow_access.json
}
