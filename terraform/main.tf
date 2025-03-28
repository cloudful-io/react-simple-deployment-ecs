module "s3-bucket" { 
    source = "github.com/cloudful-io/terraform-aws-s3"
  
    bucket_name                   = "cloudful-react-deployment-s3"
    static_website_hosting        = false
    block_public_access           = true
    create_kms_key                = false
    enforce_encryption_in_transit = false
    logging_bucket_name           = "cloudful-react-deployment-s3-logs"
}

resource "aws_cloudfront_origin_access_control" "origin-access-control" {
  name                              = module.s3-bucket.bucket_regional_domain_name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Create CloudFront Distribution
resource "aws_cloudfront_distribution" "cloudfront-distribution" { 
  origin {
    domain_name = module.s3-bucket.bucket_regional_domain_name
    origin_id   = "S3-${module.s3-bucket.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.origin-access-control.id
  }

  default_root_object = "index.html"
  enabled = true

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${module.s3-bucket.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = module.s3-bucket.id
  policy = jsonencode({
    Version = "2008-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal",
        Effect    = "Allow",
        Principal = { Service = "cloudfront.amazonaws.com" },
        Action    = "s3:GetObject",
        Resource  = "${module.s3-bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.cloudfront-distribution.arn
          }
        }
      }
    ]
  })
}

# IAM User for GitHub Actions
resource "aws_iam_user" "github_deploy_user" {
  name = "github-deploy-user"
}

# IAM Policy for S3 and CloudFront
resource "aws_iam_policy" "s3_cloudfront_policy" {
  name        = "S3CloudFrontDeployPolicy"
  description = "Allows deployment to S3 and CloudFront cache invalidation"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject", "s3:DeleteObject", "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = ["${module.s3-bucket.arn}", "${module.s3-bucket.arn}/*"]
      },
      {
        Action = [
          "cloudfront:CreateInvalidation"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Attach IAM Policy to User
resource "aws_iam_user_policy_attachment" "attach_policy" {
  user       = aws_iam_user.github_deploy_user.name
  policy_arn = aws_iam_policy.s3_cloudfront_policy.arn
}

# Generate IAM Access Key
resource "aws_iam_access_key" "github_deploy_key" {
  user = aws_iam_user.github_deploy_user.name
}

