#!/bin/bash

# This script is designed to minify multiple types of files including CSS, JavaScript, HTML, SVG and JSON.

# Strict mode, stop the script if an error occurs
set -euo pipefail

# Project root dir
ROOT_DIR="$(cd "$(dirname "$0")" && cd .. && cd .. && pwd)"

# Variables and functions import
source "${ROOT_DIR}/assets/tools/functions.sh"
source "${ROOT_DIR}/assets/tools/dependencies.sh"

INPUT_DIRECTORY="${ROOT_DIR}/to_minify/"
OUTPUT_DIRECTORY="${ROOT_DIR}/minified/"
INPUT_DIR_NAME=$(basename "$INPUT_DIRECTORY")
OUTPUT_DIR_NAME=$(basename "$OUTPUT_DIRECTORY")
FILE_TYPES=("js" "css" "html" "svg" "json")

# Directories status check
check_directories() {
    info_message "Checking output directory..."
    if [ ! -d "$OUTPUT_DIRECTORY" ]; then
        warning_message "Output directory \"$OUTPUT_DIRECTORY\" does not exist. Creating it..."
        mkdir -p "$OUTPUT_DIRECTORY" || handle_error "Failed to create output directory \"$OUTPUT_DIR_NAME\". Check permissions."
    else
        useless_action_message "Output directory \"$OUTPUT_DIR_NAME\" already exists."
    fi
    carriage_return_message

    info_message "Checking input directory..."
    if [ ! -d "$INPUT_DIRECTORY" ]; then
        warning_message "Input directory \"$INPUT_DIR_NAME\" does not exist. Creating it..."
        mkdir -p "$INPUT_DIRECTORY" || handle_error "Failed to create input directory \"$INPUT_DIR_NAME\". Check permissions."
        handle_error "Input directory \"$INPUT_DIR_NAME\" did not exist and has been created. Please add files to process."
    else
        useless_action_message "Input directory \"$INPUT_DIR_NAME\" already exists."
    fi
    carriage_return_message
}

# Checking all needed tools
check_tools() {
    check_nodejs

    if ls "$INPUT_DIRECTORY"*.js &> /dev/null; then
        check_tool "uglifyjs" "UglifyJS" "npm install -g uglify-js" 
    fi
    if ls "$INPUT_DIRECTORY"*.css &> /dev/null; then
        check_tool "cleancss" "CleanCSS" "npm install -g clean-css-cli" 
    fi
    if ls "$INPUT_DIRECTORY"*.html &> /dev/null; then
        check_tool "html-minifier" "HTML Minifier" "npm install -g html-minifier" 
    fi
    if ls "$INPUT_DIRECTORY"*.svg &> /dev/null; then
        check_tool "svgo" "SVGO" "npm install -g svgo" 
    fi
    if ls "$INPUT_DIRECTORY"*.json &> /dev/null; then
        check_tool "json-minify" "JSON Minify" "npm install -g json-minify"
    fi
}

# Minification process for each file type
minify() {
    info_message "This script will check every file from 'to_minify' and minify any supported file automatically."
    info_message "Find the minified files in the 'minified' folder."
    carriage_return_message

    check_directories
    check_tools

    for file_type in "${FILE_TYPES[@]}"; do
        if ls "$INPUT_DIRECTORY"*.$file_type &> /dev/null; then
            minify_files "$file_type"
        else
            useless_action_message "No '${file_type^^}' files found in '$OUTPUT_DIR_NAME'. Skipping minification for '${file_type^^}'."  
            carriage_return_message
        fi
    done

    useless_action_message "Press any key to exit..."
    read -n 1 -s
    exit 1
}

minify_files() {
    local file_type=$1
    info_message "Starting minification of '${file_type^^}' files from '$INPUT_DIR_NAME' to '$OUTPUT_DIR_NAME'..."

    for INPUT_FILE in "$INPUT_DIRECTORY"*.$file_type; do
        if [ ! -f "$INPUT_FILE" ]; then
            warning_message "No '${file_type^^}' files found in '$INPUT_DIR_NAME'."
            carriage_return_message
            continue
        fi

        FILE_NAME=$(basename "$INPUT_FILE" .$file_type)
        BASE_NAME=$(basename "$INPUT_FILE")
        OUTPUT_FILE="${OUTPUT_DIRECTORY}${FILE_NAME}-min.$file_type"
        OUTPUT_BASE_NAME="${FILE_NAME}-min.$file_type"

        case "$file_type" in
            js)
                info_message "Minifying '$BASE_NAME' -> '$OUTPUT_BASE_NAME'..."
                uglifyjs "$INPUT_FILE" -o "$OUTPUT_FILE" --compress --mangle # toplevel
                ;;
            css)
                info_message "Minifying '$BASE_NAME' -> '$OUTPUT_BASE_NAME'..."
                cleancss -o "$OUTPUT_FILE" "$INPUT_FILE"
                ;;
            html)
                info_message "Minifying '$BASE_NAME' -> '$OUTPUT_BASE_NAME'..."
                html-minifier --collapse-whitespace --remove-comments --minify-js true --minify-css true "$INPUT_FILE" -o "$OUTPUT_FILE"
                ;;
            svg)
                info_message "Minifying '$BASE_NAME' -> '$OUTPUT_BASE_NAME'..."
                svgo --quiet "$INPUT_FILE" -o "$OUTPUT_FILE"
                ;;
            json)
                info_message "Minifying '$BASE_NAME' -> '$OUTPUT_BASE_NAME'..."
                json-minify "$INPUT_FILE" > "$OUTPUT_FILE"
                ;;
            *)
                warning_message "Unsupported file type: '${file_type^^}'"
                ;;
        esac

        if [ $? -eq 0 ]; then
            success_message "'$BASE_NAME' has been minified successfully to '$OUTPUT_BASE_NAME'."
        else
            handle_error "Error during minification of '$BASE_NAME'."
        fi

        carriage_return_message
    done

    success_message "All '${file_type^^}' files in '$INPUT_DIR_NAME' have been processed."
    carriage_return_message
}

minify