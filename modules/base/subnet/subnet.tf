resource "aws_subnet" "public" {
  count             =  length(var.public_subnets)
  vpc_id            =  var.vpc_id
  cidr_block        =  var.public_subnets[count.index]
  availability_zone =  var.azs[count.index]
  tags = {
    Name = "public-${var.azs[count.index]}"
  }
}

resource "aws_subnet" "private" {
  count             =  length(var.private_subnets)
  vpc_id            =  var.vpc_id
  cidr_block        =  var.private_subnets[count.index]
  availability_zone =  var.azs[count.index]
  tags = {
    Name = "private-${var.azs[count.index]}"
  }
}