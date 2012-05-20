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

# Your /64 Network prefix
export BASERANGE="1234:5678:90ab:cdef"
# Mask (32bit) without leading and trailing : or empty
export MASK=""
# The IPv4 address of your vpn server
export VPN_HOST="10.8.0.1"
# The IPv6 address of the vpn server
export IPV6_EXIT_IP="1234:5678:90ab:cdef:1234:5678:90ab:cdef"


export LOG_TAG="ipv6-broker"
export DEBUG=1

if [ -e "/etc/openvpn/client.conf" ] ; then
    export CLIENT=1
else
    export CLIENT=0
fi

if [ $CLIENT -eq 1 ] ; then
    export SITID="sit1"
    export V6NET="${BASERANGE}:${MASK}:$(echo ${ifconfig_local} | awk -F. '{printf "%02x%02x:%02x", $2, $3, $4}')"
else
    export SITID="sit$(echo ${ifconfig_pool_remote_ip} | awk -F. '{print $2"-"$3"-"$4}')"
    export V6NET="${BASERANGE}:${MASK}:$(echo ${ifconfig_pool_remote_ip} | awk -F. '{printf "%02x%02x:%02x", $2, $3, $4}')"
fi
