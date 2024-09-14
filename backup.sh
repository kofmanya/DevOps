#!/bin/bash

ERROR_LOG="error.log"

exec 3>&1
exec 2>>"$ERROR_LOG" 1>/dev/null

# Function to show help
function show_help {
        exec 1>&3
	echo "Usage: $0 [options]"
	echo ""
	echo "Options:"
	echo "	-d directory	Directory to backup"
	echo "	-c algorithm	Compression algorithm (none, gzip, bzip)"
	echo "	-o output	Output file name"
	echo "	-h help		Help message"
	exec 1>/dev/null
	exit 0
}

# Function for handling errors
function log_error {
	echo "$1" >> "$ERROR_LOG"
}

# Function to perform the backup with compression 
function make_backup {
	local dir=$1
	local compression=$2
	local output=$3

	if [[ ! -d "$dir" ]]; then
		log_error "Error: directory $dir does not exists"
		exit 1
	fi

	case $compression in
		none)
			tar cf "$output.tar" "$dir" 
			;;
		gzip)
			tar czf "$output.tar.gz" "$dir"
			;;
		bzip)
           		 tar cjf "$output.tar.bz2" "$dir"
            		;;	
		*)
			log_error "Error: Unsupported compression algorithm $compression"
			exit 1
			;;
	esac
}

function get_password {
	exec 1>&3
	echo "Enter encription password:"
	read -s Password
	exec 1>/dev/null
}

# Function to encpypt the backup archive
function encrypt_backup {
	local output=$1
	openssl enc -aes-256-cbc -pbkdf2 -salt -in "$output" -out "$output.enc" -pass pass:$Password
	if [[ $? -ne 0 ]]; then
		log_error "Error: Failed to encrypt $output"
		exit 1
	fi
	rm "$output" # Remove unencrypted file
}

# Parsing command-line arguments
while getopts "d:c:o:h" opt; do
	case ${opt} in
		d)
			Directory=$OPTARG
			;;
		c)
			Compression=$OPTARG
			;;
		o)
			Output=$OPTARG
			;;
		h)
			show_help
			;;
		\?)
			log_error "Error: Invalid option"
			exit 1
			;;
	esac
done

# Check if all required arguments are provided
if [[ -z "$Directory" || -z "$Compression" || -z "$Output" ]]; then
	log_error "Error: Missing required arguments"
	show_help
	exit 1
fi
		
# Perform the backup
make_backup "$Directory" "$Compression" "$Output"

get_password

# Encrypt the backup
case $Compression in
	none)
		encrypt_backup "$Output.tar"
		;;
	gzip)
		encrypt_backup "$Output.tar.gz"
		;;
	bzip)
		encrypt_backup "$Output.tar.bz2"
		;;
esac







































































