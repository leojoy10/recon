#directory-bruteforce----------------------------------------------------------------





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









#directory-bruteforce----------------------------------------------------------------
