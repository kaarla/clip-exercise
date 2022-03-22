output "ec2-public-dns" {
  value = aws_instance.public-ec2.public_dns
}

output "ec2-public-private-ip" {
  value = aws_instance.public-ec2.private_ip
}

output "db-address" {
  value = aws_db_instance.default.address
}
