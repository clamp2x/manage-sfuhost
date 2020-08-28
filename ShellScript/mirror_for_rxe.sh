#!/bin/bash
 
# Copyright (C) 2017 Study For Us HOSTING (https://hosting.studyforus.com)
# The Site Mirroring Tool (For RHYMIX)
# Version information : 0.1 (Proto type)
# License : The MIT License (MIT)
 
# DEFINE ORIGINAL SERVER VARS
ORIGIN_HOST='ORIGIN_server_host'# ORIGINAL SERVER HOST
ORIGIN_DB_HOST='db_host'# ORIGINAL DB HOST
ORIGIN_DB_NAME='db_name'# ORIGINAL DB NAME
ORIGIN_DB_USER='db_user_name'# ORIGINAL DB USER NAME
ORIGIN_DB_PASSWD='db_user_password'# ORIGINAL DB USER PASSWORD
ORIGIN_WEB_DIR='absolute_file_path'# ONLY ABSOLUTE PATH
ORIGIN_USER='user_name'# SSH USER NAME
ORIGIN_DOMAIN='www.domain.com'# ORIGINAL DOMAIN URL
DB_PREFIX='rx_'# DB PREFIX (Basically rx_ or xe_)
 
# DEFINE MIRROR SERVER VARS
MIRROR_HOST='hostname'# MIRROR SERVER HOST
MIRROR_DB_HOST='db_host'# MIRROR DB HOST
MIRROR_DB_NAME='new_db_name'# MIRROR DB NAME
MIRROR_DB_USER='new_db_user'# MIRROR DB USER NAME
MIRROR_DB_PASSWD='new_db_password'# MIRROR DB USER PASSWORD
MIRROR_WEB_DIR='new_web_path'# MIRROR WEB DIRECTORY (ABSOLUTE PATH)
MIRROR_DOMAIN='www.mirror.com'# MIRROR DOMAIN URL
 
 
# Move to web directory.
echo "Move to new web diretory."
cd $MIRROR_WEB_DIR
 
# Dumping original DB to web directory on mirror server.
echo "Dumping DB to new web directory."
mysqldump -h$ORIGIN_DB_HOST -u$ORIGIN_DB_USER --password=$ORIGIN_DB_PASSWD  --single-transaction $ORIGIN_DB_NAME > $ORIGIN_DB_NAME.sql
echo ""
echo "done."
echo ""
echo ""
 
# Copying the original DB to new DB.
echo "Restore DB to new site."
mysql -h$MIRROR_DB_HOST -u$MIRROR_DB_USER --password=$MIRROR_DB_PASSWD  $MIRROR_DB_NAME < $ORIGIN_DB_NAME.sql
echo ""
echo "done."
echo ""
echo ""
 
 
# Delete DB file after dumping.
echo "Removing DB backup file."
rm $ORIGIN_DB_NAME.sql
echo ""
echo "done."
echo ""
echo ""
 
# Copying web files to mirror server via rsync
echo "Coping web files to new site web directory."
rsync -azh --delete $ORIGIN_USER@$ORIGIN_HOST:$ORIGIN_WEB_DIR/ $MIRROR_WEB_DIR/
echo ""
echo "done."
echo ""
echo ""
 
# Back up config.php file
echo "Back up config file."
cp files/config/config.php files/config/config.php.bak
echo ""
echo "done."
echo ""
echo ""
 
# Modifying DB information from config.php
echo "Changing DB information in config.php file"
sed -i "s/$ORIGIN_DB_NAME/$MIRROR_DB_NAME/g" $MIRROR_WEB_DIR/files/config/config.php
echo "DB name changed."
sed -i "s/$ORIGIN_DB_USER/$MIRROR_DB_USER/g" $MIRROR_WEB_DIR/files/config/config.php
echo "DB user name changed"
sed -i "s/$ORIGIN_DB_PASSWD/$MIRROR_DB_PASSWD/g" $MIRROR_WEB_DIR/files/config/config.php
echo "DB password changed."
echo ""
echo "All DB information changed."
echo ""
echo ""
 
# Changing domain name in DB. 
echo "Changing site domain information to information in DB."
mysql -h$MIRROR_DB_HOST -u$MIRROR_DB_USER -p$MIRROR_DB_PASSWD $MIRROR_DB_NAME -e "UPDATE ${DB_PREFIX}domains SET domain = \"${MIRROR_DOMAIN}\" WHERE domain = \"${ORIGIN_DOMAIN}\";"
mysql -h$MIRROR_DB_HOST -u$MIRROR_DB_USER -p$MIRROR_DB_PASSWD $MIRROR_DB_NAME -e "UPDATE ${DB_PREFIX}sites SET domain = \"${MIRROR_DOMAIN}\" WHERE domain = \"${ORIGIN_DOMAIN}\";"
echo ""
echo "done."
echo ""
echo "Site migration(mirroring) complete."
