#!/bin/bash
 
# Copyright (C) 2020 Study For Us HOSTING (https://hosting.studyforus.com)
# Changing PHP cli version via jailkit for each users.
# This script is able to use only on ispconfig
# Version information : 0.1.1 (Proto type)
# License : The MIT License (MIT)

bt="PHP cli Version Selector"

# client 번호 가져오기 
cn=$(dialog --clear --keep-tite --backtitle "$bt" --title "Get client number" --inputbox "Input client number" 8 5)
if [ ! -d /var/www/clients/client$cn ]
then
  dialog --infobox "Invaild client number." 5 20
  sleep 2
fi

# web 번호 가져오기
wn=$(dialog --clear --keep-tite --backtitle "$bt" --title "Get web number" --inputbox "Input web number" 8 5)
if [ ! -d /var/www/clients/client$cn/web$wn ]
then
  dialog --infobox "Invaild web number." 5 20
  sleep 2
fi

# PHP 버전 선택
versions=(0 "php7.0" 1 "php7.1" 2 "php7.2" 3 "php7.3" 4 "php7.4")
phpv=$(dialog --clear --keep-tite --backtitle "$bt" --title "Select php version" --manu "Select PHP cli Version : " 15 40 6 "${versions[@]})
clear
case $phpv in
  0) dialog -- infobox "php7.0 selected" 5 20
     sleep 2 ;;
  1) dialog -- infobox "php7.1 selected" 5 20
     sleep 2 ;;
  2) dialog -- infobox "php7.2 selected" 5 20
     sleep 2 ;;
  3) dialog -- infobox "php7.3 selected" 5 20
     sleep 2 ;;
  4) dialog -- infobox "php7.4 selected" 5 20
     sleep 2 ;;
esac

# PHP가 복사 되었는지 확인 후 안되어 있으면 복사
dialog --clear --keep-tite --infobox "Chekcking PHP version" 5 20
if [ ! -f /var/www/clients/client%cn/web$wn/usr/bin/$phpv ]; then
  dialog -- infobox "There is not php version to change. \n Start to copy php version to change." 5 30
  sleep 2
  jk_init -c /etc/jailkit/jk_init.ini -f -k -j /var/www/clients/client%cn/web$wn $phpv
fi
  
# php altenative 버전 삭제
rm /var/www/clients/client%cn/web$wn/etc/alternatives/php

# php 버전 변경
ln -s /usr/bin/$phpv /var/www/clients/client%cn/web$wn/etc/alternatives/php

# 완료
dialog --clear --keep-tite --infobox "php cli version has been changed."
