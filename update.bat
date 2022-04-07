@echo off
Ping www.google.com -n 1 -w 1000
if errorlevel 1 (goto no) else (goto yes)
:no
del A7WIFI.bat | powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('No internet connection', 'A7 WIFI', 'OK','Error');}"
exit
:yes
@For /F Tokens^=6^ Delims^=^" %%G In ('%SystemRoot%\System32\wbem\WMIC.exe
 /NameSpace:\\Root\StandardCimv2 Path MSFT_NetConnectionProfile Where
 "IPv4Connectivity='4' And Name Is Not Null" Get Name /Format:MOF 2^>NUL'
) do (
	set "ssid=%%~G"
	call :1 "%%ssid:~1%%"

)
exit
:1
for /f "tokens=2 delims=:" %%i in ('netsh wlan show profile name^="%ssid:"=%" key^=clear ^|findstr /C:"Key Content"') do (
	echo %%i|clip
	del A7WIFI.bat
	powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.MessageBox]::Show('SSID : %ssid%   |   Password : %%i', 'A7 WIFI  (Password saved in clipboard)', 'OK');}"
)
