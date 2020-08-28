#!/bin/bash
 
# Copyright (C) 2017 Study For Us HOSTING (https://hosting.studyforus.com)
# Version infomation : 0.1.1 (Early version)
# License : The MIT License (MIT)
 
# Local Backup Vars Setting 
BACKUP_DIR='/backup'
BACKUP_EXPIRE_DAYS=14
DB_BACKUP_DIR_NAME="databases"
DB_HOST='DB접속주소'
DB_USER='DB사용자'
DB_PASSWORD='DB암호'
 
# Backup Date Setting
DN=`date +%Y-%m-%d`
FN=`date +%Y%m%d"_"%H%M%S`
 
# Messages For Starting Backup
echo "--------------------------------------------------------------------"
echo "                 Study For Us BACKUP Scheduler                      "
echo "                      Veresion 0.1.1                                "
echo "              License : The MIT License (MIT)                       "
echo "--------------------------------------------------------------------"
echo ""
echo "Making DB BACKUP Directory (today).."
 
 
# Making DB Backup Directory
mkdir -p $BACKUP_DIR/$DB_BACKUP_DIR_NAME/$DN
 
echo "done."
echo ""
echo "Delete backup directory older than $BACKUP_EXPIRE_DAYS days.."
 
# Delete backup directory older than Expire Days
find $BACKUP_DIR/$DB_BACKUP_DIR_NAME/ -maxdepth 1 -type d -mtime +$BACKUP_EXPIRE_DAYS -exec rm -rf {} \;
 
echo "done."
echo ""
echo "Backup all DBs as each DB files in $BACKUP_DIR/$DB_BACKUP_DIR_NAME/$DN .."
 
# Getting Information DB Lists
DB_LIST=$(mysql -u $DB_USER --password=$DB_PASSWORD -h $DB_HOST -e "SHOW DATABASES;" --skip-column-names | grep -Ev "(information_schema|performance_schema)")
 
# DB Backup Start
for db in $DB_LIST;
do mysqldump -u $DB_USER --password=$DB_PASSWORD -h $DB_HOST --opt --single-transaction  -e $db | gzip > "$BACKUP_DIR/$DB_BACKUP_DIR_NAME/$DN/$db-$FN.sql.gz";
done
 
echo "done."
echo ""
echo "Now Start BACKUP /var/ Directory By Rsnapshot.."
echo "(Contain creating new backup files and removing older backup files)"
 
# Rsnapshot Backup Start
rsnapshot daily
echo ""
echo ""
echo "ALL DONE. BACKUP COMPLETE."
