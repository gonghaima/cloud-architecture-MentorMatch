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

resource "aws_lambda_function" "list_users" {
  function_name = "ListUsers"
  handler       = "listUsers.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "list_users_lambda_function_payload.zip"

  environment {
    variables = {
      USER_TABLE_NAME = aws_dynamodb_table.user_table.name
    }
  }
}

resource "aws_lambda_function" "delete_user" {
  function_name = "DeleteUser"
  handler       = "deleteUser.handler"
  runtime       = "nodejs18.x"
  role          = aws_iam_role.lambda_exec.arn
  filename      = "delete_user_lambda_function_payload.zip"

  environment {
    variables = {
      USER_TABLE_NAME = aws_dynamodb_table.user_table.name
    }
  }
}