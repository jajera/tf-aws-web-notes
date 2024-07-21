resource "aws_dynamodb_table" "example" {
  name         = "rest-api-gw-${local.suffix}"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "NoteId"
    type = "N"
  }

  hash_key  = "UserId"
  range_key = "NoteId"

  timeouts {
    create = "10m"
    update = "10m"
    delete = "10m"
  }

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_dynamodb_table_item" "testuser_1" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "testuser" }
    NoteId = { N = "1" }
    Note   = { S = "hello world" }
  })
}

resource "aws_dynamodb_table_item" "testuser_2" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "testuser" }
    NoteId = { N = "2" }
    Note   = { S = "this is my first note" }
  })
}

resource "aws_dynamodb_table_item" "student2_3" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "student2" }
    NoteId = { N = "3" }
    Note   = { S = "PartiQL is a SQL compatible language for DynamoDB" }
  })
}

resource "aws_dynamodb_table_item" "student2_4" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "student2" }
    NoteId = { N = "4" }
    Note   = { S = "I love DyDB" }
  })
}

resource "aws_dynamodb_table_item" "student2_5" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "student2" }
    NoteId = { N = "5" }
    Note   = { S = "Maximum size of an item is ____ KB ?" }
  })
}

resource "aws_dynamodb_table_item" "student_1" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "student" }
    NoteId = { N = "1" }
    Note   = { S = "DynamoDB is NoSQL" }
  })
}

resource "aws_dynamodb_table_item" "student_2" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "student" }
    NoteId = { N = "2" }
    Note   = { S = "A DynamoDB table is schemaless" }
  })
}

resource "aws_dynamodb_table_item" "student_3" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "student" }
    NoteId = { N = "3" }
    Note   = { S = "This is your updated note using the Model validation" }
  })
}

resource "aws_dynamodb_table_item" "newbie_1" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "newbie" }
    NoteId = { N = "1" }
    Note   = { S = "Free swag code: 1234" }
  })
}

resource "aws_dynamodb_table_item" "newbie_2" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "newbie" }
    NoteId = { N = "2" }
    Note   = { S = "I love DynamoDB" }
  })
}

resource "aws_dynamodb_table_item" "cognito_1" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "cognito" }
    NoteId = { N = "1" }
    Note   = { S = "DynamoDB is managed by AWS" }
  })
}

resource "aws_dynamodb_table_item" "cognito_2" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = "UserId"
  range_key  = "NoteId"

  item = jsonencode({
    UserId = { S = "cognito" }
    NoteId = { N = "2" }
    Note   = { S = "DynamoDB offers low latency read and write operations" }
  })
}
