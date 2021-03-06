#!/bin/bash

# Composer Updater (Available to select version)
# This script is able to use only on ispconfig
# Version information : 0.1.1

EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
then
    >&2 echo 'ERROR: Invalid installer checksum'
    rm composer-setup.php
    exit 1
fi

# 버전 변수 입력 받음

php composer-setup.php --quiet #--version=1.10.19
RESULT=$?
rm composer-setup.php
mv composer.phar /usr/bin/composer
exit $RESULT
