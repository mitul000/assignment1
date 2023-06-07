#----------------------------------------------------------
# CLO835 - Assignment 1
#
# Build EC2 Instances
#
#----------------------------------------------------------

provider "aws" {
  region = "us-east-1"
}


# Create a new VPC 
resource "aws_default_vpc" "default" {
  tags = {
    Name = "default vpc"
  }
}


# provisioning a public subnet in the default VPC
# resource "aws_subnet" "subnet1" {
#   vpc_id            = aws_default_vpc.default.id
#   cidr_block        = "172.31.128.0/20"
#   availability_zone = "us-east-1a"
#   map_public_ip_on_launch = true

#   tags = {
#     Name = "Assignment1 Subnet"
#   }
# }

# security group creation
resource "aws_security_group" "sg_ec2" {
  name        = "security-group-ec2"
  description = "Assignment 1 Security group"

  vpc_id = aws_default_vpc.default.id

  ingress {
    description = "HTTP from everywhere"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from everywhere"
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP from everywhere"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from everywhere"
    from_port   = 22
    to_port     = 22
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


resource "aws_ecr_repository" "web_appplication_repository" {
  name         = "assignment1-webapp"
  force_delete = true
}

resource "aws_ecr_repository" "database_repository" {
  name         = "assignment1-database"
  force_delete = true
}

resource "aws_key_pair" "key_pair" {
  key_name   = "my-key-pair-assignment"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "ec2_linux" {
  ami                         = "ami-0715c1897453cabd1"
  key_name                    = aws_key_pair.key_pair.key_name
  instance_type               = "t2.micro"
  subnet_id                   = "subnet-09a88717094a8bde5"
  security_groups             = [aws_security_group.sg_ec2.id]
  associate_public_ip_address = true
  tags = {
    Name = "My Linux VM Instance"
  }
}