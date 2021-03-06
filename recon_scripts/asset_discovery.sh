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
#Subdomain (subdomain.txt) :
cat amass.txt findomain.txt crtsh.txt assetfinder.txt subfinder.txt sublist3r.txt | sort -u > subdomain.txt





#---------
#IPs[1] :

#1-------------------------------
#Massdns (massdns.out ) :

#To get all ips from subdomain
~/tools/massdns/./bin/massdns -r ~/tools/massdns/lists/resolvers.txt -t A -o S -w massdns.out subdomain.txt
#Output will look like  events.samjoy.in. A 201.10.208.14





#-----------
#Filtering:


#1----------------------
#IP (ips-online.txt) :
cat massdns.out | awk '{print $3}' | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" > ips-online.txt


#2----------------------------------------------
#Live Subdomain (live-subdomain.txt) :

#httprobe +httpx  (Checking whether domain is alive or not)
cat subdomain.txt | httprobe > httprobe.txt ; cat subdomain.txt | httpx > httpx.txt

#Sort httprobe +httpx 
cat httprobe.txt httpx.txt | unfurl --unique domains > live-subdomain.txt


#3----------------------------------------------------
#non-cloudflare ips (non-cloudflare-ips.txt) :
python3 ~/scripts/clean_ips.py ips-online.txt non-cloudflare-ips.txt


#4------------------------------------------------------------------------------------------------
#lives-subdomain + non-cloudflare-ips (non-cloudflare-ips_live-subdomain.txt) :

#lives-subdomain + ips for Nmap to scan for vulnerabilities 
cat non-cloudflare-ips.txt live-subdomain.txt | tee non-cloudflare-ips_live-subdomain.txt





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
