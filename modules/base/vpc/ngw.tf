resource "aws_eip" "public" {
  count         = length(var.public_subnets)
  vpc           = true

}

resource "aws_nat_gateway" "public" {
  count         = length(var.public_subnets)
  allocation_id = aws_eip.public.*.id[count.index]
  subnet_id     = aws_subnet.public.*.id[count.index]
  depends_on    = [aws_subnet.public]

}