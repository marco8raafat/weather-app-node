
def tf = readJSON file: "terraform-output.json"

writeFile file: "inventory.ini", text: """
[master]
${tf.master_public_ip.value}

[workers]
${tf.worker1_public_ip.value}
${tf.worker2_public_ip.value}

[all:vars]
ansible_user=ubuntu

"""