data "aws_ami" "amazonlinux2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["137112412989"]
}

resource "aws_instance" "default_wordpress" {
  ami                    = data.aws_ami.amazonlinux2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.main["public-a"].id
  vpc_security_group_ids = [aws_security_group.ec2_instance.id]
  user_data              = file("wordpress_installation.txt")

  associate_public_ip_address = true

  tags = {
    Name = "${var.project_key}-wordpress"
  }
}
