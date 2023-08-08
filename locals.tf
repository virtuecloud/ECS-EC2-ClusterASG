locals {
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Name       = var.cluster_name
    Module = "ECS-EC2-CapacityProvider Module"
  }
}