@echo off

:prep
::Read Config
    ::Specify to return the picture from the last n days, where n is a non-negative integer (0 for today, and so on)
for /f "tokens=1 delims=<>" %%a in (
    'find /i "idx" ^< "%~dp0config.ini"' 
) do set "idx=%%a"
    ::Bing daily picture time zone
for /f "tokens=1 delims=<>" %%a in (
    'find /i "mkt" ^< "%~dp0config.ini"' 
) do set "mkt=%%a"
    ::Check if today's picture already exist or not
for /f "tokens=1 delims=<>" %%a in (
    'find /i "chk" ^< "%~dp0config.ini"' 
) do set "chk=%%a"
    ::Copy to desktop or not
for /f "tokens=1 delims=<>" %%a in (
    'find /i "ctd" ^< "%~dp0config.ini"' 
) do set "ctd=%%a"
    ::Enable watermark or not
for /f "tokens=1 delims=<>" %%a in (
    'find /i "wtm" ^< "%~dp0config.ini"' 
) do set "wtm=%%a"
    ::Watermark path(suggest to use .png)
for /f "tokens=2 delims=<>" %%a in (
    'find /i "wmp" ^< "%~dp0config.ini"' 
) do set "wmp=%%a"
    ::Watermark POS
for /f "tokens=2 delims=<>" %%a in (
    'find /i "wPosX" ^< "%~dp0config.ini"' 
) do set "wPosX=%%a"
for /f "tokens=2 delims=<>" %%a in (
    'find /i "wPosY" ^< "%~dp0config.ini"' 
) do set "wPosY=%%a"

::check config
if "%idx%"=="" set idx=idx=0
if "%mkt%"=="" set mkt=mkt=zh-CN
if "%chk%"=="" set chk=chk=true
if "%ctd%"=="" set ctd=ctd=true
if "%wtm%"=="" set wtm=wtm=true
if "%wmp%"=="" set wmp=%appdata%\watermark.png
if "%wPosY%"=="" set wPosY=wPosY=1.2
if "%wPosX%"=="" set wPosX=wPosX=2
set wmp=%wmp:~4%
set wPosX=%wPosX:~6%
set wPosY=%wPosY:~6%
if not "%wtm%"=="wtm=true" set wtm=wtm=false

::check system ver
ver | find "5.1." > NUL && set IsWin10=0
ver | find "6.1." > NUL && set IsWin10=0
ver | find "5.2." > NUL && set IsWin10=0
ver | find "6.2." > NUL && set IsWin10=1
ver | find "6.3." > NUL && set IsWin10=1
ver | find "10.0." >NUL && set IsWin10=1
::set
set name=%date:~0,4%.%date:~5,2%.%date:~8,2%
set BingApi=https://www.bing.com/HPImageArchive.aspx?n=1
set w10=echo %IsWin10%^|find "1" ^>NUL ^&^&
set w7=echo %IsWin10%^|find "0" ^>NUL ^&^&
set folder="%appdata%\AutoWallpaper"
set dfolder=%appdata%\AutoWallpaper\%name%
set i=0



:Main
::create work folder
if not exist %folder% md %folder%
::create daily picture folder
if not exist %dfolder% md %dfolder%
echo.>>"%dfolder%\%name%.log"
echo ********************Log Start********************>>"%dfolder%\%name%.log"
echo [%name%-%time:~0,2%:%time:~3,2%] Config value: %idx% %mkt% %chk% %ctd% %wtm% wmp=%wmp%>>"%dfolder%\%name%.log"
::Options "Check if the picture has been already or not"
echo %chk%|find "false" >NUL && goto DwnMsg
if exist "%dfolder%\%name%.jpg" goto Ext

:DwnMsg
%w10% echo [%name%-%time:~0,2%:%time:~3,2%] System version is Win8.0 or higher use powershell to download >>"%dfolder%\%name%.log"
%w7% echo [%name%-%time:~0,2%:%time:~3,2%] System version is Win7.0 or lower use certutil to download (May stopped by antiMalware software)>>"%dfolder%\%name%.log"

