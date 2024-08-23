resource "aws_acm_certificate" "cert" {
  domain_name       = "*.ozzy-dev.com"
  validation_method = "DNS"

  tags = {
    Environment = "test" 
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "public" {
    name         = "ozzy-dev.com"
    private_zone = false
}

resource "aws_route53_record" "route53" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public.zone_id
}

resource "aws_acm_certificate_validation" "cert-validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.route53 : record.fqdn]
}
# resource "aws_route53_health_check" "route53hc" {
#   fqdn              = "ozzy-dev.com"
#   port              = 80
#   type              = "HTTP"
#   resource_path     = "/"
#   failure_threshold = "5"
#   request_interval  = "30"

#   tags = {
#     Name = "tf-health-check"
#   }
# }
