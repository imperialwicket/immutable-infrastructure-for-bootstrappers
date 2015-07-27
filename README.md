# Immutable Infrastructure for Bootstrappers

This project provides a virtual machine skeleton to facilitate low-cost immutable infrastructure in Amazon Web Services using:

 - [Packer](https://packer.io/) - [HashiCorp](https://hashicorp.com/) project for creating system snapshots, capable of outputting many formats including Amazon Machine Images and Virtual Box boxes (useful for me).
 - [Vagrant](https://www.vagrantup.com/) - Great tool for virtual machine management, also from [HashiCorp](https://hashicorp.com/).
 - [VirtualBox](https://www.virtualbox.org/) - A well established virtualization product, to be managed by Vagrant.
 - [Asgard](https://github.com/Netflix/asgard) - Deployment and cluster management tool from [Netflix Open Source Software](http://netflix.github.io/).
 - [Amazon Web Services](https://aws.amazon.com/) - A forerunner in cloud service/hosting providers and the IAAS space.

You can read more about the concept and walk-through details at [imperialwicket.com](http://imperialwicket.com/immutable-infrastructure-for-bootstrappers/).

## Details

Details about the files that are here. Notable files for customizations are Vagrantfile, Config.groovy, and setenv.sh - which all hardcode values that you might want to modify eventually.

 - [Vagrantfile](Vagrantfile): Configuration your virtualbox vm. Memory is hardcoded here (768m), as is the vm name, and forwarding port (8181 on the host). The base box is Ubuntu/trusty64.
 - [bootstrap.sh](bootstrap.sh): VM bootstrapper, installs openjdk-7 and tomcat, then fetches Asgard 1.5.1 and Packer 0.8.2. Also performs non-interactive Asgard configuration (server.xml, setenv.sh).
 - [asgardConfig/Config.groovy](asgardConfig/Config.groovy): Groovy config template, [asgardConfig/set-aws-creds.sh](asgardConfig/set-aws-creds.sh) populates this and puts it in Tomcats root dir.
 - [asgardConfig/server.xml](asgardConfig/server.xml): Tomcat server.xml configuration, taken from [Asgard wiki](https://github.com/Netflix/asgard/wiki/Tomcat-configuration#example-tomcatconfserverxml).
 - [asgardConfig/setenv.sh](asgardConfig/setenv.sh): Tomcat environment configuration. Hardcodes JVM memory (256m) and `ASGARD_HOME=/var/lib/tomcat7`.
 - [asgardConfig/set-aws-creds.sh](asgardConfig/set-aws-creds.sh): Utility script for populating groovy config template with AWS credentials. Also starts tomcat7.
