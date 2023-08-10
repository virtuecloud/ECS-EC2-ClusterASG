################################################################################
# Service
################################################################################

module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  # Service
  name        = "${var.cluster_name}-service"
  cluster_arn = var.cluster_arn

  # Task Definition
  requires_compatibilities = ["EC2"]
  capacity_provider_strategy = {
    # On-demand instances
    cluster-asg = {
      capacity_provider = var.capacity_provider_arn
      weight            = 1
      base              = 1
    }
  }

  volume = {
    my-vol = {}
  }

  # Container definition(s)
  container_definitions = {
    (var.container_name) = {
      image = var.container_image
      port_mappings = [
        {
          name          = var.container_name
          containerPort = var.container_port
          protocol      = "tcp"
        }
      ]

      mount_points = [
        {
          sourceVolume  = "my-vol",
          containerPath = "/var/www/my-vol"
        }
      ]

      # environment = [
      #   {
      #     name  = "DB_NAME"
      #     value = "DEMO-123"
      #   },
      #   {
      #     name  = "DB_USER"
      #     value = "admin"
      #   }
      #   # Add more environment variables as needed
      # ]

      environment = var.task_environment_variables
      # environment = jsonencode(var.task_environment_variables)

    #   entry_point = ["/usr/sbin/apache2", "-D", "FOREGROUND"]

      # Example image used requires access to write to root filesystem
      readonly_root_filesystem = false
    }
  }

  load_balancer = {
    service = {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  subnet_ids = var.vpc_private_subnets
  security_group_rules = {
    alb_http_ingress = {
      type                     = "ingress"
      from_port                = var.container_port
      to_port                  = var.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = var.alb_sg_id
    }
  }

  # tags = local.tags
}