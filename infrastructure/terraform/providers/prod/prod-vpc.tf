#Main terraform file for VPN and Network testing environment


variable "region"            {}
variable "name"              {}
variable "vpc_cidr"          {}
variable "cidrs"             {} 
variable "priv_cidrs"        {}
variable "azs"               {}
variable "vpc_dns"           {}
variable "kops_ami_id"       {}
variable "env"               {}
variable "kops_dns_zone"     {}
variable "kops_state_bucket" {}
variable "consul_ami_id"     {}
variable "consul_asg_name"   {}
provider "aws" {
  region = "${var.region}"
}


module "network" {
  source = "../../modules/network"

  environment_name  = "${var.name}"
  vpc_cidr          = "${var.vpc_cidr}"
  azs               = "${var.azs}"
  priv_cidrs        = "${var.priv_cidrs}"
  cidrs             = "${var.cidrs}"
  kops_dns_zone     = "${var.kops_dns_zone}"
  env               = "${var.env}"
  kops_state_bucket = "${var.kops_state_bucket}"
  vpc_dns           = "${var.vpc_dns}"
}

module "compute" {
  source = "../../modules/compute"
  name            = "${var.name}"
  region          = "${var.region}"
  env             = "${var.env}"
  kops_ami_id     = "${var.kops_ami_id}"
  private_subnets = "${module.network.subnet_ids}"
  asg_name        = "${var.name}"
  vpc_id          = "${module.network.vpc_id}"
  consul_asg_name = "${var.consul_asg_name}"
  consul_ami_id   = "${var.consul_ami_id}"
}
