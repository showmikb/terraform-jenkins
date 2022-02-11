variable "vpc_name" {
  default = "terraform-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "az_list" {
  type = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnet_list" {
  type = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_list" {
  type = list(string)
  default = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

variable "owner_tag" {
  type = map(string)
  default = {
    Terraform = "true"
    Environment = "dev"
    Owner = "showmik-devops-monk"
    Name = "terraform-jenkins"
  }
}

variable "sg_ports" {
  type = list(number)
  default = [443, 22, 80, 8080]
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "key_name" {
  type = string
  default = "jenkins_kp"
}

