#Standard

variable "region"          {}
variable "private_subnets" {}
variable "env"             {}
variable "name"            {}
variable "vpc_id"          {}

#kops
variable "kops_ami_id"     {}
variable "asg_name"        {}

#consul
variable "consul_ami_id"   {}
variable "consul_asg_name" {}

#ecs
variable "ecs_ami_id"      {}
variable "ecs_asg_name"    {}
variable "container_image" {}
