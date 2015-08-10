#!/bin/bash
#
# Bash wrapper for immutable infrastructure for bootstrappers packer calls.

# AWS credentials file - this is in .gitignore, if you move it, put credentials 
# outside the repo or update gitignore so it doesn't end up in source control.
awsCredsFile="/vagrant/bakery/.packer-aws-credentials.json"

# Username for key gen
username="ii4b"

usage() {
cat << EOF

./ii4b-packer.sh [OPTIONS]

This script relies on AWS credentials in $awsCredsFile.

OPTIONS:

  -h  Show this help
  -e  Environment (ii4b)
  -n  Node (base)
  -a  Ami id (ami-7be63d10)
  -s  SSH username (ubuntu)
  -r  Region (us-east-1)
  -z  Availability Zone (us-east)
  -i  Instance type (t1.micro)
  

EOF
}

awsInfo(){
cat << EOF
Please provide AWS credentials with IAM Profile appropriate to 
Packer's Amazon EBS builder (https://packer.io/docs/builders/amazon.html).

EOF
}
# Options
while getopts ":e:n:a:s:r:z:i:h" flag
do
  case "$flag" in
    h)
      usage
      exit 0
      ;;
    e)
      env="-var \"env=$OPTARG\""
      ;;
    n)
      node="-var \"env=$OPTARG\""
      ;;
    a)
      ami="-var \"ami=$OPTARG\""
      ;;
    s)
      sshuser="-var \"ami_user=$OPTARG\""
      ;;
    r)
      region="-var \"region=$OPTARG\""
      ;;
    z)
      zone="-var \"availability_zone=$OPTARG\""
      ;;
    i)
      instance="-var \"instance_type=$OPTARG\""
      ;;
    ?)
      usage
      exit 1
  esac
done

# Need aws creds for Packer
if ! [ -r $awsCredsFile ]; then
  awsInfo
  read -e -p "AWS access key id: " accessKey
  read -es -p "AWS secret access key: " secretKey
  echo ""

  touch $awsCredsFile
  echo -e "{\n  \"aws_access_key\":\"$accessKey\"," > $awsCredsFile
  echo -e "  \"aws_secret_key\":\"$secretKey\"\n}" >> $awsCredsFile
fi

# Just make a new key. You can use this or replace with an
# existing or alternative key.
if ! [ -r base/keys/$username ]; then
  mkdir -p base/keys/
  ssh-keygen -t rsa -N "" -q -f base/keys/$username
  echo "Created base/keys/$username for ssh connection."
fi

# Disable packer color output
export PACKER_NO_COLOR=1

packer build -var-file=$awsCredsFile $env $node $ami $sshuser \
  $region $zone $instance packer-amazon-ebs.json # \
#  | logger -i -t packer &

