#include <windows.h>
#include <stdio.h>
#include <stdlib.h>

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR lpCmdLine, int nCmdShow) {
    // Create the batch script content
    const char* batchScript = R"(
@echo off
:: WhatsApp Ultimate Reporter - Windows Version
:: Content from above batch script here...
    )";
    
    // Write the batch script to a temporary file
    FILE* fp = fopen("whatsapp_reporter_temp.bat", "w");
    if (fp) {
        fputs(batchScript, fp);
        fclose(fp);
    }
    
    // Execute the batch script
    ShellExecute(NULL, "open", "cmd.exe", "/c whatsapp_reporter_temp.bat", NULL, SW_SHOW);
    
    return 0;
}
