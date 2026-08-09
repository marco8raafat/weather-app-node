resource "local_file" "ansible_inventory" {
  filename        = "${path.root}/../ansible/inventory/inventory.ini"
  file_permission = "0644"

  content = <<EOT
[bastion]
${aws_instance.bastion.public_ip}

[master]
${aws_instance.master.private_ip}

[workers]
${join("\n", aws_instance.worker[*].private_ip)}

[kubernetes:children]
master
workers

[kubernetes:vars]
ansible_user=ubuntu
ansible_ssh_common_args="-o ProxyJump=ubuntu@${aws_instance.bastion.public_ip} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"
EOT
}