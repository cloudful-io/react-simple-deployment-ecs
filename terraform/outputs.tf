# Output Values
output "s3_bucket_name" {
  value = module.s3-bucket.id
}

output "cloudfront_distribution_url" {
  value = aws_cloudfront_distribution.cloudfront-distribution.domain_name
}