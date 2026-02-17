# Módulo AWS VPC

Módulo de Terraform para crear recursos de VPC en AWS

## Uso

```hcl
module "vpc" {
  source  = "modules/vpc"

  networks = {
    cidr_block               = "10.0.0.0/16"
    private_subnets          = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
    public_subnets           = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
    create_igw               = true
    create_natgw             = true
    public_subnet_tags       = { Name = "public" }
    private_subnet_tags      = { Name = "private" }
    public_route_table_tags  = { Name = "rt-public" }
    private_route_table_tags = { Name = "rt-private" }
    igw_tags                 = { Name = "igw" }
    natgw_tags               = { Name = "natgw" }
    eip_tags                 = { Name = "eip-nat" }
  }

  name = "vpc-dev"

  tags = {
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Owner       = "Devsu"
  }
}
```

## Requerimientos

| Nombre | Versión |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Proveedores

| Nombre | Versión |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |


## Recursos

| Nombre | Tipo |
|------|------|
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_ec2_transit_gateway_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_transit_gateway_route_table_association) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route.public_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_natgw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Nombre | Descripción | Tipo | Por Defecto | Requerido |
|------|-------------|------|---------|:--------:|
| <a name="input_networks"></a> [networks](#input\_networks) | Variable que contiene todos los atributos necesarios para la creación de VPC | `map(object)` | `null` | Sí |
| <a name="input_networks_cidr_block"></a> [networks.cidr_block](#input_networks_cidr_block) | CIDR Block para la VPC | `string` | `null` | Sí |
| <a name="input_networks_private_subnets"></a> [networks.private_subnets](#input_networks_private_subnets) | Lista de CIDR Block para las subredes privadas | `list(string)` | `null` | Sí |
| <a name="input_networks_public_subnets"></a> [networks.public_subnets](#input_networks_public_subnets) | Lista de CIDR Block para las subredes públicas | `list(string)` | `[]` | no |
| <a name="input_networks_create_igw"></a> [networks.create_igw](#input_networks_create_igw) | Controla si se debe crear Internet Gateway | `bool` | `false` | no |
| <a name="input_networks_create_natgw"></a> [networks.create_natgw](#input_networks_create_natgw) | Controla si se debe crear NAT Gateway | `bool` | `false` | no |
| <a name="input_networks_public_subnet_tags"></a> [networks.public_subnet_tags](#input_networks_public_subnet_tags) | Tags para las subredes públicas | `map(string)` | `{ Name = "" }` | no |
| <a name="input_networks_private_subnet_tags"></a> [networks.private_subnet_tags](#input_networks_private_subnet_tags) | Tags para las subredes privadas | `map(string)` | `{ Name = "" }` | no |
| <a name="input_networks_public_route_table_tags"></a> [networks.public_route_table_tags](#input_networks_public_route_table_tags) | Tags para las tablas de enrutamiento públicas | `map(string)` | `{ Name = "" }` | no |
| <a name="input_networks_private_route_table_tags"></a> [networks.private_route_table_tags](#input_networks_private_route_table_tags) | Tags para las tablas de enrutamiento privadas | `map(string)` | `{ Name = "" }` | no |
| <a name="input_networks_igw_tags"></a> [networks.igw_tags](#input_networks_igw_tags) | Tags para Internet Gateway | `map(string)` | `{ Name = "" }` | no |
| <a name="input_networks_natgw_tags"></a> [networks.natgw_tags](#input_networks_natgw_tags) | Tags para NAT Gateway | `map(string)` | `{ Name = "" }` | no |
| <a name="input_networks_eip_tags"></a> [networks.eip_tags](#input_networks_eip_tags) | Tags para Elastic IP | `map(string)` | `{ Name = "" }` | no |
| <a name="input_name"></a> [name](#input_name) | Nombre para la VPC | `string` | `""` | Sì |
| <a name="input_tags"></a> [tags](#input_tags) | Tags para todos los recursos del módulo | `map(string)` | `{}` | Sì |

## Outputs

| Nombre | Descripción |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc_id](#output_vpc_id_) | VPC ID |
| <a name="output_vpc_arn"></a> [vpc_arn](#output_vpc_arn) | VPC Arn |
| <a name="output_vpc_cidr_block"></a> [vpc_cidr_block](#output_vpc_cidr_block) | VPC CIDR Block |
| <a name="output_public_subnet_ids"></a> [public_subnet_ids](#output_public_subnet_ids) | IDs de las subredes públicas |
| <a name="output_public_route_table_ids"></a> [public_route_table_ids](#output_public_route_table_ids) | IDs de las tablas de enrutamiento públicas |
| <a name="output_private_subnet_ids"></a> [private_subnet_ids](#output_public_subnet_ids) | IDs de las subredes privadas |
| <a name="output_private_route_table_ids"></a> [private_route_table_ids](#output_public_route_table_ids) | IDs de las tablas de enrutamiento privadas |
| <a name="output_igw_id"></a> [igw_id](#output_igw_id) | Internet Gateway ID |
| <a name="output_igw_arn"></a> [igw_arn](#output_igw_arn) | Internet Gateway Arn |
| <a name="output_natgw_ids"></a> [natgw_ids](#output_natgw_ids) | IDs de NAT Gateway |
| <a name="output_nat_public_ips"></a> [nat_public_ips](#output_nat_public_ips) | IDs de las Elastic IPs asociadas a NAT Gateways |