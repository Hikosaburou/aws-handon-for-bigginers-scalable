# ELB, Listener, Target group 設定

# Application Load Blancer
resource "aws_lb" "wordpress" {
  name               = "${var.project_key}-wordpress"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.elb.id]
  subnets = [
    aws_subnet.main["public-a"].id,
    aws_subnet.main["public-c"].id,
  ]

  enable_deletion_protection = false # 商用環境ならtrueにするべき
}

# ALB Target Group
resource "aws_lb_target_group" "wordpress" {
  name     = "${var.project_key}-wordpress"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/wp-includes/images/blank.gif"
  }
}

resource "aws_lb_target_group_attachment" "wordpress" {
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = aws_instance.default_wordpress.id
  port             = 80
}

# ALB Listener
resource "aws_lb_listener" "wordpress_http" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }
}
