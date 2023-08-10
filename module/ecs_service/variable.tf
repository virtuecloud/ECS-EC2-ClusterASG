variable "cluster_name" {
  
}
variable "cluster_arn" {
  
}
variable "capacity_provider_arn" {
  
}
variable "target_group_arn" {
  
}
variable "vpc_private_subnets" {}
variable "alb_sg_id" {}

# variable "region" {
  
# }
# variable "vpc_name" {
  
# }
# variable "vpc_cidr" {
  
# }
variable "container_name" {}
variable "container_image" {}
variable "task_environment_variables" {}



variable "container_port" {
  type = number
}
# variable "desired_max_size" {
#   type = number
# }
# variable "desired_size" {
#   type = number
# }
# variable "desired_min_size" {
#   type = number
# }
# variable "target_cpu_usage" {
#   type = number
# }
# variable "minimum_scaling_step_size" {
#   type = number
# }
# variable "maximum_scaling_step_size" {
#   type = number
# }