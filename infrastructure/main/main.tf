terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "bootstrap/terraform.tfstate"
    profile        = "terraform-user"
    region         = "us-west-2"
    dynamodb_table = "ecr-devops-state-locking"
    encrypt        = true
  }
}