#!/bin/bash

# Function to install figlet if not already installed
install_figlet() {
    if ! command -v figlet &> /dev/null; then
        echo "Figlet is not installed. Installing..."
        if command -v apt-get &> /dev/null; then
            sudo apt-get install -y figlet
        elif command -v yum &> /dev/null; then
            sudo yum install -y figlet
        else
            echo "Error: Unsupported package manager. Please install figlet manually."
            exit 1
        fi
    fi
}

# Function to display the banner using figlet
display_banner() {
    if command -v figlet &> /dev/null; then
        figlet -f slant "Shrewdeye" | sed 's/^/ /'
        echo "Tess Edition"
        echo -e "\e[1;32mNote: Enter the domain name when prompted. Tess approved! \U1F480 \e[0m"
        echo "Credits: Shrewdeye Tool - https://shrewdeye.app/"
        echo "--------------------------------------------------------"
    else
        install_figlet
    fi
}

# Function to process a single domain
process_domain() {
    domain=$1
    api_url="https://shrewdeye.app/domains/${domain}.txt"
    response=$(curl -s "$api_url")

    if [ $? -eq 0 ]; then
        echo "$response" > "${domain}_output.txt"
        echo "Data for $domain saved to ${domain}_output.txt"
    else
        echo "Error: Unable to fetch data for $domain from the API. Please check the domain name and try again."
    fi
}

# Display the banner
display_banner

# Check if the user wants to input a single domain or a list
read -p "Do you want to input a single domain or provide a list? (single/list): " choice

if [ "$choice" == "single" ]; then
    # Prompt the user for a single domain
    read -p "Enter the domain name: " domain_name
    process_domain "$domain_name"
elif [ "$choice" == "list" ]; then
    # Prompt the user for a list of domains
    read -p "Enter a list of domain names separated by spaces: " domain_list
    for domain in $domain_list; do
        process_domain "$domain"
    done
else
    echo "Invalid choice. Please enter 'single' or 'list'."
fi
