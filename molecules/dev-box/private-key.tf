resource "tls_private_key" "dev_box_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "local_private_ssh_key" {
    content  = tls_private_key.dev_box_ssh_key.private_key_openssh
    filename = "${path.module}/keys/devbox"
}

resource "local_file" "local_public_ssh_key" {
    content  = tls_private_key.dev_box_ssh_key.public_key_openssh
    filename = "${path.module}/keys/devbox.pub"
}
