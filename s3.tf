resource "aws_s3_bucket" "website_images" {
  bucket = "your-unique-bucket-name-website-images"
}

resource "aws_s3_bucket_website_configuration" "website_images" {
  bucket = aws_s3_bucket.website_images.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "website_images_public_access_block" {
  bucket = aws_s3_bucket.website_images.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket" "user_profile_images" {
  bucket = "your-unique-bucket-name-user-profile-images"
}

resource "aws_s3_bucket_public_access_block" "user_profile_images_public_access_block" {
  bucket = aws_s3_bucket.user_profile_images.id

  block_public_acls   = false
  block_public_policy = false
  ignore_public_acls  = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "website_images_policy" {
  bucket = aws_s3_bucket.website_images.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "AWS": "${aws_cloudfront_origin_access_identity.website_images_origin_access_identity.iam_arn}"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.website_images.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website_images_public_access_block]
}

resource "aws_s3_bucket_policy" "user_profile_images_policy" {
  bucket = aws_s3_bucket.user_profile_images.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          "AWS": "${aws_cloudfront_origin_access_identity.user_profile_images_origin_access_identity.iam_arn}"
        },
        Action = "s3:GetObject",
        Resource = "${aws_s3_bucket.user_profile_images.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.user_profile_images_public_access_block]
}