variable "cluster_name" {}
variable "cluster_arn" {}
variable "capacity_provider_arn" {}

variable "service_subnets" {  type = list(string) }
variable "alb_sg_id" {}
variable "alb_listener_arn" {}

variable "container_name" {}
variable "container_port" {  type = number }
variable "container_image" {}
variable "task_count" {}
variable "ecs_service_name" {}

variable "task_environment_variables" {}
variable "task_secrets_variables" {}
variable "application_environment" {}



