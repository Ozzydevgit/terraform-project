resource "aws_autoscaling_group" "main" { 
  vpc_zone_identifier       = [for subnet in aws_subnet.public_subnets : subnet.id]  
  desired_capacity   = 2
  max_size           = 2
  min_size           = 2

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
}

resource "aws_lb_listener" "front_end" {
    load_balancer_arn = aws_lb.main.arn 
    port = "80"
    protocol = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.main.arn
    }
}


# resource "aws_lb_listener" "front_end" {
#     load_balancer_arn = aws_lb.main.arn 
#     port = "443"
#     protocol = "HTTPS"
#     ssl_policy = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#     certificate_arn = aws_acm_certificate.cert.arn

#     default_action {
#         type = "forward"
#         target_group_arn = aws_lb_target_group.main.arn
#     }
# }