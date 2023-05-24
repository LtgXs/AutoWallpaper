@echo off

:Dwn
certutil -urlcache -split -f https://api.dujin.org/bing/1920.php “%appdata%\AutoWallpaper\Wallpaper.jpg”


:Change
reg add "hkcu\control panel\desktop" /v wallpaper /d "%appdata%\AutoWallpaper\Wallpaper.jpg" /f
RunDll32.exe USER32.DLL,UpdatePerUserSystemParameters
