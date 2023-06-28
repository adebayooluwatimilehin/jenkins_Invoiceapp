resource "aws_vpc" "my_vpc" {
  cidr_block       = "10.0.0.0/16"

  tags = {
    Name = "my_vpc"
  }
}
resource "aws_subnet" "subnet-1" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "subnet 1"
  }
}

resource "aws_default_security_group" "my-sg" {
  vpc_id = aws_vpc.my_vpc.id
  ingress {
    description = "Allows ssh" 
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allows jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my_sg_rule"
  }
}

resource "aws_internet_gateway" "my_gw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_gw"
  }
}

resource "aws_default_route_table" "my_rtb" {
  default_route_table_id = aws_vpc.my_vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_gw.id
  }
  tags = {
    Name = "my_rtb"
  }
}