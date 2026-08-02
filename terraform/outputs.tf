output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "master_private_ip" {
  value = aws_instance.master.private_ip
}

output "worker_private_ips" {
  value = aws_instance.worker[*].private_ip
}