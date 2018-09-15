#Route 53 and DNS required for KOPs installation

variable kops_dns_zone {}

resource "aws_route53_zone" "kops_zone" {
  name = "${var.kops_dns_zone}"
}
