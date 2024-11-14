provider "aws" {
  region = "ap-southeast-2"
}

resource "aws_dynamodb_table" "user_table" {
  name           = "User"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "user"

  attribute {
    name = "user"
    type = "S"
  }

  attribute {
    name = "role"
    type = "S"
  }

  attribute {
    name = "username"
    type = "S"
  }

  attribute {
    name = "password"
    type = "S"
  }

  attribute {
    name = "address"
    type = "S"
  }

  attribute {
    name = "postcode"
    type = "S"
  }

  attribute {
    name = "offering"
    type = "SS"
  }

  attribute {
    name = "studying"
    type = "SS"
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

  attribute {
    name = "value"
    type = "S"
  }
}

resource "aws_dynamodb_table_item" "subject_math" {
  table_name = aws_dynamodb_table.subject_table.name
  hash_key   = "key"
  item = <<ITEM
{
  "key": {"S": "math"},
  "value": {"S": "Math"}
}
ITEM
}

resource "aws_dynamodb_table_item" "subject_english" {
  table_name = aws_dynamodb_table.subject_table.name
  hash_key   = "key"
  item = <<ITEM
{
  "key": {"S": "english"},
  "value": {"S": "English"}
}
ITEM
}

resource "aws_dynamodb_table_item" "subject_computing" {
  table_name = aws_dynamodb_table.subject_table.name
  hash_key   = "key"
  item = <<ITEM
{
  "key": {"S": "computing"},
  "value": {"S": "Computing"}
}
ITEM
}

resource "aws_dynamodb_table_item" "subject_physics" {
  table_name = aws_dynamodb_table.subject_table.name
  hash_key   = "key"
  item = <<ITEM
{
  "key": {"S": "physics"},
  "value": {"S": "Physics"}
}
ITEM
}

resource "aws_lambda_function" "get_user" {
  function_name = "GetUser"
  handler       = "index.handler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "lambda_function_payload.zip"

  environment {
    variables = {
      USER_TABLE_NAME = aws_dynamodb_table.user_table.name
      SUBJECT_TABLE_NAME = aws_dynamodb_table.subject_table.name
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_api_gateway_rest_api" "api" {
  name        = "UserAPI"
  description = "API for user management"
}

resource "aws_api_gateway_resource" "user_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_resource" "user_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_resource.user_resource.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "get_user_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_id_resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_id_resource.id
  http_method = aws_api_gateway_method.get_user_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.get_user.invoke_arn
}

resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_user.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}