:DwnApi
echo [%name%-%time:~0,2%:%time:~3,2%] Getting url from bing api >>"%dfolder%\%name%.log"
::win10 powershell
%w10% powershell (new-object System.Net.WebClient).DownloadFile('%BingApi%^&%mkt%^&%idx%','%dfolder%\api.xml')
%w10% powershell (new-object System.Net.WebClient).DownloadFile('%BingApi%^&%mkt%^&format=js^&%idx%','%dfolder%\api.json')
::win7 certutil
%w7% certutil -urlcache -split -f %BingApi%^&%mkt%^&%idx% "%dfolder%\api.xml"
%w7% certutil -urlcache -split -f %BingApi%^&%mkt%^&format=js^&%idx% "%dfolder%\api.json"
::check download successful or not
if exist "%dfolder%\api.xml" echo [%name%-%time:~0,2%:%time:~3,2%] Successful >>"%dfolder%\%name%.log"
if exist "%dfolder%\api.xml" goto Dwn
::if not successful try again for 10 times
if not exist "%dfolder%\api.xml" echo [%name%-%time:~0,2%:%time:~3,2%] Failed to get download link from bing api >>"%dfolder%\%name%.log"
set /a a=%a%+1
if %a% GEQ 10 goto Failed
timeout /t 3
echo [%name%-%time:~0,2%:%time:~3,2%] Try Download Again (%a%/10) >>"%dfolder%\%name%.log"
goto DwnAPI

:Dwn
::Gather download link
set url=https://www.bing.com
set size=_UHD.jpg
set "link=" 
    ::Read link from api.xml
for /f "tokens=17 delims=<>" %%a in (
    'find /i "<images>" ^< "%dfolder%\api.xml"' 
) do set "link=%%a"
echo %link%
    ::Output the full link
set FullLink=%url%%link%%size%
echo [%name%-%time:~0,2%:%time:~3,2%] Download Link: %FullLink% >>"%dfolder%\%name%.log"
::Download picture from gathered link
%w10% powershell (new-object System.Net.WebClient).DownloadFile('%FullLink%','%dfolder%\%name%.jpg')
%w7% certutil -urlcache -split -f %FullLink% "%dfolder%\%name%.jpg"
::check download successful or not
if exist "%dfolder%\%name%.jpg" goto Change
::if not successful try again for 10 times
echo [%name%-%time:~0,2%:%time:~3,2%] Download Failed >>"%dfolder%\%name%.log"
set /a i=%i%+1
if %i% GEQ 10 goto Failed
timeout /t 3
echo [%name%-%time:~0,2%:%time:~3,2%] Try Download Again (%i%/10) >>"%dfolder%\%name%.log"
goto Dwn

:Change
::Use Change.vbs
%w7% copy /Y "%appdata%\Change.vbs" %folder%
::Use Change.exe
%w10% copy /Y "%appdata%\Change.exe" %folder%
echo [%name%-%time:~0,2%:%time:~3,2%] Download Completed >>"%dfolder%\%name%.log"
del "%userprofile%\desktop\wallpaper.jpg"
del "%appdata%\AutoWallpaper\wallpaper.jpg"

::add watermark
echo %wtm%|find "true" && cd "%appdata%\AutoWallpaper\main" && ffmpeg -i "%dfolder%\%name%.jpg" -i "%wmp%" -filter_complex "overlay=(main_w-overlay_w)/%wPosX%:(main_h-overlay_h)/%wPosY%" -q:v 0 "%appdata%\AutoWallpaper\wallpaper.jpg" & if not exist "%appdata%\AutoWallpaper\wallpaper.jpg" ffmpeg -i "%dfolder%\%name%.jpg" -i "%appdata%\watermark.png" -filter_complex "overlay=(main_w-overlay_w)/%wPosX%:(main_h-overlay_h)/%wPosY%" -q:v 0 "%appdata%\AutoWallpaper\wallpaper.jpg"
::none watermark
echo %wtm%|find "false" && copy "%dfolder%\%name%.jpg" "%appdata%\AutoWallpaper"
echo %wtm%|find "false" && ren "%appdata%\AutoWallpaper\%name%.jpg" "wallpaper.jpg"
::Copy to desktop or not
echo %ctd%|find "true" && copy "%appdata%\AutoWallpaper\wallpaper.jpg" "%userprofile%\desktop"


cd %folder%
%w7% Change.vbs
%w10% Change.exe
RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters
echo [%name%-%time:~0,2%:%time:~3,2%] Change Wallpaper Completed >>"%dfolder%\%name%.log"
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
exit

:Ext
echo [%name%-%time:~0,2%:%time:~3,2%] Today's wallpaper already existed >>"%dfolder%\%name%.log"
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
exit

:Failed
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
exit
