#!/bin/bash

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
		sudo npm install -g uglify-js
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
		sudo npm install -g clean-css-cli
		if [ $? -ne 0 ]; then
			handle_error "CleanCSS installation failed. Please check your npm configuration."
		fi
		info_message "CleanCSS installed successfully."
	else
		useless_action_message "CleanCSS is already installed!"
	fi
	carriage_return_message
}

# HTML-Minifier status check, install if not installed
check_htmlminifier() {
    info_message "Checking HTMLMinifier status..."
    if ! command -v html-minifier &> /dev/null; then
        warning_message "HTMLMinifier is not installed. Installing..."
        sudo npm install -g html-minifier
        if [ $? -ne 0 ]; then
            handle_error "HTMLMinifier installation failed. Please check your npm configuration."
        fi
        info_message "HTMLMinifier installed successfully."
    else
        useless_action_message "HTMLMinifier is already installed!"
    fi
    carriage_return_message
}

# SVGO status check, install if not installed pour HTML
check_svgo() {
    info_message "Checking SVGO status..."
    if ! command -v svgo &> /dev/null; then
        warning_message "SVGO is not installed. Installing..."
        sudo npm install -g svgo
        if [ $? -ne 0 ]; then
            handle_error "SVGO installation failed. Please check your npm configuration."
        fi
        info_message "SVGO installed successfully."
    else
        useless_action_message "SVGO is already installed!"
    fi
    carriage_return_message
}

# JSON-Minify status check, install if not installed
check_jsonminify() {
    info_message "Checking JSON-Minify status..."
    if ! command -v json-minify &> /dev/null; then
        warning_message "JSON-Minify is not installed. Installing..."
        sudo npm install -g json-minify
        if [ $? -ne 0 ]; then
            handle_error "JSON-Minify installation failed. Please check your npm configuration."
        fi
        info_message "JSON-Minify installed successfully."
    else
        useless_action_message "JSON-Minify is already installed!"
    fi
    carriage_return_message
}

# XMLLINT status check, install if not installed
check_xmllint() {
    info_message "Checking xmllint status..."
    if ! command -v xmllint &> /dev/null; then
        warning_message "xmllint is not installed. Installing..."
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo apt-get install -y libxml2-utils
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            brew install libxml2
        else
            handle_error "Operating system not supported for automatic xmllint installation.${CARRIAGE_RETURN}Please install xmllint manually."
        fi

        if ! command -v xmllint &> /dev/null; then
            handle_error "xmllint installation failed. Please install it manually."
        fi

        info_message "xmllint installed successfully."
    else
        useless_action_message "xmllint is already installed!"
    fi
    carriage_return_message
}