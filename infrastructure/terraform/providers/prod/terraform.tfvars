#Global
region   = "eu-west-1"
env      = "prod"

#Network
name              = "VPN test VPC"
vpc_cidr          = "172.21.0.0/16"
cidrs             = "172.21.1.0/24,172.21.2.0/24,172.21.3.0/24"
priv_cidrs        = "172.21.4.0/24,172.21.5.0/24,172.21.6.0/24"
azs               = "eu-west-1a,eu-west-1b,eu-west-1c"
kops_dns_zone     = "kops.prod.alexbaily.com"
kops_state_bucket = "state.kops.prod.alexbaily.com"
vpc_dns           = "172.21.0.2"

#Compute
kops_ami_id     = "ami-0a70add31403078a2"
asg_name        = "KOPs Master"
consul_ami_id   = "ami-00e9e5a91bf0929be"
consul_asg_name = "Consul Servers ASG"
ecs_ami_id      = "ami-0627e141ce928067c"
ecs_asg_name    = "ECS Host Instances ASG"
