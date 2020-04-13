output "rds_wordpress_endpoint" {
  value = aws_db_instance.wordpress.address
}
