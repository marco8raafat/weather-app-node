[bastion]
${tf.bastion_public_ip.value}

[master]
${tf.master_private_ip.value}

[workers]
${tf.worker_private_ips.value.join('\n')}

[kubernetes:children]
master
workers

[all:vars]
ansible_user=ubuntu
ansible_ssh_common_args='-o ProxyJump=ubuntu@${tf.bastion_public_ip.value}'