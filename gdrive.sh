#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
IFS=$'\n'

EXT='.idatabase_vesta'

# Modify script from https://forum.vestacp.com/viewtopic.php?t=14277
# Editor by iDatabase
# My environment : Ubuntu 16.04

# If you're short on Drive space, you may want to delete previous backups
upTime=$(date --date="14 days ago" '+%Y-%m-%dT%T')
gdrive list -q "name contains '$EXT' and modifiedTime < '$upTime'" >> drive.txt
filename='drive.txt'
# Read the list file
while read -r line
do
   theId=$(cut -c-2 <<< "$line")
   #basically skip the first line...
   if [ "$theId" != "Id" ]; then
        #send the delete command
        gdrive delete $(cut -c-28 <<< "$line")
   fi
done < $filename
# Remove temp list file
rm -rf drive.txt

# For every user you have:
for USERINFO in `grep ":/home" /etc/passwd`
do
 USERNAME=$(echo $USERINFO | cut -d: -f1)

 # Declare the variable that will give you the backup filename
 BAKFILE=$(echo "/backup/$USERNAME.$(date '+%Y-%m-%d').tar")
 BAKFILE_NEW=$BAKFILE$EXT

 if [ -e "$BAKFILE" ] ; then
  # Copy the Drive folder ID (example ABCDEFGHIJKLMNO) where you'll upload your files (the after the https://drive.google.com/.../folders/...). Upload the backup file, then delete it from machine.
  mv $BAKFILE $BAKFILE_NEW
  gdrive upload -p ABCDEFGHIJKLMNO --delete "$BAKFILE_NEW"
 fi
done

exit 0
