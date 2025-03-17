locals {
  create_vpc = var.vpc_id == ""
  vpc_id     = local.create_vpc ? aws_vpc.vpc[0].id : var.vpc_id
  subnets    = local.create_vpc ? aws_subnet.subnet[*].id : var.subnet_ids
}

/* Routing table for internet gateway */
resource "aws_route_table" "igw_rtbl" {
  count  = local.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  tags = merge(local.tags, {
    Name        = "${var.name}-igw-rtbl",
    Description = "${var.fullname} IGW routing table"
  })
}

resource "aws_route_table_association" "igw_rtbla" {
  count          = local.create_vpc ? 1 : 0
  gateway_id     = aws_internet_gateway.igw[0].id
  route_table_id = aws_route_table.igw_rtbl[0].id
}

# The default route, mapping the VPC's CIDR block to "local", is created implicitly and cannot be specified.
/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "igw" {
  count  = local.create_vpc ? 1 : 0
  vpc_id = aws_vpc.vpc[0].id

  tags = merge(local.tags, {
    Name        = "${var.name}-igw",
    Description = "${var.fullname} IGW"
  })
}

/* Routing table for subnets */
resource "aws_route_table" "rtbl" {
  count  = local.create_vpc ? local.az_count : 0
  vpc_id = aws_vpc.vpc[0].id

  tags = merge(local.tags, {
    Name        = "${var.name}-${var.zones[count.index]}-rtbl",
    Description = "${var.fullname} PVT routing table ${var.zones[count.index]}"
  })
}

/* Routing table associations for subnets */
resource "aws_route_table_association" "rtbla" {
  count          = local.create_vpc ? local.az_count : 0
  subnet_id      = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = element(aws_route_table.rtbl.*.id, count.index)
}

/* Default route to IGW */
resource "aws_route" "pub_igw_rtblr" {
  count                  = local.create_vpc ? local.az_count : 0
  route_table_id         = element(aws_route_table.rtbl.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw[0].id
}

/* Subnet */
resource "aws_subnet" "subnet" {
  count  = local.create_vpc ? local.az_count : 0
  vpc_id = aws_vpc.vpc[0].id

  cidr_block              = var.subnet_cidrs[count.index]
  availability_zone       = var.zones[count.index]
  map_public_ip_on_launch = false

  tags = merge(local.tags, {
    Name        = "${var.name}-${var.zones[count.index]}-subnet",
    Description = "${var.fullname} subnet"
  })
}

resource "aws_vpc" "vpc" {
  count                = local.create_vpc ? 1 : 0
  enable_dns_hostnames = true
  enable_dns_support   = true

  cidr_block = var.vpc_cidr

  tags = merge(local.tags, {
    Name        = "${var.name}-vpc"
    Description = "${var.fullname} VPC"
  })
}
