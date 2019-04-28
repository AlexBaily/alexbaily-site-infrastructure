#This module will be used for the EC2 ASGs

data "aws_ami" "consul_server_ami" {
  owners = ["self"]

  filter {
    name   = "image-id"
    values = ["${var.consul_ami_id}"]
  }
}



resource "aws_launch_configuration" "consul_as_conf" {
  image_id        = "${data.aws_ami.consul_server_ami.id}"
  instance_type   = "t2.nano"
  key_name        = "kops-ssh-key"
  user_data       = "${file("../../modules/compute/files/consul-user-data.sh")}"
  security_groups = ["${aws_security_group.consul_servers.id}"]
  lifecycle { create_before_destroy = true }
}

resource "aws_autoscaling_group" "consul_as_group" {
  vpc_zone_identifier       = ["${var.private_subnets}"]
  name                      = "${var.consul_asg_name} ASG"
  min_size                  = 1
  max_size                  = 5
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.consul_as_conf.name}"

  tag {
    key                 = "consul"
    value               = "server"
    propagate_at_launch = true
  }

  lifecycle { create_before_destroy = true }
}
