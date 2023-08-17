# ECS-EC2-ClusterASG

<h1 align="center"> Virtuecloud </h1> <br>
<p align="center">
  <a href="https://virtuecloud.io/">
    <img alt="Virtuecloud" title="Virtuecloud" src="https://virtuecloud.io/assets/images/VitueCloud_Logo.png" width="450">
  </a>
</p>

# Introduction

Terraform module for AWS ECS Deployment with the EC2

# Core Components

## AWS

_The AWS infrastructure is setup using terraform in the ./terraform._

_The following components are deployed:_
1. Application Load Balancer 
2. ECS Cluster / ECS Service 
3. Security Groups
4. AutoScaling
5. VPC

# Usage

## ECS Cluster, VPC Module

```hcl

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

```

## ECS Service Module

```hcl

module "ecs_service" {
  source = "./module/ecs_service"

  for_each = var.containers

  cluster_name            = var.cluster_name
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

```

# Note:
We did mapping in terraform.tfvars as the given example below:

```hcl

region                  = "us-east-1"
cluster_name            = "virtuecloud-cluster"
vpc_name                = "ECS-EC2-VPC"
vpc_cidr                = "10.0.0.0/16"
application_environment = "UAT"

# Autoscaling Group Related values
desired_max_size          = 5
desired_size              = 2
desired_min_size          = 2
target_cpu_usage          = 80
minimum_scaling_step_size = 1
maximum_scaling_step_size = 5
containers = {
  container_1 = {
    task_count       = 1 # Number of containers running
    container_image  = "nginx:latest"
    container_name   = "nginx-cont"
    container_port   = 80
    ecs_service_name = "nginx-svc"
    host_header      = "nginx.dev.com"
    envs = [
      { "name" = "type", "value" = "nginx" },
      { "name" = "env", "value" = "dev" },
    ]
    secrets = []
  },

  container_2 = {
    task_count       = 1
    container_image  = "httpd:latest"
    container_name   = "appache"
    container_port   = 80
    ecs_service_name = "httpd"
    host_header      = "appache.nginx.dev.com"
    envs             = []
    secrets          = []
  }
}

```


