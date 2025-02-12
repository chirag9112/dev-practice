provider "aws" {
  region = "us-east-1" 
}

resource "aws_instance" "website" {
  ami           = "ami-04b4f1a9cf54c11d0"  
  instance_type = "t2.micro"              
  key_name      = "chirag_rsa"      

  security_groups = [aws_security_group.sg.name]  

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y httpd
    sudo systemctl start httpd
    sudo systemctl enable httpd
    echo "<h1>Welcome to Terraform</h1>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "Terraform-Instance"
  }
}

resource "aws_security_group" "sg" {
  name        = "sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH from any IP (Not secure, restrict it in production)
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP from any IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}