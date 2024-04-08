# Output value for the first app server

output "instance_one_public_ip" {
    description = "Public IP address of  AppServerOne"
    
    value = aws_instance.app_server_one.public_ip
}



# Output value for the second  app server
output "instance_two_public_ip" {
    description = "Public IP address of AppServerTwo"
    
    value = aws_instance.app_server_two.public_ip
}




# Output value for the database

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_db_instance.rds_mysql.db_instance_endpoint
}