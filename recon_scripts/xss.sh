#xss-----------------------------------------------------------------------------------------

mkdir results/xss

#Exploit  dalfox_gf+kxss (xss.txt)
dalfox file xss.txt -b gabriel.xss.ht -o dalfox_gf+kxss_blind-xss.txt 

dalfox file xss.txt -o dalfox_gf+kxss_non-blind-xss.txt
 
#move file
mv dalfox_gf+kxss_blind-xss.txt dalfox_gf+kxss_non-blind-xss.txt results/xss





#Exploit dalfox_paramspider (parameters_paramspider.txt)
dalfox file output/paramspider.txt -b gabriel.xss.ht -o dalfox_parameters_paramspider_blind.txt 

dalfox file output/paramspider.txt -o dalfox_parameters_paramspider_non-blind.txt
 
#move file
mv dalfox_parameters_paramspider_blind.txt dalfox_parameters_paramspider_non-blind.txt results/xss





#Exploit dalfox_Gospider_multiple (live-dom-sub.txt)
gospider -S live-dom-sub.txt -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'| grep "=" | qsreplace -a | dalfox pipe >>gospider_xss.txt

#move file
mv gospider_xss.txt results/xss
		










#xss-----------------------------------------------------------------------------------------
