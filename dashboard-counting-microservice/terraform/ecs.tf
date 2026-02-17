# ============================================================
# ECS Cluster
# ============================================================

resource "aws_ecs_cluster" "main" {
  name = "demo-microservices"
}

# ============================================================
# ECS Task Definitions - Container blueprints
# ============================================================

resource "aws_ecs_task_definition" "counting" {
  family                   = "counting"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = "counting"
    image     = "${aws_ecr_repository.counting.repository_url}:latest"
    essential = true

    portMappings = [{
      containerPort = 9001
      protocol      = "tcp"
    }]

    environment = [
      { name = "PORT", value = "9001" }
    ]
  }])
}

resource "aws_ecs_task_definition" "dashboard" {
  family                   = "dashboard"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([{
    name      = "dashboard"
    image     = "${aws_ecr_repository.dashboard.repository_url}:latest"
    essential = true

    portMappings = [{
      containerPort = 9002
      protocol      = "tcp"
    }]

    environment = [
      { name = "PORT", value = "9002" },
      { name = "COUNTING_SERVICE_URL", value = "http://counting.microservices.local:9001" }
    ]
  }])
}

# ============================================================
# ECS Services - Keep tasks running and register with Cloud Map
# ============================================================

resource "aws_ecs_service" "counting" {
  name            = "counting"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.counting.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.counting.arn
  }
}

resource "aws_ecs_service" "dashboard" {
  name            = "dashboard"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.dashboard.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = true
  }

  service_registries {
    registry_arn = aws_service_discovery_service.dashboard.arn
  }

  depends_on = [aws_ecs_service.counting]
}
