@echo off
set i=0
set name=%date:~0,4%.%date:~5,2%.%date:~8,2%
if not exist "%appdata%\AutoWallpaper" md "%appdata%\AutoWallpaper"
if not exist "%appdata%\AutoWallpaper\%name%" md "%appdata%\AutoWallpaper\%name%"
echo.>>"%appdata%\AutoWallpaper\%name%\%name%.log"
echo ********************Log Start********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
if exist "%appdata%\AutoWallpaper\%name%\%name%.jpg" goto Exit
ver | find "10.0." > NUL &&  goto DwnHMsg
goto DwnLMsg

:DwnHMsg
echo [%name%-%time:~0,2%:%time:~3,2%] System version is Win8.0 or higher use powershell to download >>"%appdata%\AutoWallpaper\%name%\%name%.log"
:DwnH
echo [%name%-%time:~0,2%:%time:~3,2%] Getting url from bing api >>"%appdata%\AutoWallpaper\%name%\%name%.log"
powershell (new-object System.Net.WebClient).DownloadFile('https://www.bing.com/HPImageArchive.aspx?n=1^&mkt=zh-CN','%appdata%\AutoWallpaper\%name%\api.xml')
powershell (new-object System.Net.WebClient).DownloadFile('https://www.bing.com/HPImageArchive.aspx?n=1^&mkt=zh-CN^&format=js^&idx=0','%appdata%\AutoWallpaper\%name%\api.json')
if exist "%appdata%\AutoWallpaper\%name%\api.xml" echo [%name%-%time:~0,2%:%time:~3,2%] Successful >>"%appdata%\AutoWallpaper\%name%\%name%.log"
set url=https://www.bing.com
set size=_UHD.jpg
set "link=" 
for /f "tokens=17 delims=<>" %%a in (
    'find /i "<images>" ^< "%appdata%\AutoWallpaper\%name%\api.xml"' 
) do set "link=%%a" 
echo %link%
set FullLink=%url%%link%%size%
echo [%name%-%time:~0,2%:%time:~3,2%] Download Link: %FullLink% >>"%appdata%\AutoWallpaper\%name%\%name%.log"
powershell (new-object System.Net.WebClient).DownloadFile('%FullLink%','%appdata%\AutoWallpaper\%name%\%name%.jpg')
if exist "%appdata%\AutoWallpaper\%name%\%name%.jpg" goto Change
echo [%name%-%time:~0,2%:%time:~3,2%] Download Failed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
set /a i=%i%+1
if %i% GEQ 10 goto BackupHMsg
timeout /t 3
echo [%name%-%time:~0,2%:%time:~3,2%] Try Download Again (%i%/10) >>"%appdata%\AutoWallpaper\%name%\%name%.log"
goto DwnH

:DwnLMsg
echo [%name%-%time:~0,2%:%time:~3,2%] System version is Win7.0 or lower use certutil to download (May stopped by antiMalware software)>>"%appdata%\AutoWallpaper\%name%\%name%.log"
:DwnL
echo [%name%-%time:~0,2%:%time:~3,2%] Getting url from bing api >>"%appdata%\AutoWallpaper\%name%\%name%.log"
certutil -urlcache -split -f https://www.bing.com/HPImageArchive.aspx?n=1^&mkt=zh-CN "%appdata%\AutoWallpaper\%name%\api.xml"
if exist "%appdata%\AutoWallpaper\%name%\api.xml" echo [%name%-%time:~0,2%:%time:~3,2%] Successful >>"%appdata%\AutoWallpaper\%name%\%name%.log"
set url=https://www.bing.com
set size=_UHD.jpg
set "link=" 
for /f "tokens=17 delims=<>" %%a in (
    'find /i "<images>" ^< "%appdata%\AutoWallpaper\%name%\api.xml"' 
) do set "link=%%a" 
echo %link%
set FullLink=%url%%link%%size%
echo [%name%-%time:~0,2%:%time:~3,2%] Download Link: %FullLink% >>"%appdata%\AutoWallpaper\%name%\%name%.log"
certutil -urlcache -split -f %FullLink% "%appdata%\AutoWallpaper\%name%\%name%.jpg"
if exist "%appdata%\AutoWallpaper\%name%\%name%.jpg" goto Change
echo [%name%-%time:~0,2%:%time:~3,2%] Download Failed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
set /a i=%i%+1
if %i% GEQ 10 goto BackupHMsg
timeout /t 3
echo [%name%-%time:~0,2%:%time:~3,2%] Try Download Again (%i%/10) >>"%appdata%\AutoWallpaper\%name%\%name%.log"
goto DwnL

:BackupHMsg
echo [%name%-%time:~0,2%:%time:~3,2%] Try Download From Another API >>"%appdata%\AutoWallpaper\%name%\%name%.log"
:BackupH
set i=0
powershell (new-object System.Net.WebClient).DownloadFile('https://api.dujin.org/bing/1920.php','%appdata%\AutoWallpaper\%name%\%name%.jpg')
if exist "%appdata%\AutoWallpaper\%name%\%name%.jpg" goto Change
echo [%name%-%time:~0,2%:%time:~3,2%] Download Failed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
set /a i=%i%+1
if %i% GEQ 10 goto Failed
timeout /t 3
echo [%name%-%time:~0,2%:%time:~3,2%] Try Download Again (%i%/10) >>"%appdata%\AutoWallpaper\%name%\%name%.log"
goto BackupH

:BackupLMsg
echo [%name%-%time:~0,2%:%time:~3,2%] Try Download From Another API >>"%appdata%\AutoWallpaper\%name%\%name%.log"
:BackupL
set i=0
certutil -urlcache -split -f https://api.dujin.org/bing/1920.php "%appdata%\AutoWallpaper\%name%\%name%.jpg"
if exist "%appdata%\AutoWallpaper\%name%\%name%.jpg" goto Change
echo [%name%-%time:~0,2%:%time:~3,2%] Download Failed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
set /a i=%i%+1
if %i% GEQ 10 goto Failed
timeout /t 3
echo [%name%-%time:~0,2%:%time:~3,2%] Try Download Again (%i%/10) >>"%appdata%\AutoWallpaper\%name%\%name%.log"
goto BackupL

:Failed
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
exit

:Change
copy Change.exe "%appdata%\AutoWallpaper"
echo [%name%-%time:~0,2%:%time:~3,2%] Download Completed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
del "%userprofile%\desktop\wallpaper.jpg"
del "%appdata%\AutoWallpaper\wallpaper.jpg"
copy "%appdata%\AutoWallpaper\%name%\%name%.jpg" "%userprofile%\desktop"
ren "%userprofile%\desktop\%name%.jpg" "wallpaper.jpg"
copy "%userprofile%\desktop\wallpaper.jpg" "%appdata%\AutoWallpaper"
cd "%appdata%\AutoWallpaper"
Change.exe
RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters
echo [%name%-%time:~0,2%:%time:~3,2%] Change Wallpaper Completed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
exit

:Ext
echo [%name%-%time:~0,2%:%time:~3,2%] Today's wallpaper already existed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
