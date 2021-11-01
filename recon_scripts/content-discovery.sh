#Content Discovery --------------------------------------------------------





echo ""
echo -n "content-discovery-1 target.com https://target.com"
echo ""

#--------------
#crawl links:

#1----------------
#gau (gau.txt) :
gau $1 | qsreplace -a | tee gau.txt

#2--------------------------------------
#Waybackurls (waybackurls.txt) :
echo $1 |waybackurls | qsreplace -a |tee waybackurls.txt

#3------------------------------
#GoSpider (gospider.txt) :
gospider -s "$2" -c 10 -d 5 --blacklist ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" --other-source | grep -e "code-200" | awk '{print $5}'| grep "=" | qsreplace -a | tee gospider.txt

#$2 = URL(http://testphp.vulnweb.com)


#4-----------------------------
#Hakrawler (hakrawler.txt) :
echo $2 >hak.txt ; cat hak.txt | hakrawler -d 3 | grep "=" | qsreplace -a | tee hakrawler.txt

#$2 = file contains URL's (http://testphp.vulnweb.com)





#--------------------
#find parameters:

#1-----------------------------------------------------
#paramspider (parameters_paramspider.txt) :
python3 ~/tools/ParamSpider/paramspider.py --d $1 -o ~/recon/$1/parameters_paramspider.txt





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

cat final_JS | anti-burl |awk '{print $4}' | sort -u >> JS_GAU+WaybackURLs.txt ; rm final_JS





mkdir results










#Content Discovery --------------------------------------------------------
