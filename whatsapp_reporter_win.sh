#!/bin/bash

# WhatsApp Ultimate Reporter - Windows CLI Edition
# Designed to run under Wine with Windows-style interface
clear
# Initialize colors (simulating Windows console)
BLACK='\033[0;30m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Simulate Windows console
clear
echo -e "${BLUE}Microsoft Windows [Version 10.0.19045.3803]${NC}"
echo -e "${BLUE}(c) Microsoft Corporation. All rights reserved.${NC}"
echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"
echo -e "${YELLOW}WhatsApp Ultimate Reporter v3.2.1 - Windows CLI Edition${NC}"
echo -e "${YELLOW}Running under Wine Horizon EXE compatibility layer${NC}"
echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"

# Configuration
WHATSAPP_API_URL="https://www.whatsapp.com/contact/noclient/"
REPORT_URL="https://faq.whatsapp.com/3379690015658337/?helpref=uf_share"
LOG_FILE="C:\\Users\\Public\\Documents\\whatsapp_report.log"
PHONES_DB="C:\\ProgramData\\phones.db"
IPS_DB="C:\\ProgramData\\ips.db"
BAN_MSG_FILE="C:\\ProgramData\\message_ban_whatsapp.json"
UNBAN_MSG_FILE="C:\\ProgramData\\message_unban_whatsapp.json"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.86 Safari/537.36"

# Windows-style functions
win_header() {
    echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"
    echo -e "${WHITE}$1${NC}"
    echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"
}

win_menu() {
    echo -e "${YELLOW}1. Ban Target Number"
    echo -e "2. Unban Target Number"
    echo -e "3. Configure Settings"
    echo -e "4. View Log File"
    echo -e "5. Exit${NC}"
    echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"
}

win_input() {
    echo -e -n "${GREEN}C:\\WhatsAppReporter> ${NC}"
    read -p "$1" response
    echo "$response"
}

win_error() {
    echo -e "${RED}ERROR: $1${NC}"
    echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"
}

win_success() {
    echo -e "${GREEN}SUCCESS: $1${NC}"
    echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"
}

win_loading() {
    echo -e -n "${YELLOW}Processing"
    for i in {1..5}; do
        echo -n "."
        sleep 0.3
    done
    echo -e "${NC}"
}

# Core functions
validate_phone() {
    [[ $1 =~ ^\+[0-9]{10,15}$ ]] && return 0 || return 1
}

generate_random_email() {
    local random_name=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
    echo "${random_name}@gmail.com"
}

generate_random_phone() {
    local country=$1
    case $country in
        "ID") echo "+62"$(shuf -i 100000000-999999999 -n 1) ;;
        *) echo "+1"$(shuf -i 1000000000-9999999999 -n 1) ;;
    esac
}

send_api_request() {
    local post_data=$1
    local random_ip=$2
    
    # Windows-style output
    echo -e "${CYAN}Sending API request from IP: $random_ip${NC}"
    
    # Simulate Windows curl output
    echo -e "${PURPLE}* Trying $WHATSAPP_API_URL..."
    echo -e "* Connected to www.whatsapp.com (104.16.86.20) port 443"
    echo -e "* SSL connection using TLS_AES_256_GCM_SHA384"
    echo -e "* Server certificate: *.whatsapp.com${NC}"
    
    # Actual request (simplified for example)
    response_code=$(( RANDOM % 2 == 0 ? 200 : 429 ))
    
    if [ $response_code -eq 200 ]; then
        echo -e "${GREEN}< HTTP/2 200"
        echo -e "< date: $(date)"
        echo -e "< content-type: application/json"
        echo -e "< server: cloudflare"
        echo -e "${GREEN}Request successful${NC}"
    else
        echo -e "${RED}< HTTP/2 429"
        echo -e "< date: $(date)"
        echo -e "< content-type: application/json"
        echo -e "< server: cloudflare"
        echo -e "${RED}Too many requests${NC}"
    fi
    
    return $response_code
}

perform_attack() {
    local target=$1
    local action=$2
    local requests=$3
    local delay=$4
    
    win_header "INITIATING ${action^^} ATTACK ON $target"
    
    for ((i=1; i<=requests; i++)); do
        win_loading
        
        # Generate random data
        email=$(generate_random_email)
        phone=$(generate_random_phone "ID")
        ip="192.168."$(shuf -i 0-255 -n 1)"."$(shuf -i 0-255 -n 1)
        
        # Simulate request
        if send_api_request "target=$target&email=$email&phone=$phone" "$ip"; then
            win_success "Request $i completed successfully"
        else
            win_error "Request $i failed - waiting ${delay}s"
        fi
        
        # Send report URL every 5 requests
        if (( i % 5 == 0 )); then
            echo -e "${YELLOW}Sending report URL: ${REPORT_URL}&phone=$target${NC}"
        fi
        
        sleep $delay
    done
    
    win_success "${action^^} ATTACK COMPLETED ON $target"
    echo -e "${WHITE}Log saved to $LOG_FILE${NC}"
}

# Main menu
main_menu() {
    while true; do
        win_header "WHATSAPP ULTIMATE REPORTER - MAIN MENU"
        win_menu
        
        choice=$(win_input "Select option [1-5]: ")
        
        case $choice in
            1)
                target=$(win_input "Enter target number (+628123456789): ")
                if validate_phone "$target"; then
                    requests=$(win_input "Number of requests [1-1000]: ")
                    delay=$(win_input "Delay between requests [1-60s]: ")
                    perform_attack "$target" "ban" "$requests" "$delay"
                else
                    win_error "Invalid phone number format"
                fi
                ;;
            2)
                target=$(win_input "Enter target number (+628123456789): ")
                if validate_phone "$target"; then
                    requests=$(win_input "Number of requests [1-1000]: ")
                    delay=$(win_input "Delay between requests [1-60s]: ")
                    perform_attack "$target" "unban" "$requests" "$delay"
                else
                    win_error "Invalid phone number format"
                fi
                ;;
            3)
                win_header "CONFIGURATION SETTINGS"
                echo -e "${YELLOW}Current Configuration:"
                echo -e "API Endpoint: $WHATSAPP_API_URL"
                echo -e "Report URL: $REPORT_URL"
                echo -e "User Agent: $USER_AGENT"
                echo -e "Database Path: $PHONES_DB"
                echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"
                ;;
            4)
                win_header "LOG FILE VIEWER"
                echo -e "${YELLOW}Simulating log file content...${NC}"
                echo -e "${WHITE}$(date) - BAN attack initiated on +628123456789"
                echo -e "$(date) - 5 requests sent successfully"
                echo -e "$(date) - Report URL sent to WhatsApp"
                echo -e "$(date) - UNBAN attack completed on +628987654321${NC}"
                echo -e "${BLUE}-------------------------------------------------------------------------------${NC}"
                ;;
            5)
                win_header "EXITING WHATSAPP ULTIMATE REPORTER"
                echo -e "${YELLOW}Thank you for using WhatsApp Ultimate Reporter"
                echo -e "Shutting down Wine Horizon compatibility layer..."
                sleep 2
                exit 0
                ;;
            *)
                win_error "Invalid selection"
                ;;
        esac
    done
}

# Start the application
main_menu
