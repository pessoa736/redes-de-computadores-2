#!/bin/sh

echo 'send host-name = gethostname();' > /etc/dhcp/dhclient.conf
dhclient -cf /etc/dhcp/dhclient.conf eth0
exec /docker-entrypoint.sh "$@"
