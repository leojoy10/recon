#!/bin/bash

echo " ##########      ##########              ##########              #########              #                  #     "
echo " #        #      #                     #                       #           #            # #                #     "     
echo " #        #      #                   #                       #               #          #   #              #     "
echo " #        #      #                 #                       #                   #        #     #            #     "
echo " #        #      #               #                       #                      #       #       #          #     "
echo " #########       ##########      #                      #                        #      #         #        #     "
echo " #       #       #               #                       #                     #        #           #      #     "
echo " #        #      #                 #                       #                 #          #            #     #     "
echo " #         #     #                   #                       #              #           #              #   #     "
echo " #          #    #                     #                      #           #             #                # #     "
echo " #           #   ##########             ##########              #########               #                  #     "

echo ""
echo "Getting Started"


echo ""
echo "update & upgrade "

sudo apt-get -y update && sudo apt-get -y upgrade


echo ""
echo "setting up the environment"

# -y -->Automatic yes to prompts; assume "yes" as answer to all prompts and run non-interactively.
sudo apt install python3;
sudo apt-get install -y python3-pip
sudo apt-get install -y python-pip
sudo apt-get install -y python-setuptools
sudo apt-get install -y build-essential libssl-dev libffi-dev python-dev
sudo apt-get install -y python-dnspython
sudo apt-get install -y ruby-full
sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libssl-dev
sudo apt-get install -y jq
sudo apt-get install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
sudo apt-get install -y libldns-dev
sudo apt-get install -y git
sudo apt-get install -y rename
sudo apt-get install -y xargs
sudo apt install -y cargo


echo ""
echo "Downloading .bash_profile aliases from my repostitory (recon)"

wget https://raw.githubusercontent.com/leojoy10/recon/main/.bash_profile
source ~/.bash_profile
echo "done"


echo ""
#install go

if [[ -z "$GOPATH" ]];then
echo "It looks like go is not installed, would you like to install it now"
PS3="Please select an option : "
choices=("yes" "no")
select choice in "${choices[@]}"; do
        case $choice in
                yes)

					echo "Installing Golang"
					echo ""
                                                                                echo "Make sure whether you Input latest version of  Golang binary release link"
             					curl -OL https://golang.org/dl/go1.16.7.linux-amd64.tar.gz
                                                                                echo ""
                                                                                echo " Extract go1.16.7.linux-amd64.tar.gz into /usr/local, you will find go folder which is Go tree in /usr/local/go"
                                                                                sudo tar -C /usr/local -xvf go1.16.7.linux-amd64.tar.gz
					
					echo "removing Golang binary"
					rm -r go1.16.7.linux-amd64.tar.gz
					echo ""
					echo "Golang installation successfully completed"
					sleep 1
					break
					;;
				no)
					echo "Please install go and rerun this script"
					echo "Aborting installation..."
					exit 1
					;;
	esac	
done
fi


echo ""
echo "Don't forget to set up AWS credentials!"

apt install -y awscli


echo ""
echo "creating directories in ~/"

mkdir ~/api
mkdir ~/aws-s3
mkdir ~/android

mkdir ~/tools
mkdir ~/scripts
mkdir ~/wordlist
mkdir ~/.gf

mkdir ~/recon


echo ""
echo "Installing 20 Go based tools"


#----------------------------
#Subdomain enumeration:

#1---------------
#install amass:
echo "Installing Amass"
go get -v github.com/OWASP/Amass/v3/...;
echo "done"

#2--------------------:
#install assetfinder
echo "Installing assetfinder"
go get -u github.com/tomnomnom/assetfinder
echo "done"

#3-------------------
#install subfinder:
echo "Installing subfinder"
GO111MODULE=on go get -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder;
echo "done"


#-----------
#Filtering:

#1---
#gf :
#install gf tools and gfpattern
echo "installing gf tool"
go get -u github.com/tomnomnom/gf

echo "[*] Installing Gf-patterns..."
cd ~/tools/
git clone -q https://github.com/1ndianl33t/Gf-Patterns

