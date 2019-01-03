#Terraform Network Module

variable "environment_name" {}
variable "vpc_cidr"         {}
variable "cidrs"            {}
variable "priv_cidrs"       {}
variable "azs"              {}
variable "vpc_dns"          {}


resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags { Name = "${var.environment_name}" } 
}

#Local address to be used with bind installed for consul to work on 53; 
#AWS DNS for forwarded requests
resource "aws_vpc_dhcp_options" "dhcp_option" {
  domain_name          = "service.consul"
  domain_name_servers  = ["127.0.0.1", "${var.vpc_dns}"]
  ntp_servers          = ["127.0.0.1"]
  netbios_name_servers = ["127.0.0.1"]
  netbios_node_type    = 2

  tags = {
    Name = "consul-dhcp-options"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags { Name = "${var.environment_name}" }
}


resource "aws_subnet" "public" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(split(",", var.cidrs), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = "${length(split(",", var.cidrs))}"

  tags { Name = "${var.environment_name} ${element(split(",", var.azs), count.index)}" }
}

resource "aws_route_table" "public" {
  vpc_id           = "${aws_vpc.vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "${aws_internet_gateway.public.id}"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = "${aws_vpc.vpc.id}"
  cidr_block        = "${element(split(",", var.priv_cidrs), count.index)}"
  availability_zone = "${element(split(",", var.azs), count.index)}"
  count             = 3

  tags { Name = "${var.environment_name} Private ${element(split(",", var.azs), count.index)}" }
}

resource "aws_route_table" "private" {
  vpc_id           = "${aws_vpc.vpc.id}"
  route {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = "${aws_nat_gateway.gw.id}"
  }
}

resource "aws_route_table_association" "private_routes" {
  subnet_id      = "${element(aws_subnet.private.*.id, count.index)}"
  route_table_id = "${aws_route_table.private.id}"
  count          = 3
}

#EIP for NateGateway
resource "aws_eip" "nat" {
  vpc      = true
}

#One Nat Gateway to keep down cost rather than one in each private subnet
resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id     = "${aws_subnet.public.0.id}"
}

output "vpc_id"     { value = "${aws_vpc.vpc.id}" }
output "subnet_ids" { value = "${join(",", aws_subnet.private.*.id)}" }
