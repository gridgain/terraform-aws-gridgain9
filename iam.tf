data "aws_partition" "current" {}

data "aws_iam_policy_document" "assume-role" {
  statement {
    sid     = "EC2AssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "this" {
  name = "${var.name}-iam-role"

  assume_role_policy = data.aws_iam_policy_document.assume-role.json

  tags = merge(local.tags, {
    Name = "${var.name}-iam-role"
  })
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "kms:Decrypt",
      "kms:DescribeKey",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyPair",
    ]
    resources = [
      local.kms_key_arn,
    ]
  }

  statement {
    actions = [
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeLoadBalancerPolicies",
      "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeAccountLimits",
      "elasticloadbalancing:DescribeListenerAttributes",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTrustStoreAssociations",
      "elasticloadbalancing:DescribeTrustStoreRevocations",
      "elasticloadbalancing:DescribeTrustStores",
      "elasticloadbalancing:GetResourcePolicy"
    ]
    resources = [aws_lb.this.arn]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "arn:aws:logs:*:*:log-group:/gridgain/*",
    ]
  }
}

resource "aws_iam_policy" "this" {
  name        = "${var.name}-kms-iam-policy"
  description = "IAM Policy providing access to KMS for ${var.fullname}"
  policy      = data.aws_iam_policy_document.this.json

  tags = merge(local.tags, {
    Name        = "${var.name}-kms-iam-policy",
    Description = "IAM Policy providing access to KMS for ${var.fullname}"
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.ssm_enable ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  count      = var.cloudwatch_logs_enable ? 1 : 0
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.name}-iam-profile"
  role = aws_iam_role.this.name

  tags = merge(local.tags, {
    Name        = "${var.name}-iam-profile",
    Description = "IAM InstanceProfile for ${var.fullname}"
  })

  lifecycle {
    create_before_destroy = true
  }
}
