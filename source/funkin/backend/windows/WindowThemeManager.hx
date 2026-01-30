package funkin.backend.windows;

#if(cpp && windows)
@:headerCode('
#include <windows.h>
#include <hxcpp.h>
#include <dwmapi.h>
')
#end

class WindowThemeManager
{
	#if(cpp && windows)
	public static function setTheme(theme:WindowTheme, ?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0)
			return;

		untyped __cpp__('
		    BOOL isDark = ({1} == 1);
			HWND window = (HWND)(intptr_t){0};

			if (DwmSetWindowAttribute(window, 19, &isDark, sizeof(isDark)) != S_OK) {
    			DwmSetWindowAttribute(window, 20, &isDark, sizeof(isDark));
			}

	    ', hwnd, theme);
	}

	public static function getDefaultTheme():WindowTheme
	{
		var isDark:Bool = false;

		var regPath = "Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize";

		untyped __cpp__('
			DWORD value = 0;
			DWORD valueSize = sizeof(DWORD);
			HKEY hKey = nullptr;

			if (RegOpenKeyExW(HKEY_CURRENT_USER, (const wchar_t*){0}.wc_str(), 0, KEY_READ, &hKey) == ERROR_SUCCESS)
			{
				if (RegQueryValueExW(hKey, L"AppsUseLightTheme", nullptr, nullptr, (LPBYTE)&value, &valueSize) == ERROR_SUCCESS)
				{
					isDark = (value == 0);
				}

				RegCloseKey(hKey);
			}
		', regPath);

		return isDark ? WindowTheme.DARK : WindowTheme.LIGHT;
	}

    private static function getWindowHandle(?title:String = ""):Int
	{
		if (title == null || title == "")
			title = openfl.Lib.application.window.title;

		return
			untyped __cpp__('(intptr_t)(FindWindowW(NULL, (const wchar_t*){0}.wc_str()) != NULL ? FindWindowW(NULL, (const wchar_t*){0}.wc_str()) : GetActiveWindow())',
			title);
	}
	#end
}


enum abstract WindowTheme(Int)
{
	var LIGHT = 0;
	var DARK = 1;
}
