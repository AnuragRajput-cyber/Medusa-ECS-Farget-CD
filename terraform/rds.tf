resource "aws_db_subnet_group" "medusa_db_subnets" {
  name       = "medusa-db-subnet-group"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id
  ]
}

resource "aws_db_instance" "medusa_db" {
  allocated_storage    = 20
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = var.DB_password
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.medusa_db_subnets.name
  vpc_security_group_ids = [aws_security_group.medusa_sg.id]
}
