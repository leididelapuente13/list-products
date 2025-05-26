variable "region" {
  description = "AWS region to deploy to"
  type        = string
  default     = "us-west-1"
}

variable "product_table_name" {
  description = "DynamoDB table name for products"
  type        = string
  default     = "Products"
}

