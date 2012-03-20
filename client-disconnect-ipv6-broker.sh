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

# This is a script that is run each time a remote client disconnects
# to this openvpn server.

# remove neighbor discovering proxy again
test $DEBUG -eq 1 && echo "/sbin/ip -6 neigh del proxy ${V6NET}02 dev eth0" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 neigh del proxy ${V6NET}02 dev eth0

# remove the route
test $DEBUG -eq 1 && echo "/sbin/ip -6 route del ${V6NET}00/124 via ${V6NET}02 dev ${SITID} metric 1" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 route del ${V6NET}00/124 via ${V6NET}02 dev ${SITID} metric 1

# unset the ipv6 address
test $DEBUG -eq 1 && echo "/sbin/ip -6 addr del ${V6NET}01/124 dev ${SITID}" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip -6 addr del ${V6NET}01/124 dev ${SITID}

# deactivate the tunnel
test $DEBUG -eq 1 && echo "/sbin/ip link set dev ${SITID} down" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip link set dev ${SITID} down

# remove the tunnel interface
test $DEBUG -eq 1 && echo "/sbin/ip tunnel del ${SITID} mode sit ttl 255 remote ${ifconfig_pool_remote_ip} local ${ifconfig_local}" | /usr/bin/logger -t $LOG_TAG
sudo /sbin/ip tunnel del ${SITID} mode sit ttl 255 remote ${ifconfig_pool_remote_ip} local ${ifconfig_local}

test $DEBUG -eq 1 && sudo /sbin/ip addr show | /usr/bin/logger -t $LOG_TAG
test $DEBUG -eq 1 && sudo /sbin/ip -6 route show | /usr/bin/logger -t $LOG_TAG

exit 0
