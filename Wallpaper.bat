@echo off
set name=%date:~0,4%.%date:~5,2%.%date:~8,2%
if not exist "%appdata%\AutoWallpaper" md "%appdata%\AutoWallpaper"
if not exist "%appdata%\AutoWallpaper\%name%" md "%appdata%\AutoWallpaper\%name%"
echo.>>"%appdata%\AutoWallpaper\%name%\%name%.log"
echo ********************Log Start********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
if exist "%appdata%\AutoWallpaper\%name%\%name%.jpg" goto Ext

:Dwn
certutil -urlcache -split -f https://api.dujin.org/bing/1920.php "%appdata%\AutoWallpaper\%name%\%name%.jpg"
if exist "%appdata%\AutoWallpaper\%name%\%name%.jpg" goto Change
echo [%name%-%time:~0,2%:%time:~3,2%] Download Failed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
exit

:Change
echo [%name%-%time:~0,2%:%time:~3,2%] Download Completed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
reg add "hkcu\control panel\desktop" /v wallpaper /d "%appdata%\AutoWallpaper\%name%\%name%.jpg" /f
RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters
echo [%name%-%time:~0,2%:%time:~3,2%] Change Wallpaper Completed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
exit

:Ext
echo [%name%-%time:~0,2%:%time:~3,2%] Today's wallpaper already existed >>"%appdata%\AutoWallpaper\%name%\%name%.log"
echo *********************Log End*********************>>"%appdata%\AutoWallpaper\%name%\%name%.log"
