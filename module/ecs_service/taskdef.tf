 resource "aws_ecs_task_definition" "example_task_def" {
  family = var.container_name
  container_definitions = jsonencode(
[
  {
    "name": "${var.container_name}",
    "image": "${var.container_image}",
    "essential": true,
    "portMappings": [
      {
        "protocol": "tcp",
        "containerPort": var.container_port,
        "hostPort": 0
      }
    ],
        "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
            "awslogs-group": "/ecs/${var.container_name}",
            "awslogs-region": "us-east-1",
            "awslogs-stream-prefix": "ecs"
          }
        },
        "environment": var.task_environment_variables == [] ? null : var.task_environment_variables
  }
] )
  memory = 1024
  requires_compatibilities = ["EC2"]
  network_mode = "bridge"
  execution_role_arn = aws_iam_role.task_def_role.arn
  
}
resource "aws_iam_role" "task_def_role" {
  name = "${var.container_name}_task_def_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
resource "aws_iam_role_policy" "ecr-iam-policy" {
  name = "${var.container_name}_task_def_policy"
  role = aws_iam_role.task_def_role.id
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:BatchGetImage",
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        }
    ]
})
} 