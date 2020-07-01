#!/bin/bash

###################################################################################################################
# This script backs up your Bitwarden data in encrypted form to the cloud storage provider of your choice.
#
# Requirements:
#   Bitwarden CLI (bw)
#   jq
#
# To decrypt:
#   gpg --passphrase [Bitwarden master password] --batch --output export.tar.gz --decrypt export.tar.gz.gpg
#   tar zxvf export.tar.gz
###################################################################################################################

#################### CONFIGURATION ####################

# Comment out anything you want to configure interactively
rclone_remote=personal-gdrive # your rclone remote (can be found with "rclone listremotes")
rclone_path=bitwarden-backup # your rclone destination path (the directory where the backup will be saved)

################ END OF CONFIGURATION #################

# Set unset configuration variables
echo -e '\033[4mConfiguration\033[0m'

if [ -z "$rclone_remote" ]; then
    echo -en '\033[1mRclone remote name: \033[0m'
    read -r rclone_remote
fi

if [ -z "$rclone_path" ]; then
#    read -rp "Rclone destination path: " rclone_path
    echo -en '\033[1mRclone destination path: \033[0m'
    read -r rclone_path    
fi

echo -en '\033[1mBitwarden master password: \033[0m'
read -rs bw_password
echo

echo -e '\033[4mExecution\033[0m'
export BW_SESSION=$(bw unlock --raw "$bw_password") # Create new Bitwarden session

# Sync the remote copy of the vault with the local one
echo -e '\033[1mSyncing local copy...\033[0m'
bw sync > /dev/null

# Export the vault + attachments
echo -e '\033[1mExporting vault...\033[0m'
bw export "$bw_password" --format json --output "./export/bitwarden-backup.json" > /dev/null
echo -e '\033[1mExporting attachments...\033[0m'
bash <(bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output \"./export/attachments/\($parent.id)/\(.fileName)\""') &> /dev/null

# Create an archive
tar czf export.tar.gz export
rm -rf export/

# Encrypt
echo -e '\033[1mEncrypting...\033[0m'
gpg --symmetric --no-tty --batch --passphrase "$bw_password" --cipher-algo AES256 export.tar.gz > /dev/null
rm export.tar.gz

# Upload to cloud
echo -e '\033[1mUploading...\033[0m'
rclone copy export.tar.gz.gpg "$rclone_remote":"$rclone_path"
rm export.tar.gz.gpg