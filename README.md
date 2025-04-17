## 💾 BACKUP AND RESTORE SCRIPT
Bash | GPG Encryption | Cron Automation                        
A robust solution for directory backups with encryption
and automated scheduling capabilities.

## 🚀 KEY FEATURES
✔ Secure encryption using GPG (AES-256)                    
✔ Validation for source/destination paths                           
✔ Hourly automated backups via cron                            
✔ Detailed operation logging                           
✔ Simple restore functionality                              

## 🛠️ PREREQUISITES
$ sudo apt-get install gnupg cron  # Debian/Ubuntu                             
$ brew install gnupg               # macOS                                     


## 🧠 USAGE EXAMPLES

1. Backup command:
$ ./backup.sh                          
>> Enter source:      /path/to/source                               
>> Enter destination: /path/to/backups                                      
>> Encryption key:    my_secure_key123                                     

2. Restore command: 
$ ./restore.sh                                
>> Backup file:      /path/to/backups/backup_20231115.tgz.gpg                         
>> Restore location: /path/to/restore                      
>> Decryption key:   my_secure_key123                    

## ⚙️ AUTOMATION
1. View active cron jobs:
$ crontab -l

2. Edit automation schedule:
$ crontab -e                             
Add this line for hourly backups:                       
0 * * * * /path/to/backup.sh /source /backups encryption_key                                

## 📂 PROJECT STRUCTURE
backup-system/                     
├── backup_restore.sh    # Core functions                       
├── backup.sh           # Backup interface                           
├── restore.sh          # Restore interface                             
├── logs/               # Operation logs                    
│   └── backup_20231115.log                         
└── README              # This file                               
