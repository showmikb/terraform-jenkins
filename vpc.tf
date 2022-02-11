module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.az_list
  private_subnets = var.private_subnet_list
  public_subnets  = var.public_subnet_list

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = var.owner_tag
}