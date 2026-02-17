terraform {
  backend "s3" {
    bucket = "devsu-devops-java-mgm-2025"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }
}
