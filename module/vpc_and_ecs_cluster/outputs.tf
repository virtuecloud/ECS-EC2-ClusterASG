
output "cluster_arn" {
  value = module.ecs_cluster.arn
}

output "capacity_provider_arn" {
  value = module.ecs_cluster.autoscaling_capacity_providers["cluster-asg"].name
}

output "target_group_arn" {
  value = element(module.alb.target_group_arns, 0)
}

output "vpc_private_subnets" {
  value = module.vpc.private_subnets
}

output "alb_sg_id" {
  value = module.alb_sg.security_group_id
}
