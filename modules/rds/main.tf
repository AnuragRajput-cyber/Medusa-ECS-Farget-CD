resource "aws_security_group" "rds" {
  name        = "medusa-rds-sg"
  description = "Allow traffic from ECS to RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.ecs_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "medusa-rds-sg"
  }
}

resource "aws_db_subnet_group" "main" {
  name       = "medusa-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "medusa-db-subnet-group"
  }
}

resource "aws_db_instance" "main" {
  identifier             = "medusa-db"
  engine                 = "postgres"
  engine_version         = "17.4"
  instance_class         = var.db_instance_class
  allocated_storage      = 20
  storage_type           = "gp2"
  db_name                = "medusa"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  multi_az               = var.db_multi_az

  tags = {
    Name = "medusa-db"
  }
}