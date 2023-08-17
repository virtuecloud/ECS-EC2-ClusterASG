

variable "cluster_name" {}

variable "region" {}

variable "vpc_name" {}

variable "vpc_cidr" {}

variable "container_name" {}

variable "container_port" {  type = number }

variable "desired_max_size" {  type = number }

variable "desired_size" {  type = number }

variable "desired_min_size" {  type = number }

variable "target_cpu_usage" {  type = number }

variable "minimum_scaling_step_size" {  type = number }

variable "maximum_scaling_step_size" {  type = number }