#To get started quickly, you can copy the example pattern files to ~/.gf like this:
cp -r ~/go/pkg/mod/github.com/tomnomnom/gf@v0.0.0-20200618134122-dcd4c361f9f5/examples ~/.gf
cp ~/tools/Gf-Patterns/*.json ~/.gf
source ~/.bash_profile
echo "done"

#2-------
#unfurl :
echo "Installing unfurl"
go get -u github.com/tomnomnom/unfurl
echo "done"

#3------------
#qsreplace :
echo "Installing qsreplace"
go get -u github.com/tomnomnom/qsreplace
echo "done"

#3------
#anew :
echo "Installing anew"
go get -u github.com/tomnomnom/anew
echo "done"

#4------
#Kxss :
echo "installing kxss"
go get github.com/Emoe/kxss
echo "done"

#-------------------------------------------------------
#Checking domain and URL whether alive or not):

#1----------
#httprobe:
echo "installing httprobe"
go get -u github.com/tomnomnom/httprobe
echo "done"

#2------
#httpx:
echo "installing httpx"
GO111MODULE=on go get -u -v github.com/projectdiscovery/httpx/cmd/httpx@latest;
echo "done"

#3----------
#anti-burl:
echo "installing anti-burl"
go get -u github.com/tomnomnom/hacks/anti-burl
echo "done"

#------------------
#port scanning:

#1-------
#naabu:
echo "installing naabu"
sudo apt install -y libpcap-dev
GO111MODULE=on go get -v github.com/projectdiscovery/naabu/v2/cmd/naabu;
echo "done"


#-----------------
#DNS toolkit :

#1-----
#dnsx:
echo "installing dnsx"
go get -v github.com/projectdiscovery/dnsx/cmd/dnsx
echo "done"


#--------------------------
#directory-bruteforce:

#1----
#ffuf:
echo "installing ffuf"
go get -u github.com/ffuf/ffuf;
echo "done"


#------------------------
#Content Discovery:

#1----
#gau:
echo "installing gau"
GO111MODULE=on go get -u -v github.com/lc/gau;
echo "done"

#2---------------
#waybackurls:
echo "installing waybackurls"
go get github.com/tomnomnom/waybackurls;
echo "done"

#3----------
#gospider:
echo "installing gospider"
GO111MODULE=on go get -u github.com/jaeles-project/gospider
echo "done"

#4-----------
#hakrawler:
echo "installing hakrawler"
go get github.com/hakluke/hakrawler;
echo "done"


#----------
#Scanner:

#1------
#nuclei:
echo "installing nuclei"
GO111MODULE=on go get -u -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest;
echo "done"

#2-------
#dalfox:
echo "installing dalfox"
GO111MODULE=on go get -u -v github.com/hahwul/dalfox@latest;
echo "done"

echo ""
echo "Go based tools installation completed"









echo ""
echo "Installing tools"

cd ~/tools/


#----------------------------
#Subdomain enumeration:

#1------------
#findomain:
echo "Installing findomain"
mkdir findomain
cd findomain
wget https://github.com/Findomain/Findomain/archive/refs/tags/5.0.0.tar.gz
tar -xzf 5.0.0.tar.gz
rm 5.0.0.tar.gz
cd Findomain-5.0.0
cargo build --release
sudo cp target/release/findomain /usr/bin/
cd ~/tools/
echo "done"

#2-----------
#Sublist3R:
echo "Installing Sublist3R"
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r
pip3 install -r requirements.txt
sudo python3 setup.py install
cd ~/tools/
echo "done"

#-----------------------------------
#To get all ips from subdomain:

#1----------
#massdns:
echo "installing massdns"
git clone https://github.com/blechschmidt/massdns.git
cd ~/tools/massdns
make
cd ~/tools/
echo "done"


#-----------------
#Visual Recon:

#1-------------
#eyewitness:
mkdir eyewitness
cd eyewitness
wget https://github.com/FortyNorthSecurity/EyeWitness/archive/refs/tags/v20211018.1.tar.gz
tar -xvzf v20211018.1.tar.gz
rm -r v20211018.1.tar.gz
cd ~/tools/eyewitness/EyeWitness-20211018.1/Python/setup
./setup.sh
cd ~/tools/
echo "done"


#----------------
#port scanning:

#1------
#nmap:
echo "installing nmap"
sudo apt-get install -y nmap
echo "done"

#2----------
#masscan:
echo "installing masscan"
sudo apt-get --assume-yes install git make gcc
git clone https://github.com/robertdavidgraham/masscan
cd masscan
make install
cd ~/tools/
echo "done"

#3----------
#rustscan:
echo "installing rustscan"
mkdir rutscan
cd rutscan
wget https://github.com/RustScan/RustScan/releases/download/2.0.1/rustscan_2.0.1_amd64.deb
dpkg -i rustscan_2.0.1_amd64.deb
cd ~/tools/
echo "done"


#------------------------
#directory-bruteforce:

#1----------
#dirsearch:
echo "installing dirsearch"
git clone https://github.com/maurosoria/dirsearch.git
cd dirsearch
pip3 install -r requirements.txt
cd ~/tools/
echo "done"


-----------------
#403 bypass:

#1---------------
#403bypasser:
echo "installing massdns"
git clone https://github.com/yunemse48/403bypasser.git
cd 403bypasser
sudo pip3 install -r requirements.txt
cd ~/tools/
echo "done"


#--------------------
#find parameters:

#1---------------
#ParamSpider:
#install ParamSpider
echo "installing ParamSpider"
git clone https://github.com/devanshbatham/ParamSpider
cd ParamSpider
pip3 install -r requirements.txt
cd ~/tools/
echo "done"

#2-------------
#arjunfinder:
echo "installing arjunfinder"
pip3 install arjun


#---------------------------
#Vulnerability Scanner:

#1--------
#sqlmap:
echo "installing sqlmap"
git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git sqlmap-dev
cd ~/tools/
echo "done"

#2---------
#wpscan:
echo "installing wpscan"
gem install wpscan
cd ~/tools/
echo "done"


echo ""
echo "Downloading scripts"

cd ~/scripts

#----------
#Filtering:

#1-------------------------
#Filter cloud-flare ips:
wget https://raw.githubusercontent.com/leojoy10/recon/main/scripts/clean_ips.py


#2-----------------------------------------
#subdomain_status-code checker:
wget https://raw.githubusercontent.com/leojoy10/recon/main/scripts/subdomain_status-code.py


echo ""
echo "Downloading wordlist"

cd ~/wordlist

#1----------
#PayloadsAllTheThings:
echo "downloading PayloadsAllTheThings"
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git
cd ~/wordlist
echo "done"

#2----------
#SecLists:
echo "downloading Seclists"
git clone https://github.com/danielmiessler/SecLists.git
cd ~/wordlist
echo "done"

#3----------
#Bug-Bounty-Wordlists:
echo "downloading Bug-Bounty-Wordlists"
git clone https://github.com/Karanxa/Bug-Bounty-Wordlists.git
cd ~/wordlist
echo "done"


echo ""
echo "Update nuclei template"

#1--------------------
#nuclei-templates :
echo "updating nuclei-templates "
nuclei -update-templates
echo "done"










echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo -e "Done! Happy Hacking "
ls 
echo "One last time: don't forget to set up AWS credentials in ~/.aws/!"
