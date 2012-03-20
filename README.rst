README
======

You can use these scripts to create your own IPv6 tunnel broker.

INSTALLATION
============

Server
------

- You need a dedicated OpenVPN account if your OpenVPN does not run as root.
  You must give this user full password-less *sudo* access to ``/sbin/ip``:
  ``openvpn ALL=(ALL)  NOPASSWD: /sbin/ip``
- You must enable package forwarding for IPv6. Either put ``sysctl -w
  net.ipv6.conf.all.forwarding=1`` into you ``/etc/rc.local`` or appand
  ``net.ipv6.conf.all.forwarding = 1`` to ``/etc/sysctl.conf``.
  **Warning:** If you automatically receive your IPv6 routes, you *must* set
  your v6 routes manually (``ip -6 route add ::/0 via <IPv6-Gateway> dev
  eth0>``!
- You may need to activate *Neighbor Discovery Proxy*: Add
  ``net.ipv6.conf.all.proxy_ndp = 1`` to your ``/etc/sysctl.conf``
- Copy the files ``client-connect-ipv6-broker.sh``,
  ``client-disconnect-ipv6-broker.sh`` and ``ipv6-broker.sh`` to your server
  into the directory ``/etc/openvpn/`` and make sure they are executable.
- Append the lines from the ``server-ipv6.conf`` file to your OpenVPN server
  configuration.

Client
------

- You need a dedicated OpenVPN account if your OpenVPN does not run as root.
  You must give this user full password-less *sudo* access to ``/sbin/ip``:
  ``openvpn ALL=(ALL)  NOPASSWD: /sbin/ip``
- Copy the files ``up-ipv6-broker.sh``, ``down-ipv6-broker.sh`` and
  ``ipv6-broker.sh`` to your client into the directory ``/etc/openvpn/`` and
  make sure they are executable.
- Append the lines from the ``client-ipv6.conf`` file to your OpenVPN client
  configuration.
