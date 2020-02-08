output "prod_url" {
  value = "https://${aws_api_gateway_deployment.this.rest_api_id}.execute-api.${data.aws_region.current.name}.amazonaws.com/${aws_api_gateway_deployment.this.stage_name}"
}