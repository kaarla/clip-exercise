provider "aws" {
  region = "us-west-2"
}

data "aws_region" "current" {}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "kar-vpc"
  }
}

resource "aws_subnet" "ec2_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "kar-ec2-subnet"
  }
}

resource "aws_subnet" "db_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "kar-db-subnet"
  }
}

resource "aws_subnet" "db_subnet1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2c"

  tags = {
    Name = "kar-db-subnet"
  }
}

resource "aws_db_subnet_group" "subnet_group" {
  name       = "kar-database-subnet-group"
  subnet_ids = ["${aws_subnet.db_subnet1.id}","${aws_subnet.db_subnet.id}"]
}

resource "aws_network_interface" "ec2_interface" {
  subnet_id   = aws_subnet.ec2_subnet.id

  tags = {
    Name = "kar-ec2-network-interface"
  }
}

resource "aws_network_interface" "db_interface" {
  subnet_id   = aws_subnet.db_subnet.id

  tags = {
    Name = "kar-db-network-interface"
  }
}

resource "aws_instance" "ec2" {
  ami           = "ami-0d1cd67c26f5fca19" # us-west-2
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.ec2_interface.id
    device_index         = 0
  }

  tags = {
    Name = "kar-EC2"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "kar-main-gateway"
  }
}

resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = "foo"
  password             = "foobarbaz"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  publicly_accessible  = true

  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  vpc_security_group_ids = [ aws_vpc.main.default_security_group_id ]

  tags = {
    Name = "kar-db"
  }

  depends_on = [ aws_internet_gateway.gw ]
}
