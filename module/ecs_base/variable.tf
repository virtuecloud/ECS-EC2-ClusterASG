variable "cluster_name" {
  
}
variable "vpc_id" {
  
}
variable "vpc_private_subnets" {
  
}
variable "desired_max_size" {
  type = number
}
variable "desired_size" {
  type = number
}
variable "desired_min_size" {
  type = number
}
variable "target_cpu_usage" {
  type = number
}
variable "minimum_scaling_step_size" {
  type = number
}
variable "maximum_scaling_step_size" {
  type = number
}
variable "alb_security_group_id" {
  
}
variable "tags" {
  
}