#!/bin/bash

# update the DynDNS IP address, if needed
# update the tunnelbroker.net IPv6 tunnel, if needed

source $(pwd)/credentials

# https://www.tunnelbroker.net/tunnel_detail.php?tid=248270
# https://forums.he.net/index.php?topic=1994.0
HE_URL="https://ipv4.tunnelbroker.net/nic/update?username=${HE_USER}&password=${HE_PASS}&hostname=${HE_HOST}"

# https://help.dyn.com/remote-access-api/perform-update/
DDNS_URL="https://members.dyndns.org/v3/update?hostname=${DDNS_HOST}&myip="

# set -x

echo -n "checking current IP address in Google DNS... "
current=$(dig @8.8.8.8 $DDNS_HOST +answer +short)
[ -z "${current}" ] && { echo "can't find host $DDNS_HOST in DNS, exiting..."; exit 1; }
echo $current

echo -n "checking visible IP address via canhazip... "
visible=$(curl -s4 canhazip.com)
[ -z "${visible}" ] && { echo "can't get response from canhazip, exiting..."; exit 1; }
echo $visible

echo -n "checking DynDNS status... "
if [ "$visible" != "$current" ]; then
    echo -n "with ${visible}... "
    read status newip <<<$(curl -s -u${DDNS_USER}:${DDNS_PASS} "${DDNS_URL}{$visible}")
    if [ "$status" = "good" ]; then
        echo "done"
    else
        echo "oh-oh: ${status}"
    fi
else
    echo "up-to-date"
fi

echo -n "checking HE Tunnel status... "
read status heip <<<$(curl -s $HE_URL)
if [ "$status" = "nochg" ]; then
    if [ "$visible" != "$heip" ]; then
        echo "change detected!"
        echo -n "[$heip / $visible], updating tunnel "
        read status newip <<<$(curl -s "${HE_URL}&myip=${visible}")
        if [ "$status" = "good" ]; then
             echo "done"
        else
             echo "oh-oh: ${status}"
        fi
    else
        echo "up-to-date"
    fi
else
    echo "something unexpected happened: $status"
fi

