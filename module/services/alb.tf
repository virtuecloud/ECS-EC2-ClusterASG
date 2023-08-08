################################################################################
# LoadBalancer
################################################################################

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "${var.cluster_name}-${var.container_name}"

  load_balancer_type = "application"

  vpc_id          = var.vpc_id
  subnets         = var.vpc_private_subnets
  security_groups = [module.alb_sg.security_group_id]

  http_tcp_listeners = [
    {
      port               = var.container_port
      protocol           = "HTTP"
      target_group_index = 0
    },
  ]

  target_groups = [
    {
      name             = "${var.cluster_name}-${var.container_name}"
      backend_protocol = "HTTP"
      backend_port     = var.container_port
      target_type      = "ip"
    },
  ]

  tags = var.tags
}

################################################################################
# LoadBalancer Security Group
################################################################################

module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.cluster_name}-service"
  description = "Service security group"
  vpc_id      = var.vpc_id

  ingress_rules       = ["http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  # egress_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  egress_cidr_blocks = var.vpc_private_subnets_cidr_block

  tags = var.tags
}