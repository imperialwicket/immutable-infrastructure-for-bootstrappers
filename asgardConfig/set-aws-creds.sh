#!/bin/bash

tomcatHome='/var/lib/tomcat7'

# Exit if the config is already present or we're non-interactive
[ -r $tomcatHome/Config.groovy ] || [ -v PS1 ] && exit 0

cat << EOF
###########################################################
#
#  Please provide the following:
#    - AWS account id:
#       (https://console.aws.amazon.com/billing/home?#/account)
#    - AWS Access Key ID
#    - AWS Secret Access Key
#
#  Sample IAM profile for an IAM user specific to Asgard:
#    (https://gist.github.com/imperialwicket/3779b9fb7d9fb4b9f781)
#
#  If you require config changes you can manually edit or
#  delete the /usr/share/tomcat7/Config.groovy file 
#  (deleting will cause this script to run again).
#
###########################################################

EOF

# Get credentials 
read -e -p "AWS account id: " accountId
read -e -p "AWS access key id: " accessKey
read -es -p "AWS secret access key: " secretKey

# Copy the skeleton config to /root/.asgard and insert creds
echo -e "\n\nInserting credentials in $tomcatHome/Config.groovy."
sudo cp /vagrant/asgardConfig/Config.groovy $tomcatHome/Config.groovy
sudo sed -i \
  -e "s/ACCESS_ID/$accessKey/g" \
  -e "s/SECRET_ACCESS_KEY/$secretKey/g" \
  -e "s/ACCOUNT_ID/$accountId/g" \
  $tomcatHome/Config.groovy

sudo service tomcat7 restart

echo -e "\nAsgard will be available from your host machine at:"
echo -e "  http://localhost:8181\n"

exit 0
