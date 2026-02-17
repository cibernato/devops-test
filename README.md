# Devsu Devops Project

The follwing project has the goal of demonstrating the skills in Devops tools of the candidate.

The tech-stack used for the project is the following:
- Cloud: AWS
- CI/CD System: Azure Devops
- Container: Docker
- Orchestration: Kubernetes
- IaC: Terraform
- Templating: Helm
- Code Analysis: SonarCloud
- Vulnerability Scan: Snyk

To understand the functionality of the Java app, please click [here](java_app.md)

## Cloud Architecture

The architecture proposed is based on AWS, region `us-east-1`. It's a simple architecture to build EKS.

![Cloud Architecture](/images/cloud_architecture.jpg)

Composed by 3 public subnets, internet gateway, EKS control plane and EKS nodes.

Take in consideration the proposed architecture was build for simplicity and not to incur into high costs in the cloud. A production ready EKS should be built in private subnets, using NAT Gateways spread into multiple public subnets for high availability. The API Server endpoint should be private and accessible only through VPN or bastion server.

### Infrastructure as Code

All the AWS infrastructure is managed using Terraform.

Three modules were developed for this project:
- networking: configure all networking related services (VPC, Subnets, Internet Gateway, NAT Gateway, Route Tables)
- eks: configure IAM roles, EKS Cluster, EKS nodes, IRSA
- acm: configure a Certificate resource in AWS from a self-managed certificate

The Terraform State file is store in a S3 bucket.

## Kubernetes Architecture

![Kubernetes Architecture](/images/k8s_architecture.jpg)

Kubernetes architecture is composed by the following resources:
- Ingress: to handle traffic from external users
- Service: to load balance traffic to the pods
- Deployment: to maintain high availability for the app

The Ingress Controller installed in the cluster is Nginx, which creates a Network Load Balancer in AWS, to handle the requests outside the Kubernetes environment.

### Helm

A Helm chart is available to deploy the Kubernetes objects in the cloud, it contain the following templates:
- deployment
- service
- horizontalpodautoscarler
- ingress
- configmap
- secret

It helps to ease the deployment of the solution in different environments, just modifying the variables.

## Docker

Dockerfile contains the minimun necessary dependencies to run the Java application.

To test the app, a `docker-compose.yml` is provided. Execute the following command to build the Dockerfile.

```shell
# Build image locally
docker build -t devsu-devops-java-app:local .

# Run the app
docker-compose up --build -d
```

App is exposed on port 8000 locally, with the command `curl` to `localhost:8000` is possible to send requests.

## CI/CD

GitHub Actions is the tool used to automate the build, test, containerization, security scan and deploy of the Java app. 

### Branches

![Branches](/images/branch.png)

### Commit History

feature/dev
![Feature Commit History](/images/commits.png)


### Pipelines

The main pipeline file is `.github/workflows/app-pipeline.yml`.

The pipeline is composed of 5 jobs:
- Build: build Java app with Maven
- Test: unit test with Maven
- SonarCloud: static code analysis and code coverage with SonarCloud (only for master branch)
- Docker: build the container image and push it to Docker Hub
- Snyk: vulnerability scan at container OS level
- Deploy: deploy app into EKS

There is another pipeline in the project called `.github/workflows/iac-pipeline.yml`, this is used to create the infrastructure in AWS using Terraform.

IaC pipeline is composed of the following jobs:
- Linter: scan Terraform code for programmatic and stylistic errors using tflint
- Security: security scan over Terraform code using trivy
- Cost: potential monthly cost of the infrastructure to be deployed using infracost
- Terraform: executes terraform plan, apply or destroy (manual trigger or branch-based)

All pipelines were implemented based on previous experiences, including variables and stages.

## AWS Resources

### Networking

VPC
![VPC](/images/vpc.jpg)

Subnets
![Subnet A](/images/subnet_a.jpg)
![Subnet B](/images/subnet_b.jpg)
![Subnet C](/images/subnet_c.jpg)

Route Table
![Route Table](/images/route_table.jpg)
![Route Table Association](/images/route_asso.jpg)

Internet Gateway
![Internet Gateway](/images/igw.jpg)

EKS
![EKS](/images/eks.jpg)
![Nodes](/images/nodes.jpg)

Network Load Balancer (created by Nginx Ingress Controller)
![NLB](/images/nlb.jpg)

ACM
![Certificate](/images/certificate.jpg)

