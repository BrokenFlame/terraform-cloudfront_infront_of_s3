module s3websitebehindcloudfront {
    source                                      = "./cloudfront_for_s3"
    s3_metric_filter_name                       = "${var.service_name}"
    bucket_name                                 = "${var.service_name}"
    cloudfront_acm_certificate_domain           = "${var.ssl_certificate_domain}"
    cloudfront_default_root_object              = "index.html"
    cloudfront_default_404_page                 = "/errors/404.html"
    cloudfront_default_403_page                 = "/errors/403.html"
    cloudfront_fqdns                            = ["${var.cloudfront_fqdns}"]
    route53_zone_name                           = "${var.domain_zone_name}"
    tags                                        = "${var.tags}"
    certificationa_authority_authorization      = "${var.caa_map}"
}

resource "aws_s3_bucket_object" "object" {
  count  = "${length(var.filenames)}"
  bucket =  "${module.s3websitebehindcloudfront.bucket_id}"
  key    = "${element(var.filenames, count.index)}"
  source = "./files/${element(var.filenames, count.index)}"
  etag   = "${md5(file("./files/${element(var.filenames, count.index)}"))}"
  tags   = "${var.tags}"
}

#Add files to deploy here... or build a deployment pipeline, your call.
variable "filenames" {
  type = "list"
  default = ["index.html", "errors/404.html", "error/403.html"]
}
