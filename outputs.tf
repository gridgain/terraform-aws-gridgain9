################################################################################
# Networking
################################################################################

output "vpc_id" {
  description = "ID of a VPC used for GridGain nodes"
  value       = local.vpc_id
}

output "subnet_ids" {
  description = "List of private subent IDs"
  value       = local.subnets
}

output "security_group_id" {
  description = "ID of the security group used for GridGain nodes"
  value       = aws_security_group.this.id
}

output "lb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "lb_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

################################################################################
# Encryption
################################################################################
output "kms_key_alias" {
  description = "KMS key alias used for snapshot encryption"
  value       = ""
}

################################################################################
# EC2 Instances
################################################################################
output "instance_ids" {
  description = "List of EC2 instance IDs"
  value = try(
    aws_instance.this.*.id,
    [],
  )
}

output "isntance_arns" {
  description = "List of ARNs assigned to the instances"
  value = try(
    aws_instance.this.*.arn,
    [],
  )
}

output "instance_state" {
  description = "List of instance states"
  value = try(
    aws_instance.this.*.instance_state,
    [],
  )
}

output "primary_network_interface_ids" {
  description = "List of primary network interface IDs"
  value = try(
    aws_instance.this.*.primary_network_interface_id,
    [],
  )
}

output "private_dns" {
  description = "List of private DNS names assigned to the instances"
  value = try(
    aws_instance.this.*.private_dns,
    [],
  )
}

output "public_dns" {
  description = "List of public DNS names assigned to the instances"
  value = try(
    aws_instance.this.*.public_dns,
    [],
  )
}

output "public_ips" {
  description = "List of public IP addresses assigned to the instances"
  value = try(
    aws_instance.this.*.public_ip,
    [],
  )
}

output "private_ip" {
  description = "List of private IP addresses assigned to the instances"
  value = try(
    aws_instance.this.*.private_ip,
    [],
  )
}

output "ipv6_addresses" {
  description = "List of IPv6 addresses assigned to the instances, if applicable"
  value = try(
    aws_instance.this.*.ipv6_addresses,
    [],
  )
}

output "tags_all" {
  description = "A map of tags assigned to the resources, including those inherited from the provider default_tags configuration block"
  value = try(
    aws_instance.this[0].tags_all,
    {},
  )
}

output "ami" {
  description = "AMI ID that was used to create the instances"
  value = try(
    aws_instance.this[0].ami,
    null,
  )
}

output "availability_zone" {
  description = "The availability zone of the created instances"
  value = try(
    distinct(aws_instance.this.*.availability_zone),
    [],
  )
}

################################################################################
# IAM Role / Instance Profile
################################################################################

output "iam_role_name" {
  description = "The name of the IAM role"
  value       = try(aws_iam_role.this.name, null)
}

output "iam_role_arn" {
  description = "The Amazon Resource Name (ARN) specifying the IAM role"
  value       = try(aws_iam_role.this.arn, null)
}

output "iam_role_unique_id" {
  description = "Stable and unique string identifying the IAM role"
  value       = try(aws_iam_role.this.unique_id, null)
}

output "iam_instance_profile_arn" {
  description = "ARN assigned by AWS to the instance profile"
  value       = try(aws_iam_instance_profile.this.arn, null)
}

output "iam_instance_profile_id" {
  description = "Instance profile's ID"
  value       = try(aws_iam_instance_profile.this.id, null)
}

output "iam_instance_profile_unique" {
  description = "Stable and unique string identifying the IAM instance profile"
  value       = try(aws_iam_instance_profile.this.unique_id, null)
}

output "ssm_connect_commands" {
  description = "The AWS CLI command to connect to the instance using Session Manager"
  value = [
    for instance in aws_instance.this : "aws ssm start-session --target ${instance.id} --region ${data.aws_region.this.region}"
  ]
}
