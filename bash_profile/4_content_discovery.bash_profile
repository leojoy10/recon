#Content Discovery[3] --------------------------------------------------------





content-discovery-1(){

echo -n "content-discovery-1 target.com https://target.com"

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
cat $2 | hakrawler -d 3 | grep "=" | qsreplace -a | tee hakrawler.txt

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
}





content-discovery-2(){
#find parameters
#paramspider
cat live-subdomain.txt | xargs -I % python3 ~/tools/ParamSpider/paramspider.py -l high -o %.txt -d % ;
cat *.txt > /output/paramspider.txt

#crawl links
#gau
cat live-subdomain.txt | gau | sort -u > gau.txt

#gau with filtering
cat gau.txt | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" | tee gau-filter.txt

#Waybackurls
cat live-subdomain.txt |waybackurls | sort -u | tee waybackurls.txt

#Waybackurls with filtering
cat waybackurls.txt | grep "=" | egrep -iv ".(jpg|jpeg|gif|css|tif|tiff|png|ttf|woff|woff2|ico|pdf|svg|txt)" | tee waybackurls-filter.txt

cat gau-filter.txt waybackurls-filter.txt | qsreplace -a |tee injection.txt

echo "creating directory /results"
mkdir results

#Filter JS files
#getjs
#cat $1 |getJS >javascriptfile.txt

}





#Content Discovery[3] --------------------------------------------------------