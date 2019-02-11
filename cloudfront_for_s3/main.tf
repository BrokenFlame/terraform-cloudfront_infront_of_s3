resource "aws_s3_bucket" "s3_bucket" {
  bucket                    = "${var.bucket_name}"
  acl                       = "private"

#  logging {
#    target_bucket           = "${aws_s3_bucket.s3_logging_bucket.id}"
#    target_prefix           = "log/s3/"
#  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm       = "AES256"
      }
    }
  }

    cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["${var.cors_allowed_http_methods}"]
    allowed_origins = ["${var.cors_allowed_origins}"]
    expose_headers  = ["ETag"]
    max_age_seconds = "${var.cloudfront_default_max_ttl}"
  }

 # lifecycle_rule {
 #   id      = "log"
 #   enabled = true
 #   prefix = "log/"
 #   tags = {
 #     "rule"      = "log"
 #     "autoclean" = "true"
 #   }
 #   transition {
 #     days          = 30
 #     storage_class = "GLACIER"
 #   }
 #   expiration {
 #     days = 90
 #   }
 # }

  tags                      = "${var.tags}"
}


data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = [
      "${aws_s3_bucket.s3_bucket.arn}/*"
      ]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "${aws_s3_bucket.s3_bucket.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

resource "aws_s3_bucket_metric" "website-filtered" {
  bucket = "${aws_s3_bucket.s3_bucket.bucket}"
  name   = "${var.s3_metric_filter_name}"
}

resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_access_identity" {
  comment = "Origin access identity for ${var.bucket_name}"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = "${aws_s3_bucket.s3_bucket.bucket_regional_domain_name}"
    origin_id   = "${var.bucket_name}-resource-pool"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  enabled             = "${var.clouldfront_is_enabled}"
  http_version        = "http2"
  is_ipv6_enabled     = "${var.cloudfront_ipv6_enabled}"
  comment             = "This is the Cloudfront Distribution for the Bucket ${var.bucket_name}"
  default_root_object = "${var.cloudfront_default_root_object}"
  custom_error_response {
    error_code      = 404
    response_code   = 404 
    response_page_path = "${var.cloudfront_default_404_page}"
    error_caching_min_ttl = 0
  }
  
  custom_error_response {
    error_code      = 403
    response_code   = 403 
    response_page_path = "${var.cloudfront_default_403_page}"
    error_caching_min_ttl = 0
  }

  #logging_config {
  #  include_cookies = false
  #  bucket          = "${aws_s3_bucket.s3_logging_bucket.bucket_regional_domain_name}"
  #  prefix          = "log/cloudfront/"
  #}

  aliases = ["${var.cloudfront_fqdns}"]

  default_cache_behavior {
    allowed_methods  = "${var.cloudfront_default_allowed_http_methods}"
    cached_methods   = "${var.cloudfront_default_cached_methods}"
    target_origin_id = "${var.bucket_name}-resource-pool"

    forwarded_values {
      query_string = false
      headers      = ["Origin"]

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    compress               = "true"
    min_ttl                = "${var.cloudfront_default_min_ttl}"
    default_ttl            = "${var.cloudfront_default_default_ttl}"
    max_ttl                = "${var.cloudfront_default_max_ttl}"
  }

  price_class = "${var.cloudfront_price_class}"

  restrictions {
    geo_restriction {
      restriction_type = "${var.cloudfront_geo_restriction_type}"
      locations        = "${var.cloudfront_gro_restriction_locations}"
    }
  }

  tags = "${var.tags}"

  viewer_certificate {
    acm_certificate_arn             = "${data.aws_acm_certificate.acm_certificate.*.arn[0]}"
    minimum_protocol_version        = "${var.cloudfront_minimum_tls_protocol_version}"
    cloudfront_default_certificate  = "${lookup(var.cloudfront_acm_certificate_domain, 0, false) == "" ? true : false}"
    ssl_support_method              = "${var.cloudfront_frontend_type}"
  }
  depends_on = ["aws_s3_bucket.s3_bucket"]
  
}

data "aws_route53_zone" "hosted_zone" {
    name = "${var.route53_zone_name}"
}

resource "aws_route53_record" "domain_record" {
  count                         = "${length(var.cloudfront_fqdns)}"
  zone_id                       = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name                          = "${var.cloudfront_fqdns[count.index]}"
  type                          = "A"

  alias {
      name                      = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
      zone_id                   = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
      evaluate_target_health    = false
  }
}

resource "aws_route53_record" "CAA_Record" {
  count                         = "${length(var.cloudfront_fqdns)}"
  zone_id                       = "${data.aws_route53_zone.hosted_zone.zone_id}"
  name                          = "${var.cloudfront_fqdns[count.index]}"
  type                          = "CAA"
  ttl                           = "600"
  records                       = ["0 issue \"${var.certificationa_authority_authorization[var.cloudfront_fqdns[count.index]]}\""]
}

data "aws_acm_certificate" "acm_certificate" {
  count           = "${length(var.cloudfront_fqdns)}"
  domain          = "${var.cloudfront_acm_certificate_domain[var.cloudfront_fqdns[count.index]]}"
  statuses        = ["ISSUED"]
  most_recent     = true
}