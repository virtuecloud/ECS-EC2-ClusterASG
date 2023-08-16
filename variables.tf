variable "containers" {
  type    = map(any)
  default = {}
}

variable "region" { type = string }
variable "cluster_name" { type = string }
variable "application_environment" { type = string }


variable "vpc_name" { type = string }
variable "vpc_cidr" { type = string }

variable "desired_max_size" { type = number }
variable "desired_size" { type = number }
variable "desired_min_size" { type = number }
variable "target_cpu_usage" { type = number }
variable "minimum_scaling_step_size" { type = number }
variable "maximum_scaling_step_size" { type = number }