#!/bin/bash
 
# Copyright (C) 2017 Study For Us HOSTING (https://hosting.studyforus.com)
# Auto Copying Tool From Git Repository
# Version infomation : 1.0
# License : The MIT License (MIT)
 
# Define Vars
GIT_DIR='git' #Input only FOLDER NAME
WEB_DIR='/web' #Input Web Directory (both absolute path and relative path are possible)
GIT_SOURCE='https://github.com/rhymix/rhymix/' #Input Git repository path
 
# Checking Git clone
if [ ! -d $WEB_DIR/$GIT_DIR/.git ]; then
  echo "Git Directory does not exist. Git Directory will be made."
  echo "Start git clone progress"
  mkdir -p $WEB_DIR/$GIT_DIR
  git clone $GIT_SOURCE $WEB_DIR/$GIT_DIR/
  # Copying Git files to Web Directory by rsync
  rsync -avr --exclude='$GIT_DIR' $WEB_DIR/$GIT_DIR/ $WEB_DIR/
fi
 
 
# Checking updates and patches from Git repository
cd $WEB_DIR/$GIT_DIR
git stash
git pull
git stash apply
git stash clear
