locals {
  default_name_prefix     = "${lower(replace(var.application_name))}-${var.role}"
  default_alb_name_prefix = "${var.role}-${lower(replace(var.application_name))}"
}

module "stack-asg" {
  source = "../aws-modules-tf/asg"

  name        = "${local.default_name_prefix}"
  asg_min     = "${var.asg_min}"
  asg_max     = "${var.asg_max}"
  asg_desired = "${var.asg_desired}"

  image_id      = "${data.aws_ami.ami.id}"
  instance_type = "${var.instance_type}"

  key_name             = "${var.key_name}"

  root_volume_size        = "${var.root_volume_size}"
  vpc_zone_identifier = "${var.vpc_subnets}"

  security_groups = ["${concat(
                list("${aws_security_group.create_sg.id}"),
                var.vpc_security_groups)
              }"]

}

module "stack-alb" {
  count = "${var.alb_enabled ? 1 : 0}"

  source              = "../aws-modules-tf/albp"
  stack_name          = "${local.default_alb_name_prefix}"
  vpc_id              = "${var.vpc_id}"
  lb_port             = "${var.listener_port}"
  vpc_zone_identifier = ["${var.vpc_subnets}"]
  fqdn                = "${var.fqdn}"
  target_groups       = "${var.target_groups}"
  asg_id              = "${module.stack-asg.asg_id}"

  security_groups = ["${concat(
                      list("${aws_security_group.create_sg.id}"),
                      var.vpc_security_groups)
                    }"]
}
