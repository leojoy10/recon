#!/bin/bash

#check if the first argument doesn't exist.
[ -z "$1" ] && { echo "[!] ./alldomains.sh <Registrare Email/Name>"; exit 1; }

curl -s -XPOST https://reverse-whois-api.whoisxmlapi.com/api/v2 -d \
"{\"apiKey\": \"at_OcXsa3KoHdXWWaUOkGGaYa5vtbaT9\",\"mode\": \"purchase\",\"basicSearchTerms\": {\"include\": [\"$1\"]}}" | 
tr ',\|[' '\n' | 
cut -d '"' -f 2 | 
grep -v "domainsCount\|domainsList"
