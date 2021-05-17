variable region {
  description = "Specify the region name"
  default     = "us-east-1"
}

variable "role" {
  description = "Role of Stack (web,app,db). default to app"
  default     = "app"
}

data "aws_caller_identity" "current" {}

variable instance_type {
  description = "ec2 instance type"
  default     = "t3.micro"
}

variable root_volume_size {
  default = "50"
}

variable "asg_min" {
  default = "0"
}

variable "asg_max" {
  default = "10"
}

variable "asg_desired" {}

variable "application_name" {}

variable key_name {}

variable vpc_subnets {
  type = "list"
}

variable vpc_security_groups {
  type = "list"
}

variable local_cidr {}

variable vpc_id {}

variable alb_enabled {
  default = "false"
}

variable listener_port {
  default = "443"
}

variable "target_groups" {
  type    = "list"
  default = []
}
