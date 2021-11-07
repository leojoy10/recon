#1--------------------------------------------
#remove duplicates and sort it (domains.txt) :
cat reverse_whois.txt whoisxmlapi.txt manual_domain.txt | sort -u >>domains.txt


#2------------------------------------------------------------------------------------
#Sub-domain from amass and sort it with manual (subdomains.txt ) :

amass enum -passive -norecursive -noalts -df domains.txt -o amass-subdomains.txt
cat amass-subdomains.txt manual_sub-domain.txt  | sort -u >>subdomains.txt

#3--------------------
#IPv4  (massdns.out ) :

cat domains.txt subdomains.txt | sort -u >> massdns_domains.txt

#To get A record ie)ipv4 from domains & subdomains
~/tools/massdns/./bin/massdns -r ~/tools/massdns/lists/resolvers.txt -t A -o S -w massdns.out massdns_domains.txt

#Output will look like  events.samjoy.in. A 201.10.208.14





#-----------
#Filtering:


#1------------------------------
#Live domain (live-domain.txt) :

cat domains.txt | httpx -o live-domains.txt


#2------------------------------------
#Live Subdomain (live-subdomains.txt) :

cat subdomains.txt | httpx -o live-subdomains.txt


#3-----------------------------------------------------------------------(Final result of live domain and subdomain)
#Live domain and subdomain combined (live-dom-sub.txt) :
cat live-domains.txt live-subdomains.txt | sort -u >> live-dom-sub.txt


#4----------------------
#IP (ips-A_record.txt) :
cat massdns.out | awk '{print $3}' | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" >> ips-A_record.txt


#5------------
#IP (ips.txt) :
cat ips-A_record.txt manual_ip.txt | sort -u >> ips.txt


#6-----------------------------------------------(Final result of IP)
#non-cloudflare ips (non-cloudflare-ips.txt) :
python3 ~/scripts/clean_ips.py ips.txt non-cloudflare-ips.txt





#remove files
rm whoisxmlapi.txt reverse_whois.txt massdns_domains.txt massdns.out
