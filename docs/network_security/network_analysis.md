---
sidebar_position: 2
---

# Network Analysis

In this example, there gonna be used 1 machine in which ``tcpdump`` is installed.

``tcpdump`` is a cli packet analyzer that shows a display of all the packages that are transmitted or received over the network.

> [More info on tcpdump here!](https://www.tcpdump.org/)

## Basic Commands

To see everything that goes on in the network, then all is needed is to give the correct interface to the command

```bash
tcpdump -i ethX # If it is ethernet, where X is the number of the interface
```

If it is ``eth0``, then it's not needed to be mentioned.

### Filtering

The output of ``tcpdump`` can be filtered in many ways. A few examples:

```bash
tcpdump src 1.1.1.1 # Filters the source of the packet
tcpdump dst 1.0.0.1 # Filters the destination of the packet
tcpdump net 1.2.3.0/24 # Filters the network of the packet
tcpdump port 3389 # Filters the port of the packet
tcpdump icmp # Filters the protocol used
```

### Writing to a file

Sometimes, it is really useful if it is written on a file. In case of an attack forensic, the file that ``tcpdump`` saves can determine what happened to somebody who knows how to read it.

To save it to a file, this command is needed:

```bash
tcpdump -w capture_file
```

## Advanced uses

### Combination of the commands

The commands can be fused together and used together for all purposes.

The keywords to combine them come from Boolean algebra and are:

* **AND** as ``and`` or ``&&``
* **OR** as ``or`` or ``||``
* **EXCEPT** as ``not`` or ``!``

A small example:

```bash
tcpdump src 113.214.211.3 and dst port 80 or net 192.168.1.122.0/16
```

### Isolation of TCP flags

> [What are the TCP flags?](https://www.geeksforgeeks.org/tcp-flags/)

``tcpdump`` can also isolate the TCP flags and show only the flags that is asked. [Refer here](http://docs.swarmlab.io/SwarmLab-HowTos/swarmlab/docs/build/site/swarmlab_sec-intro/docs/index-analysis.html#_isolate_tcp_flags) for more info!
