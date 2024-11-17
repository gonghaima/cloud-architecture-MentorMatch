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

resource "aws_api_gateway_resource" "user_search_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users-search"
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

resource "aws_api_gateway_method" "list_users_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_search_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "delete_user_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.user_id_resource.id
  http_method   = "DELETE"
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

resource "aws_api_gateway_integration" "lambda_list_users_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_search_resource.id
  http_method = aws_api_gateway_method.list_users_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.list_users.invoke_arn
}

resource "aws_api_gateway_integration" "lambda_delete_user_integration" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.user_id_resource.id
  http_method = aws_api_gateway_method.delete_user_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.delete_user.invoke_arn
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

resource "aws_lambda_permission" "api_gateway_list_users" {
  statement_id  = "AllowAPIGatewayInvokeListUsers"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.list_users.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_gateway_delete_user" {
  statement_id  = "AllowAPIGatewayInvokeDeleteUser"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete_user.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.get_user_method,
    aws_api_gateway_method.create_user_method,
    aws_api_gateway_method.update_user_method,
    aws_api_gateway_method.list_users_method,
    aws_api_gateway_method.delete_user_method,
    aws_api_gateway_method.options_user_method,
    aws_api_gateway_method.options_user_id_method,
    aws_api_gateway_integration.lambda_get_user_integration,
    aws_api_gateway_integration.lambda_create_user_integration,
    aws_api_gateway_integration.lambda_update_user_integration,
    aws_api_gateway_integration.lambda_list_users_integration,
    aws_api_gateway_integration.lambda_delete_user_integration,
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