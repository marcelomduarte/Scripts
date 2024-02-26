::===============================================================
:: Script: winget_desinstalar_progs_dispensaveis.bat
:: Finalidade: script para desinstalação de programas dispensáveis
:: Autor: Baboo
:: Site: www.baboo.com.br
::===============================================================

winget uninstall "Piriform.CCleaner"
ping -n 20 127.0.0.1>nul
winget uninstall "iTop VPN_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "iTop.iTopScreenRecorder"
ping -n 5 127.0.0.1>nul
winget uninstall "DualSafe Password Manager_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "IObit.DriverBooster"
ping -n 5 127.0.0.1>nul
winget uninstall "IObit.AdvancedSystemCare"
ping -n 5 127.0.0.1>nul
winget uninstall "IObitUninstall"
ping -n 5 127.0.0.1>nul
winget uninstall "IObit Malware Fighter_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "IObit Software Updater_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "Smart Defrag_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "iTop.iTopDataRecovery"
ping -n 5 127.0.0.1>nul
winget uninstall "iTop PDF_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "iTop Easy Desktop_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "AVG TuneUp"
ping -20 5 127.0.0.1>nul
winget uninstall {4209F371-8668-980C-19C9-F8698AB75135}_is1
ping -n 5 127.0.0.1>nul
winget uninstall {4209F371-AD80-9E5D-7FD6-99DC6D5D8B7F}_is1
ping -n 5 127.0.0.1>nul
winget uninstall {4209F371-CB4A-DB54-FD54-9F662DEF845D}_is1
ping -n 5 127.0.0.1>nul
winget uninstall "Glarysoft.GlaryUtilities"
ping -n 20 127.0.0.1>nul
winget uninstall "Glarysoft.FileRecoveryFree"
ping -n 20 127.0.0.1>nul
winget uninstall "Malware Hunter"
ping -n 20 127.0.0.1>nul
winget uninstall "Software Update"
ping -n 5 127.0.0.1>nul
winget uninstall "WiseCleaner.WiseDiskCleaner"
ping -n 5 127.0.0.1>nul
winget uninstall "WiseCleaner.WiseGameBooster"
ping -n 5 127.0.0.1>nul
winget uninstall "WiseCleaner.WiseMemoryOptimizer"
ping -n 5 127.0.0.1>nul
winget uninstall "WiseCleaner.WiseProgramUninstaller"
ping -n 5 127.0.0.1>nul
winget uninstall "WiseCleaner.WiseRegistryCleaner"
ping -n 5 127.0.0.1>nul
winget uninstall "Wise System Monitor_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "RARLab.WinRAR"
ping -n 5 127.0.0.1>nul
winget uninstall "winget uninstall "Foxit.FoxitReader"
ping -n 30 127.0.0.1>nul
winget uninstall {D43B360E-722D-421B-BC77-20B9E0F8B6CD}_is1
ping -n 20 127.0.0.1>nul
winget uninstall "Adobe.Acrobat.Reader.32-bit"
ping -n 60 127.0.0.1>nul
winget uninstall "cmpc"
ping -n 10 127.0.0.1>nul
winget uninstall "Wise PC 1stAid_is1"
ping -n 5 127.0.0.1>nul
winget uninstall "Razer Cortex_is1"
ping -n 20 127.0.0.1>nul
winget uninstall "Auslogics.DiskDefrag"
ping -n 10 127.0.0.1>nul
winget uninstall {D627784F-B3EE-44E8-96B1-9509B991EA34}_is1
ping -n 10 127.0.0.1>nul
winget uninstall {8D8024F1-2945-49A5-9B78-5AB7B11D7942}_is1
ping -n 10 127.0.0.1>nul
winget uninstall {7216871F-869E-437C-B9BF-2A13F2DCE63F}_is1
ping -n 10 127.0.0.1>nul
winget uninstall  {23BB1B18-3537-48F7-BEF7-42BC65DBF993}_is1
ping -n 10 127.0.0.1>nul

SAFE MODE

REG DELETE "HKEY_CURRENT_USER\SOFTWARE\AvastAdSDK" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\iTop Screen Recorder" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\IObit" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\iTop Screen Recorder" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\iTop VPN" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\AscFileFilter" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Services\AscRegistryFilter" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AscFileFilter" /f
REG DELETE "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\AscRegistryFilter" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Ashampoo" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\WiseCleaner" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\iTop PDF" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Foxit Software" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Glarysoft" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\iTop Easy Desktop" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\WinRAR SFX" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\BSD" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\cmpc" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\Razer" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\Razer" /f
REG DELETE "HKEY_CURRENT_USER\SOFTWARE\VB and VBA Program Settings\YouTubeCatcher" /f
REG DELETE "HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432NODE\WISECLEANER" /f

rmdir /s /q "C:\Program Files (x86)\Ashampoo"
rmdir /s /q "C:\Program Files (x86)\Auslogics"
rmdir /s /q "C:\Program Files (x86)\IObit"
rmdir /s /q "C:\Program Files (x86)\iTop PDF\Launcher.exe"
rmdir /s /q "C:\Program Files (x86)\iTop Data Recovery\"
rmdir /s /q "C:\Program Files (x86)\iTop Easy Desktop\"
rmdir /s /q "C:\Program Files (x86)\iTop Screen Recorder\"
rmdir /s /q "C:\Program Files (x86)\Glary Utilities 5\"
rmdir /s /q "C:\Program Files (x86)\Glarysoft\"
rmdir /s /q "C:\Program Files (x86)\Wise"
rmdir /s /q "C:\Program Files\WinRAR"
rmdir /s /q "C:\Program Files (x86)\Razer"
rmdir /s /q "C:\Program Files (x86)\cmcm"
rmdir /q /s C:\Users\%USERNAME%\AppData\Local\Ashampoo
rmdir /q /s C:\Users\%USERNAME%\AppData\Local\Razer
rmdir /q /s C:\Users\%USERNAME%\AppData\Local\AWSToolkit
rmdir /q /s C:\Users\%USERNAME%\AppData\Local\ToastNotificationManagerCompat
rmdir /q /s "C:\Users\%USERNAME%\AppData\Local\DualSafe Password Manager"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Local\iTop Easy Desktop"
rmdir /q /s C:\Users\%USERNAME%\AppData\LocalLow\IOBit
rmdir /q /s "C:\Users\%USERNAME%\AppData\LocalLow\iTop Easy Desktop"
rmdir /q /s "C:\Users\%USERNAME%\AppData\LocalLow\iTop Screen Recorder"
rmdir /q /s C:\Users\%USERNAME%\AppData\Roaming\IOBit
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\iTop Data Recovery"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\iTop PDF"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\iTop Screen Recorder"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\DiskDefrag"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\GlarySoft"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\Foxit AgentInformation"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\Foxit Software"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\WinRAR"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\kingsoft"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Roaming\Wise Euask"
rmdir /q /s "C:\Program Files (x86)\Adobe\Acrobat Reader DC"
rmdir /q /s "C:\Users\%USERNAME%\AppData\Local\Temp"
rmdir /q /s "C:\Windows\Temp"
rmdir /q /s %systemdrive%\$recycle.bin

exit