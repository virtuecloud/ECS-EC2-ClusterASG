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
