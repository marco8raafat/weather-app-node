resource "aws_vpc" "vpc" {

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "weather-vpc"
  }

}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "weather-igw"
  }
}

resource "aws_subnet" "subnet-public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "weather-subnet-public"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "weather-private-subnet"
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "weather-nat-eip"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.subnet-public.id

  tags = {
    Name = "weather-nat-gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "weather-public-rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "weather-private-rt"
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.subnet-public.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  filename        = "weather-key.pem"
  content         = tls_private_key.ssh_key.private_key_pem
  file_permission = "0400"
}

resource "aws_key_pair" "weather_key" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "bastion_sg" {
  name   = "bastion-sg"
  vpc_id = aws_vpc.vpc.id
  ingress {
    description = "SSH"
    from_port = 22
    to_port   = 22
    protocol = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port   = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "kubernetes_sg" {

  name   = "k8s-sg"
  vpc_id = aws_vpc.vpc.id

  # SSH from Bastion
  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # Allow all communication between Kubernetes nodes
  ingress {
    description = "Internal Kubernetes Communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  # Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "bastion" {
  ami = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.subnet-public.id
  vpc_security_group_ids = [
    aws_security_group.bastion_sg.id
  ]
  key_name = aws_key_pair.weather_key.key_name
  associate_public_ip_address = true
  root_block_device {
  volume_size = 20
  volume_type = "gp3"
  encrypted   = true
  }
  tags = {
    Name = "weather-bastion"
  }
}

resource "aws_instance" "master" {
  ami = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.kubernetes_sg.id
  ]
  key_name = aws_key_pair.weather_key.key_name
  associate_public_ip_address = false
  root_block_device {
  volume_size = 20
  volume_type = "gp3"
  encrypted   = true
  }
  tags = {
    Name = "k8s-master"
  }
}

resource "aws_instance" "worker" {
  count = 2
  ami = var.ubuntu_ami
  instance_type = var.instance_type
  subnet_id = aws_subnet.private_subnet.id
  vpc_security_group_ids = [
    aws_security_group.kubernetes_sg.id
  ]
  key_name = aws_key_pair.weather_key.key_name
  root_block_device {
  volume_size = 20
  volume_type = "gp3"
  encrypted   = true
  }
  tags = {
    Name = "k8s-worker-${count.index + 1}"
  }
}