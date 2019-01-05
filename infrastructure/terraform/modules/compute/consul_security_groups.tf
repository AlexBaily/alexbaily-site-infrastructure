resource "aws_security_group" "consul_servers" {
  name            = "consul_servers"
  description     = "${var.name} Consul Servers SG"
  vpc_id          = "${var.vpc_id}"
}

resource "aws_security_group_rule" "consul_inbound_from_self" {
  type    = "ingress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  self      = true

  security_group_id = "${aws_security_group.consul_servers.id}"
}

resource "aws_security_group_rule" "consul_ssh_management" {
  type    = "ingress"
  from_port = 22
  to_port   = 22 
  protocol  = "tcp"
  cidr_blocks  = ["10.0.0.0/8"]

  security_group_id = "${aws_security_group.consul_servers.id}"
}

resource "aws_security_group_rule" "consul_inbound_rpc_from_agents" {
  type    = "ingress"
  from_port = 8300
  to_port   = 8302
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.consul_agent.id}"

  security_group_id = "${aws_security_group.consul_servers.id}"
}

resource "aws_security_group_rule" "consul_inbound_dns_from_agents" {
  type    = "ingress"
  from_port = 8600
  to_port   = 8600
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.consul_agent.id}"

  security_group_id = "${aws_security_group.consul_servers.id}"
}

resource "aws_security_group_rule" "consul_inbound_api_from_agents" {
  type    = "ingress"
  from_port = 8500
  to_port   = 8500
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.consul_agent.id}"

  security_group_id = "${aws_security_group.consul_servers.id}"
}

resource "aws_security_group_rule" "consul_inbound_crpc_from_agents" {
  type    = "ingress"
  from_port = 8400
  to_port   = 8400
  protocol  = "tcp"
  source_security_group_id = "${aws_security_group.consul_agent.id}"

  security_group_id = "${aws_security_group.consul_servers.id}"
}


resource "aws_security_group_rule" "consul_outbound_from_self" {
  type    = "egress"
  from_port = 0
  to_port   = 0
  protocol  = -1
  self      = true

  security_group_id = "${aws_security_group.consul_servers.id}"
}


resource "aws_security_group" "consul_agent" {
  name            = "consul_agent"
  description     = "${var.name} Consul Agent SG"
  vpc_id          = "${var.vpc_id}"
}



