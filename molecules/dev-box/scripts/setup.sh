mkdir /home/${USER}/.ssh

echo "${DEV_BOX_SSH_PRIVATE_KEY_ENCODED}" | base64 -d > /home/${USER}/.ssh/id_rsa
echo "${DEV_BOX_SSH_PUBLIC_KEY_ENCODED}" | base64 -d > /home/${USER}/.ssh/id_rsa.pub

cat /home/${USER}/.ssh/id_rsa.pub >> /home/${USER}/.ssh/authorized_keys

echo "
Host *
IdentityFile /home/${USER}/.ssh/id_rsa
IdentitiesOnly yes
" > "/home/${USER}/.ssh/config"

# ssh-copy-id -i ~/.ssh/id_rsa.pub
# sed -i 's/#^\w*PasswordAuthentication yes/PasswordAuthentication no/g' /etc/ssh/sshd_config

# echo '
# Hosts *
#   ChallengeResponseAuthentication no
#   UsePAM no
#   PasswordAuthentication no
# ' > /etc/ssh/ssh_config.d/disable_root_login.conf

# service ssh start
