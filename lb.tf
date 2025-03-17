
resource "aws_lb" "this" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.this.id]
  subnets            = local.subnets

  enable_deletion_protection       = false
  enable_cross_zone_load_balancing = true
  enable_http2                     = true
  idle_timeout                     = 60

  tags = merge(local.tags, {
    Name = "${var.name}-lb"
  })
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 10300
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.name}-tg"
  port     = 10300
  protocol = "HTTP"
  vpc_id   = local.vpc_id

  health_check {
    path                = "/management/v1/node/state"
    port                = 10300
    protocol            = "HTTP"
    timeout             = 5
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = merge(local.tags, {
    Name = "${var.name}-tg"
  })
}

resource "aws_lb_target_group_attachment" "this" {
  count            = var.nodes_count
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = aws_instance.this[count.index].id
  port             = 10300
}
