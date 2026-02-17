# Módulo AWS EKS

Módulo de Terraform para crear recursos de EKS en AWS.

## Uso

Para crear los recursos de EKS, se debe de crear previamente infraestructura de VPC, con al menos dos subredes en dos zonas de disponibilidad diferentes.

```hcl
module "eks-cluster" {
  source = "../../../modules/eks"

  cluster_name       = "eks-demo-cluster"
  cluster_version    = "1.27"
  cluster_subnet_ids = module.vpc.private_subnet_ids
  enable_irsa        = true
  create_iam_role    = true
  node_group_name    = "node-group-demo"
  desired_size       = 1
  max_size           = 2
  min_size           = 1

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    OwnedBy     = "Devsu"
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
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_ec2_tag.subnet_cluster_owner_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [aws_ec2_tag.subnet_cluster_lb_tag](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_tag) | resource |
| [tls_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data/tls_certificate) | data |
| [aws_iam_openid_connect_provider.oidc_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data/iam_policy_document) | data |
| [aws_iam_role.eks_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_policy_document.nodes_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data/iam_policy_document) | data |
| [aws_iam_role.node_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |

## Inputs

| Nombre | Descripción | Tipo | Por Defecto | Requerido |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster_name](#input_cluster_name) | Nombre del Cluster EKS | `string` | `"demo_eks_cluster"` | Sí |
| <a name="input_cluster_version"></a> [cluster_version](#input_cluster_version) | Versión de Kubernetes | `string` | `1.26` | no |
| <a name="input_cluster_enabled_log_types"></a> [cluster_enabled_log_types](#input_cluster_enabled_log_types) | Tipos de Logs a extraer de EKS | `list(string)` | `[]` | no |
| <a name="input_iam_role_arn"></a> [iam_role_arn](#input_iam_role_arn) | ARN de IAM Role para Cluster EKS | `string` | `null` | no |
| <a name="input_cluster_security_groups"></a> [cluster_security_groups](#input_cluster_security_groups) | Lista de Security Group IDs | `list(string)` | `[]` | no |
| <a name="input_cluster_subnet_ids"></a> [cluster_subnet_ids](#input_cluster_subnet_ids) | Lista de Subnet IDs | `list(string)` | `[]` | no |
| <a name="input_cluster_endpoint_private_access"></a> [cluster_endpoint_private_access](#input_cluster_endpoint_private_access) | Acceso Privado a Kubernetes API Server | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster_endpoint_public_access](#input_cluster_endpoint_public_access) | Acceso Público a Kubernetes API Server | `bool` | `false` | no |
| <a name="input_cluster_public_access_cidrs"></a> [cluster_public_access_cidrs](#input_cluster_public_access_cidrs) | CIDR Block que son permitidos de acceder a Kubernetes API Server, si el acceso público está permitido | `list(string)` | `[]` | no |
| <a name="input_enable_irsa"></a> [enable_irsa](#input_enable_irsa) | Habilitar IAM Roles for Service Accounts | `bool` | `false` | no |
| <a name="input_openid_connect_audiences"></a> [openid_connect_audiences](#input_openid_connect_audiences) | Audiencias OpenID | `list(string)` | `[]` | no |
| <a name="input_custom_oidc_thumbprints"></a> [custom_oidc_thumbprints](#input_custom_oidc_thumbprints) | Custom ODIC Thumbprints | `list(string)` | `[]` | no |
| <a name="input_create_iam_role"></a> [create_iam_role](#input_create_iam_role) | Crear IAM Role para Cluster EKS | `bool` | `false` | no |
| <a name="input_node_group_name"></a> [node_group_name](#input_node_group_name) | Nombre de Node Group | `string` | `demo_eks_node_group` | no |
| <a name="input_instance_types"></a> [instance_types](#input_instance_types) | Tipo de Instancia EC2 para Node Group | `list(string)` | `[]` | no |
| <a name="input_desired_size"></a> [desired_size](#input_desired_size) | Cantidad de Instancias EC2 deseadas | `number` | `0` | no |
| <a name="input_max_size"></a> [max_size](#input_max_size) | Cantidad Máxima de incremento de Instancias EC2 | `number` | `0` | no |
| <a name="input_min_size"></a> [min_size](#input_min_size) | Cantidad Mínima de Instancias EC2 | `number` | `0` | no |
| <a name="input_cluster_tags"></a> [cluster_tags](#input_cluster_tags) | Tags para el cluster EKS | `map(string)` | `{}` | no |
| <a name="input_node_tags"></a> [node_tags](#input_node_tags) | Tags para Node Group | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input_tags) | Tags para los recursos del módulo | `map(string)` | `{}` | no |


## Outputs

| Nombre | Descripción |
|------|-------------|
| <a name="output_eks_cluster_name"></a> [eks_cluster_name](#output_eks_cluster_name) | EKS Cluster Name |
| <a name="output_eks_cluster_arn"></a> [eks_cluster_arn](#output_eks_cluster_arn) | EKS Cluster ARN |
| <a name="output_eks_cluster_endpoint"></a> [eks_cluster_endpoint](#output_eks_cluster_endpoint) | EKS Cluster API Server Endpoint |
| <a name="output_eks_cluster_platform_version"></a> [eks_cluster_platform_version](#output_eks_cluster_platform_version) | Kubernetes Version |
| <a name="output_eks_node_group_name"></a> [eks_node_group_name](#output_eks_node_group_name) | EKS Cluster Managed Node Group Name |
| <a name="output_eks_node_group_arn"></a> [eks_node_group_arn](#output_eks_node_group_arn) | EKS Cluster Managed Node Group ARN |