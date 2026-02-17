locals {
  len_public_subnets      = length(var.networks.public_subnets)
  len_private_subnets     = length(var.networks.private_subnets)
  subnet_public_tag       = var.networks.public_subnet_tags["Name"] != "" ? var.networks.public_subnet_tags["Name"] : reverse(split("-", var.name))[0]
  subnet_private_tag      = var.networks.private_subnet_tags["Name"] != "" ? var.networks.private_subnet_tags["Name"] : reverse(split("-", var.name))[0]
  route_table_public_tag  = var.networks.public_route_table_tags["Name"] != "" ? var.networks.public_route_table_tags["Name"] : "rt-${reverse(split("-", var.name))[0]}"
  route_table_private_tag = var.networks.private_route_table_tags["Name"] != "" ? var.networks.private_route_table_tags["Name"] : "rt-${reverse(split("-", var.name))[0]}"
}
