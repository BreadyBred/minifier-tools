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
    warning_message "(/!\ The path needs to be in this format: 'C://'. 'C:\' will not be recognized. /!\)"
    read -p "Enter the full path of the file you want to minify (Shift + Insert to paste a path): " file_path
    if [ -n "$file_path" ]; then
        FILE_NAME="$file_path"
        FILE_BASE=$(basename "$FILE_NAME")

        if check_file_exists "$file_path"; then
            detect_file_extension
        else
            handle_error "The file '$file_path' does not exist. Please provide a valid path."
        fi
    fi
}

# Get the file extension from the file path
get_file_extension() {
    local file_path="$1"
    echo "${file_path##*.}" | tr '[:upper:]' '[:lower:]'
}

# Minification process
minify_file() {
    check_nodejs
    local file_type="$1"

    if [ "$file_type" == "js" ]; then
        check_uglifyjs
        uglifyjs "$FILE_NAME" -o "$FILE_NAME" --compress --mangle || handle_error "Failed to minify JavaScript file."
        success_message "'$FILE_BASE' minified successfully."
    elif [ "$file_type" == "css" ]; then
        check_cleancss
        cleancss -o "$FILE_NAME" "$FILE_NAME" || handle_error "Failed to minify CSS file."
        success_message "'$FILE_BASE' minified successfully."
    else
        handle_error "Unsupported file type: $file_type"
    fi
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

# Node.JS status check, install if not installed
check_nodejs() {
	info_message "Checking Node.js status..."
	if ! command -v node &> /dev/null; then
		warning_message "Node.js isn't installed. Installing..."
		if [[ "$OSTYPE" == "linux-gnu"* ]]; then
			curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
			sudo apt-get install -y nodejs
		elif [[ "$OSTYPE" == "darwin"* ]]; then
			brew install node
		else
			handle_error "Operating system not supported for automatic Node.js installation.${CARRIAGE_RETURN}Please install Node.js manually from https://nodejs.org/"
		fi

		if ! command -v node &> /dev/null; then
			handle_error "Node.js installation failed. Please install it manually."
		fi

		info_message "Node.js installed successfully."
	else
		useless_action_message "Node.js is already installed!"
	fi
	carriage_return_message
}

# UglifyJS status check, install if not installed
check_uglifyjs() {
	info_message "Checking UglifyJS status..."
	if ! command -v uglifyjs &> /dev/null; then
		warning_message "UglifyJS is not installed. Installing..."
		npm install -g uglify-js
		if [ $? -ne 0 ]; then
			  handle_error "UglifyJS installation failed. Please check your npm configuration."
		fi
		info_message "UglifyJS installed successfully."
	else
		useless_action_message "UglifyJS is already installed!"
	fi
	carriage_return_message
}

# CleanCSS status check, install if not installed
check_cleancss() {
	info_message "Checking CleanCSS status..."
	if ! command -v cleancss &> /dev/null; then
		warning_message "CleanCSS is not installed. Installing..."
		npm install -g clean-css-cli
		if [ $? -ne 0 ]; then
			handle_error "CleanCSS installation failed. Please check your npm configuration."
		fi
		info_message "CleanCSS installed successfully."
	else
		useless_action_message "CleanCSS is already installed!"
	fi
	carriage_return_message
}

prompt_file_path