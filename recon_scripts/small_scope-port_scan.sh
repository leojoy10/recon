#port scanning------------------------------------------------------------------------





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










#port scanning------------------------------------------------------------------------
