---
sidebar_position: 3
---

# IP Tables

For this part of the exercise, 5 machines are gonna be used from swarmlab hybrid.
``iptables`` is a unix command that is used to configure kernel firewall within the [netfilter project](https://www.netfilter.org). Kali Linux comes pre-installed with this command. There are many different tools to be used to configure it, either CLI or GUI, though they are not needed, ``iptables`` can stand alone and be as powerful.

## Features

* Filtering IP packets built into the Kernel organized into **tables**.
* These tables are made up of predefined **chains** that they contain **rules** which are traversed in-order.
* Each of these rules is a predication of potential matches and a corresponding action (**target**) that is executed only when the conditions are met.
* If a packet reaches the end of a chain, then the chain's **policy** target determines the final destination.

> [More info here!](https://en.wikipedia.org/wiki/Iptables)

### The tables

``iptables`` consists of the following tables:

* **Filter**: The default table.
    * **Input**: Packets going to the local sockets
    * **Forward**: Packets routed through the server
    * **Output**: Locally generated packets
* **Nat**: When a new connection is established by a packet, this table is used.
    * **Prerouting**: Designating packets when they come in
    * **Output**: Locally generated packets before routing takes place
    * **Postrouting**: Altering packets on the way out
* **Mangle**: Used for altering of packets.
    * **Prerouting**: Incoming packets
    * **Postrouting**: Outgoing packets
    * **Output**: Locally generated packets that are being altered
    * **Input**: Packets coming directly into the server
    * **Forward**: Packets being routed through the server
* **Raw**: Used for configuring exemptions from connection tracking.
    * **Prerouting**: Packets that arrive by the network interface
    * **Output**: Processes that are locally generated
* **Security**: Used for Mandatory Access Control (MAC) rules. After the filter table, the security table is automatically used next.
    * **Input**: Packets entering the server
    * **Output**: Locally generated packets
    * **Forward**: Packets passing through the server

### Rules

Packet filtering is based on rules, which check if a packet matches the conditions for a target.
The things that a rule might match is:
* What interface the packet came from
* What type of packet it is
* What is the destination of the packet

Targets are specified by ``-j`` or ``--jump`` option and can either be defined by the user, one of the built-in targets or a target extension.

> [See here info about traversing of tables and chains.](https://www.frozentux.net/iptables-tutorial/chunkyhtml/c962.html)