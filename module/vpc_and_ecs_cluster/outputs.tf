
output "cluster_arn" {
  value = module.ecs_cluster.arn
}

output "capacity_provider_arn" {
  value = module.ecs_cluster.autoscaling_capacity_providers["cluster-asg"].name
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "alb_sg_id" {
  value = module.alb_sg.security_group_id
}

output "alb_listener_arn" {
  value = module.alb.http_tcp_listener_arns
}

output "lb_dns_name" {
  description = "The DNS name of the load balancer."
  value       = module.alb.lb_dns_name
}