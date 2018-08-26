#This module will be used for the EC2 ASGs

variable "region"          {}
variable "kops_ami_id"     {}
variable "private_subnets" {}
variable "asg_name"        {} 
variable "env"             {}
variable "name"            {}

data "aws_ami" "kops_master" {
  filter {
    name   = "image-id"
    values = ["${var.kops_ami_id}"]
  }
}

resource "aws_launch_configuration" "as_conf" {
  name            = "${var.name} launch configuration"
  image_id        = "${data.aws_ami.kops_master.id}"
  instance_type   = "t2.nano"

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
