---
sidebar_position: 3
---

# SSH Tunnelling

SSH Tunnelling is the ability to create bi-directorial encrypted connection between machines to exchange data encrypted.

## Port Forwarding

> What is [port forwarding?](https://www.ssh.com/academy/ssh/tunneling/example)

### Local Forwarding

Local forwarding is when a traffic is forwarded to the local machine. In this exercise, swarmlab hybrid is gonna be forwarded to a second machine. First, it is needed to get the IP of the first machine. The first machine is a Linux. That means that it uses the ``ifconfig`` to find the IP.
``ifconfig`` returns all the addresses of all the interfaces. It is needed to find the correct interface to find the IP of the machine. Most of the time it's ``eth0`` if it's wired or ``wlan0`` if it's wired. In the case of the exercise, let's assume that the IP address of the first machine is ``192.168.1.1``.
On Windows, the correct command on CMD is ``ipconfig``, it follows the same logic as ``ifconfig`` and it's more simple to understand.

```sh
ssh -nNT -L 8080:192.168.1.1:3088 user@192.168.1.1
```

### Remote Forwarding

Remote forwarding is the opposite of local forwarding. That means that instead of forwarding locally, it forwards remotely.

```sh
ssh -nNT -R 192.168.1.1:3088:localhost:8080 user@192.168.1.1
```
