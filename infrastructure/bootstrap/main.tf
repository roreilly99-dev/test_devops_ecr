terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "bootstrap/terraform.tfstate"
    region         = "us-west-2"
    profile = "terraform-user"
    dynamodb_table = "ecr-devops-state-locking"
    encrypt        = true
  }
  required_providers{
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
 
    }
  }
}

provider "aws"{
    region = "eu-west-1"
    profile = "terraform-user"
    default_tags{

    }
}

resource "aws_s3_bucket" "ecr_devops_state"{
    bucket = "ecr-devops-state"
    force_destroy = true
}

resource "aws_s3_bucket_versioning" "versioning"{
    bucket = aws_s3_bucket.ecr_devops_state.id
    versioning_configuration{
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse"{
    bucket = aws_s3_bucket.ecr_devops_state.bucket
    rule {
        apply_server_side_encryption_by_default{
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_dynamodb_table" "ecr_devops_locks"{
    name = "ecr-devops-state-locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute{
        name = "LockID"
        type = "S"
    }
}