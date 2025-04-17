# Backup and Restore Script
This project provides a simple yet powerful Bash script for backing up and restoring directories with encryption. The script allows you to:
* Backup: Compress and encrypt directories/files into a .tgz.gpg archive.
* Restore: Decrypt and extract the backup to a specified directory.
* Automation: Automate backups using a cron job.

## Features
* Validation: Ensures that the source and destination directories are valid and not the same.
* Encryption: Uses GPG for encrypting backup files.
* Cron Job: Automates the backup process to run every hour.
* Logging: Logs backup operations for future reference.

## Prerequisites
* Bash: The script is written in Bash, so ensure you have a Bash shell available.
* GPG: GNU Privacy Guard (GPG) is required for encryption/decryption.
* Cron: For automated backups, ensure cron is installed and running.

## Usage
### Backup
Run the Backup Script:
```
./backup.sh
```
Input Parameters:
* Source Directory: The directory you want to back up.
* Destination Directory: The directory where the backup will be stored.
* Encryption Key: The key used to encrypt the backup.

Example:
```
/path/to/source /path/to/destination my_encryption_key
```

### Restore
Run the Restore Script:
```
./restore.sh
```

Input Parameters:
* Backup Directory: The directory containing the backup files.
* Restore Directory: The directory where the backup will be restored.
* Decryption Key: The key used to decrypt the backup.

Example:
```
/path/to/backup /path/to/restore my_decryption_key
```

## Automation
The backup script automatically adds a cron job to run every hour. You can view or edit the cron job using:
```
crontab -e
```

## Files
* backup_restore.sh: Contains the core functions for backup and restore operations.
* backup.sh: Script to initiate the backup process.
* restore.sh: Script to initiate the restore process.
  
---

## Example
### Backup Example
```
./backup.sh
/path/to/source /path/to/destination my_encryption_key
```
### Restore Example
```
./restore.sh
/path/to/backup /path/to/restore my_decryption_key
```
