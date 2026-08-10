resource "local_file" "ansible_inventory" {
  filename        = "${path.root}/../ansible/inventory/inventory.ini"
  file_permission = "0644"

  content = <<EOT
[bastion]
bastion ansible_host=${aws_instance.bastion.public_ip} ansible_user=ubuntu

[master]
master ansible_host=${aws_instance.master.private_ip} ansible_user=ubuntu

[workers]
worker01 ansible_host=${aws_instance.worker[0].private_ip} ansible_user=ubuntu
worker02 ansible_host=${aws_instance.worker[1].private_ip} ansible_user=ubuntu

[kubernetes:children]
master
workers

[kubernetes:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=terraform/weather-key.pem
ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ProxyCommand="ssh -i terraform/weather-key.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ubuntu@${aws_instance.bastion.public_ip}"'
EOT
}