variable "vpc_id" {
  type        = "string"
  description = "The VPC id"
}

variable "stack_name" {
  type        = "string"
  description = "Prefix to be used in the Name tag for all resources"
}

variable "security_groups" {
  type        = "list"
  description = "The list of subnets for the asg"
}

variable "vpc_zone_identifier" {
  type        = "list"
  description = "The list of subnets for the asg"
}

variable "lb_port" {
  default     = 443
  description = "Load balencer Port"
}

variable "count" {}
variable "enable_uuid" {
  default = "1"
}


variable "asg_id" {}

variable "tags" {
  type = "map"
}

variable "fqdn" {}


locals {
    alb_name_pre = "${var.enable_uuid ? "${replace("${var.stack_name}-alb-${uuid()}", "/-([-]*)$/", "")}" : "${replace("${var.stack_name}", "/-([-]*)$/", "")}" }"
    alb_name_post  = "${substr("${local.alb_name_pre}", 0, min(length("${local.alb_name_pre}"), 28))}-alb"
}

data "aws_acm_certificate" "selected" {
  count       = "${var.count}"
  domain      = "${var.fqdn}"
  most_recent = true
}

variable "target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created"
  type        = "list"
  default     = []
}

variable "target_groups_defaults" {
  description = "Default values for target groups as defined by the list of maps."
  type        = "map"

  default = {
    "cookie_duration"                  = 86400
    "target_port"                      = 8080
    "backend_protocol"                 = "HTTP"
    "deregistration_delay"             = 300
    "health_check_interval"            = 10
    "health_check_healthy_threshold"   = 3
    "health_check_path"                = "/"
    "health_check_port"                = "traffic-port"
    "health_check_timeout"             = 5
    "health_check_unhealthy_threshold" = 3
    "health_check_matcher"             = "200-299"
    "stickiness_enabled"               = true
    "target_type"                      = "instance"
  }
}

resource "aws_lb" "alb" {
  count              = "${var.count}"
  name               = "${local.alb_name_post}"
  load_balancer_type = "application"
  internal           = "true"
  security_groups    = ["${var.security_groups}"]
  subnets            = ["${var.vpc_zone_identifier}"]
  enable_http2       = "true"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "tg" {
  count                = "${var.count ? "${length(var.target_groups)}" : 0}"
  vpc_id               = "${var.vpc_id}"
  name                 = "${replace("${substr("${lookup(var.target_groups[count.index], "name")}-${var.stack_name}-tg-${uuid()}", 0, 32)}---", "/-([-]*)$/", "")}"
  port                 = "${lookup(var.target_groups[count.index], "target_port", lookup(var.target_groups_defaults, "target_port"))}"
  protocol             = "${upper(lookup(var.target_groups[count.index], "backend_protocol", lookup(var.target_groups_defaults, "backend_protocol")))}"

 
  depends_on = ["aws_lb.alb"]

}

resource "aws_lb_listener" "listener" {
  count             = "${var.count}"
  load_balancer_arn = "${aws_lb.alb.arn}"
  port              = "${var.lb_port}"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "${data.aws_acm_certificate.selected.arn}"

  default_action {
    type             = "forward"
    target_group_arn = "${element(aws_lb_target_group.tg.*.id, 0)}"
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  count = "${var.count ? "${length(var.target_groups) - 1}" : 0}"

  listener_arn = "${aws_lb_listener.listener.arn}"
  priority     = "${lookup(var.target_groups["${count.index + 1}"], "priority")}"

  action {
    type             = "forward"
    target_group_arn = "${element(aws_lb_target_group.tg.*.id, "${count.index + 1}")}"
  }

  condition {
    field  = "path-pattern"
    values = ["${lookup(var.target_groups["${count.index + 1}"], "alb_path")}"]
  }
}

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "stack-asg-attachment" {
  count                  = "${var.count * length(var.target_groups)}"
  autoscaling_group_name = "${var.asg_id}"
  alb_target_group_arn   = "${element(aws_lb_target_group.tg.*.id, "${count.index}")}"
}
