#!/bin/bash
 
# Copyright (C) 2020 Study For Us HOSTING (https://hosting.studyforus.com)
# Changing PHP cli version via jailkit for each users.
# This script is able to use only on ispconfig
# Version information : 1.4.3
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

# 제대로된 폴더인지 확인
if [ ! -d /var/www/clients/client$cn/web$wn ]; then
  echo -e "There is no directory. Wrong client or web number.\n\n"
  exit 1
fi

# 사이트 도메인 명 변수 지정
site=`ls -alF /var/www/ | grep client$cn/web$wn/ | rev | cut -d " " -f 3 | rev`

# 선택된 client/web number 표시
echo ""
echo "client$cn / web$wn ($site) selected."
echo ""
echo ""
echo ""

# jailkit 전체 재설치 확인
#while true; do
#  read -p "Do you want to re-install shell whole files? (y/n) : [n] " reinst
#  reinst=${reinst:-n}
#  case $reinst in
#    [Yy]* ) echo ""            
#            echo "Deleting old jailkit files...."
#            rm -rf /var/www/clients/client$cn/web$wn/bin/* /var/www/clients/client$cn/web$wn/dev/* /var/www/clients/client$cn/web$wn/etc/* /var/www/clients/client$cn/web$wn/lib/* /var/www/clients/client$cn/web$wn/lib64/* /var/www/clients/client$cn/web$wn/run/* /var/www/clients/client$cn/web$wn/usr/* /var/www/clients/client$cn/web$wn/var/*
#            echo ""
#            echo "This is client$cn/web$wn/bin/ files."
#            ls -al /var/www/clients/client$cn/web$wn/bin/
#            echo ""
#            echo "Copying all of jailkit files to client$cn / web$wn ...."
#            jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client$cn/web$wn basicshell editors extendedshell netutils ssh sftp scp groups jk_lsh git php composer 1>/dev/null
#            echo ""
#            echo "Copying complete."
#            break ;;
#    [Nn]* ) echo ""
#            echo "Pass to next progress..." 
#            break ;;
#  esac
#done

## 계속 설치를 진행할 것인지 확인
#if [ $reinst == "y" -o $reinst == "Y" ]; then
#  while true; do
#      read -p "Would you like to keep going? (y/n) : [y] " kgo
#      kgo=${kgo:-y}
#      case $kgo in
#          [Yy]* ) break ;;
#          [Nn]* ) exit ;;
#      esac
#  done
#fi

# 쉘 사용자인지 확인
if [ ! -f /var/www/clients/client$cn/web$wn/etc/alternatives/php ]; then
  echo -e "There is no shell user on $site.\n\n"
  exit 1
fi

# 현재 php 버전 변수 지정
cphp=`ls -al /var/www/clients/client$cn/web$wn/etc/alternatives/php | rev | cut -c1-6 | rev`

# 현재 설정되어 있는 PHP 버전 확인하기
echo "All of installed PHP versions of $site."
ls /var/www/clients/client$cn/web$wn/usr/bin/ | grep php
echo -e "\nCurrent PHP version is $cphp"
echo ""
echo ""

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
  echo "5. PHP 8.0"
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
    "5" ) echo "PHP 8.0 is selected"
          phpv=php8.0
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
    yn=${yn:-n}
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


# jailkit 재설치를 한 경우 composer 재설치 하지 않도록 조정
#if [ $reinst == "Y" -o $reinst == "y" ]; then
#  echo ""
#  echo "Already re-installed all of jailkit files."
#else
#  # composer 설치할건지 확인
#  while true; do
#      read -p "Do you want to install composer? (y/n) : [n] " yorn
#      yorn=${yorn:-n}
#      case $yorn in
#          [Yy]* ) echo ""
#                  echo "Copying composer files......"
#                  jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client$cn/web$wn composer 1>/dev/null
#                  echo "Copiying complete."
#                  break ;;
#          [Nn]* ) break ;;
#      esac
#  done
#fi

# composer 설치 확인
if [ ! -f /var/www/clients/client$cn/web$wn/usr/bin/composer ]; then
  echo ""
  echo "There is no composer files, now copying composer files."
  jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client$cn/web$wn composer 1>/dev/null
  echo ""
  echo "All composer files have been installed."
else
  # composer가 설치되어 있는 경우 다시 설치할 것인지 확인
  while true; do
      read -p "Do you want to re-install composer? (y/n) : [n] " yorn
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
fi

# 완료.
echo "All of installed PHP versions of $site."
ls /var/www/clients/client$cn/web$wn/usr/bin/ | grep php
echo -e "\nCurrent PHP version is $cphp"
echo ""
echo ""
echo "All process has done. The php cli version has been changed."
