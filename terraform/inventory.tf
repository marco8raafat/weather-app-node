resource "local_file" "ansible_inventory" {
  filename        = "${path.root}/../ansible/inventory/inventory.ini"
  file_permission = "0644"

  content = <<EOT
[bastion]
${aws_instance.bastion.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=${path.root}/weather-key.pem ansible_ssh_common_args="-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

[master]
${aws_instance.master.private_ip}

[workers]
${join("\n", aws_instance.worker[*].private_ip)}

[kubernetes:children]
master
workers

[kubernetes:vars]
ansible_user=ubuntu
ansible_ssh_common_args="-o ProxyCommand='ssh -i ${path.root}/weather-key.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ubuntu@${aws_instance.bastion.public_ip}'"
EOT
}