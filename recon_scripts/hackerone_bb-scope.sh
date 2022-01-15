#hackerone_bb-scope.sh
#Input [2] : domains.txt == cidr.txt 
#Input [3] : domain.txt == subdomain.txt == ip.txt

#output [2] : subs.txt == cidrs.txt
#output [2] : target-domains.txt == target-ips.txt



#-----------------------------------
#Subdomain enumeration[5] :

#1--------
#amass :
amass enum -passive -norecursive -noalts -df domains.txt -o amass.txt

#2-------------
#findomain :
findomain -f domains.txt -u findomain.txt 

#3-------------
#subfinder  :
subfinder -dL domains.txt -o subfinder.txt
 
#4-------------
#assetfinder :
cat domains.txt | assetfinder --subs-only  > assetfinder.txt

#5-------
#chaos :

#-----------
#Filtering:    
cat subfinder.txt assetfinder.txt amass.txt findomain.txt | anew > subs.txt

#----------------
#remove files :
rm subfinder.txt assetfinder.txt amass.txt findomain.txt





#--------------------------------------------
#get list of IPs for a give CIDR [1] :

#1-------------
#mapCIDR :
mapcidr -l cidr.txt > cidrs.txt





#--------------------------------------
#Combine scopes for hacking :
cat domain.txt subdomain.txt domains.txt subs.txt | anew > target-domains.txt
cat ip.txt cidrs.txt | sort -u > target-ips.txt 

#----------------------------
#move to scope folder :
mkdir scope;
mv domain.txt subdomain.txt domains.txt subs.txt ip.txt cidr.txt cidrs.txt -t scope;
