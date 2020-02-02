# AWS VPC setup using Terraform

Creates a single VPC with a public and private subnet in each availability zone in the eu-west-2 region.

Creates a VPC internet gateway and an eip/nat gateway for each availability zone in the eu-west-2 region.

Creates a single public route table and associates the public subnet of each availability zone in the eu-west-2 region.

Creates multiple private route tables and associates the private subnet of each availability zone in the eu-west-2 region.

Creates a route to the VPC internet gateway on the single public route table.

Creates a route to the availablity zone nat gateway on each of the private route tables.

Creates a public network ACL and associates the public subnet of each availability zone in the eu-west-2 region.

Creates a private network ACL and associates the private subnet of each availability zone in the eu-west-2 region.

Creates ingress/egress on the public and private network ACLs to allow all traffic/ports.

Creates a public security group and private security group.

Creates an Amazon Linux EC2 instance with 10 GB std EBS volume in the public and private subnet of each availability zone in the eu-west-2 region.

Associates the public and private security groups to the EC2 instances.

cd ~\terraform\account\lab\vpc

terraform init

terraform plan

terraform apply

To access the EC2 instances (bastion hosts) in the Public subnets and jump to the EC2 instances in the Private subnets, you need to do the following:

We need to create a new key-pair and load the public key into the EC2 instance. The quickest way is to destroy and apply.

terraform destroy

Run ssh-keygen to create private/public keys.

Change the permissions on ~\.ssh\id_rsa and ~\.ssh\id_rsa.pub so you are the owner.

Start the ssh-agent service.

Run ssh-add -k ~\.ssh\id_rsa

Copy the contents of ~\.ssh\id_rsa.pub to ~\terraform\modules\base\ec2\ec2.tf aws_key_pair resource public_key.

terraform plan

terraform apply

Now you can connect to the Public EC2 instances. You will need to grab the Public IP of the EC2 instance you want to connect to.

ssh -A -i "~\.ssh\id_rsa" ec2-user@XXXXXXXXX.eu-west-2.compute.amazonaws.com

You no longer need to specify a private key to connect to the Private EC2 instances.

ssh ec2-user@10.0.X.X
