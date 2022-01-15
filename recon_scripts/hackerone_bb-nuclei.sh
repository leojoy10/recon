#-------------------------------
#hackerone_bb-nuclei.sh :
#Input [3] : target-domains-open_ports.txt == target-ips-open_ports.txt == target-domains-A-open_ports.txt
#Input [2] : gau-way.txt == output/paramspider.txt

#Output [5] : results/nuclei





#---------------------------------------------
#create a folder to pull all the results :
mkdir results ; mkdir results/nuclei

#------------
#scanning:
cat target-domains-open_ports.txt | httpx -silent | nuclei -t nuclei-templates/ | tee -a results/nuclei/nuclei_target-domains-open_ports.txt

cat target-ips-open_ports.txt | httpx -silent | nuclei -t nuclei-templates/ | tee -a results/nuclei/nuclei_target-ips-open_ports.txt

cat target-domains-A-open_ports.txt | httpx -silent | nuclei -t nuclei-templates/ | tee -a results/nuclei/nuclei_target-domains-A-open_ports.txt

cat gau-way.txt | nuclei -t nuclei-templates/ | tee -a results/nuclei/nuclei_gau-way.txt

cat output/paramspider.txt | nuclei -t nuclei-templates/ | tee -a results/nuclei/nuclei_paramspider.txt
