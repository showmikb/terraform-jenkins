output "vpc_id" {
  value = module.vpc.vpc_id
}
output "ec2_ip" {
  value = aws_instance.jenkins.public_ip
}