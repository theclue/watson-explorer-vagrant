#!/bin/bash

# This is needed because we must sync 64 bit packages to 32 bit ones
yum update -y

yum install -y wget unzip

cp /vagrant/9.0.0.4-WS-WatsonExplorer-SE-FP001.zip /tmp
cd /tmp

unzip 9.0.0.4-WS-WatsonExplorer-SE-FP001.zip



rm -f 9.0.0.4-WS-WatsonExplorer-SE-FP001.zip

# Launch the installer
