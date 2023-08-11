# ################################################################################
# # Service
# ################################################################################
# module "ecs_service" {
#   source = "terraform-aws-modules/ecs/aws//modules/service"

#   # Service
#   name        = "${var.cluster_name}-service"
#   cluster_arn = var.cluster_arn

#   # Task Definition
#   requires_compatibilities = ["EC2"]
#   capacity_provider_strategy = {
#     # On-demand instances
#     cluster-asg = {
#       capacity_provider = var.capacity_provider_arn
#       weight            = 1
#       base              = 1
#     }
#   }

#   volume = {
#     my-vol = {}
#   }

#   # Container definition(s)
#   container_definitions = {
#     (var.container_name) = {
#       image = var.container_image
#       port_mappings = [
#         {
#           name          = var.container_name
#           containerPort = var.container_port
#           protocol      = "tcp"
#         }
#       ]

#       mount_points = [
#         {
#           sourceVolume  = "my-vol",
#           containerPath = "/var/www/my-vol"
#         }
#       ]

#           environment = var.task_environment_variables
#       readonly_root_filesystem = false
#     }
#   }

#   load_balancer = {
#     service = {
#       target_group_arn = aws_lb_target_group.service_tg.arn
#       container_name   = var.container_name
#       container_port   = var.container_port
#     }
#   }

#   subnet_ids = var.service_subnets
#   security_group_rules = {
#     alb_http_ingress = {
#       type                     = "ingress"
#       from_port                = var.container_port
#       to_port                  = var.container_port
#       protocol                 = "tcp"
#       description              = "Service port"
#       source_security_group_id = var.alb_sg_id
#     }
#   }

#   # tags = local.tags
# }

data "aws_vpc" "service_vpc" {
  id = data.aws_subnet.service_subnet.vpc_id
}
data "aws_subnet" "service_subnet" {
  id = var.service_subnets[0]  
}
resource "aws_lb_target_group" "service_tg" {
  name     = "${var.container_name}-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.service_vpc.id
}



 resource "aws_ecs_service" "example-ecs-service" {
  name = var.container_name
  cluster = var.cluster_arn
  task_definition = aws_ecs_task_definition.example_task_def.arn
  launch_type = "EC2"
  desired_count = 1
  depends_on = [aws_cloudwatch_log_group.example_cw_log_group]
  

  load_balancer {
    target_group_arn = aws_lb_target_group.service_tg.arn
    container_name = var.container_name
    container_port = var.container_port
  }
} 


 resource "aws_cloudwatch_log_group" "example_cw_log_group" {
   name = "/ecs/${var.container_name}"

   tags = {
     Environment = "stage"
     Application = "${var.container_name}"
   }
 }

 resource "aws_lb_listener_rule" "attach_tg" {
  listener_arn = var.alb_listener_arn[0]  # Use the listener ARN from your module
  # priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg.arn
  }
  # condition {
  #   path_pattern {
  #     values = ["/${var.container_name}"]
  #   }
  # }
}