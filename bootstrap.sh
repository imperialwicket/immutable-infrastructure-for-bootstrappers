#!/bin/bash 

packerVersion='0.8.2'
asgardRelease='1.5.1'
config='/vagrant/asgardConfig'

apt-get update -qq
apt-get install -qq openjdk-7-jre tomcat7 unzip

# Asgard war
echo "Installing Asgard release $asgardRelease."
tomcat='/var/lib/tomcat7'
tomcatWebapps="$tomcat/webapps"
wget -q https://github.com/Netflix/asgard/releases/download/1.5.1/asgard.war
sudo mv asgard.war $tomcatWebapps
[ -x $tomcatWebapps/ROOT ] && sudo rm -rf $tomcatWebapps/ROOT
sudo chown tomcat7:tomcat7 $tomcatWebapps/asgard.war
sudo cp -f $config/server.xml $tomcat/conf/
sudo mkdir -p $tomcat/bin
sudo cp -f $config/setenv.sh $tomcat/bin/
# We need IAM creds anyway. Just stop until we get them via set-aws-creds.sh
sudo service tomcat7 stop
echo "Tomcat stopped until IAM credentials are available."

# Packer
echo "Installing Packer version $packerVersion."
packerZip="packer_${packerVersion}_linux_amd64.zip"
wget -q https://dl.bintray.com/mitchellh/packer/$packerZip
unzip -uo -qq $packerZip -d /usr/local/bin
rm $packerZip

# AWS Credential gathering
echo -e "\n\n######################################################################\n#"
echo -e "# Use $config/set-aws-creds.sh to"
echo -e "# configure your credentials for Asgard.\n#"
echo -e "######################################################################\n\n"

