terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "${var.aws_region}"
}

module "web-stack" {
  source              = "../aws-modules-tf/stack"
  role                = "web"
  asg_desired         = "${var.web_asg_desired}"
  alb_enabled         = "${var.alb_enabled}"
  instance_type       = "${var.web_instance_type}"
  application_name    = "${var.application_name_tag}"
  fqdn                = "${var.fqdn}"
  key_name            = "${var.key_name}"
  vpc_id              = "${var.vpc_id}"
  vpc_subnets         = ["${var.vpc_subnets_web}"]
  local_cidr          = "${var.demo_local_cidr}"
  vpc_security_groups = ["${var.web_common_sg}"]
  ingress_ports       = "${var.web_ingress_port}"
  target_groups       = "${var.web_alb_paths}"
}

module "app-stack" {
  source              = "../aws-modules-tf/stack"
  role                = "app"
  asg_desired         = "${var.app_asg_desired}"
  alb_enabled         = "${var.alb_enabled}"
  instance_type       = "${var.app_instance_type}"
  application_name    = "${var.application_name_tag}"
  fqdn                = "${var.fqdn}"
  key_name            = "${var.key_name}"
  vpc_id              = "${var.vpc_id}"
  vpc_subnets         = ["${var.vpc_subnets_app}"]
  local_cidr          = "${var.demo_local_cidr}"
  vpc_security_groups = ["${var.app_common_sg}"]
  ingress_ports       = "${var.app_ingress_port}"
  target_groups       = "${var.app_alb_paths}"
}

module "db-stack" {
  source              = "../aws-modules-tf/stack"
  role                = "db"
  asg_desired         = "${var.db_asg_desired}"
  alb_enabled         = "${var.alb_enabled}"
  instance_type       = "${var.db_instance_type}"
  application_name    = "${var.application_name_tag}"
  key_name            = "${var.key_name}"
  vpc_id              = "${var.vpc_id}"
  vpc_subnets         = ["${var.vpc_subnets_db}"]
  local_cidr          = "${var.demo_local_cidr}"
  vpc_security_groups = ["${var.db_common_sg}"]
  ingress_ports       = "${var.db_ingress_port}"
}
