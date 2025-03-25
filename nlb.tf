
resource "aws_lb" "cluster" {
  name               = "${var.name}-nlb"
  internal           = true
  load_balancer_type = "network"
  security_groups    = [aws_security_group.this.id]
  subnets            = local.subnets

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true

  tags = merge(local.tags, {
    Name = "${var.name}-nlb"
  })
}

resource "aws_lb_listener" "cluster" {
  load_balancer_arn = aws_lb.cluster.arn
  port              = 3344
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cluster.arn
  }
}

resource "aws_lb_target_group" "cluster" {
  name     = "${var.name}-cluster-tg"
  port     = 3344
  protocol = "TCP"
  vpc_id   = local.vpc_id

  tags = merge(local.tags, {
    Name = "${var.name}-cluster-tg"
  })
}

resource "aws_lb_target_group_attachment" "cluster" {
  count            = var.nodes_count
  target_group_arn = aws_lb_target_group.cluster.arn
  target_id        = aws_instance.this[count.index].id
  port             = 3344
}
