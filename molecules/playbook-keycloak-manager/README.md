# playbook-keycloak-manager

docker run --rm \
  -v $(pwd):/ansible \
  -e ANSIBLE_COLLECTIONS_PATHS=/ansible/collections \
  quay.io/ansible/ansible-runner:stable-2.9-latest \
  bash -c "ansible-galaxy collection install -r /ansible/requirements.yaml -p /ansible/collections && ansible-playbook /ansible/keycloak-manager.yml -i host.docker.internal"

ACCESS_TOKEN=$(curl -X POST \
  "http://localhost:8084/realms/master/protocol/openid-connect/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=<>" \
  -d "password=<>" \
  -d "grant_type=password" \
  -d "client_id=admin-cli" | jq -r .access_token)

curl "http://localhost:8084/admin/realms/master" \
  -H "Authorization: Bearer $ACCESS_TOKEN"

