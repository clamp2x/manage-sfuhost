#!/bin/bash

# Copyright (C) 2021 Study For Us HOSTING (https://sfuhost.com)
# auto git download and updater
# Version infomation : 0.1.0 
# License : The MIT License (MIT)

# 추후 업데이트 내용 : 변수를 먼저 지정가능하도록 변경하기

# 변수 설정
# 깃 다운로드 주소
read -p "Git source URL : " GIT_SOURCE
# 깃 이름
GIT_NAME=`echo "$GIT_SOURCE" | rev | cut -d "/" -f 1 | rev`
# 깃 다운로드 폴더
read - p "Where do you want to download git source? (alsolute path only) : " GIT_PATH
# 깃 브랜치 설정 (차후 추가)
# read -p "branch name : " BRANCH

# git 다운로드 폴더에서 .git 폴더가 있는지 확인 후 없으면 git clone 실행
if [ ! -d $GIT_PATH/.git ]; then
    echo "Git Directory does not exist. Git Directory will be made."
    echo "Start git clone progress"
    git clone $GIT_SOURCE $GIT_PATH
    # git 클론 후 rsync 로 복사
    rsync -avr --exclude='$GIT_NAME' $GIT_PATH/$GIT_NAME/ $GIT_PATH/
    # 원본 git 폴더 제거
    rm -rf $GIT_NAME/
else
    # .git 폴더가 있는 경우 업데이트
    cd $GIT_PATH
    # 변경 내용이 있는지 확인 후 원본 상태로 임시로 되돌리기
    git stash
    # git 업데이트
    git pull
    # 변경했던 내용 다시 복원
    git stash apply
    # 임시 저장된 변경내용 삭제
    git stash clear
fi