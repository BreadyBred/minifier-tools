#!/bin/bash

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
	fi
	carriage_return_message

	info_message "Checking input directory..."
	if [ ! -d "$INPUT_DIRECTORY" ]; then
		warning_message "Input directory '$INPUT_DIRECTORY' does not exist. Creating it..."
		mkdir -p "$INPUT_DIRECTORY"
		handle_error "Input directory '$INPUT_DIRECTORY' did not exist and has been created. Please add JavaScript files to process."
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
		info_message "Node.js is already installed!"
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
		info_message "UglifyJS is already installed!"
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
		info_message "clean-css-cli is already installed!"
	fi
	carriage_return_message
}

# Minification process
minify_files() {
	local file_type=$1
	info_message "Starting minification of $file_type files from '$INPUT_DIR_NAME' to 	'$OUTPUT_DIR_NAME'..."

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
}

# Function to prompt the user for choice
choose_minifier() {
  echo -e "${CYAN}Choose your minifier:${BLANK_SPACE}"
  PS3="Enter your choice (1 for JS, 2 for CSS): "
  options=("JS (JavaScript)" "CSS (Stylesheets)")
  select opt in "${options[@]}"; do
    case $opt in
      "JS (JavaScript)")
        minify "js"
        break
        ;;
      "CSS (Stylesheets)")
        minify "css"
        break
        ;;
      *) 
        echo "Invalid choice. Please choose 1 for JS or 2 for CSS."
        ;;
    esac
  done
}

check_tools() {
  if [ "$1" == "js" ]; then
	check_uglifyjs
  fi
  
  if [ "$1" == "css" ]; then
	check_cleancss
  fi
}

minify() {
  check_directories

  check_nodejs
  check_tools $1
  
  minify_files $1

  read -p "Press any key to continue..."
}

choose_minifier