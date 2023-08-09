
module "ecs" {
  source = "./module/ecs"
  cluster_name = "test-cluster"

  vpc_cidr = "10.0.0.0/16"
  region = "us-east-1"
  container_port = 80
  vpc_name = "ECS-EC2-VPC"
  container_name = "ecs-sample"

#   vpc_id = module.vpc.vpc_id
#   vpc_private_subnets = module.vpc.private_subnets
  desired_max_size = 5
  desired_size = 1
  desired_min_size = 1
  target_cpu_usage = 80
  minimum_scaling_step_size = 1
  maximum_scaling_step_size = 5
#   alb_security_group_id = module.ecs_service.alb_sg_id
#   tags = local.tags
}