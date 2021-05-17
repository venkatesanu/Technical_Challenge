#Security groups
resource "aws_security_group" "create_sg" {
  name        = "${local.default_name_prefix}-sg"
  description = "Used for general application access"
  vpc_id      = "${var.vpc_id}"

  #Web Security group

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.local_cidr}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "ingress_ports" {
  default = ["80", "22"]
}

resource "aws_security_group_rule" "ingress_tcp" {
  count = "${length(var.ingress_ports)}"

  type        = "ingress"
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/8"]
  from_port   = "${element(var.ingress_ports, count.index)}"
  to_port     = "${element(var.ingress_ports, count.index)}"

  security_group_id = "${aws_security_group.create_sg.id}"
}

