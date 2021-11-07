#Content Discovery --------------------------------------------------------

#INPUT- live-dom-sub.txt (https://target.com, https://account.target.com)


#--------------
#crawl links:

#--------------------------------------------------------------------------------------------------------------------
#Filter only domains for input Gau +waybackurls paramspider (gau-wayback-paramspider-domains.txt) :
cat live-dom-sub.txt | unfurl --unique domains >>gau-wayback-paramspider-domains.txt; 


#1----------------
#gau (gau.txt) :
cat gau-wayback-paramspider-domains.txt | gau | sort -u >> gau.txt


#2--------------------------------------
#Waybackurls (waybackurls.txt) :
cat gau-wayback-paramspider-domains.txt | waybackurls | sort -u >> waybackurls.txt


#3------------------------------
#GoSpider (gospider.txt) :
gospider -S live-dom-sub.txt -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'| grep "=" | qsreplace -a | tee gospider.txt

#$2 = URL(http://testphp.vulnweb.com)


#4------------------------------
#Hakrawler (hakrawler.txt) :
cat live-dom-sub.txt | hakrawler -d 3 | grep "=" | qsreplace -a | tee hakrawler.txt





#--------------------
#find parameters:

#1-----------------------------------------------
#paramspider (/output/paramspider.txt) :
cat gau-wayback-paramspider-domains.txt | xargs -I % python3 ~/tools/ParamSpider/paramspider.py -l high -o %.txt -d % ;

#Group every output into one file
cd output/ ; cat *.txt >> paramspider.txt ; cd ../





#-----------
#Filtering:

#1------------------
#URL's (urls.txt) :
cat gau.txt waybackurls.txt gospider.txt hakrawler.txt | qsreplace -a | tee urls.txt


#2------------------------------------
#Parameters (parameters.txt) :
#(Filter the parameters using grep "=" from GAU + WaybackURLs + Gospider + Hakrawler)

cat urls.txt | grep "=" | tee parameters.txt





#3-------------------
#Javascript-Files: 

#1----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#Filter JS files from GAU+waybackurls -->remove duplicates --> then check 200 status code using anti-burl (JS_GAU+WaybackURLs.txt) :  

cat gau.txt |grep -iE '\.js'|grep -iEv '\.jsp|\.json' >> gauJS.txt
cat waybackurls.txt | grep -iE '\.js'|grep -iEv '\.jsp|\.json' >> waybJS.txt

cat gauJS.txt waybJS.txt | sort -u >> final_JS ; rm gauJS.txt waybJS.txt

cat final_JS | anti-burl |awk '{print $4}' | sort -u >> JS_GAU+WaybackURLs.txt 





#remove files
rm gau-wayback-paramspider-domains.txt final_JS





echo "creating directory /results"
mkdir results










#Content Discovery --------------------------------------------------------