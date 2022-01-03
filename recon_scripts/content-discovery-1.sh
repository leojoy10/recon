#Content Discovery --------------------------------------------------------





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










#Content Discovery --------------------------------------------------------
