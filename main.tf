terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.16"
        }
    }
    
    required_version = ">= 1.2.0"
}

provider "aws" {
    region = "us-east-1"
}




resource "aws_vpc" "hw_vpc"{
    cidr_block = "10.0.0.0/16"
    tags = {
        Name = "TF HW VPC"
    }
}

resource "aws_subnet" "subnet_pub01"{
    vpc_id = aws_vpc.hw_vpc.id
    cidr_block = "10.0.101.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "us-east-1a"
    tags = {
        Name = "aws-subnet-pub01"
        }
    
}

resource "aws_subnet" "subnet_priv01"{
    vpc_id = aws_vpc.hw_vpc.id
    cidr_block = "10.0.102.0/24"
    availability_zone = "us-east-1a"
    tags = {
        Name = "aws_subnet_priv01"
        }
    
}

resource "aws_subnet" "subnet_pub02"{
    vpc_id = aws_vpc.hw_vpc.id
    cidr_block = "10.0.201.0/24"
    availability_zone = "us-east-1b"
    tags = {Name = "aws_subnet_pub02"
    }
}

resource "aws_subnet" "subnet_priv02"{
    vpc_id = aws_vpc.hw_vpc.id
    cidr_block = "10.0.202.0/24"
    availability_zone = "us-east-1b"
    tags = {Name = "aws_subnet_priv02"
    }
}


resource "aws_instance" "app_server_one" {
    ami = "ami-0c101f26f147fa7fd"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.subnet_pub01.id
    security_groups = ["aws_security_group.hw_web_security_group.id"]
    tags = {
        Name = "var.instance1_name"
    }
}


resource "aws_instance" "app_server_two" {
    ami = "ami-0c101f26f147fa7fd"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.subnet_pub02.id
    security_groups = ["aws_security_group.hw_web_security_group.id"]
    tags = {
        Name = "var.instance2_name"
    }
}


resource "aws_db_subnet_group" "db_subnet"{
    name = "db_priv_subnets"
    subnet_ids = [aws_subnet.subnet_priv01.id, aws_subnet.subnet_priv02.id]
    
    tags = {
        Name = "Database Priv Subnets"
    }
}


resource "aws_db_instance" "rds_mysql" {
  allocated_storage    = 10
  db_name              = "tfhomeworkdb"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "seis616"
  password             = "seis616spring2024"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
  vpc_security_group_ids = ["aws_security_group.hw_db_security_group.id"]
}



resource "aws_security_group" "hw_web_security_group" {
  name        = "hw_security_group"
  description = "Allow port 80 to web servers"
  vpc_id      = aws_vpc.hw_vpc.id
  tags = {
    Name = "Web Security Group"
  }

    
  ingress {
      description   = "Allow port 80 to web servers"
      from_port     = 80
      to_port       = 80
      protocol      = "tcp"
      cidr_blocks    = ["0.0.0.0/0"]
  }  
    
}

resource "aws_security_group" "hw_db_security_group" {
  name        = "hw_security_group"
  description = "Allow port 3306 to db servers"
  vpc_id      = aws_vpc.hw_vpc.id
  tags = {
    Name = "Database Security Group"
  }

    
  ingress {
      description   = "Allow port 3306 to db servers"
      from_port     = 3306
      to_port       = 3306
      protocol      = "tcp"
      cidr_blocks    = ["10.0.0.0/16"]
  }  
  egress {
      description   = "Allow port 3306 to db servers"
      from_port     = 3306
      to_port       = 3306
      protocol      = "tcp"
      cidr_blocks    = ["0.0.0.0/0"]
  }     
}




