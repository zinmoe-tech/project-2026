# ============================================================
# Output Values
# ============================================================

output "ecr_dashboard_url" {
  description = "ECR repository URL for dashboard"
  value       = aws_ecr_repository.dashboard.repository_url
}

output "ecr_counting_url" {
  description = "ECR repository URL for counting"
  value       = aws_ecr_repository.counting.repository_url
}

output "ecs_cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.main.name
}

output "counting_service_dns" {
  description = "Cloud Map DNS for counting service"
  value       = "counting.microservices.local"
}
