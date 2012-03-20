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

test $DEBUG -eq 1 && echo "/sbin/ip route del ::/0 via ${V6NET}01" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip route del ::/0 via ${V6NET}01

test $DEBUG -eq 1 && echo "/sbin/ip -6 addr del ${V6NET}02/124 dev ${SITID}" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 addr del ${V6NET}02/124 dev ${SITID}

test $DEBUG -eq 1 && echo "/sbin/ip link set dev ${SITID} down" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip link set dev ${SITID} down

test $DEBUG -eq 1 && echo "/sbin/ip tunnel del ${SITID} mode sit ttl 255 remote ${VPN_HOST} local ${ifconfig_local}" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip tunnel del ${SITID} mode sit ttl 255 remote ${VPN_HOST} local ${ifconfig_local}

test $DEBUG -eq 1 && sudo /sbin/ip addr show | /usr/bin/logger -t $LOG_TAG
test $DEBUG -eq 1 && sudo /sbin/ip -6 route show | /usr/bin/logger -t $LOG_TAG

exit 0
