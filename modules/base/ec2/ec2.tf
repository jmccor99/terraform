locals {
  instance-userdata = <<EOF
		#! /bin/bash
    sudo yum update -y
		sudo yum install -y httpd
		sudo service httpd start
		echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	EOF
}

resource "aws_key_pair" "this" {
  key_name        = "ec2-key"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCiOm0As3xMMbaEkHadNqlxGZ8x4/K55QLms6+Hmg0mUdvdGHkhTbCqotov55MiMlvYCM5p7drHich7hj17BsilWD+7HSP57onDWBheNGj+VCo0mTLOc2YMR1+21SSNpiRbeGrYh2e0jUGcp4gpE0I+gQ1DNpjK+HittRJJ6vx4s+D4SedgnNwhOU3Yaihn6sSfRNHrWo43xBkM6ohUkI6ofNmjmsGMRUvUNYSjLjwT04JtLqd+dpufXQ/1VCytfsEqyKpYhE7EAlBilez8dOlgb2iwKqb9CapOth1msaoV4tJCOQ2ntAv+KyWus4880YdgCoYrv2PmMLk9J2+N9wyX johnm@DESKTOP-JKHO39P"
}

resource "aws_instance" "public_ec2" {
  count                       = length(var.public_subnets)
  ami                         = "ami-f976839e"
  instance_type               = "t2.micro"
  key_name                    = "ec2-key"
  vpc_security_group_ids      = [var.public_security_group_id]
  subnet_id                   = var.public_subnets.*[count.index]
  associate_public_ip_address = "true"
  user_data_base64            = base64encode(local.instance-userdata)
 
  root_block_device {
    volume_size           = "10"
    volume_type           = "standard"
    delete_on_termination = "true"
  }
 
  tags = {
    Name = "Amazon Linux Public"
  } 
}

resource "aws_instance" "private_ec2" {
  count                       = length(var.private_subnets)
  ami                         = "ami-f976839e"
  instance_type               = "t2.micro"
  key_name                    = "ec2-key"
  vpc_security_group_ids      = [var.private_security_group_id]
  subnet_id                   = var.private_subnets.*[count.index]
  associate_public_ip_address = "false"
  user_data_base64            = base64encode(local.instance-userdata)
 
  root_block_device {
    volume_size           = "10"
    volume_type           = "standard"
    delete_on_termination = "true"
  }
 
  tags = {
    Name = "Amazon Linux Private"
  } 
}