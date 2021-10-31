#Run setup.sh

echo "Downloading setup.sh "
cd /root
wget https://raw.githubusercontent.com/leojoy10/recon/main/setup.sh
chmod +rwx setup.sh
./setup.sh


cd /root
echo ""
source .bash_profile

echo ""
echo "Downloading bash_profile files "

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.1_asset_discovery

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.2_port_scan

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.3_directory_bruteforce

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.4_content_discovery

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.5_vulnerability_Filtering

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.aws_s3

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.lfi

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.open_redirect

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.rce

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.sql

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.ssrf

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.ssti

wget https://raw.githubusercontent.com/leojoy10/recon/main/bash_profile/.xss


echo ""
echo "sourcing"
for f in .*; do source $f; done

echo ""
echo "completed successfully"
