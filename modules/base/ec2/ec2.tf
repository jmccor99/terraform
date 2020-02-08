resource "aws_key_pair" "this" {
  key_name        = "ec2-key"
  public_key      = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCfUlbK1mhjAXKtMnhEF8xHKFo6RWoVBXEDRbf1tTYEbnZKQiY/TvL3vyfVsP4QebIlCFnMQT8AeTaj+SX5eCO0mgPHbJG2rsxgfUE2eN4TVkknJpxUmYqTlpl4JM0H538l7yncGSjAaoPkxLJdfA9TDQ2oiWxnoMXPq63ts0/mZOKB3J0cA+3Yh7pExnTvNEQRVCqTFRLf/Wp3yVvuD0E5QEMXPQxYJr64rvA4g4S2BJAN/rca0/gAWI93Uw+KcSGGTzOZ/cJiVgseBWWQFh3+3Du7Yzh073UYrfI4Fak7l02zfNMkZ1B3dwUE06GdO2wucCe4w/QP1wwY+RJs0zlR johnm@DESKTOP-JKHO39P"
}

resource "aws_instance" "public_ec2" {
  count                       = length(var.public_subnets)
  ami                         = "ami-f976839e"
  instance_type               = "t2.micro"
  key_name                    = "ec2-key"
  vpc_security_group_ids      = [var.public_security_group_id]
  subnet_id                   = var.public_subnets.*[count.index]
  associate_public_ip_address = "true"
 
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