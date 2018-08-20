#Main terraform file for VPN and Network testing environment


variable "region"         {}
variable "name"           {}
variable "vpc_cidr"       {}
variable "cidrs"          {} 
variable "priv_cidrs"     {}
variable "azs"            {}
variable "kops_ami_id"    {}
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

module "compute" {
  source = "../../modules/compute"

  region       = "${var.region}"
  kops_ami_id  = "${var.kops_ami_id}"
  subnets      = "${module.network.subnet_ids}"
  name         = "${var.name}"
  vpc_id       = "${module.network.vpc_id}"

}
