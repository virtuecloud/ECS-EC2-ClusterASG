
module "vpc_and_ecs_cluster" {

  source                    = "./module/vpc_and_ecs_cluster"
  vpc_cidr                  = "10.0.0.0/16"
  vpc_name                  = "ECS-EC2-VPC"
  cluster_name              = "test-cluster"
  container_port = 80
  container_name = "ecs-sample"
  
  region                    = "us-east-1"
  desired_max_size          = 5
  desired_size              = 2
  desired_min_size          = 2
  target_cpu_usage          = 80
  minimum_scaling_step_size = 1
  maximum_scaling_step_size = 5

}

module "ecs_service" {
  source         = "./module/ecs_service"

  for_each = var.containers

  cluster_name   = each.value.container_name
  container_port = each.value.container_port
  container_name = each.value.container_name
  container_image = each.value.container_image
  cluster_arn = module.vpc_and_ecs_cluster.cluster_arn
  capacity_provider_arn = module.vpc_and_ecs_cluster.capacity_provider_arn
  # target_group_arn = module.vpc_and_ecs_cluster.target_group_arn
  service_subnets = module.vpc_and_ecs_cluster.vpc_private_subnets
  alb_sg_id = module.vpc_and_ecs_cluster.alb_sg_id
  alb_listener_arn = module.vpc_and_ecs_cluster.alb_listener_arn

  
  task_environment_variables = each.value.envs
  

}
