$TTL 300
@   IN SOA ns2.DomainExpansion.com. admin.DomainExpansion.com. (
        1       ; serial
        3600    ; refresh
        900     ; retry
        604800  ; expire
        300 )   ; negative ttl

@                       IN NS ns1.DomainExpansion.com.
@                       IN NS ns2.DomainExpansion.com.
ns1                     IN A  172.20.0.100
ns2                     IN A  172.20.0.101