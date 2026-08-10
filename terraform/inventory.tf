resource "local_file" "ansible_inventory" {
  filename        = "${path.root}/../ansible/inventory/inventory.ini"
  file_permission = "0644"

  content = <<EOT
[bastion]
bastion ansible_host=${aws_instance.bastion.public_ip} ansible_user=ubuntu

[master]
master ansible_host=${aws_instance.master.private_ip} ansible_user=ubuntu

[workers]
${join("\n", formatlist("worker%02d ansible_host=%s ansible_user=ubuntu", range(1, length(aws_instance.worker) + 1), aws_instance.worker[*].private_ip))}

[kubernetes:children]
master
workers

[kubernetes:vars]
ansible_user=ubuntu
ansible_ssh_common_args='-o ProxyCommand="ssh -i terraform/weather-key.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -W %h:%p ubuntu@${aws_instance.bastion.public_ip}"'
EOT
}