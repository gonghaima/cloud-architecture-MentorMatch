resource "aws_dynamodb_table" "user_table" {
  name           = "User"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user"

  attribute {
    name = "user"
    type = "S"
  }
}

resource "aws_dynamodb_table" "subject_table" {
  name           = "Subject"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "key"

  attribute {
    name = "key"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "subject_math" {
  table_name = aws_dynamodb_table.subject_table.name
  hash_key   = "key"
  item = <<ITEM
{
  "key": {"S": "math"},
  "value": {"L": [{"S": "Math"}]}
}
ITEM
}

resource "aws_dynamodb_table_item" "subject_english" {
  table_name = aws_dynamodb_table.subject_table.name
  hash_key   = "key"
  item = <<ITEM
{
  "key": {"S": "english"},
  "value": {"L": [{"S": "English"}]}
}
ITEM
}

resource "aws_dynamodb_table_item" "subject_computing" {
  table_name = aws_dynamodb_table.subject_table.name
  hash_key   = "key"
  item = <<ITEM
{
  "key": {"S": "computing"},
  "value": {"L": [{"S": "Computing"}]}
}
ITEM
}

resource "aws_dynamodb_table_item" "subject_physics" {
  table_name = aws_dynamodb_table.subject_table.name
  hash_key   = "key"
  item = <<ITEM
{
  "key": {"S": "physics"},
  "value": {"L": [{"S": "Physics"}]}
}
ITEM
}