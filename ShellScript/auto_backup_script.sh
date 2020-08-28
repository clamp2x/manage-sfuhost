#!/bin/bash

# Copyright (C) 2017 Study For Us HOSTING (https://hosting.studyforus.com)
# Version infomation : 0.1.2 
# License : The MIT License (MIT)

#Local Backup Setting Vars
BACKUP_DIR='/backup'
BACKUP_EXPIRE_DAYS=14
DB_BACKUP_DIR_NAME="databases"
DB_HOST='DB접속주소'
DB_USER='DB사용자'
DB_PASSWORD='DB암호'

#Backup Date Setting
DN=`date +%Y-%m-%d`
FN=`date +%Y%m%d"_"%H%M%S`

# Messages For Starting Backup
echo "--------------------------------------------------------------------"
echo "                 Study For Us BACKUP Scheduler                      "
echo "                      Veresion 0.1.2                                "
echo "              License : The MIT License (MIT)                       "
echo "--------------------------------------------------------------------"
echo ""
echo "Making DB BACKUP Directory (today).."


#Make DB Backup Directory
mkdir -p $BACKUP_DIR/$DB_BACKUP_DIR_NAME/$DN

echo "done."
echo ""
echo "Remove older DB BACKUP Directories over $BACKUP_EXPIRE_DAYS days.."
#Remove Older DB Backup over Expire dates
find $BACKUP_DIR/$DB_BACKUP_DIR_NAME/ -maxdepth 1 -type d -mtime +$BACKUP_EXPIRE_DAYS -exec rm -rf {} \;

echo "done."
echo ""
echo "BACKUP DB files to all DB each files in $BACKUP_DIR/$DB_BACKUP_DIR_NAME/$DN .."

#Gets Information DB Lists
DB_LIST=$(/usr/bin/mysql -u $DB_USER --password=$DB_PASSWORD -h $DB_HOST -e "SHOW DATABASES;" --skip-column-names | grep -Ev "(information_schema|performance_schema)")

#DB Backup Start
for db in $DB_LIST;
do /usr/bin/mysqldump -u $DB_USER --password=$DB_PASSWORD -h $DB_HOST --opt --single-transaction  -e $db | gzip > "$BACKUP_DIR/$DB_BACKUP_DIR_NAME/$DN/$db-$FN.sql.gz";
done

echo "done."
echo ""
echo "Now Start BACKUP /var/ Directory with Rsnapshot.."
echo "(contains newfiles and removing older files)"

#Rsnapshot Backup Start
/usr/bin/rsnapshot daily
echo ""
echo ""
echo "ALL DONE. BACKUP COMPLETE."
echo ""
echo ""
#echo "The system will be turn off now. But not now."
#/sbin/poweroff
rm -rf /backup/daily.0/var/backup/
