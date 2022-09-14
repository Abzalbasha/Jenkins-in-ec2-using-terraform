locals {
  vpc_id           = "aws_default_vpc.main.id"
  ssh_user         = "ec2-user"
  key_name         = "jenkins"
  private_key_path = "~/Downloads/jenkins.pem"
}

provider "aws"{
    region = "us-east-1"
    access_key = "ASIAWFPJN4VDAO6ONC5V"
    secret_key = "/mZGbubHP1rySyRrUkZ9GW+iSGDVLIzg1GTSKH6X"
    token = "FwoGZXIvYXdzEDQaDLCqZVpzYo/12oS7DSK3AURLUd1Z15W9my8hNlDaOAMd1E2wk474BdeoO9IMGaBp0vI8ILWOoSbwqH3OAXGRqjQwCKoj2anWR6LM1dJ1vS9I++B2AvnQqyJ6h1eDNF4JvmX5+j1/8aeciISXzq606L8+GrvpcK0qy4gfCBelfVVdl9+fvrxhzvY7gPPal9hc6AbTRYEVDPnpd5nhRe6WlQwTBiIabM/XpHHj9XgwbcH1BBhWMtqS1pHWWy1lVIm35eLo2H/yECia4IaZBjItIn31YPqP8jl6IwTqfU5un/dxgLTYdq8jySj2PvrRRQD1zxPNzaHtG2E1X7tS"
}

resource "aws_default_vpc" "main" {
  tags = {
    Name = "main"
  }
}

resource "aws_security_group" "jenkins_security" {
  name        = "jenkins_security"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.main.id

  ingress {
    description      = "innbound rulesfrom VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [aws_default_vpc.main.cidr_block]
  }
  ingress {
    description      = "innbound rules from vpc"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [aws_default_vpc.main.cidr_block]
  }
 ingress {
    description      = "innbound rulesfrom VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_default_vpc.main.cidr_block]
  }
   ingress {
    description      = "innbound rulesfrom VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_default_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jenkins_security"
  }
}
resource "aws_instance" "myec2" {
  ami           = "ami-05fa00d4c63e32376"
  instance_type = "t2.micro"
  security_groups = {jenkins_security.jenkins_security.name}
  ssh_user = "ec2-user"
  key_name = "jenkins"
  private_key_path = "~/Downloads/jenkins.pem"
  tags = {
      Name = "Terraform"
      Department = "cloud-devops"
  }
  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = local.ssh_user
      private_key = file(local.private_key_path)
      host        = aws_instance.myec2.public_ip
    }
  }
  provisioner "local-exec" {
    command = "ansible-playbook  -i ${aws_instance.myec2.public_ip}, --private-key ${local.private_key_path} jenkins.yaml"
  }
}
