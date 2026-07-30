resource "tls_private_key" "ssh" {
  algorithm = "ED25519"
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.ssh.private_key_openssh
  filename        = "${path.module}/.ssh/k8s-ha"
  file_permission = "0600"
}

resource "local_file" "cloud_init" {
  filename = "${path.module}/cloud-init.yaml"
  content  = <<-EOT
    #cloud-config
    ssh_authorized_keys:
      - ${tls_private_key.ssh.public_key_openssh}
  EOT
}