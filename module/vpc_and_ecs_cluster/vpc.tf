module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(var.vpc_cidr, 8, k + 48)]

  # private_subnet_names = ["Alpha Primary", "Alpha Backup", "Beta Primary" ]

  enable_nat_gateway = true
  single_nat_gateway = true

  # default_route_table_name = "default"

  private_subnet_tags = {
    Name = "private-subnet"
  }
  public_subnet_tags = {
    Name = "public-subnet"
  }

 default_route_table_tags = {
    Name = "default-rt"
  }
  private_route_table_tags = {
    Name = "private-route-table"
  }

  public_route_table_tags = {
    Name = "public-route-table"
  }

  igw_tags  = {
    Name = "igw"
  }
 nat_gateway_tags  = {
    Name = "nat_gw"
  }

  tags = local.tags
}

