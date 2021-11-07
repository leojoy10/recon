echo ""
echo "don't forget to add Registrant Email"
touch whoisxmlapi.txt manual_domain.txt manual_sub-domain.txt manual_ip.txt ;
~/scripts/reverse_whois.sh $1 >> reverse_whois.txt
