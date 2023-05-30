#include <windows.h>
#include <iostream>
using namespace std;

int main()
{
    //Hide Console
    HWND hWnd = GetConsoleWindow();
    ShowWindow(hWnd, SW_HIDE);

    //指定图片相对路径
    string relative_path = "wallpaper.jpg";

    //获取图片绝对路径
    char absolute_path[MAX_PATH];
    GetFullPathNameA(relative_path.c_str(), MAX_PATH, absolute_path, NULL);

    //更换壁纸
    SystemParametersInfo(SPI_SETDESKWALLPAPER, 0, (PVOID)absolute_path, SPIF_UPDATEINIFILE | SPIF_SENDCHANGE);

    return 0;
}
