#!/bin/bash

# Function to install figlet if required
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
        echo "$(figlet -f slant 'Shrewdeye' | sed 's/^/ /')"
        echo -e "\e[1;32mTess approved! \U1F480 \e[0m\n"
        echo "Credit: Shrewdeye Tool - https://shrewdeye.app/"
        echo "--------------------------------------------------------"
    else
        install_figlet
        display_banner  # Call display_banner again after installation
    fi
}

process_domain() {
    timestamp=$(date +"%Y%m%d%H%M%S")  # Get current date and time in the format YYYYMMDDHHMMSS
    failed_domains_count=0

    for domain in "$@"; do
        api_url="https://shrewdeye.app/domains/${domain}.txt"
        response=$(curl -s "$api_url")

        if [ $? -eq 0 ]; then
            output_file="${domain}_${timestamp}_output.txt"
            echo "$response" > "$output_file"
            echo "Data for $domain saved to $output_file"
        else
            echo "Error: Unable to fetch data for $domain from the API. Please check the domain name and try again."
            failed_domains_count=$((failed_domains_count + 1))
            failed_domains_output="${domain}_failed_${timestamp}.txt"
            echo "$domain" >> "$failed_domains_output"
        fi
    done

    if [ "$failed_domains_count" -gt 1 ]; then
        echo "Multiple domains failed. List of failed domains saved to ${failed_domains_output}"
    fi
}

# Main Script
display_banner

# Check if there are no command-line arguments, and display help menu
if [ $# -eq 0 ]; then
    echo "Usage: shrewdeye.sh [OPTIONS]"
    echo "Options:"
    echo "  -d, --domain    Specify a single domain to process"
    echo "  -l, --list      Specify a list of space seperated domains to process"
    echo "  -f, --file      Specify a text file containing a list of domains to process"
    echo "  -h, --help      Show this help message and exit"
    exit 0
fi

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -d|--domain)
            domain_name="$2"
            process_domain "$domain_name"
            shift 2
            ;;
        -l|--list)
            shift
            # Combine space-separated arguments into a single string
            domain_list="$@"
            # Use a while loop to iterate over space-separated domains
            for domain in $domain_list; do
                # Check if the argument starts with '-' (indicating a new option)
                if [[ $domain == -* ]]; then
                    break
                fi
                process_domain "$domain"
                shift
            done
            ;;
        -f|--file)
            file_path="$2"
            if [ -f "$file_path" ]; then
                # Read domains from the file and process each one
                while IFS= read -r domain || [ -n "$domain" ]; do
                    process_domain "$domain"
                done < "$file_path"
            else
                echo "Error: File $file_path not found."
                exit 1
            fi
            shift 2
            ;;
        -h|--help)
            echo "Usage: shrewdeye.sh [OPTIONS]"
            echo "Options:"
            echo "  -d, --domain    Specify a single domain to process"
            echo "  -l, --list      Specify a space-separated list of domains to process"
            echo "  -f, --file      Specify a file containing a list of domains to process (One per line)"
            echo "  -h, --help      Show this help message and exit"
            exit 0
            ;;
        *)
            echo "Error: Invalid option: $key. Use -h for help."
            exit 1
            ;;
    esac
done

echo "Thanks for using shrewdeye-bash"
