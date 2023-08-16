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

        "secrets": var.task_secrets_variables == [] ? null : var.task_secrets_variables

        #  "secrets": [
        #         {
        #             "name": "env-from-ARN",
        #             "valueFrom": "arn:aws:secretsmanager:us-east-1:331313361307:secret:mongodb-secret-dev-SHTuqC"
                    
        #         },
        #     ],
  }
] )

  memory = 1024
  cpu = 1024
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
  
    "Version": "2012-10-17"
    "Statement": [
        {
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogStream"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "Logs"
        },
        {
            "Action": [
                "ecr:GetDownloadUrlForLayer",
                "ecr:GetAuthorizationToken",
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "ECR"
        },
        {
            "Action": "secretsmanager:GetSecretValue",
            "Effect": "Allow",
            "Resource": "arn:aws:secretsmanager:*:*:secret:*",
            "Sid": "GetSecrets"
        }
    ]

})
} 

data "aws_secretsmanager_secret" "secrets" {
  arn = "arn:aws:secretsmanager:us-east-1:331313361307:secret:mongodb-secret-dev-SHTuqC"
}

data "aws_secretsmanager_secret_version" "current" {
  secret_id = data.aws_secretsmanager_secret.secrets.id
}