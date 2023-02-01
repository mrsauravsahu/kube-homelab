# k3s

molecule to setup k3s servers

## setup

The host running terraform should be able to reach the servers via ssh with the `root` user.

```
$ ssh -T root@<HOSTNAME-OR-IP> echo works
# should print works without asking password
```

This can be done by copying the public ssh key-pair you'll be using for ssh into the `~/.ssh/authorized_keys` file on the server.
