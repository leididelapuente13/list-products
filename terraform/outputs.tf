output "list_products_arn" {
  description = "Base URL of list_products lambda"
  value       = "aws_lambda_function.list_products.invoke_arn"
}
