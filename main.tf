
module "vpc_and_ecs_cluster" {

  source         = "./module/vpc_and_ecs_cluster"
  vpc_cidr       = var.vpc_cidr
  vpc_name       = var.vpc_name
  cluster_name   = var.cluster_name
  container_port = 80
  container_name = "ecs-sample"

  region                    = var.region
  desired_max_size          = var.desired_max_size
  desired_size              = var.desired_size
  desired_min_size          = var.desired_min_size
  target_cpu_usage          = var.target_cpu_usage
  minimum_scaling_step_size = var.minimum_scaling_step_size
  maximum_scaling_step_size = var.maximum_scaling_step_size

}

module "ecs_service" {
  source = "./module/ecs_service"

  for_each = var.containers

  cluster_name            = var.cluster_name
  region                  = var.region
  task_count              = each.value.task_count
  container_port          = each.value.container_port
  container_name          = each.value.container_name
  container_image         = each.value.container_image
  ecs_service_name        = each.value.ecs_service_name
  application_environment = var.application_environment
  host_header             = each.value.host_header


  cluster_arn                = module.vpc_and_ecs_cluster.cluster_arn
  capacity_provider_arn      = module.vpc_and_ecs_cluster.capacity_provider_arn
  service_subnets            = module.vpc_and_ecs_cluster.vpc_private_subnets
  alb_sg_id                  = module.vpc_and_ecs_cluster.alb_sg_id
  alb_listener_arn           = module.vpc_and_ecs_cluster.alb_listener_arn
  task_environment_variables = each.value.envs
  task_secrets_variables     = each.value.secrets
}

