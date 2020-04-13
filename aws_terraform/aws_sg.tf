# Security Groups
resource "aws_security_group" "ec2_instance" {
  name        = "${var.project_key}-ec2"
  description = "WordPress Instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP from My IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_key}-ec2"
  }
}