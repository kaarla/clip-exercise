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
