# Simple AWS VPC setup using Terraform

Creates a single VPC with a public and private subnet in each availability zone in the eu-west-2 region.

Creates a VPC internet gateway and an eip/nat gateway for each availability zone in the eu-west-2 region.

Creates a single public route table and associates the public subnet in each availability zone in the eu-west-2 region.

Creates multiple private route tables and associates the private subnet in each availability zone in the eu-west-2 region.

Creates a route to the VPC internet gateway on the single public route table.

Creates a route to the availablity zone nat gateway on each of the private route tables.

Creates a public network ACL and associates the public subnet in each availability zone in the eu-west-2 region.

Creates a private network ACL and associates the private subnet in each availability zone in the eu-west-2 region.

Creates ingress/egress on the public and private network ACLs to allow all traffic/ports.

Creates a public security group and private security group.

cd terraform\account\lab\vpc

terraform init
terraform plan
terraform apply