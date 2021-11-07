#port scanning------------------------------------------------------------------------





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










#port scanning------------------------------------------------------------------------
