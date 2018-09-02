#Main terraform file for VPN and Network testing environment


variable "region"         {}
variable "name"           {}
variable "vpc_cidr"       {}
variable "cidrs"          {} 
variable "priv_cidrs"     {}
variable "azs"            {}
variable "kops_ami_id"    {}
variable "env"            {}
provider "aws" {
  region = "${var.region}"
}


module "network" {
  source = "../../modules/network"

  environment_name = "${var.name}"
  vpc_cidr         = "${var.vpc_cidr}"
  azs              = "${var.azs}"
  priv_cidrs       = "${var.priv_cidrs}"
  cidrs            = "${var.cidrs}"
}

/*module "compute" {
  source = "../../modules/compute"
  name            = "${var.name}"
  region          = "${var.region}"
  env             = "${var.env}"
  kops_ami_id     = "${var.kops_ami_id}"
  private_subnets = "${module.network.subnet_ids}"
  asg_name        = "${var.name}"

}*/
