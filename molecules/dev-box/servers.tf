resource "docker_image" "base_image" {
  name = "mrsauravsahu/homelab/dev-box"
  build {
    path = "."
    dockerfile = "dev.dockerfile"
    tag  = ["mrsauravsahu/homelab/dev-box"]
    build_arg = { }
    label = {
      author : "Saurav Sahu <mrsauravsahu@outlook.com>"
    }
  }

  triggers = {
    dockerfile = filesha1("dev.dockerfile")
    setup_script = filesha1("scripts/setup.sh")
  }
}

resource "docker_container" "servers" {
  for_each = { for index, server in var.servers: server.name => { index = index, server = server } }
  name  = "mrsauravsahu_homelab_${each.key}"
  image = docker_image.base_image.image_id
  env = toset([
    "DEV_BOX_SSH_PRIVATE_KEY_ENCODED=${base64encode(tls_private_key.dev_box_ssh_key.private_key_openssh)}",
    "DEV_BOX_SSH_PUBLIC_KEY_ENCODED=${base64encode(tls_private_key.dev_box_ssh_key.public_key_openssh)}"
  ])

  volumes {
    host_path = abspath("${path.module}")
    container_path = "/srv/app/"
  }

  ports {
    external = 8080 + each.value.index
    internal = 22
  }
}
