terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.70.0"
    }
  }
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "website-bucket" {
    bucket = "kindlebitwebsiteddd"
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
    bucket = aws_s3_bucket.website-bucket.id
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false  
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.website-bucket.id
  policy = jsonencode(
    {
     Version = "2012-10-17",
     Statement = [
        {
             Sid ="PublicReadGetObject",
             Effect = "Allow",
             Principal ="*",
             Action = "s3:GetObject",
             Resource = "arn:aws:s3:::${aws_s3_bucket.website-bucket.id}/*"
        }
    ]
}
  )
}

resource "aws_s3_bucket_website_configuration" "mywebapp" {
  bucket = aws_s3_bucket.website-bucket.id

  index_document {
    suffix = "index.html"
  }

}

resource "aws_s3_object" "index_html" {
    bucket = aws_s3_bucket.website-bucket.bucket
    source = "./index.html"
    key = "index.html"
    content_type = "text/html"
  
}

output "bucket_url" {
  value = aws_s3_bucket_website_configuration.mywebapp.website_endpoint
}