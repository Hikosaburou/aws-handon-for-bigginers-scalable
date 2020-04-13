# Security Groups

# For WordPress Instnace
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

  ingress {
    description = "SSH from My IP"
    from_port   = 22
    to_port     = 22
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

# For RDS
resource "aws_security_group" "rds_instance" {
  name        = "${var.project_key}-rds"
  description = "RDS MySQL DB Instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from WordPress Instance"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_instance.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_key}-rds"
  }
}
