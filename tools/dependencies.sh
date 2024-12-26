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