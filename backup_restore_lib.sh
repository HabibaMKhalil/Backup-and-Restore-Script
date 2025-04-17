#!bin/bash

function validate_backup_params(){
	source=$1
	destination=$2
	key=$3
	
	valid=true
	
	# Checking for missing parameters
	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
		echo
		echo "Error: Missing parameters"
		echo "Usage: [source_directory] [destination_directory] [encryption_key]"
		echo 
		return 1
	fi
	
	# Checking if the source directory is valid
	if [ ! -d "$1" ]; then
		valid=false
		echo "Error: The source directory to be backed up is invalid"
	fi
	
	# Checking if the destination directory is valid
	if [ ! -d "$2" ]; then
		valid=false
		echo "Error: The destination directory to store the backup is invalid"
	fi
	
	# If any validation failed return 1
	if [ "$valid" = false ]; then
		return 1
	fi
	
	# Otherwise, check if the source and destination directories are the same
	if diff -r "$source" "$destination" > /dev/null; then
		echo "Error: Both directory paths can't be the same"
		return 1
	fi

	# Checking if the source directory is empty
	if [ -z "$( ls -A "$source")" ]; then
		echo "Source directory is empty. No backup performed."
		return 1
	fi
}

function validate_restore_params(){
	source=$1
	destination=$2
	key=$3
	
	valid=true
	
	# Checking for missing parameters
	if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
		echo
		echo "Error: Missing parameters"
		echo "Usage: [source_directory] [destination_directory] [decryption_key]"
		echo
		return 1
	fi
	
	# Checking if the source directory is valid
	if [ ! -d "$1" ]; then
		valid=false
		echo "Error: The directory that contains the backup is invalid"
	fi
	
	# Checking if the destination directory is valid
	if [ ! -d "$2" ]; then
		valid=false
		echo "Error: The directory the backup should be stored in is invalid"
	fi
	
	# If any validation failed return 1
	if [ "$valid" = false ]; then
		return 1
	fi
	
	# Otherwise, check if the source and destination directories are the same
	if diff -r "$source" "$destination" > /dev/null; then
		echo "Error: Both directory paths can't be the same"
		return 1
	fi
}

function backup(){
	source_dir="$1"
    	destination_dir="$2"
   	encryption_key="$3"
    	current_date=$(date +'%Y-%m-%d_%H-%M-%S' | sed 's/[: ]/_/g')
	#current_date=$(echo $(date) | tr ' ' '_')
    	date_dir="$destination_dir/$current_date"

	validate_backup_params "$source_dir" "$destination_dir" "$encryption_key"
		
	# if the parameters are not valid
	if [ $? -ne 0 ]; then
		echo "Exiting..."
		return 1
	fi
	# otherwise if they are valid
	echo "Starting backup..."
    	mkdir -p "$date_dir"
	
	# Creating a tarball of all the backed-up items in the date directory
	all_files_tar="$date_dir/all_archive_files_$current_date.tgz"

   	for item in "$source_dir"/*; do
		# getting the name of the file or directory
		item_name=$(basename "$item")

		# if the item is a directory
		if [ -d "$item" ]; then
			# create a compressed gzip tarball archive - tar.gz file
			tar_file="$date_dir/${item_name}_${current_date}.tgz"
		    	tar -czf "$tar_file" -C "$source_dir" "$item_name"

			# encrypting the tar.gz file
		    	gpg --symmetric --batch --passphrase "$encryption_key" -o "$tar_file.gpg" "$tar_file"

			# removing the unencrypted file and the original directory
		    	 rm "$tar_file"
			rm -r "$item"
			echo "Backup and encryption of directory: ${item_name} done!"

		#if the item is a file
		elif [ -f "$item" ]; then
			# Adding files to tarball
			if [ ! -f "$all_files_tar" ]; then
					# if the tarball doesn't exist, will create a new tarball
					tar -cf "$all_files_tar" -C "$source_dir" "$item_name"
				else
					# otherwise if it does exist will update it by appending each additional file to the tarball
					tar -uf "$all_files_tar" -C "$source_dir" "$item_name"
			fi
			# removing the original file
			rm "$item"
			echo "Bakup and encryption of file: ${item_name} done!"
		fi
	done

	# Encrypting the tar.gz file
	gpg --symmetric --batch --passphrase "$encryption_key" -o "$all_files_tar.gpg" "$all_files_tar"

	# removing the original tar.gz file
	 rm "$all_files_tar"
	echo "Backup and encryption of all files done!"

	# Adding cron job to execute this script every hour if not already present
	cron_config="0 * * * * /home/nour-helmy/Lab1/backup.sh $source_dir $destination_dir $encryption_key >> /home/nour-helmy/Lab1/backup.log2>&1"
	# Check if the cron job already exists to avoid duplicates
	(crontab -l | grep -q -F "$cron_config") || (crontab -l; echo "$cron_config") | crontab -
	echo "Cron added to run the backup script every hour."
}

function restore(){
	backup_dir="$1"
	restore_dir="$2"
	decryption_key="$3"
	temp_dir="$restore_dir/temp"

	validate_restore_params "$backup_dir" "$restore_dir" "$decryption_key"
		
	# if the parameters are not valid
	if [ $? -ne 0 ]; then
		echo "Exiting..."
		return 1
	fi
	# otherwise if they are valid
	echo "Starting restore..."

	# Creating the temp directory
	mkdir -p "$temp_dir"

	# Looping over all .gpg files in the backup directory
	for file in "$backup_dir"/*.gpg; do
		# if the file exists
		if [[ -f "$file" ]]; then
			echo "Decrypting: $file"
			# Decrypt each .gpg file and save to temp directory with the original filename
			gpg --batch --yes --passphrase "$decryption_key" -o "$temp_dir/$(basename "$file" .gpg)" -d "$file"
		fi
	done

	# Extracting files from temp to the destination directory
	for file in "$temp_dir"/*; do
		tar -xvf "$file" -C "$restore_dir"
	done

	# Removing temp directory
	rm -rf "$temp_dir"
	echo "Restore completed successfully"
}
