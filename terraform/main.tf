provider "aws" {
  region = "your_aws_region"
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"  # Ubuntu Server 20.04 LTS AMI
  instance_type = "t2.micro"
  key_name      = "your_key_pair_name"

  security_group = aws_security_group.web_sg.id

  tags = {
    Name = "web-server-instance"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Security group for web server instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "rds_database" {
  identifier            = "mydbinstance"
  allocated_storage     = 20
  storage_type          = "gp2"
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  name                  = "mydatabase"
  username              = "admin"
  password              = "password"

  vpc_security_group_ids = [aws_security_group.rds_sg.id]

  parameter_group_name = "default.mysql5.7"

  tags = {
    Name = "rds-database-instance"
  }
}

resource "aws_security_group" "rds_sg" {
  name        = "rds-sg"
  description = "Security group for RDS database instance"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_group_names = [aws_security_group.web_sg.name]
  }
}
