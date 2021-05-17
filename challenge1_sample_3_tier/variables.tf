variable aws_region {
  description = "Specify the region name"
  default = "us-east-1"
}

variable "vpc_id" {}

variable "vpc_subnets_web" {
  type = "list"
}

variable "vpc_subnets_app" {
  type = "list"
}

variable "vpc_subnets_db" {
  type = "list"
}

variable "web_common_sg" {
  type = "list"
}

variable "app_common_sg" {
  type = "list"
}

variable "db_common_sg" {
  type = "list"
}

variable "demo_local_cidr" {
  default = "10.0.0.0/8"
}

variable "web_asg_desired" {
  default = "1"
}

variable "app_asg_desired" {
  default = "1"
}

variable "db_asg_desired" {
  default = "1"
}

variable "fqdn" {
  description = "Fully-qualified domain name of the ACM certificate"
  default     = "demo.example.com"
}

variable "web_instance_type" {
  default = "t3.large"
}

variable "app_instance_type" {
  default = "t3.large"
}

variable "db_instance_type" {
  default = "t3.large"
}

variable "key_name" {
  default = "demo-key"
}

variable "alb_enabled" {
  default = "0"
}

variable "web_alb_paths" {
  type = "list"
  default = [ { "name" = "root", "target_port" = 80, "alb_path" = "/", "priority" = 0} ]
}

variable "app_alb_paths" {
  type = "list"
  default = [ { "name" = "root", "target_port" = 20200, "alb_path" = "/", "priority" = 0} ]
}

variable "app_ingress_port" {
  default = ["20200"]
}

variable "web_ingress_port" {
  default = [ "443" ]
}

variable "db_ingress_port" {
  default = [ "3306" ]
}
