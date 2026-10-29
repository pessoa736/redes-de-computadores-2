#!/bin/sh
HOSTS=/etc/dnsmasq.d/dinamic_hosts     # ajuste: o arquivo addn-hosts que o order.sh escreve
NS2=172.20.0.101
ZONA=DomainExpansion.com

{
  echo "server $NS2"
  echo "zone $ZONA"
  awk 'NF>=2 && $1 !~ /^#/ {print $1, $2}' "$HOSTS" | while read ip nome; do
    case "$nome" in *super*) ;; *) continue ;; esac
    nome2=$(echo "${nome%%.*}" | sed 's/super/hyper/')
    echo "update delete $nome2.$ZONA. A"
    echo "update add $nome2.$ZONA. 300 A $ip"
  done
  echo "send"
} | nsupdate