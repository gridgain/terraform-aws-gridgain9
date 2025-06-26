locals {
  security_group = {
    ingress = flatten([
      [
        for range in var.public_allowlist : [
          for port in var.ports : {
            from  = port
            to    = port
            proto = port == 0 ? "-1" : "tcp"
            cidrs = [range]
            desc  = "Allow ${port} from ${range} for incoming traffic"
          }
        ]
      ]
    ])
    egress = [{
      from  = 0
      to    = 0
      proto = -1
      cidrs = ["0.0.0.0/0"]
      desc  = "Allow any outgoing traffic"
    }]
  }
}

resource "aws_security_group" "this" {
  name        = "${var.name}-sg"
  description = "Controls access to ${var.fullname} instance"
  vpc_id      = local.vpc_id

  tags = merge(local.tags, {
    Name        = "${var.name}-sg"
    Description = "Controls access to ${var.fullname} instance",
  })
}

resource "aws_security_group_rule" "ingress" {
  count = length(local.security_group.ingress)

  type              = "ingress"
  from_port         = local.security_group.ingress[count.index].from
  to_port           = local.security_group.ingress[count.index].to
  protocol          = local.security_group.ingress[count.index].proto
  cidr_blocks       = local.security_group.ingress[count.index].cidrs
  description       = local.security_group.ingress[count.index].desc
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group_rule" "egress" {
  count = length(local.security_group.egress)

  type              = "egress"
  from_port         = local.security_group.egress[count.index].from
  to_port           = local.security_group.egress[count.index].to
  protocol          = local.security_group.egress[count.index].proto
  cidr_blocks       = local.security_group.egress[count.index].cidrs
  description       = local.security_group.egress[count.index].desc
  security_group_id = aws_security_group.this.id
}
