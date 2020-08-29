#!/bin/sh

# dialog 이용할 건지 xdialog 이용할 건지 선택 쉽게 하기 위한 변수
DIALOG=${DIALOG=dialog}

# 입력값을 저장할 임시 파일 지정, tempfile 명령어를 이용해 생성하지만 실패하는 경우 /tmp/에 파일명으로 기록되도록 설정
tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/test$$

# 이 쉘스크립트가 끝나면 $tempfile 이 자동으로 삭제되도록 지정
trap "rm -f $tempfile" 0 1 2 5 15

# dialog 실행 결과를 $tempfile 에 저장 되도록 지정
$DIALOG --title "My input box" --clear \
        --inputbox "Hi, this is a sample input box\n
Try entering your name below:" 16 51 2> $tempfile

# 마지막 결과값을 변수로 지정
retval=$?

case $retval in
  0)
    echo "Input string is `cat $tempfile`";;
  1)
    echo "Cancel pressed.";;
  255)
    if test -s $tempfile ; then
      cat $tempfile
    else
      echo "ESC pressed."
    fi
    ;;
esac
