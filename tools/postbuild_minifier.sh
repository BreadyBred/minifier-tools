#!/bin/bash

# Strict mode, stop the script if an error occurs
set -euo pipefail

# Project root dir
ROOT_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"

# Variables and functions import
source ${ROOT_DIR}/tools/functions.sh

#! Your path to the JS file to minify
FILE_NAME="C://DIRECTORY/TO/JS/SCRIPT/script.js"

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

# File status check
info_message "Checking script"
if [ ! -f "$FILE_NAME" ]; then
    handle_error "Error: $FILE_NAME doesn't exist."
else
	info_message "Script exists! Starting modules installation."
fi
carriage_return_message

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
info_message "Starting minification..."
uglifyjs "$FILE_NAME" -o "$FILE_NAME" --compress --mangle

if [ $? -eq 0 ]; then
    success_message "$FILE_NAME has been minified successfully."
else
    handle_error "Error during file minification."
fi
carriage_return_message

read -p "Press any key to continue..."