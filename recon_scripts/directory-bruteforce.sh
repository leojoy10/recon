#directory-bruteforce----------------------------------------------------------------





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










#directory-bruteforce----------------------------------------------------------------
