resource "aws_iam_role" "create" {
  name = "rest-api-gw-${local.suffix}-create"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "create" {
  name = "rest-api-gw-${local.suffix}-create"
  role = aws_iam_role.create.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DescribeTable"
        ],
        "Resource" : "${aws_dynamodb_table.example.arn}",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "${aws_cloudwatch_log_group.create.arn}",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "delete" {
  name = "rest-api-gw-${local.suffix}-delete"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "delete" {
  name = "rest-api-gw-${local.suffix}-delete"
  role = aws_iam_role.delete.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "dynamodb:DeleteItem",
          "dynamodb:DescribeTable"
        ],
        "Resource" : "${aws_dynamodb_table.example.arn}",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "${aws_cloudwatch_log_group.delete.arn}",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "dictate" {
  name = "rest-api-gw-${local.suffix}-dictate"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "dictate" {
  name = "rest-api-gw-${local.suffix}-dictate"
  role = aws_iam_role.dictate.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:Scan"
        ],
        "Resource" : "${aws_dynamodb_table.example.arn}",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "${aws_cloudwatch_log_group.dictate.arn}",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "polly:SynthesizeSpeech"
        ],
        "Resource" : "*",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "s3:PutObject",
          "s3:GetObject"
        ],
        "Resource" : "${aws_s3_bucket.mp3.arn}*",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "list" {
  name = "rest-api-gw-${local.suffix}-list"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "list" {
  name = "rest-api-gw-${local.suffix}-list"
  role = aws_iam_role.list.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ],
        "Resource" : "${aws_dynamodb_table.example.arn}",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "${aws_cloudwatch_log_group.list.arn}",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "search" {
  name = "rest-api-gw-${local.suffix}-search"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "search" {
  name = "rest-api-gw-${local.suffix}-search"
  role = aws_iam_role.search.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "dynamodb:Query",
          "dynamodb:DescribeTable"
        ],
        "Resource" : "${aws_dynamodb_table.example.arn}",
        "Effect" : "Allow"
      },
      {
        "Action" : [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        "Resource" : "${aws_cloudwatch_log_group.search.arn}",
        "Effect" : "Allow"
      }
    ]
  })
}

resource "aws_iam_role" "apigw_lambda" {
  name = "rest-api-gw-${local.suffix}-apigw-lambda"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "apigateway.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "apigw_lambda_create" {
  name = "rest-api-gw-${local.suffix}-apigw-lambda-create"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = aws_lambda_function.create.arn
      }
    ]
  })
}

resource "aws_iam_policy" "apigw_lambda_delete" {
  name = "rest-api-gw-${local.suffix}-apigw-lambda-delete"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = aws_lambda_function.delete.arn
      }
    ]
  })
}

resource "aws_iam_policy" "apigw_lambda_dictate" {
  name = "rest-api-gw-${local.suffix}-apigw-lambda-dictate"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = aws_lambda_function.dictate.arn
      }
    ]
  })
}

resource "aws_iam_policy" "apigw_lambda_list" {
  name = "rest-api-gw-${local.suffix}-apigw-lambda-list"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = aws_lambda_function.list.arn
      }
    ]
  })
}

resource "aws_iam_policy" "apigw_lambda_search" {
  name = "rest-api-gw-${local.suffix}-apigw-lambda-search"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "lambda:InvokeFunction"
        Effect   = "Allow"
        Resource = aws_lambda_function.search.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "apigw_lambda_create" {
  role       = aws_iam_role.apigw_lambda.name
  policy_arn = aws_iam_policy.apigw_lambda_create.arn
}

resource "aws_iam_role_policy_attachment" "apigw_lambda_delete" {
  role       = aws_iam_role.apigw_lambda.name
  policy_arn = aws_iam_policy.apigw_lambda_delete.arn
}

resource "aws_iam_role_policy_attachment" "apigw_lambda_dictate" {
  role       = aws_iam_role.apigw_lambda.name
  policy_arn = aws_iam_policy.apigw_lambda_dictate.arn
}

resource "aws_iam_role_policy_attachment" "apigw_lambda_list" {
  role       = aws_iam_role.apigw_lambda.name
  policy_arn = aws_iam_policy.apigw_lambda_list.arn
}

resource "aws_iam_role_policy_attachment" "apigw_lambda_search" {
  role       = aws_iam_role.apigw_lambda.name
  policy_arn = aws_iam_policy.apigw_lambda_search.arn
}

resource "aws_iam_role_policy_attachment" "apigw_cloudwatch_policy" {
  role       = aws_iam_role.apigw_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

resource "aws_iam_role" "apigw_exec" {
  name = "rest-api-gw-${local.suffix}-apigw-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "apigateway.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "apigw_exec" {
  name = "rest-api-gw-${local.suffix}-apigw-exec"
  role = aws_iam_role.apigw_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:ListUsers",
          "cognito-idp:AdminInitiateAuth",
          "cognito-idp:AdminGetUser"
        ],
        Resource = [
          "arn:aws:cognito-idp:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:userpool/${aws_cognito_user_pool.example.id}"
        ]
      }
    ]
  })
}
