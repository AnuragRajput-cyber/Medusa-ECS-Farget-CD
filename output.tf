output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.ecs.alb_dns_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = module.ecs.ecr_repository_url
}

output "db_endpoint" {
  description = "Endpoint of the RDS instance"
  value       = module.rds.db_host
  sensitive   = true
}