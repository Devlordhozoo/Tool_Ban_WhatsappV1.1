sudo apt update
clear
sudo apt install wine 
clear
sudo apt install wine mingw-w64
clear
x86_64-w64-mingw32-g++ whatsapp_reporter.cpp -o whatsapp_reporter.exe -mwindows -lshlwapi 
echo " wine whatsapp_reporter.exe"
