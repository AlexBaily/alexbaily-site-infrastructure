#Global
region   = "eu-west-1"
env      = "prod"

#Network
name           = "VPN test VPC"
vpc_cidr       = "172.21.0.0/16"
cidrs          = "172.21.1.0/24,172.21.2.0/24,172.21.3.0/24"
priv_cidrs     = "172.21.4.0/24,172.21.5.0/24,172.21.6.0/24"
azs            = "eu-west-1a,eu-west-1b,eu-west-1c"

#Compute
kops_ami_id   = ""
asg_name = "KOPs Master"
