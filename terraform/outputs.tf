# Output Values
output "s3_bucket_name" {
  value = module.s3-bucket.id
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.cloudfront-distribution.id
}

output "iam_access_key" {
  value     = aws_iam_access_key.github_deploy_key.id
  sensitive = true 
}

output "iam_secret_key" {
  value     = aws_iam_access_key.github_deploy_key.secret
  sensitive = true
} 