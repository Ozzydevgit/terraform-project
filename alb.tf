resource "aws_lb" "main" {
  name               = "main-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http.id]
  subnets            = [for subnet in aws_subnet.public_subnets : subnet.id]

  enable_deletion_protection = false

#   access_logs {
#     bucket  = aws_s3_bucket.lb_logs.id
#     prefix  = "test-lb"
#     enabled = true
#   }

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "main" {
  name     = "main-lb-tf"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

 resource "aws_autoscaling_attachment" "asg_attachment" {
    autoscaling_group_name = aws_autoscaling_group.main.name
    lb_target_group_arn   = aws_lb_target_group.main.arn
}

# resource "aws_route53_record" "www" {
#   zone_id = data.aws_route53_zone.public.zone_id
#   name    = "web.ozzy-dev.com"
#   type    = "A"

#   alias {
#     name = aws_lb.main.dns_name
#     zone_id = aws_lb.main.zone_id
#     evaluate_target_health = false
#   }
# }
