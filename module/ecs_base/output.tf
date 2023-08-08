output "cluster_arn" {
  value = module.ecs_cluster.arn
}
output "capacity_provider_arn" {
  value = module.ecs_cluster.autoscaling_capacity_providers["cluster-asg"].name
}