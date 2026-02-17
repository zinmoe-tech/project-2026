# ============================================================
# Security Group - Allow traffic to ports 9001 and 9002
# ============================================================

resource "aws_security_group" "ecs_tasks" {
  name        = "ecs-tasks-sg"
  description = "Allow traffic to ECS tasks"
  vpc_id      = data.aws_vpc.default.id

  # Allow counting service port
  ingress {
    from_port   = 9001
    to_port     = 9001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Counting service"
  }

  # Allow dashboard service port
  ingress {
    from_port   = 9002
    to_port     = 9002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Dashboard service"
  }

  # Allow all outbound (needed for ECR pull, Cloud Map DNS, etc.)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
