#!/bin/bash
 
# Copyright (C) 2020 Study For Us HOSTING (https://hosting.studyforus.com)
# Shell User Perfect remover
# This script is able to use only on ispconfig
# Version information : 0.3.0
# License : The MIT License (MIT)

# 화면 클리어
clear

# 호스팅 정보 입력받기
read -p "Enter Client number : " cn
read -p "Enter Web number : " wn
echo ""

# 사이트 번호 체크
if [ ! -d /var/www/clients/client$cn/web$wn ]; then
  echo -e "There is no directory. Wrong client or web number.\n\n"
  exit 1
fi

while true; do 
  # 호스팅 정보가 맞는지 확인하기
  echo ""
  site=`ls -alF /var/www/ | grep client$cn/web$wn/ | rev | cut -d " " -f 3 | rev`
  echo "This is related site list"
  echo "$site"
  echo ""
  read -p "You selected client $cn // web $wn, is it right? (y/n) : [y] " ynright
  ynright=${ynright:-y}
  case $ynright in
    [Yy]* ) echo ""
            echo "Go to next step..."
            sleep 1
            break ;;
    [Nn]* ) echo ""
            ./$(basename $0) && exit ;;
  esac
done

# 선택된 client/web number 표시
echo ""
echo "client$cn / web$wn selected."
echo ""
echo ""
echo ""

while true; do
  read -p "Do you have a plan to re-create shell user? (y/n) : [y] " ynrec
  ynrec=${ynrec:-y}
  case $ynrec in
    [Yy]* ) echo ""
            echo "Delete only jailkit system files."
            # jaiilkit 시스템 폴더만 삭제
            rm -rf /var/www/clients/client$cn/web$wn/bin/* /var/www/clients/client$cn/web$wn/dev/* /var/www/clients/client$cn/web$wn/etc/* /var/www/clients/client$cn/web$wn/lib/* /var/www/clients/client$cn/web$wn/lib64/* /var/www/clients/client$cn/web$wn/usr/* /var/www/clients/client$cn/web$wn/var/* /var/www/clients/client$cn/web$wn/run/*
            break ;;
            
    [Nn]* ) # 잠금 해제 하기
            echo "start to remove shell user remain files."
            echo "It will delete to personal shell files also."
            chattr -i /var/www/clients/client$cn/web$wn
            
            # 본격적인 폴더 및 파일 삭제
            rm -rf /var/www/clients/client$cn/web$wn/bin/ /var/www/clients/client$cn/web$wn/dev/ /var/www/clients/client$cn/web$wn/etc/ /var/www/clients/client$cn/web$wn/lib/ /var/www/clients/client$cn/web$wn/lib64/ /var/www/clients/client$cn/web$wn/usr/ /var/www/clients/client$cn/web$wn/var/ /var/www/clients/client$cn/web$wn/run/ /var/www/clients/client$cn/web$wn/home/ /var/www/clients/client$cn/web$wn/.ssh/
            rm /var/www/clients/client$cn/web$wn/.bash_history /var/www/clients/client$cn/web$wn/.profile
            break ;;
  esac
done

# 화면 클리어
clear

# 완료
if [ $ynrec == "y" -o $ynrec == "Y" ]; then
  echo ""
  echo "Deleted only jailkit shell file."
  echo "You must re-create shell user again."
  echo "The simple way is change Chroot shell option from None to jailkit." 
  echo ""
  echo ""
else
  echo ""
  echo "All shell user files has been deleted."
fi
