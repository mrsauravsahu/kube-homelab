output "servers" {
  value = [for server in values(docker_container.servers) : server.id ]
}
