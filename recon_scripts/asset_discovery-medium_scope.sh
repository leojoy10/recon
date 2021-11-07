#Asset Discovery[10] ------------------------------------------------------





#-----------------------------------
#Subdomain enumeration[6] :

#1----------------------
#amass (amass.txt) :
amass enum --passive -d $1 > amass.txt

#2-------------------------------
#findomain (findomain.txt) :
findomain -t $1 -u findomain.txt

#3-------------------
#crtsh (crtsh.txt) :
curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee -a ./crtsh.txt

#4---------------------------------
#assetfinder (assetfinder.txt) :
assetfinder --subs-only $1 > assetfinder.txt

#5------------------------------
#subfinder (subfinder.txt) :
subfinder -d $1 -o subfinder.txt

#6----------------------------
#sublist3r (sublist3r.txt) :
python3 ~/tools/Sublist3r/sublist3r.py -d $1 -t 10 -v -o sublist3r.txt

#----------------------------------
#Subdomain (subdomains.txt) :
cat amass.txt findomain.txt crtsh.txt assetfinder.txt subfinder.txt sublist3r.txt manual_sub-domain.txt | sort -u > subdomains.txt





#---------
#IPs[1] :

#1-------------------------------
#Massdns (massdns.out ) :

#To get all ips from subdomain
~/tools/massdns/./bin/massdns -r ~/tools/massdns/lists/resolvers.txt -t A -o S -w massdns.out subdomains.txt
#Output will look like  events.samjoy.in. A 201.10.208.14





#-----------
#Filtering:


#1----------------------------------------------
#Live Subdomain (live-subdomains.txt) :

cat subdomains.txt | httpx -o live-subdomains.txt


#2----------------------------------------------------------------------------(Final result of live subdomain)
#Live subdomain to input content-discovery (live-dom-sub.txt) :
cat live-subdomains.txt | sort -u >> live-dom-sub.txt 


#3----------------------
#IP (ips-A_record.txt) :
cat massdns.out | awk '{print $3}' | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" > ips-A_record.txt


#4------------
#IP (ips.txt) :
cat ips-A_record.txt manual_ip.txt | sort -u >> ips.txt


#5-----------------------------------------------------(Final result of IP)
#non-cloudflare ips (non-cloudflare-ips.txt) :
python3 ~/scripts/clean_ips.py ips.txt non-cloudflare-ips.txt








#-----------------
#Visual Recon:

#1------------------
#Screenshots () :
python3 ~/tools/eyewitness/EyeWitness-20211018.1/Python/EyeWitness.py -f live-subdomain.txt --web
python3 ~/tools/eyewitness/EyeWitness-20211018.1/Python/EyeWitness.py -f ips-online.txt --web


#2-------------------------------------------------------------
#subdomain checker (subdomain_status-code.txt) :
python3 ~/scripts/subdomain_status-code.py live-subdomain.txt |sort -u | tee subdomain_status-code.txt





#remove files
rm amass.txt findomain.txt crtsh.txt assetfinder.txt subfinder.txt sublist3r.txt httprobe.txt httpx.txt geckodriver.log massdns.out










#Asset Discovery[10] --------------------------------------------------------
