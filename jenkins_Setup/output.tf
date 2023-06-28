output "ec2_public_ip" {
  value = aws_instance.jenkin_server.public_ip
}