#Run setup.sh

echo "Downloading setup.sh "
cd /root
wget https://raw.githubusercontent.com/leojoy10/recon/main/setup.sh
chmod +rwx setup.sh
./setup.sh





#Downloading recon_scripts

cd /root

echo ""
echo "Installing subversion "
sudo apt-get -y update && sudo apt-get -y upgrade
sudo apt-get -y install subversion


echo ""
echo "Downloading recon_scripts "
svn export https://github.com/leojoy10/recon/trunk/recon_scripts
cd recon_scripts
chmod +rwx *.sh
echo 'export PATH=$PATH:/root/recon_scripts/' >> ~/.bash_profile
source ~/.bash_profile





#Downloading recon_scripts

cd /root

echo ""
echo "Downloading scripts "
svn export https://github.com/leojoy10/recon/trunk/scripts










cd /root
echo ""
echo "completed successfully! Happy Hacking"

