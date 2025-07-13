output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_alb.main.dns_name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.medusa.repository_url
}