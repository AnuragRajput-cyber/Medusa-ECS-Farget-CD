resource "aws_ecs_cluster" "medusa_cluster" {
  name = "medusa-cluster"
}

resource "aws_ecs_task_definition" "medusa_task_definition" {
  family                   = "medusa-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "medusa",
      image     = "public.ecr.aws/v7f0w4r6/medusa-backend:latest",
      essential = true,
      portMappings = [
        { containerPort = 9000 }
      ],
      environment = [
        {
          name  = "DATABASE_URL",
          value = "postgres://postgres:${var.DB_password}@${aws_db_instance.medusa_db.address}:5432/medusadb"
        },
        {
          name  = "JWT_SECRET",
          value = "your_jwt_secret_here"
        },
        {
          name  = "DEPLOY_TIMESTAMP",
          value = timestamp()
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "medusa_service" {
  name            = "medusa-service"
  cluster         = aws_ecs_cluster.medusa_cluster.id
  task_definition = aws_ecs_task_definition.medusa_task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [
      aws_subnet.public_subnet_1.id,
      aws_subnet.public_subnet_2.id
    ]
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
