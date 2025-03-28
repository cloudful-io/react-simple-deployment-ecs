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

