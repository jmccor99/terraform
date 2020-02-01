resource "aws_eip" "public" {
  count         = length(var.public_subnets)
  vpc           = true
  tags = {
    Name = "${var.azs[count.index]}"
  }
}

resource "aws_nat_gateway" "ngw" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.public.*.id[count.index]
  subnet_id     = var.public_subnets.*[count.index]
  tags = {
    Name = "${var.azs[count.index]}"
  }
}

resource "aws_route_table" "private" {
  count  = length(var.azs)
  vpc_id = var.vpc_id
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
  subnet_id      = var.private_subnets.*[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}