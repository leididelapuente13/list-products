resource "aws_lambda_function" "list_products" {
  function_name = "list-products"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "src/handlers/listProducts.listProducts"
  runtime       = "nodejs18.x"
  filename      = "function.zip"
  source_code_hash = filebase64sha256("function.zip")
}

# resource "aws_api_gateway_method" "list" {
#   rest_api_id   = aws_api_gateway_rest_api.api.id
#   resource_id   = aws_api_gateway_resource.products.id
#   http_method   = "GET"
#   authorization = "NONE"
#   integration {
#     type             = "AWS_PROXY"
#     integration_http_method = "POST"
#     uri              = aws_lambda_function.list_products.invoke_arn
#   }
# }
