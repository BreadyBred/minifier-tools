#!/bin/bash

# This script minifies JavaScript files using UglifyJS.

# Minification is the process of reducing file size by removing unnecessary characters,
# which in turn improves website performance by decreasing loading times.
# This is especially useful for optimizing production files.

# This script supports two types of minification:
# 	1. JavaScript files using UglifyJS
# 	2. CSS files using CleanCSS

# How to use:
# 	1. Run the script and enter the absolute path to the file you want to minify
#	2. The script will detect your file extension and automatically minify it with its own method

# Any needed module (NodeJS, UglifyJS and CleanCSS) will be installed if needed.

# If you need to minify multiple files at once, consider using the Standalone version of the script,
# which allows for bulk processing of JavaScript files.

# Strict mode, stop the script if an error occurs
set -euo pipefail

# Project root dir
ROOT_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"

# Variables and functions import
source ${ROOT_DIR}/tools/functions.sh
source ${ROOT_DIR}/tools/dependencies.sh

# Check if the provided file path exists
check_file_exists() {
	local path="$1"
	if [ -f "$path" ]; then
		return 0
	else
		return 1
	fi
}

# Function to prompt the user for a file path
prompt_file_path() {
    while true; do
        warning_message "(/!\ The path needs to be in this format: 'C://'. 'C:\' will not be recognized. /!\)"
        read -p "Enter the full path of the file you want to minify (Shift + Insert to paste a path): " file_path
        if [ -n "$file_path" ]; then
            FILE_NAME="$file_path"
            FILE_BASE=$(basename "$FILE_NAME")
            dir $file_path

            if check_file_exists "$file_path"; then
                detect_file_extension
                break
            else
                soft_error_message "The file '$file_path' does not exist. Please provide a valid path."
				carriage_return_message
            fi
        else
            soft_error_message "You didn't enter a file path. Please try again."
			carriage_return_message
        fi
    done
}


# Get the file extension from the file path
get_file_extension() {
	local file_path="$1"
	echo "${file_path##*.}" | tr '[:upper:]' '[:lower:]'
}

# Detect file extension
detect_file_extension() {
	local file_extension
	file_extension=$(get_file_extension "$FILE_NAME")
	if [ -z "$file_extension" ]; then
		handle_error "Could not detect file extension for '$FILE_BASE'."
	fi
	minify_file "$file_extension"
}

# Minification process
minify_file() {
    check_nodejs
    local file_type="$1"
    local minified_file_name="${FILE_NAME%.*}-min.${FILE_NAME##*.}"

    if [ "$file_type" == "js" ]; then
        check_uglifyjs
        uglifyjs "$FILE_NAME" -o "$minified_file_name" --compress --mangle || handle_error "Failed to minify JavaScript file."
        success_message "'$FILE_BASE' minified successfully."

    elif [ "$file_type" == "css" ]; then
        check_cleancss
        cleancss -o "$minified_file_name" "$FILE_NAME" || handle_error "Failed to minify CSS file."
        success_message "'$FILE_BASE' minified successfully."

    else
        handle_error "Unsupported file type: $file_type"
    fi
}


prompt_file_path