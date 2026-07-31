resource "multipass_instance" "node" {
  for_each = var.nodes

  name           = each.key
  image          = var.ubuntu_version
  cpus           = each.value.cpus
  memory         = each.value.memory
  disk           = each.value.disk
  cloudinit_file = local_file.cloud_init.filename
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content  = <<-EOT
    [primary_cp]
    cp1 ansible_host=${multipass_instance.node["cp1"].ipv4}

    [secondary_cp]
    cp2 ansible_host=${multipass_instance.node["cp2"].ipv4}
    cp3 ansible_host=${multipass_instance.node["cp3"].ipv4}

    [control_plane:children]
    primary_cp
    secondary_cp
    
    [workers]
    w1 ansible_host=${multipass_instance.node["w1"].ipv4}
    w2 ansible_host=${multipass_instance.node["w2"].ipv4}

    [k8s:children]
    control_plane
    workers

    [k8s:vars]
    ansible_user=ubuntu
    ansible_ssh_private_key_file=../terraform/.ssh/k8s-ha
    ansible_python_interpreter=/usr/bin/python3
  EOT
}