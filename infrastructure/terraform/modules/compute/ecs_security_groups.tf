resource "aws_security_group" "ecs_server" {
  name            = "ecs_server"
  description     = "${var.name} ECS Servers SG"
  vpc_id          = "${var.vpc_id}"
}

resource "aws_security_group_rule" "ecs_ssh_management" {
  type    = "ingress"
  from_port = 22
  to_port   = 22 
  protocol  = "tcp"
  cidr_blocks  = ["10.0.0.4/32"]

  security_group_id = "${aws_security_group.consul_servers.id}"
}
