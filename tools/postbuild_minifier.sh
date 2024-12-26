#!/bin/bash

# This script minifies JavaScript files using UglifyJS.
# It is primarily intended for automatic post-build use, executed after compiling TypeScript,
# but can also be used to minify any JavaScript file.

# Minification is the process of reducing file size by removing unnecessary characters,
# which in turn improves website performance by decreasing loading times.
# This is especially useful for optimizing production files.

# How to use:
# To integrate this script into your build process, add it as a post-build step in your package.json file.
# Here's how:
# 	"scripts": {
# 		"build": "tsc",
# 		"postbuild": "bash ./path/to/script/postbuild_minifier.sh"
# 	}
# Once you've added this, the script will run automatically after executing npm run build,
# ensuring that your JavaScript files are minified without additional manual steps.

# This script WILL overwrite your old JavaScript file because it is meant
# to be combined with a TypeScript environment.

# Any needed module (NodeJS, UglifyJS) will be installed if needed.

# If you need to minify multiple files at once, consider using the Standalone version of the script,
# which allows for bulk processing of JavaScript files.

# Strict mode, stop the script if an error occurs
set -euo pipefail

# Project root dir
ROOT_DIR="$(cd "$(dirname "$0")" && cd .. && pwd)"

# Variables and functions import
source ${ROOT_DIR}/tools/functions.sh
source ${ROOT_DIR}/tools/dependencies.sh

#!--- Your path to the JS file to minify ---!#
FILE_NAME="C://PATH/TO/JS/SCRIPT/script.js"
FILE_BASE=$(basename "$FILE_NAME")

# File status check
info_message "Checking script"
if [ ! -f "$FILE_NAME" ]; then
	handle_error "Error: $FILE_BASE doesn't exist."
else
	useless_action_message "$FILE_BASE exists!"
fi
carriage_return_message

check_nodejs
check_uglifyjs

# Minification process
info_message "Starting minification..."
uglifyjs "$FILE_NAME" -o "$FILE_NAME" --compress --mangle

if [ $? -eq 0 ]; then
	success_message "$FILE_BASE has been minified successfully."
else
	handle_error "Error during file minification."
fi
carriage_return_message

useless_action_message "Press any key to exit..."
read -n 1 -s
exit 1