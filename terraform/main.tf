resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1b"
}

resource "aws_security_group" "medusa_sg" {
  name   = "ecs_security_group"
  vpc_id = aws_vpc.main
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]

  }
}
resource "aws_db_instance" "meedusa_db" {
  allocated_storage   = 20
  engine              = "postgres"
  instance_class      = db.t3.micro
  username            = "postgres"
  password            = var.DB_password
  skip_final_snapshot = true
}
resource "aws_ecr_repository" "medusaImage_repo" {
  name = "medusa-backend"
}

resource "aws_ecs_cluster" "medusa_Cluster" {
  name = "medusa-cluster"
}
resource "aws_ecs_task_definition" "medusa_task_definition" {
  family                   = "medusa-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"

  container_definitions = jsondecode([
    { name      = "medusa",
      image     = "${aws_ecr_repository.medusaImage_repo.repository_url}:latest"
      essential = true
      portMapping = [
        { containerPort = 9000 }
      ]
      environment = [{
        name  = "DATABASE_URL"
        value = "postgres://postgres:${var.DB_password}@${aws_db_instance.medusa_db.address}:5432/medusadb"
        },
        {
          name  = "JWT_SECRET"
          value = "najfhaofjeoifihafn"
        }
      ]
    }
  ])
}
resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_subnet_2]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.medusa_tg.arn
    container_name   = "medusa"
    container_port   = 9000
  }

  depends_on = [aws_lb_listener.http_listener]
}

resource "aws_lb" "medusa_alb" {
  name               = "medusa-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_subnet_1]
}
resource "aws_lb_target_group" "medusa_tg" {
  name        = "medusa-target-group"
  port        = 9000
  protocol    = "HTTP"
  vpc_id      = aws_vpc.main.id
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.medusa_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.medusa_tg.arn
  }
}



