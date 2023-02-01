# k3s

molecule to setup k3s servers

## setup

The host running terraform should be able to reach the servers with the `root` user.

```
$ ssh -T root@<HOSTNAME-OR-IP> echo works
# should print works without asking password
```

This can be done by copying the your public ssh key-pair into the `~/.ssh/authorized_keys` file on the server.
