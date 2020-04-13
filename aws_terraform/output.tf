output "rds_wordpress_endpoint" {
  value = aws_db_instance.wordpress.address
}

output "lb_dns_name" {
  value = aws_lb.wordpress.dns_name
}
