@echo off
:: WhatsApp Ultimate Reporter - Windows Version
:: To be run with Wine on Ubuntu

:: Set colors (basic Windows color support)
echo.
echo  _    _ _   _ _   _ _____ ___  ______   __ _____ _____ _____ 
echo ^| ^|  ^| ^| ^| ^| ^| ^| \ ^| ^|_   _/ _ \^|  _ \ \ / /^|_   _^|  ___^|  ___^|
echo ^| ^|  ^| ^| ^| ^| ^| ^|  \^| ^| ^| ^|^| ^| ^| ^| ^| ^|_) \ V /   ^| ^| ^| ^|__ ^| ^|__   
echo ^| ^|/\^| ^| ^| ^| ^| ^|^\ ^| ^| ^|^| ^|^| ^|_^| ^|  _ ^< \ /    ^| ^| ^|  __^|^|  __^|
echo \  /\  / ^|_^| ^| ^| \ ^|_^| ^|_\___/^|_^| \_\^| ^|    ^|_^| ^| ^|___^| ^|___ 
echo  \/  \/ \___/^|_^|  \_\___/            ^|_^|        ^|_^|_____^|_____^|
echo.
echo WhatsApp Ultimate Reporter Pro - Windows Version
echo ===============================================
echo Created by ^>^>LORDHOZOO^<^< 
echo.

:: Configuration
set WHATSAPP_API_URL=https://www.whatsapp.com/contact/noclient/
set REPORT_URL=https://faq.whatsapp.com/3379690015658337/?helpref=uf_share
set LOG_FILE=whatsapp_ultimate.log
set PHONES_DB=phones.db
set IPS_DB=ips.db
set BAN_MSG_FILE=message_ban_whatsapp.json
set UNBAN_MSG_FILE=message_unban_whatsapp.json
set USER_AGENT=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.6778.86 Safari/537.36

:: WhatsApp parameters
set AJAXPIPE_TOKEN=AXjVMTl_Wz4hIrAtZA8
set COMPAT_IFRAME_TOKEN=AUUBoz_O3X_0Wosk3O9XO8rS_NY
set BRSID=7525697063073108760
set FB_LSD=AVpbkNjZYpw
set HSRP_REV=1024646339

:: Get target number
:get_number
echo Enter target phone number (e.g. +628123456789):
set /p target_number=
echo %target_number% | findstr /r "^+[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].*" >nul
if %errorlevel% neq 0 (
    echo Invalid format. Example: +628123456789
    goto get_number
)

:: Get action
:get_action
echo Action (ban/unban):
set /p action=
if not "%action%"=="ban" if not "%action%"=="unban" (
    echo Enter 'ban' or 'unban'
    goto get_action
)

:: Get request count
:get_requests
echo Number of requests (1-1000):
set /p num_requests=
echo %num_requests% | findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% neq 0 goto invalid_count
if %num_requests% lss 1 goto invalid_count
if %num_requests% gtr 1000 goto invalid_count
goto got_count

:invalid_count
echo Enter number 1-1000
goto get_requests

:got_count

:: Get delay
:get_delay
echo Delay between requests (seconds):
set /p delay=
echo %delay% | findstr /r "^[0-9][0-9]*$" >nul
if %errorlevel% neq 0 goto invalid_delay
if %delay% lss 1 goto invalid_delay
if %delay% gtr 60 goto invalid_delay
goto got_delay

:invalid_delay
echo Enter 1-60 seconds
goto get_delay

:got_delay

:: Confirm
echo.
echo Confirm attack on %target_number% - %num_requests% requests - %delay% seconds delay
echo Proceed? (y/n)
set /p confirm=
if /i not "%confirm%"=="y" exit /b 0

:: Execute attack
echo Starting attack...
call :perform_attack %num_requests% %delay% %target_number% %action%
echo Attack completed. Check %LOG_FILE% for details.
pause
exit /b 0

:: ==================== Functions ====================

:generate_random_email
setlocal
set chars=abcdefghijklmnopqrstuvwxyz0123456789
set email=
for /l %%i in (1,1,10) do (
    set /a rand=!random! %% 36
    for /f %%c in ('echo !chars:~%rand%,1!') do set email=!email!%%c
)
endlocal & set email=%email%@gmail.com
goto :eof

:generate_random_phone
setlocal
set country=%1
if "%country%"=="ID" (
    set /a first=1 + !random! %% 9
    set /a rest=!random! %% 100000000
    set phone=+62%first%%rest:~0,8%
) else if "%country%"=="EG" (
    set /a first=1 + !random! %% 9
    set /a rest=!random! %% 100000000
    set phone=+20%first%%rest:~0,8%
) else if "%country%"=="US" (
    set /a rest=!random! %% 1000000000
    set phone=+1%rest:~0,9%
) else (
    set /a rest=!random! %% 1000000000
    set phone=0%rest:~0,9%
)
endlocal & set phone=%phone%
goto :eof

:perform_attack
setlocal enabledelayedexpansion
set num_requests=%1
set delay=%2
set target_number=%3
set action=%4

:: Countries with emphasis on Indonesia (ID)
set countries=ID ID ID EG US KR CN IN
set platforms=ANDROID IPHONE WHATS_APP_WEB_DESKTOP KAIOS OTHER

for /l %%i in (1,1,%num_requests%) do (
    :: Get random values
    set /a rand_country=!random! %% 8
    for /f "tokens=%rand_country%" %%c in ("%countries%") do set country_selector=%%c
    
    call :generate_random_phone %country_selector%
    set phone_number=!phone!
    
    call :generate_random_email
    set email=!email!
    
    :: Prepare data with WhatsApp parameters
    set post_data=country_selector=!country_selector!^&email=!email!^&email_confirm=!email!^&phone_number=!phone_number!^&platform=ANDROID^&your_message=Report+!target_number!^&step=articles^&__user=0^&__a=!random!^&__req=0.5
    
    :: Send request (simplified for batch)
    echo Sending request %%i for !target_number!...
    timeout /t %delay% >nul
)
endlocal
goto :eof
