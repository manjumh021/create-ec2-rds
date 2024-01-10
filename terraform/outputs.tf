output "web_server_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "rds_database_endpoint" {
  value = aws_db_instance.rds_database.endpoint
}
