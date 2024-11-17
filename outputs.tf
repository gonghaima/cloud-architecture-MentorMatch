output "website_images_distribution_domain" {
  value = aws_cloudfront_distribution.website_images_distribution.domain_name
}

output "user_profile_images_distribution_domain" {
  value = aws_cloudfront_distribution.user_profile_images_distribution.domain_name
}

output "api_gateway_url" {
  value = "https://${aws_api_gateway_rest_api.api.id}.execute-api.${var.region}.amazonaws.com/${aws_api_gateway_stage.api_stage.stage_name}"
}