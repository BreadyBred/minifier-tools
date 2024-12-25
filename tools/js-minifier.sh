#!/bin/bash

# Strict mode, stop the script if an error occurs
set -euo pipefail

CYAN="\033[1;36m"
RED="\033[1;31m"
ORANGE="\033[1;33m"
GREEN="\033[1;32m"
BLANK_SPACE="\033[0m"
CARRIAGE_RETURN="\n"

ROOT_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)/"
INPUT_DIRECTORY="${ROOT_DIR}to_minify/"
OUTPUT_DIRECTORY="${ROOT_DIR}minified/"
INPUT_DIR_NAME=$(basename "$INPUT_DIRECTORY")
OUTPUT_DIR_NAME=$(basename "$OUTPUT_DIRECTORY")

handle_error() {
  echo -e "${RED}❌ An error occured: $1 (╯°□°)╯︵ ┻━┻ ${BLANK_SPACE}"
  exit 1
}

warning_message() {
  echo -e "${ORANGE}$1 ¯\_(ツ)_/¯ ${BLANK_SPACE}"
}

success_message() {
  echo -e "${GREEN}$1 *\(^o^)/* ${BLANK_SPACE}"
}

info_message() {
  echo -e "${CYAN}$1${BLANK_SPACE}"
}

carriage_return_message() {
	echo -e ""
}

# Repertory status check
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

# NodeJS status check, install if not installed
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

# UglifyJS status check, install if not installed
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

# Minification process
info_message "Starting minification of JavaScript files from '$INPUT_DIR_NAME' to '$OUTPUT_DIR_NAME'..."


for INPUT_FILE in "$INPUT_DIRECTORY"*.js; do
    if [ ! -f "$INPUT_FILE" ]; then
        warning_message "No JavaScript files found in '$INPUT_DIRECTORY'."
        continue
    fi

    FILE_NAME=$(basename "$INPUT_FILE" .js)
    BASE_NAME=$(basename "$INPUT_FILE")
    OUTPUT_FILE="${OUTPUT_DIRECTORY}${FILE_NAME}-min.js"
    OUTPUT_BASE_NAME="${FILE_NAME}-min.js"

    info_message "Minifying '$BASE_NAME' -> '$OUTPUT_BASE_NAME'..."
    uglifyjs "$INPUT_FILE" -o "$OUTPUT_FILE" --compress --mangle

    if [ $? -eq 0 ]; then
        success_message "'$BASE_NAME' has been minified successfully to '$OUTPUT_BASE_NAME'."
    else
        handle_error "Error during minification of '$BASE_NAME'."
    fi

    carriage_return_message
done

success_message "All files in '$INPUT_DIR_NAME' have been processed."

read -p "Press any key to continue..."