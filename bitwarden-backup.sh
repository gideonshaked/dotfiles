#!/bin/bash

###################################################################################################################
# This script backs up your Bitwarden data in encrypted form to the cloud storage provider of your choice.
# It cannot operate non-interactively because it needs the Bitwarden master password.
#
# Requirements:
#   Bitwarden CLI (bw)
#   jq
#
# Decryption and extraction:
#   gpg --output export.tar.gz --decrypt export.tar.gz.gpg
#   tar zxvf export.tar.gz
###################################################################################################################

#################### CONFIGURATION ####################

# Your rclone remote (can be found with "rclone listremotes")
rclone_remote=personal-gdrive # Comment to configure interactively

# Your rclone destination path (the directory where the backup will be saved)
rclone_path=bitwarden-backup # Comment to configure interactively

# If you choose to use a gpg key to encrypt your backup instead of your Bitwarden master password, leave the key ID below.
# Otherwise, comment the line out and your Bitwarden master password will be used instead.
gpg_key_id=B32E71C0406D78418FD42F475EDA897ACA5CF40B

################ END OF CONFIGURATION #################

# Set unset configuration variables
echo -e '\033[4mConfiguration\033[0m'

if [ -z "$rclone_remote" ]; then
    echo -en '\033[1mRclone remote name: \033[0m'
    read -r rclone_remote
fi

if [ -z "$rclone_path" ]; then
    echo -en '\033[1mRclone destination path: \033[0m'
    read -r rclone_path    
fi

echo -en '\033[1mBitwarden master password: \033[0m'
read -rs bw_password
echo

if ! BW_SESSION=$(bw unlock --raw "$bw_password"); then # If new Bitward session fails, exit
    exit 1
fi
export BW_SESSION

echo -e '\033[4mExecution\033[0m'

# Sync the remote copy of the vault with the local one
echo -en '\033[1mSyncing local copy...\033[0m '
bw sync > /dev/null
echo 'done'

# Export the vault + attachments
echo -en '\033[1mExporting vault...\033[0m '
bw export "$bw_password" --format json --output "./export/bitwarden-backup.json" > /dev/null
echo 'done'

echo -en '\033[1mExporting attachments...\033[0m '
bash <(bw list items | jq -r '.[] | select(.attachments != null) | . as $parent | .attachments[] | "bw get attachment \(.id) --itemid \($parent.id) --output \"./export/attachments/\($parent.id)/\(.fileName)\""') > /dev/null
echo 'done'

# Create an archive
echo -en '\033[1mArchiving...\033[0m '
tar czf export.tar.gz export
rm -rf export/
echo 'done'

# Encrypt
echo -en '\033[1mEncrypting...\033[0m '
if [ -z "$gpg_key_id" ]; then # If there is no gpg key id in the config, use bw master password
    gpg --no-tty --batch --symmetric --passphrase "$bw_password" --cipher-algo AES256 export.tar.gz
else
    gpg --no-tty --batch --recipient "$gpg_key_id" --encrypt export.tar.gz 
fi
rm export.tar.gz
echo 'done'

# Upload to cloud
echo -en '\033[1mUploading...\033[0m '
rclone copy export.tar.gz.gpg "$rclone_remote":"$rclone_path"
rm export.tar.gz.gpg
echo 'done'