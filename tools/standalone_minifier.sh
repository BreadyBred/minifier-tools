#!/bin/bash

# This script is designed to minify both CSS and JavaScript files.

# Minification is the process of reducing the size of files by removing unnecessary characters,
# which helps improve website loading times and overall performance.

# This script supports two types of minification:
# 	1. JavaScript files using UglifyJS
# 	2. CSS files using CleanCSS

# How to use:
# 	1. Put your JavaScript and CSS files in the to_minify/ directory.
# 	2. Run the script, which will minify the files and save the results in the minified/ directory.
# 	3. The script will minify every JS and CSS file it will find in this folder.

# Any needed module (NodeJS, UglifyJS and CleanCSS) will be installed if needed.

# If you're working with TypeScript and prefer to minify your files automatically after each build,
# i recommend using the Postbuild version of this script.
# It allows you to minify the files immediately after the TypeScript compilation process, saving you time and effort.

# Strict mode, stop the script if an error occurs
set -euo pipefail

# Project root dir
ROOT_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"

# Variables and functions import
source ${ROOT_DIR}/tools/functions.sh

INPUT_DIRECTORY="${ROOT_DIR}/to_minify/"
OUTPUT_DIRECTORY="${ROOT_DIR}/minified/"
INPUT_DIR_NAME=$(basename "$INPUT_DIRECTORY")
OUTPUT_DIR_NAME=$(basename "$OUTPUT_DIRECTORY")

# Directories status check
check_directories() {
	info_message "Checking output directory..."
	if [ ! -d "$OUTPUT_DIRECTORY" ]; then
		warning_message "Output directory '$OUTPUT_DIRECTORY' does not exist. Creating it..."
		mkdir -p "$OUTPUT_DIRECTORY"
	else
		useless_action_message "Output directory already exists."
	fi
	carriage_return_message

	info_message "Checking input directory..."
	if [ ! -d "$INPUT_DIRECTORY" ]; then
		warning_message "Input directory '$INPUT_DIRECTORY' does not exist. Creating it..."
		mkdir -p "$INPUT_DIRECTORY"
		handle_error "Input directory '$INPUT_DIRECTORY' did not exist and has been created. Please add JavaScript files to process."
	else
		useless_action_message "Input directory already exists."
	fi
	carriage_return_message
}

# NodeJS status check, install if not installed
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
	info_message "Checking clean-css-cli status..."
	if ! command -v cleancss &> /dev/null; then
		warning_message "clean-css-cli is not installed. Installing..."
		npm install -g clean-css-cli
		if [ $? -ne 0 ]; then
			handle_error "clean-css-cli installation failed. Please check your npm configuration."
		fi
		info_message "clean-css-cli installed successfully."
	else
		useless_action_message "clean-css-cli is already installed!"
	fi
	carriage_return_message
}

# Minification process
minify_files() {
	local file_type=$1
	info_message "Starting minification of $file_type files from '$INPUT_DIR_NAME' to '$OUTPUT_DIR_NAME'..."

	for INPUT_FILE in "$INPUT_DIRECTORY"*.$file_type; do
		if [ ! -f "$INPUT_FILE" ]; then
			warning_message "No $file_type files found in '$INPUT_DIRECTORY'."
			continue
		fi

		FILE_NAME=$(basename "$INPUT_FILE" .$file_type)
		BASE_NAME=$(basename "$INPUT_FILE")
		OUTPUT_FILE="${OUTPUT_DIRECTORY}${FILE_NAME}-min.$file_type"
		OUTPUT_BASE_NAME="${FILE_NAME}-min.$file_type"

		if [ "$file_type" == "js" ]; then
			info_message "Minifying '$BASE_NAME' -> '$OUTPUT_BASE_NAME'..."
			uglifyjs "$INPUT_FILE" -o "$OUTPUT_FILE" --compress --mangle
		elif [ "$file_type" == "css" ]; then
			info_message "Minifying '$BASE_NAME' -> '$OUTPUT_BASE_NAME'..."
			cleancss -o "$OUTPUT_FILE" "$INPUT_FILE"
		fi

		if [ $? -eq 0 ]; then
			success_message "'$BASE_NAME' has been minified successfully to '$OUTPUT_BASE_NAME'."
		else
			handle_error "Error during minification of '$BASE_NAME'."
		fi

		carriage_return_message
	done

	success_message "All files in '$INPUT_DIR_NAME' have been processed."
	carriage_return_message
}

minify() {
	info_message "This script will check every file from 'to_minify' and minify any JS and CSS file automatically."
	info_message "Find the minified files in the 'minified' folder."
	carriage_return_message

	check_directories

	check_nodejs
	check_uglifyjs
	check_cleancss
	
	# Minify all JavaScript files
	minify_files "js"

	# Minify all CSS files
	minify_files "css"

	useless_action_message "Press any key to exit..."
	read -n 1 -s
	exit 1
}

minify
