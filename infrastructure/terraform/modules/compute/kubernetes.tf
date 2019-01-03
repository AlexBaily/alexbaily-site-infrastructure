#This module will be used for the EC2 ASGs

data "aws_ami" "kops_master" {
  filter {
    name   = "image-id"
    values = ["${var.kops_ami_id}"]
  }
}

resource "aws_security_group" "kops_master" {
  name            = "kops_master"
  description     = "${var.name} kops master SG"
  vpc_id          = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.102/32"]
  }
}

resource "aws_launch_configuration" "as_conf" {
  name            = "${var.name} launch configuration"
  image_id        = "${data.aws_ami.kops_master.id}"
  instance_type   = "t2.nano"
  key_name        = "kops-ssh-key"
  security_groups = ["${aws_security_group.kops_master.id}"]
}

resource "aws_autoscaling_group" "as_group" {
  vpc_zone_identifier       = ["${var.private_subnets}"]
  name                      = "${var.asg_name} ASG"
  min_size                  = 1
  max_size                  = 5
  health_check_grace_period = 300
  health_check_type         = "EC2"
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
}
