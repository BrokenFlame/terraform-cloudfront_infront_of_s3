This is for static websites. It is deployed to a single region (US-East-1) behind CloudFront.

Adjust variables and main.tf as required.

Remember to configure an SSL Certificate for your domain before hand in AWS Certificate Manager, and to use the corrisponding domain as the first domain in the list for variable "cloudfront_fqdns".