resource "aws_lb_target_group" "public" {
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "Public"
  }
}

resource "aws_lb_target_group" "private" {
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name = "Private"
  }
}

resource "aws_lb_target_group_attachment" "public" {
  count            = length(var.public_ec2_id)
  target_group_arn = aws_lb_target_group.public.arn
  target_id        = var.public_ec2_id[count.index]
  port             = 80
}

resource "aws_lb_target_group_attachment" "private" {
  count            = length(var.private_ec2_id)
  target_group_arn = aws_lb_target_group.private.arn
  target_id        = var.private_ec2_id[count.index]
  port             = 80
}

resource "aws_lb" "public" {
  name                             = "public"
  internal                         = false
  load_balancer_type               = "network"
  subnets                          = var.public_subnets
  enable_cross_zone_load_balancing = true
}

resource "aws_lb" "private" {
  name                             = "private"
  internal                         = true
  load_balancer_type               = "network"
  subnets                          = var.private_subnets
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "public" {
  load_balancer_arn = aws_lb.public.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public.arn
  }
}

resource "aws_lb_listener" "private" {
  load_balancer_arn = aws_lb.private.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private.arn
  }
}