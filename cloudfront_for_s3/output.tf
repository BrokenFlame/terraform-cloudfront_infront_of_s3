#S3 Outputs
output "bucket_region" {
  value = "${aws_s3_bucket.s3_bucket.region}"
}

output "bucket_hosted_zone_id"
{
  value = "${aws_s3_bucket.s3_bucket.id}"
}

output "bucket_domain_name" {
  value = "${aws_s3_bucket.s3_bucket.bucket_domain_name}"
}

output "bucket_arn" {
  value = "${aws_s3_bucket.s3_bucket.arn}"
}

output "bucket_id" {
  value = "${aws_s3_bucket.s3_bucket.id}"
}

#Cloudfront Outputs
output "cloudfront_id" {
    value = "${aws_cloudfront_distribution.s3_distribution.id}"
}
output "cloudfront_arn" {
    value = "${aws_cloudfront_distribution.s3_distribution.arn}"
}
output "cloudfront_caller_reference" {
    value = "${aws_cloudfront_distribution.s3_distribution.caller_reference}"
}
output "cloudfront_status" {
    value = "${aws_cloudfront_distribution.s3_distribution.status}"
}
output "cloudfront_active_trusted_signers" {
    value = "${aws_cloudfront_distribution.s3_distribution.active_trusted_signers}"
}
output "cloudfront_domain_name" {
    value = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
}
output "cloudfront_last_modified_time" {
    value = "${aws_cloudfront_distribution.s3_distribution.last_modified_time}"
}
output "cloudfront_in_progress_validation_batches" {
    value = "${aws_cloudfront_distribution.s3_distribution.in_progress_validation_batches}"
}
output "cloudfront_etag" {
    value = "${aws_cloudfront_distribution.s3_distribution.etag}"
}
output "cloudfront_hosted_zone_id" {
    value = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
}

#Route53
output "route53_name" {
    value = "${aws_route53_record.domain_record.*.name}"
}

output "route53_fqdn" {
    value = "${aws_route53_record.domain_record.*.fqdn}"
}