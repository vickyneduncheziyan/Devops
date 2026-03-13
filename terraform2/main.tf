resource "aws_instance" "mumbai_ec2" {
  provider      = aws.mumbai
  ami           = "ami-0f559c3642608c138"
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "Mumbai-Nginx-Server"
  }
}

resource "aws_instance" "hyderabad_ec2" {
  provider      = aws.hyderabad
  ami           = "ami-022062aacfecac5bd"
  instance_type = "t3.micro"

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install nginx -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "Hyderabad-Nginx-Server"
  }
}