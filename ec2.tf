resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      description      = "TLS from VPC"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = [module.vpc.vpc_cidr_block, "${chomp(data.http.myip.body)}/32"]
    }
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = var.owner_tag
}

resource "tls_private_key" "tlskey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = var.key_name      
  public_key = tls_private_key.tlskey.public_key_openssh

  provisioner "local-exec" { 
    command = "echo '${tls_private_key.tlskey.private_key_pem}' > ./jenkinskp.pem"
  }
}

resource "aws_instance" "jenkins" {
  ami             = data.aws_ami.amazon_linux.id
  instance_type   = var.instance_type
  key_name        = var.key_name
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  subnet_id = module.vpc.public_subnets[0]
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("./jenkinskp.pem")
    host     = aws_instance.jenkins.public_ip
  }
  provisioner "remote-exec" {
    inline = [
              "sudo yum update –y",
              "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
              "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
              "sudo yum upgrade -y",
              "sudo amazon-linux-extras install epel -y",
              "sudo yum update -y",
              "sudo yum install jenkins java-1.8.0-openjdk-devel -y",
              "sudo systemctl daemon-reload",
              "sudo systemctl start jenkins",
              "sudo systemctl status jenkins",
              "sudo sleep 30",
              "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
             ]
  }

  tags = var.owner_tag
}
