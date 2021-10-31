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

bash_profile\ 
-create a folder named bash_profile and simultaneosly create a random file name then upload every .* files

scripts\
-Upload your scripts
clean_ips.py 
subdomain_status-code.py


-------------------------------------------
Files: (.bash_profile and setup.sh)

.bash_profile
#go
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

#aquatone
export PATH=$PATH:/root/tools/aquatone

#findomain
export PATH=$PATH:/root/tools/findomain

#gf (To get auto-complete working you need to source the gf-completion.bash file in your .bash_profile)
source $HOME/go/pkg/mod/github.com/tomnomnom/gf@v0.0.0-20200618134122-dcd4c361f9f5/gf-completion.bash

setup.sh
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
started: 11.20
Ended:  

Total time: 