
[bastion]
${bastion_public_ip}

[master]
${master_private_ip}

[workers]
${worker_private_ips}

[kubernetes:children]
master
workers

[all:vars]
ansible_user=${ansible_user}
ansible_ssh_common_args='-o ProxyJump=${bastion_ssh_proxy}'