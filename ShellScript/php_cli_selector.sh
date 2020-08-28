#!/bin/bash
 
# Copyright (C) 2020 Study For Us HOSTING (https://hosting.studyforus.com)
# Changing PHP cli version via jailkit for each users.
# This script is able to use only on ispconfig
# Version information : 0.3.1 (Proto type)
# License : The MIT License (MIT)


# 호스팅 정보 입력받기
echo -e -n "Enter Client number : "
read cn
echo -e -n "Enter Web number : "
read wn

# PHP 버전 선택
fMenu()
{
  echo "PHP cli version changer for ispconfig "
  echo ""
  echo "0. PHP 7.0"
  echo "1. PHP 7.1"
  echo "2. PHP 7.2"
  echo "3. PHP 7.3"
  echo "4. PHP 7.4"
}

while :
do
  fMenu
  echo ""
  echo ""
  echo -n "Select PHP version number : "
  read phpversion
  case "$phpversion" in
    "0" ) echo "PHP 7.0 is selected"
          php7.0 ;;
    "1" ) echo "PHP 7.1 is selected"
          php7.1 ;;
    "2" ) echo "PHP 7.2 is selected"
          php7.2 ;;
    "3" ) echo "PHP 7.3 is selected"
          php7.3 ;;
    "4" ) echo "PHP 7.4 is selected"
          php7.4 ;;
  esac
done


# php 버전이 설치 되어 있나 확인
echo "checking php version."
if [ ! -f /var/www/clients/client%cn/web$wn/usr/bin/$phpversion ]; then
  echo "There is not php version to change."
  echo "Start to copy php version to change."
  jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client%cn/web$wn $phpversion
fi

# php altenative 버전 삭제
rm /var/www/clients/client%cn/web$wn/etc/alternatives/php

# php 버전 변경
ln -s /usr/bin/$phpversion /var/www/clients/client%cn/web$wn/etc/alternatives/php

# 완료.
echo "php cli version has been changed."
