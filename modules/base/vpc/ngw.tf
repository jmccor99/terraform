resource "aws_eip" "public" {
  count         = length(var.public_subnets)
  vpc           = true
  tags = {
    Name = "${aws_subnet.public.*.availability_zone[count.index]}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.public.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]
  depends_on    = [aws_subnet.public]
  tags = {
    Name = "${aws_subnet.public.*.availability_zone[count.index]}"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.azs[count.index]}"
  }
}

resource "aws_route" "private" {
  count                  = length(var.azs)
  route_table_id         = aws_route_table.private.*.id[count.index]
  gateway_id             = aws_nat_gateway.ngw.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.private]
  lifecycle {
    ignore_changes = [gateway_id]
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]

  depends_on = [
    aws_subnet.private,
    aws_route_table.private,
  ]
}