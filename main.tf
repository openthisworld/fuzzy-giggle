provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "web_server_ip" {
  instance = aws_instance.web_server.id
  vpc      = true
}

resource "aws_eip_association" "web_server_ip_ass" {
  instance_id = aws_instance.web_server.id
  allocation_id = aws_eip.web_server_ip.id
}

resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main_subnet" {
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "sg_website" {
  name        = "sg_website"
  vpc_id = aws_vpc.main_vpc.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web_server" {
  ami = "ami-0ff8a91507f77f867"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main_subnet.id
  vpc_security_group_ids = [aws_security_group.sg_website.id]
  depends_on = [aws_security_group.sg_website]
  associate_public_ip_address = false
  #private_ip = aws_eip.web_server_ip.private_ip
}

output "elastic_ip" {
  value = aws_eip.web_server_ip.public_ip
}