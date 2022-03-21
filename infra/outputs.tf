output "ec2_instance_id" {
  description = "ec2 ID"
  value       = aws_instance.ec2.id
}

output "db_instance_id" {
  description = "db instance id"
  value       = aws_db_instance.default.id
}

output "vpc_id" {
  description = "db instance id"
  value       = aws_vpc.main.id
}

output "db_endpoint" {
  description = "database endpoint, address:port"
  value       = aws_db_instance.default.endpoint
}

output "db_address" {
  description = "database address"
  value       = aws_db_instance.default.address
}

output "db_port" {
  description = "database port"
  value       = aws_db_instance.default.port
}
