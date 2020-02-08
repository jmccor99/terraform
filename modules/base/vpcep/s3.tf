resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.vpc_id
  service_name = "com.amazonaws.eu-west-2.s3"
  
}

resource "aws_vpc_endpoint_route_table_association" "route_table_association" {
  count           = length(var.aws_route_table_private_ids)
  route_table_id  = var.aws_route_table_private_ids[count.index]
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}