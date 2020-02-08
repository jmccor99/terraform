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

Creates an EC2 instance in each of the public and private subnets using the Amazon Linux ami.

Creates a public and private NLB with a TCP port 80 listener and target group using the EC2 instances.

Creates an api gateway with a lambda proxy integration.

Create an SNS topic with an SQS endpoint queue.

cd terraform\account\lab\vpc

terraform init

terraform plan

terraform apply
