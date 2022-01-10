---
sidebar_position: 1
---

# Network Scanning

To complete this part of the exercises, 3 machines are needed which can be supplied easily by [Swarmlab Hybrid](https://git.swarmlab.io:3000/zeus/swarmlab-hybrid).

## Find ports connections

> [What is a port?](https://www.cloudflare.com/learning/network-layer/what-is-a-computer-port/)

### Connect to master

When the machines are ready and deployed on the swarm, connect to the master node of the swarm.

```bash
docker exec -it -udocker hybrid-linux-master-1 /bin/bash
```

### Find all TCP ports connections

> [What is TCP?](https://en.wikipedia.org/wiki/Transmission_Control_Protocol)

``netstat`` is a UNIX command that displays network connections to the users. Depending on which parameter given at the start, it can work differently.
To see all the TCP ports that are open on the system and in use, the parameter ``-at`` is used.

```bash
netstat -at
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 127.0.0.11:43345        0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp6       0      0 [::]:22                 [::]:*                  LISTEN
```

### Find all UDP ports connections

> [What is UDP?](https://en.wikipedia.org/wiki/User_Datagram_Protocol)

To see all the UDP ports using ``netstat``, similarly to TCP, a parameter needs to be used. In this case it's the ``-au`` parameter.

```bash
netstat -au
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
udp        0      0 127.0.0.11:34545        0.0.0.0:*
```

### Run the demo on the project

Inside the base Linux machine, there is an [Ansible automation](https://www.ansible.com) made by the owner of Swarmlab.
This opens more ports. When it will finish running, there is gonna be a re-scanning of the ports to check what changed.

```bash
docker@6178eda5b8e6:/project$ cd courses/fluentd/
docker@6178eda5b8e6:/project/courses/fluentd$ ./fluentd.yml.sh
```

#### Find all TCP ports connections

```bash
netstat -at
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 127.0.0.11:43345        0.0.0.0:*               LISTEN
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN
tcp        0      0 6178eda5b8e6:22         6178eda5b8e6:51204      ESTABLISHED
tcp        0      0 6178eda5b8e6:51204      6178eda5b8e6:22         ESTABLISHED
tcp6       0      0 [::]:22                 [::]:*                  LISTEN
```

The automation opened more TCP ports to the system.

#### Find all UDP ports connections

```bash
netstat -au
Active Internet connections (servers and established)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
udp        0      0 127.0.0.11:34545        0.0.0.0:*
```

Nothing changed on the UDP ports.

## Find all live hosts

``netstat`` only displays the list of the localhost. To see all the hosts in the network, ``nmap`` is the tool needed for this work.
``nmap`` is a tool used to discover hosts and services on a network by sending packets and analyzing the resources that comes back. It can be used to discover hosts, services or operating system detections. [More info here](https://nmap.org).

> [What is an IP address?](https://en.wikipedia.org/wiki/IP_address)
> [How to find which IP address belongs to the host using ifconfig?](https://www.computerhope.com/unix/uifconfi.htm)

To find all the hosts on the system, first it is needed to find the IP address of the localhost. It is discovered that it is ``172.26.0.2`` by running ``ifconfig``. It is not the only command that can be used to find the IP address of the host. Other known command is ``ip link``.
Furthermore, it can be deduced that the network is ``172.26.0.*``.

```bash
nmap -sP 172.26.0.* | grep Nmap | cut -d' ' -f5-6
https://nmap.org )
172.26.0.1
6178eda5b8e6 (172.26.0.2)
hybrid-linux-worker-1.hybrid-linux_hybrid-linux (172.26.0.3)
addresses (3
```

## Find open TCP ports in all hosts

To find all the TCP ports in the network, a few parameters are needed to be used:

- ``-p-`` to return all the ports of the network that are open.
- ``-sT`` to search for only TCP ports. ``-sU`` is for UDP ports.

```bash
nmap -p- -sT 172.26.0.*

Starting Nmap 7.60 ( https://nmap.org ) at 2021-10-24 09:47 UTC
Nmap scan report for 172.26.0.1
Host is up (0.00033s latency).
Not shown: 65530 closed ports
PORT      STATE SERVICE
22/tcp    open  ssh
3080/tcp  open  stm_pproc
3088/tcp  open  xdtp
5000/tcp  open  upnp
40545/tcp open  unknown

Nmap scan report for 6178eda5b8e6 (172.26.0.2)
Host is up (0.00021s latency).
Not shown: 65534 closed ports
PORT   STATE SERVICE
22/tcp open  ssh

Nmap scan report for hybrid-linux-worker-1.hybrid-linux_hybrid-linux (172.26.0.3)
Host is up (0.00044s latency).
Not shown: 65534 closed ports
PORT   STATE SERVICE
22/tcp open  ssh

Nmap done: 256 IP addresses (3 hosts up) scanned in 10.29 seconds
```

It can be noticed that port ``22``, which is ``sshd``, is open. That means that the other machine (``172.26.0.3``) of the system can be remotely accessed.

## SSH connect

> [What is SSH?](https://en.wikipedia.org/wiki/Secure_Shell)

### SSH exec remote command

> Run commands using the following syntax

```bash
docker@6178eda5b8e6:/project/courses/fluentd$ ssh -t docker@172.26.0.3 'ip a'
Warning: Permanently added '172.26.0.3' (ECDSA) to the list of known hosts.
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
55: eth0@if56: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:ac:1a:00:03 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet 172.26.0.3/16 brd 172.26.255.255 scope global eth0
       valid_lft forever preferred_lft forever
Connection to 172.26.0.3 closed.

docker@6178eda5b8e6:/project/courses/fluentd$ ssh -t docker@172.26.0.3 'echo docker | sudo -S cat /etc/passwd'
[sudo] password for docker: root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
sshd:x:101:65534::/run/sshd:/usr/sbin/nologin
docker:x:1000:1000::/home/docker:/bin/sh
Connection to 172.26.0.3 closed.
```
