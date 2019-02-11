
variable "region" {
  default = "us-east-1"
}

variable "tags" {
    default = {
    "owner"        = "Somebody"
    "environment"  = "prod"
    "service"      = "productname"
    "component"    = "website"
    "terraform"    = "true"
  }
}

variable "cloudfront_fqdns" {
  type = "list"
  default = ["mywebsite.mydomain.com"]
}

variable "caa_map" {
  default = {
    "mywebsite.mydomain.com"   = "amazon.com"
    "www.mydomain.com"         = "amazon.com"
  }
}


variable "ssl_certificate_domain" {
  type = "map" 
  default = {
    "mywebsite.mydomain.com" = "mywebsite.mydomain.com"
    "www.mydomain.com"      = "*.mydomain.com"
  }
}

variable "domain_zone_name" {
  default = "mydomain.com"
}

variable "service_name" {
    default = "productname"
}

