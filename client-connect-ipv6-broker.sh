#!/bin/bash

# OpenVPN IPv6 Tunnel Broker
# Copyright (c) 2012 Markus Holtermann
# Copyright (c) 2011 Lyndsay Roger - https://www.zagbot.com/
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

source /etc/openvpn/ipv6-broker.sh

# This is a script that is run each time a remote client connects
# to this openvpn server.
# it will setup the ipv6 tunnel depending on the ip address that was
# given to the client

# setup the sit between the local and remote openvpn addresses
test $DEBUG -eq 1 && echo "/sbin/ip tunnel add ${SITID} mode sit ttl 255 remote ${ifconfig_pool_remote_ip} local ${ifconfig_local}" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip tunnel add ${SITID} mode sit ttl 255 remote ${ifconfig_pool_remote_ip} local ${ifconfig_local}

# activate the tunnel device
test $DEBUG -eq 1 && echo "/sbin/ip link set dev ${SITID} up" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip link set dev ${SITID} up

# config routing for the new network
test $DEBUG -eq 1 && echo "/sbin/ip -6 addr add ${V6NET}01/124 dev ${SITID}" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 addr add ${V6NET}01/124 dev ${SITID}

# add the route for the network
test $DEBUG -eq 1 && echo "/sbin/ip -6 route add ${V6NET}00/124 via ${V6NET}02 dev ${SITID} metric 1" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 route add ${V6NET}00/124 via ${V6NET}02 dev ${SITID} metric 1

# add neighbor discovering proxy for host
test $DEBUG -eq 1 && echo "/sbin/ip -6 neigh add proxy ${IPV6_EXIT_IP} dev eth0" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 neigh add proxy ${IPV6_EXIT_IP} dev eth0
# add neighbor discovering proxy for this interface
test $DEBUG -eq 1 && echo "/sbin/ip -6 neigh add proxy ${V6NET}02 dev eth0" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 neigh add proxy ${V6NET}02 dev eth0


# log to syslog
test $DEBUG -eq 1 && echo "${script_type} client_ip:${trusted_ip} common_name:${common_name} local_ip:${ifconfig_local} remote_ip:${ifconfig_pool_remote_ip} sit:${SITID} ipv6net:${V6NET}" | /usr/bin/logger -t $LOG_TAG
test $DEBUG -eq 1 && sudo /sbin/ip addr show | /usr/bin/logger -t $LOG_TAG
test $DEBUG -eq 1 && sudo /sbin/ip -6 route show | /usr/bin/logger -t $LOG_TAG

# needed for connection
exit 0
