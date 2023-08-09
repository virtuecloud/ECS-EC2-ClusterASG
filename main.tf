
module "vpc_and_ecs_cluster" {

  source                    = "./module/vpc_and_ecs_cluster"
  vpc_cidr                  = "10.0.0.0/16"
  vpc_name                  = "ECS-EC2-VPC"
  cluster_name              = "test-cluster"
  container_port = 80
  container_name = "ecs-sample"
  
  region                    = "us-east-1"
  desired_max_size          = 5
  desired_size              = 1
  desired_min_size          = 1
  target_cpu_usage          = 80
  minimum_scaling_step_size = 1
  maximum_scaling_step_size = 5

}

module "ecs_service" {
  source         = "./module/ecs_service"
  cluster_name   = "test-cluster"
  container_port = 80
  container_name = "ecs-sample"
  cluster_arn = module.vpc_and_ecs_cluster.cluster_arn
  capacity_provider_arn = module.vpc_and_ecs_cluster.capacity_provider_arn
  target_group_arn = module.vpc_and_ecs_cluster.target_group_arn
  vpc_private_subnets = module.vpc_and_ecs_cluster.vpc_private_subnets
  alb_sg_id = module.vpc_and_ecs_cluster.alb_sg_id

}
