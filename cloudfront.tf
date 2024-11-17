resource "aws_cloudfront_distribution" "website_images_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_images.bucket_regional_domain_name
    origin_id   = "S3-website-images"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.website_images_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for website images"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-website-images"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_distribution" "user_profile_images_distribution" {
  origin {
    domain_name = aws_s3_bucket.user_profile_images.bucket_regional_domain_name
    origin_id   = "S3-user-profile-images"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.user_profile_images_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for user profile images"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-user-profile-images"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cloudfront_origin_access_identity" "website_images_origin_access_identity" {
  comment = "Origin Access Identity for website images"
}

resource "aws_cloudfront_origin_access_identity" "user_profile_images_origin_access_identity" {
  comment = "Origin Access Identity for user profile images"
}