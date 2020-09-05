#!/bin/bash
 
# Copyright (C) 2020 Study For Us HOSTING (https://hosting.studyforus.com)
# Changing PHP cli version via jailkit for each users.
# This script is able to use only on ispconfig
# Version information : 0.9.8
# License : The MIT License (MIT)

# 화면 클리어
clear

# 호스팅 정보 입력받기
echo -e -n "Enter Client number : "
read cn
echo -e -n "Enter Web number : "
read wn

# 화면 클리어
clear

# 선택된 client/web number 표시
echo ""
echo "client$cn / web$wn selected."
echo ""
echo ""
echo ""

# jailkit 전체 재설치 확인
while true; do
  read -p "Do you want to re-install shell whole files? (y/n) : [n] " reset
  reset=${reset:-n}
  case $reset in
    [Yy]* ) echo ""
            echo "Copying all of jailkit files to client$cn / web$wn"
            jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client$cn/web$wn basicshell editors extendedshell netutils ssh sftp scp groups jk_lsh git php composer
            echo ""
            echo "Copying complete."
            break ;;
    [Nn]* ) while true; do # 계속 설치를 진행할 것인지 확인
               read -p "Would you like to keep going? (y/n) : [y] " kgo
               kgo=${kgo:-y}
               case $kgo in
                  [Yy]* ) exit ;;
                  [Nn]* ) break ;;
               esac
            done
  esac
done

# 계속 설치를 진행할 것인지 확인
#while true; do
#    read -p "Would you like to keep going? (y/n) : [y] " kgo
#    kgo=${kgo:-y}
#    case $kgo in
#        [Yy]* ) exit ;;
#        [Nn]* ) break ;;
#    esac
#done

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
          phpv=php7.0
          break ;;
    "1" ) echo "PHP 7.1 is selected"
          phpv=php7.1
          break ;;
    "2" ) echo "PHP 7.2 is selected"
          phpv=php7.2
          break ;;
    "3" ) echo "PHP 7.3 is selected"
          phpv=php7.3
          break ;;
    "4" ) echo "PHP 7.4 is selected"
          phpv=php7.4
          break;;
  esac
done

# 화면 클리어
clear

# php 버전이 설치 되어 있나 확인
echo "Checking php version."
echo ""
if [ ! -f /var/www/clients/client$cn/web$wn/usr/bin/$phpv ]; then
  echo ""
  echo "The php version to be changed does not exist, start copying php version to change."
  echo ""
  echo "Copying files......"
  jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client$cn/web$wn $phpv 1>/dev/null
  echo "Copiying complete."
else
  echo ""
  # php 재설치 확인
  while true; do
    read -p "The php version to change already exists, Do you want to re-install selected php version? (y/n) : [n] " yn
    yn = ${yn:-n}
    case $yn in
      [Yy]* ) echo ""
              echo "Copying files......"
              jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client$cn/web$wn $phpv 1>/dev/null
              echo "Copiying complete."
              break ;;
      [Nn]* ) break ;;
    esac
  done
fi

# php altenative 버전 삭제
rm /var/www/clients/client$cn/web$wn/etc/alternatives/php
echo ""
echo "Alternative php file has been removed."


# php 버전 변경
ln -s /usr/bin/$phpv /var/www/clients/client$cn/web$wn/etc/alternatives/php
echo ""
echo "A symbolic link has been created."

# composer 설치할건지 확인
while true; do
    read -p "Do you want to install composer? (y/n) : [n] " yorn
    yorn=${yorn:-n}
    case $yorn in
        [Yy]* ) echo ""
                echo "Copying composer files......"
                jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client$cn/web$wn composer 1>/dev/null
                echo "Copiying complete."
                break ;;
        [Nn]* ) break ;;
    esac
done

# 완료.
echo ""
ls /var/www/clients/client$cn/web$wn/usr/bin/ | grep php
ls -al /var/www/clients/client$cn/web$wn/etc/alternatives/php
echo ""
echo ""
echo "All process has done. The php cli version has been changed."
