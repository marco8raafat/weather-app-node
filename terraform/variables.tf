variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true
}

variable "my_public_ip" {
  description = "Your public IP address"
  type        = string
}

variable "ubuntu_ami" {
  description = "Ubuntu Server 26.04 LTS AMI ID"
  type        = string
}

variable "key_name" {
  description = "Name of the existing AWS key pair"
  type        = string
}

variable "instance_type" {
  default = "t3.micro"
}

variable "availability_zone" {
  default = "us-east-1a"
}