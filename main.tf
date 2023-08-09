module "ecs_ec2" {
  source = "./module/ecs_base"
  cluster_name = "test-cluster"
  vpc_id = module.vpc.vpc_id
  vpc_private_subnets = module.vpc.private_subnets
  desired_max_size = 5
  desired_size = 1
  desired_min_size = 1
  target_cpu_usage = 80
  minimum_scaling_step_size = 1
  maximum_scaling_step_size = 5
  alb_security_group_id = module.ecs_service.alb_sg_id
  tags = local.tags
}

module "ecs_service" {
  for_each = {
    service1 = {
      container_name = "nginx1"
      container_image = "nginx:latest"
      container_port = 80
    }
    service2 = {
      container_name = "tomcat1"
      container_image = "httpd:latest"
      container_port = 80
    }
  }
  source = "./module/services"
  cluster_name = "test-cluster"
  vpc_id = module.vpc.vpc_id
  vpc_public_subnets = module.vpc.public_subnets
  vpc_private_subnets = module.vpc.private_subnets
  vpc_private_subnets_cidr_block = module.vpc.private_subnets_cidr_blocks
  ecs_cluster_arn = module.ecs_ec2.cluster_arn
  capacity_provider_arn = module.ecs_ec2.capacity_provider_arn
  container_name = each.value.container_name
  container_image = each.value.container_image
  container_port = each.value.container_port
  tags = local.tags
}