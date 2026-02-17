############################################
# Providers (Two Regions)
############################################

provider "aws" {
  alias  = "mumbai"
  region = "ap-south-1"
}

provider "aws" {
  alias  = "hyderabad"
  region = "ap-south-2"
}

############################################
# Security Group - ap-south-1
############################################

resource "aws_security_group" "sg_mumbai" {
  provider = aws.mumbai
  name     = "nginx-sg-mumbai"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
# Security Group - ap-south-2
############################################

resource "aws_security_group" "sg_hyderabad" {
  provider = aws.hyderabad
  name     = "nginx-sg-hyderabad"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

############################################
# EC2 - ap-south-1
############################################

resource "aws_instance" "mumbai_ec2" {
  provider        = aws.mumbai
  ami             = "ami-0317b0f0a0144b137"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.sg_mumbai.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "Hello from ap-south-1" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Nginx-ap-south-1"
  }
}

############################################
# EC2 - ap-south-2
############################################

resource "aws_instance" "hyderabad_ec2" {
  provider        = aws.hyderabad
  ami             = "ami-01cfb0266fc955899"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.sg_hyderabad.name]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install nginx -y
              systemctl start nginx
              systemctl enable nginx
              echo "Hello from ap-south-2" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "Nginx-ap-south-2"
  }
}

############################################
# Outputs
############################################

output "ap_south_1_public_ip" {
  value = aws_instance.mumbai_ec2.public_ip
}

output "ap_south_2_public_ip" {
  value = aws_instance.hyderabad_ec2.public_ip
}