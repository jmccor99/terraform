output "vpc_id" {
  value = module.vpc.vpc_id
}

output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "default_route_table_id" {
  value = module.vpc.default_route_table_id
}

output "default_network_acl_id" {
  value = module.vpc.default_network_acl_id
}

output "subnet_public_ids" {
    value = module.subnet.subnet_public_ids
}

output "subnet_private_ids" {
    value = module.subnet.subnet_private_ids
}