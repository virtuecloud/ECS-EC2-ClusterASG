################################################################################
# Cluster
################################################################################

module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name = var.cluster_name

  # Capacity provider - autoscaling groups
  default_capacity_provider_use_fargate = false
  autoscaling_capacity_providers = {
    # On-demand instances
    cluster-asg = {
      auto_scaling_group_arn         = module.autoscaling["cluster-asg"].autoscaling_group_arn
      managed_termination_protection = "ENABLED"

      managed_scaling = {
        maximum_scaling_step_size = var.maximum_scaling_step_size
        minimum_scaling_step_size = var.minimum_scaling_step_size
        status                    = "ENABLED"
        target_capacity           = var.target_cpu_usage
      }

      default_capacity_provider_strategy = {
        weight = 60
        base   = 20
      }
    }
  }

  tags = local.tags
}

