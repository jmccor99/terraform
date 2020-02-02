resource "aws_key_pair" "this" {
  key_name        = "ec2-key"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 lab@local"
}

resource "aws_instance" "public_ec2" {
  count                       = length(var.public_subnets)
  ami                         = "ami-f976839e"
  instance_type               = "t2.micro"
  key_name                    = "ec2-key"
  vpc_security_group_ids      = [var.public_security_group_id]
  subnet_id                   = var.public_subnets.*[count.index]
  associate_public_ip_address = "false"
 
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
 
  root_block_device {
    volume_size           = "10"
    volume_type           = "standard"
    delete_on_termination = "true"
  }
 
  tags = {
    Name = "Amazon Linux Private"
  } 
}