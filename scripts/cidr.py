#!/usr/bin/env python

import ipaddress, sys

try:
    cidr = sys.argv[1]
except:
    print("[!] Usage: ips <CIDR>")
    exit(1)

ips = ipaddress.ip_network(str(cidr))

for ip in ips:
    print(ip)
