--------------------
SETUP before :

IMPORTANT: download directly from VPS then upload any files to github, if not it won't work



1)once finished writing scripts download from VPS

---------------------------------
Download entire bash files:
scp root@194.195.114.88:/root/.* C:\Users\Hacker\Desktop\VPS\recon\bash_profile

--------------------------
Download setup.sh :
scp root@194.195.114.88:/root/setup.sh C:\Users\Hacker\Desktop\VPS\recon

-----------------------------------------------------------------------------------------
Download final script to run both setup.sh then download bash_profile: 
scp root@194.195.114.88:/root/install-bash.sh C:\Users\Hacker\Desktop\VPS\recon




2) Github upload

(i) create a repository named recon

(ii) Upload files under recon repository

-------------------------------------------
Folder: (bash_profile\ and scripts\)

(i) bash_profile\ 
-create a folder named bash_profile and simultaneosly create a random file name then upload every .* files

(ii) scripts\
-Upload your scripts
clean_ips.py 
subdomain_status-code.py


-------------------------------------------
Files: ( setup.sh)

(i) setup.sh
{{codes}}





-------------------
Steps to setup:

1- Login to ubuntu 20.04

2- copy the content manually from notepad(install-bash.txt) to install-bash.sh and run the script

nano install-bash.sh
chmod +rwx install-bash.sh
./install-bash.sh


-----------------------
Time to complete:
started: 
Ended: 

Total time:  






source all files:

for f in .*; do source $f; done



if problem 

Ubuntu
ssh-keygen -f "/home/samjoy/.ssh/known_hosts" -R "194.195.114.88"

powershell
ssh-keygen -f "C:\\Users\\Hacker/.ssh/known_hosts" -R "194.195.114.88"
