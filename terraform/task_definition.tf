resource "aws_ecs_task_definition" "medusa_task" {
  family                   = "medusa-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

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
          value = "changeme"
        }
      ]
    }
  ])
}
