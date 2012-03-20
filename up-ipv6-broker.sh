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

# script that is run on the client when it creates a tunnel to the remote OpenVPN server

test $DEBUG -eq 1 && echo "sudo /sbin/ip tunnel add ${SITID} mode sit ttl 255 remote ${VPN_HOST} local ${ifconfig_local}" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip tunnel add ${SITID} mode sit ttl 255 remote ${VPN_HOST} local ${ifconfig_local}

test $DEBUG -eq 1 && echo "sudo /sbin/ip link set dev ${SITID} up" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip link set dev ${SITID} up

test $DEBUG -eq 1 && echo "sudo /sbin/ip -6 addr add ${V6NET}02/124 dev ${SITID}" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 addr add ${V6NET}02/124 dev ${SITID}

test $DEBUG -eq 1 && echo "sudo /sbin/ip route add ::/0 via ${V6NET}01" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip route add ::/0 via ${V6NET}01

exit 0
