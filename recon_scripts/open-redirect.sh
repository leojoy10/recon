#Open-redirect---------------------------------------------------------------------------





mkdir results/open-redirect

#Exploit
cat urls.txt parameters_paramspider.txt | sort -u | gf redirect | qsreplace "https://evil.com" | httpx -silent -status-code -location | tee open-redirect.txt

#move
mv open-redirect.txt open-redirect










#Open-redirect---------------------------------------------------------------------------
