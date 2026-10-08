#!/bin/sh

action=$1
IP=$3
host=$4

FILE=/etc/dnsmasq.d/dinamic-hosts
SUFIXO=DomainExpansion.jjk.com

[ "$host" = "ns1" ] && exit 0

nome=""
[ -n "$host" ] && nome="$host.$SUFIXO"

atual=$(cat "$FILE" 2>/dev/null)

case "$action" in
    add|old)
        [ -n "$nome" ] || exit 0
        novo=$(printf '%s\n' "$atual" | awk -v ip="$IP" -v nome="$nome" '
            NF == 0 { next }
            $1 == ip || $2 == nome { if (!feito) { print ip, nome; feito = 1 }; next }
            { print }
            END { if (!feito) print ip, nome }')
        ;;
    del)
        novo=$(printf '%s\n' "$atual" | awk -v ip="$IP" 'NF && $1 != ip')
        ;;
    *)
        exit 0
        ;;
esac



if [ "$novo" != "$atual" ]; then
    printf '%s\n' "$novo" > "$FILE" 
    pkill -HUP dnsmasq 2>/dev/null
fi
exit 0