output "public_ec2_id" {
  description = "List of ARNs of instances"
  value       = aws_instance.public_ec2.*.id
}

output "private_ec2_id" {
  description = "List of ARNs of instances"
  value       = aws_instance.private_ec2.*.id
}