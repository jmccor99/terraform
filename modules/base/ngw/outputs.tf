output "aws_route_table_private_ids" {
    value = aws_route_table.private.*.id
}