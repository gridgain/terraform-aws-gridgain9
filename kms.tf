
locals {
  create_kms_key = var.kms_key_alias == ""
  kms_key_arn    = local.create_kms_key ? module.kms.key_arn : data.aws_kms_key.kms[0].arn
  kms_key_alias  = local.create_kms_key ? keys(module.kms.aliases)[0] : var.kms_key_alias
  kms_key_id     = local.create_kms_key ? module.kms.key_id : data.aws_kms_key.kms[0].id
}

data "aws_kms_key" "kms" {
  count  = local.create_kms_key ? 0 : 1
  key_id = "alias/${var.kms_key_alias}"
}

module "kms" {
  create  = local.create_kms_key
  source  = "terraform-aws-modules/kms/aws"
  version = "3.1.0"

  aliases = [
    "${var.name}-kms"
  ]

  key_usage                = "ENCRYPT_DECRYPT"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"

  is_enabled          = true
  multi_region        = true
  enable_key_rotation = true

  description = "KMS key for encrypting ${var.fullname} cluster data"
  tags = merge(local.tags, {
    Name        = "${var.name}-kms"
    Description = "KMS key for encrypting ${var.fullname} cluster data"
  })
}
