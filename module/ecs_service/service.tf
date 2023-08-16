

resource "aws_lb_target_group" "service_tg" {
  name     = "${var.container_name}-tg"
  port     = var.container_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.service_vpc.id
}

 resource "aws_ecs_service" "example-ecs-service" {
  name  =   var.ecs_service_name
  cluster   =   var.cluster_arn
  task_definition   =  aws_ecs_task_definition.example_task_def.arn
  launch_type =  "EC2"
  desired_count   = var.task_count
  depends_on =   [aws_cloudwatch_log_group.example_cw_log_group]
  

  load_balancer {
    target_group_arn = aws_lb_target_group.service_tg.arn
    container_name = var.container_name
    container_port = var.container_port
  }
} 


 resource "aws_cloudwatch_log_group" "example_cw_log_group" {
   name = "/ecs/${var.container_name}"

   tags = {
     Environment = var.application_environment
     Application = "${var.container_name}"
   }
 }

 resource "aws_lb_listener_rule" "attach_tg" {
  listener_arn = var.alb_listener_arn[0] 

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.service_tg.arn
  }
  condition {
    host_header {
      values = ["${var.container_name}-example.com"]  
    }
 }
 }

