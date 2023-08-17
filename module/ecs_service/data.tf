data "aws_vpc" "service_vpc" {
  id = data.aws_subnet.service_subnet.vpc_id
}
data "aws_subnet" "service_subnet" {
  id = var.service_subnets[0]  
}

# data "aws_secretsmanager_secret" "secrets" {
#   arn = "arn:aws:secretsmanager:us-east-1:331313361307:secret:mongodb-secret-dev-SHTuqC"
# }

# data "aws_secretsmanager_secret_version" "current" {
#   secret_id = data.aws_secretsmanager_secret.secrets.id
# }