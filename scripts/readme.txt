1) reverse_whois.sh

./alldomains.sh domains@target.com | tee reverse_whois.txt 


2) asn.sh

# if the first argument is an IP, the response will be the ASNumber

./asn.sh 172.217.163.174

# if the first argument is an ASN, the response will be a list of CIDRS

./asn.sh AS15169 | tee cidr.txt


3) cidr.py

python3 cidr.py 34.92.0.0/14 | tee ip_cidr.txt