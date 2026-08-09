terraform {
  backend "s3" {
    bucket = "atos-terraform-state-2026"
    key    = "weather-app/terraform.tfstate"
    region = "us-east-1"

    encrypt = true
  }
}