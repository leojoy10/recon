#--------------------------------
#hackerone_bb-surface.sh :
#Input [2] : target-domains.txt == target-ips.txt

#Output [2] : massdns.out == target-domains-A.txt
#Output [3] : target-domains-open_ports.txt == target-ips-open_ports.txt == target-domains-A-open_ports.txt
#Output [4] : gau.txt == waybackurls.txt == gau-way.txt ==output/paramspider.txt





#-------------------------------------------------------------
#Enumerating A records for target-domains.txt [1] :


#1-------------------------------
#massdns [DNS resolver] :
~/tools/massdns/./bin/massdns -r ~/tools/massdns/lists/resolvers.txt -t A -o S -w massdns.out target-domains.txt


#-----------------------------------------------
#Alive IPv4 (Filter from massdns.out ) :
cat massdns.out | awk '{print $3}' | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" > filter-A.txt
    
#----------------------------------------------------
#non-cloudflare ips (target-domains-A.txt) :
python3 ~/scripts/clean_ips.py filter-A.txt target-domains-A.txt;
rm filter-A.txt;





#--------------
#Port-scan [2] :

#1-2--------------------------
#rustscan and naabu :
naabu -list target-domains.txt -p - -c 100 -rate 2000 | tee -a target-domains-open_ports.txt

rustscan -a 'target-ips.txt' -r 1-65535 | grep Open | sed 's/Open //' | tee -a target-ips-open_ports.txt 

rustscan -a 'target-domains-A.txt' -r 1-65535 | grep Open | sed 's/Open //' | tee -a target-domains-A-open_ports.txt 





#---------------------------
#content discovery [2]:


#1---------------
#find URL's :

#------
#gau :
cat target-domains.txt | gau | sort -u > gau.txt

#------------------
#Waybackurls :
cat target-domains.txt |waybackurls | sort -u > waybackurls.txt

#-------------
#Filtering :
cat gau.txt waybackurls.txt | sort -u > gau-way.txt


#2---------------------
#find parameters :

#-----------------
#paramspider :
cat target-domains.txt | xargs -I % python3 ~/tools/ParamSpider/paramspider.py -l high -o %.txt -d % ;
cat output/*.txt > output/paramspider.txt

