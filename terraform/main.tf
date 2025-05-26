provider "aws" {
  region = var.region
}

resource "aws_dynamodb_table" "Products" {
  name         = var.product_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "userId"

  attribute {
    name = "userId"
    type = "S"
  }

}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
  name   = "lambda_dynamo_policy"
  role   = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:Scan",
          "dynamodb:GetItem"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_function" "list_products" {
  function_name = "list-products"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "listProducts.handler"
  runtime       = "nodejs18.x"
  filename      = "../dist/list_products.zip"
  source_code_hash = filebase64sha256("../dist/list_products.zip")
  timeout       = 10

  environment {
    variables = {
      TABLE_NAME = var.product_table_name
    }
  }
}

