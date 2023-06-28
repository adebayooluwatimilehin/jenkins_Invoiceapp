data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical owner ID for Ubuntu AMIs
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "jenkin_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.small"
  key_name                    = "terraform_key"
  subnet_id                   = aws_subnet.subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.my-sg.id]
  availability_zone           = "us-east-1a"
  associate_public_ip_address = true
  user_data                   = file("jenkins_script.sh")
  tags = {
    Name = "jenkin-server"
  }
}
