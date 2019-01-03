#This module will be used for the EC2 ASGs

data "aws_ami" "consul_server_ami" {
  filter {
    name   = "image-id"
    values = ["${var.consul_ami_id}"]
  }
}

resource "aws_launch_configuration" "consul_as_conf" {
  name            = "${var.name} Consul launch configuration"
  image_id        = "${data.aws_ami.consul_server_ami.id}"
  instance_type   = "t2.nano"
  key_name        = "kops-ssh-key"
  security_groups = ["${aws_security_group.consul_servers.id}"]
}

resource "aws_autoscaling_group" "consul_as_group" {
  vpc_zone_identifier       = ["${var.private_subnets}"]
  name                      = "${var.consul_asg_name} ASG"
  min_size                  = 1
  max_size                  = 5
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.consul_as_conf.name}"
}
