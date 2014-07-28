#!/bin/bash

# This is needed before anything else because we must eventually sync 64 bit packages to 32 bit ones
yum update -y

yum install -y wget unzip httpd httpd-manual mod_ssl mod_authz_ldap

# Apache2 autoconfig & start
chkconfig --levels 235 httpd on
service httpd start

cp /vagrant/9.0.0.4-WS-WatsonExplorer-SE-FP001.zip /tmp
cd /tmp

unzip 9.0.0.4-WS-WatsonExplorer-SE-FP001.zip

rm -f 9.0.0.4-WS-WatsonExplorer-SE-FP001.zip

# Launch the installation using the provided Response File
# This won't work atm!
/tmp/WEX_v9.0.0.4-se/IM/IMLinux/tools/imcl input /vagrant/full_install_linux_response.xml -acceptLicense

# Apache Integration 
cp /opt/ibm/IDE/Engine/vivisimo-apache.conf . /etc/httpd/conf.d

# Start the Application Builder
/etc/init.d/zookeeper-service-default start
/etc/init.d/appbuilder-service-default start

# Service Autostart/Shutdown
chkconfig -add /etc/init.d/zookeeper-service-default start
chkconfig -add /etc/init.d/appbuilder-service-default start

# Some useful verbose stuff
PUBLIC_IP=$(/sbin/ifconfig eth1 | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
echo "-----------------------------------------------------------------------------------------"
echo ""
echo "  Welcome to IBM Watson Explorer 9.0.0.4"
echo ""
echo "  This cluster was provisioned by Gabriele Baldassarre - http://gabrielebaldassarre.com"
echo ""
echo "  Master Node FQHN: $(hostname) Public IP: ($PUBLIC_IP)"
echo ""
echo "  Please use the provided WebUIs for inspecting the services executing on this machine:"
echo ""
echo "  Engine:	            http://$PUBLIC_IP/vivisimo/cgi-bin/admin"
echo "  Application Builder http://$PUBLIC_IP:8080/AppBuilder/"
echo ""
echo "  Using the following default credentials:"
echo ""
echo "  Username: data-explorer-admin"
echo "  Password: TH1nk1710"
echo ""
echo "  IBM Watson Explorer is installed inside /opt/ibm/IDE"
echo ""
