module "vpc" {
  source = "../modules/networking"

  name = "vpc-devsu"

  networks = {
    cidr_block              = "192.168.0.0/16"
    private_subnets         = []
    public_subnets          = ["192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
    public_azs              = ["us-east-1a", "us-east-1b", "us-east-1c"]
    create_igw              = true
    create_natgw            = false
    public_subnet_tags      = { Name = "public" }
    public_route_table_tags = { Name = "rt-public" }
    igw_tags                = { Name = "igw" }
  }

  tags = {
    ManagedBy   = "Terraform"
    Environment = "Dev"
    Owner       = "Devsu"
  }

}

module "eks" {
  source = "../modules/eks"

  cluster_name                    = "eks-devsu"
  cluster_version                 = "1.30"
  cluster_subnet_ids              = module.vpc.public_subnet_ids
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false
  enable_irsa                     = true
  create_iam_role                 = true
  node_group_name                 = "node-group-devsu"
  desired_size                    = 1
  max_size                        = 2
  min_size                        = 1

  tags = {
    Environment = "dev"
    ManagedBy   = "Terraform"
    OwnedBy     = "Devsu"
  }

  depends_on = [module.vpc]
}

module "acm" {
  source = "../modules/acm"

  private_key = "${path.module}/devsu-devops.com.key"
  certificate = "${path.module}/devsu-devops.com.crt"
}

resource "kubernetes_namespace_v1" "nginx" {
  metadata {
    name = "nginx-ingress"
  }

  depends_on = [module.eks]
}

resource "kubernetes_namespace_v1" "dev" {
  metadata {
    name = "dev"
  }

  depends_on = [module.eks]
}

resource "kubernetes_namespace_v1" "prod" {
  metadata {
    name = "prod"
  }

  depends_on = [module.eks]
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://helm.nginx.com/stable"
  chart      = "nginx-ingress"
  version    = "2.2.2"
  namespace  = kubernetes_namespace_v1.nginx.metadata[0].name
  values = [
    yamlencode({
      controller = {
        replicaCount = 2
        service = {
          annotations = {
            "service.beta.kubernetes.io/aws-load-balancer-backend-protocol"       = "http"
            "service.beta.kubernetes.io/aws-load-balancer-proxy-protocol"         = "*"
            "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"               = module.acm.acm_arn
            "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"              = "443"
            "service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy" = "ELBSecurityPolicy-TLS13-1-3-2021-06"
            "service.beta.kubernetes.io/aws-load-balancer-type"                   = "nlb"
          }
        }
      }
    })
  ]

  depends_on = [module.eks, module.acm]
}