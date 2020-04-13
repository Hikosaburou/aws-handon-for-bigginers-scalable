# パスワード生成
resource "random_password" "rds_wordpress_admin" {
  length           = 16
  special          = true
  override_special = "_%@"
}

# Parameter Group
# デフォルトも存在するが、DBインスタンス作成時にはまず作成するものと考える。
resource "aws_db_parameter_group" "wordpress" {
  name   = "${var.project_key}-wordpress-pg"
  family = "mysql5.7"
}

# Subnet Group
resource "aws_db_subnet_group" "wordpress" {
  name = "${var.project_key}-wordpress-subnets"
  subnet_ids = [
    aws_subnet.main["private-a"].id,
    aws_subnet.main["private-c"].id
  ]

  tags = {
    Name = "${var.project_key}-wordpress-subnets"
  }
}


# RDS DB Instance
resource "aws_db_instance" "wordpress" {
  # DB機能・性能のせってい
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "5.7.22"
  instance_class    = "db.t2.micro" # ここも変数に出すことが多い

  # マネージド機能の設定
  identifier                 = "${var.project_key}-wordpress-db"
  backup_retention_period    = 1
  auto_minor_version_upgrade = false
  multi_az                   = false

  name                 = "wordpress"
  username             = "admin"
  password             = random_password.rds_wordpress_admin.result
  parameter_group_name = aws_db_parameter_group.wordpress.name
}

# Parameter Store
# DBのパスワードはパラメータストアに暗号化文字列として配置する
resource "aws_ssm_parameter" "rds_password" {
  name  = "/rds/${var.project_key}-wordpress/password"
  type  = "SecureString" # KMSで暗号化して保存
  value = aws_db_instance.wordpress.password
}
