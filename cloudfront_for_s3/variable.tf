variable "s3_metric_filter_name" {
    type = "string"
    description = "The filter used to check website files only."
}

variable "bucket_name" {
    type = "string"
}

variable "clouldfront_is_enabled" {
  default = true
}

variable "cloudfront_ipv6_enabled" {
  default = true
}

variable "cloudfront_frontend_type" {
    default = "sni-only"
}

variable "cloudfront_acm_certificate_domain" {
  type = "map"
}

variable "cloudfront_default_root_object" {
  default   = "index.htm"
}

variable "cloudfront_price_class" {
  default   = "PriceClass_All"
}

variable "cloudfront_minimum_tls_protocol_version" {
  default   = "TLSv1.2_2018"
}

variable "cloudfront_default_allowed_http_methods" {
  type      = "list"
  default   = ["GET", "HEAD", "OPTIONS"]  
}

variable "cloudfront_default_cached_methods" {
  type      = "list"
  default   = ["GET", "HEAD", "OPTIONS"]
}

variable "cloudfront_default_min_ttl" {
  default = 300
}

variable "cloudfront_default_default_ttl" {
  default = 3600
}

variable "cloudfront_default_max_ttl" {
  default = 86400
}

variable "cloudfront_geo_restriction_type" {
  default = "none"
}

variable "cloudfront_gro_restriction_locations" {
    type    = "list"
    default = []
}

#Route53
variable "cloudfront_fqdns" {
  type = "list"
}

variable "route53_zone_name" {
  type = "string"
}

variable "tags" {
  type = "map"
}

variable "cloudfront_default_403_page" {
  description = "Path to 403 Page."
  default     = "/errors/403.htm"
}

variable "cloudfront_default_404_page" {
  description = "Path to 404 Page."
  default     = "/errors/404.htm"
}

variable "cors_allowed_origins" {
  default = "*"
}

variable "cors_allowed_http_methods" {
  type      = "list"
  default   = ["GET", "HEAD"]
}

variable "certificationa_authority_authorization" {
  description = "Map of Certificates and CAAs." 
  type        = "map"
}
