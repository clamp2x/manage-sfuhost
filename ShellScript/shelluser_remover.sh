#! /bin/bash

# shell user remover for ispconfig
# ver 0.0.1

chattr -i /var/www/clients/client2/web3/
rm /var/www/clients/client2/web3/.bash_history
rm -rf /var/www/clients/client2/web3/bin/
rm -rf /var/www/clients/client2/web3/dev/
rm -rf /var/www/clients/client2/web3/etc/
rm -rf /var/www/clients/client2/web3/home/
rm -rf /var/www/clients/client2/web3/lib/
rm -rf /var/www/clients/client2/web3/lib64/
rm -rf /var/www/clients/client2/web3/.ssh/
rm -rf /var/www/clients/client2/web3/usr/
rm -rf /var/www/clients/client2/web3/var/
rm -rf /var/www/clients/client2/web3/run/
rm /var/www/clients/client2/web3/.profile
