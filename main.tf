variable "region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.76.0"  # Adjust the version as needed
    }
  }
}

provider "aws" {
  region = var.region
}

data "aws_caller_identity" "current" {}

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
  handler       = "getUser.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "get_user_lambda_function_payload.zip"

  environment {
    variables = {
      USER_TABLE_NAME = aws_dynamodb_table.user_table.name
      SUBJECT_TABLE_NAME = aws_dynamodb_table.subject_table.name
    }
  }
}

resource "aws_lambda_function" "create_user" {
  function_name = "CreateUser"
  handler       = "createUser.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "create_user_lambda_function_payload.zip"

  environment {
    variables = {
      USER_TABLE_NAME = aws_dynamodb_table.user_table.name
    }
  }
}

resource "aws_lambda_function" "update_user" {
  function_name = "UpdateUser"
  handler       = "updateUser.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "update_user_lambda_function_payload.zip"

  environment {
    variables = {
      USER_TABLE_NAME = aws_dynamodb_table.user_table.name
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

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

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_dynamodb_policy" {
  name   = "lambda_dynamodb_policy"
  role   = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:PutItem",
          "dynamodb:GetItem",
          "dynamodb:DeleteItem",
          "dynamodb:UpdateItem"
        ],
        Resource = "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${aws_dynamodb_table.user_table.name}"
      }
    ]
  })
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

resource "aws_api_gateway_method" "create_user_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "update_user_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_id_resource.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_user_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "options_user_id_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_id_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_get_user_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_id_resource.id
  http_method = aws_api_gateway_method.get_user_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.get_user.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_create_user_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_resource.id
  http_method = aws_api_gateway_method.create_user_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.create_user.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_update_user_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_id_resource.id
  http_method = aws_api_gateway_method.update_user_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.update_user.invoke_arn
}

resource "aws_api_gateway_integration" "options_user_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_resource.id
  http_method = aws_api_gateway_method.options_user_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_integration" "options_user_id_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_id_resource.id
  http_method = aws_api_gateway_method.options_user_id_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = "{\"statusCode\": 200}"
  }
}

resource "aws_api_gateway_method_response" "options_user_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_resource.id
  http_method = aws_api_gateway_method.options_user_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_method_response" "options_user_id_method_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_id_resource.id
  http_method = aws_api_gateway_method.options_user_id_method.http_method
  status_code = "200"

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true
    "method.response.header.Access-Control-Allow-Methods" = true
    "method.response.header.Access-Control-Allow-Origin"  = true
  }
}

resource "aws_api_gateway_integration_response" "options_user_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_resource.id
  http_method = aws_api_gateway_method.options_user_method.http_method
  status_code = "200"

  depends_on = [aws_api_gateway_integration.options_user_integration]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_api_gateway_integration_response" "options_user_id_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_id_resource.id
  http_method = aws_api_gateway_method.options_user_id_method.http_method
  status_code = "200"

  depends_on = [aws_api_gateway_integration.options_user_id_integration]

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
    "method.response.header.Access-Control-Allow-Methods" = "'GET,POST,OPTIONS'"
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }

  response_templates = {
    "application/json" = ""
  }
}

resource "aws_lambda_permission" "api_gateway_get_user" {
  statement_id  = "AllowAPIGatewayInvokeGetUser"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_user.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_create_user" {
  statement_id  = "AllowAPIGatewayInvokeCreateUser"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_user.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_update_user" {
  statement_id  = "AllowAPIGatewayInvokeUpdateUser"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.update_user.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.get_user_method,
    aws_api_gateway_method.create_user_method,
    aws_api_gateway_method.update_user_method,
    aws_api_gateway_method.options_user_method,
    aws_api_gateway_method.options_user_id_method,
    aws_api_gateway_integration.lambda_get_user_integration,
    aws_api_gateway_integration.lambda_create_user_integration,
    aws_api_gateway_integration.lambda_update_user_integration,
    aws_api_gateway_integration.options_user_integration,
    aws_api_gateway_integration.options_user_id_integration
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api.id
  stage_name    = "prod"
}

output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.api_stage.stage_name}"
}