# Backup and Encryption Script

## Description
This script creates a backup of a specified directory, compresses it using a selected compression algorithm (if any), and then encrypts the resulting backup file using AES-256-CBC encryption.

The script logs any errors to `error.log` and suppresses all other output.

## Usage
To use the script, you need to pass three required arguments:
- **Directory to backup** (`-d`)
- **Compression algorithm** (`-c`)
- **Output file name** (`-o`)

### Basic Syntax

```
./backup.sh [-h] -d <directory> -c <compression> -o <output>
```
