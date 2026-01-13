package funkin.backend.windows;

import funkin.backend.windows.WindowTheme;

// W.I.P (bro actually everything here is W.I.P)

#if windows
@:headerCode('
#include <windows.h>
#include <hxcpp.h>
#include <dwmapi.h>
')
class WindowController
{
	public static function hide(?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0)
			return;

		untyped __cpp__('ShowWindow((HWND)(intptr_t){0}, SW_HIDE);', hwnd);
	}

	public static function show(?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0)
			return;

		untyped __cpp__('ShowWindow((HWND)(intptr_t){0}, SW_SHOW);', hwnd);
	}

	public static function setOnTop(?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0)
			return;

		untyped __cpp__('
			SetWindowPos(
				(HWND)(intptr_t){0},
				HWND_TOPMOST,
				0,0,0,0,
				SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW
			);
		', hwnd);
	}

	public static function unsetOnTop(?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0)
			return;

		untyped __cpp__('
			SetWindowPos(
				(HWND)(intptr_t){0},
				HWND_NOTOPMOST,
				0,0,0,0,
				SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW
			);
		', hwnd);
	}

	public static function forceFocus(?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0)
			return;

		untyped __cpp__('
			HWND target = (HWND)(intptr_t){0};
			HWND fg = GetForegroundWindow();

			DWORD t1 = GetWindowThreadProcessId(fg, NULL);
			DWORD t2 = GetCurrentThreadId();

			if (t1 != t2)
				AttachThreadInput(t1, t2, TRUE);

			SetForegroundWindow(target);
			SetFocus(target);
			SetActiveWindow(target);

			if (t1 != t2)
				AttachThreadInput(t1, t2, FALSE);
		', hwnd);
	}

	// Windows 11 only
	public static function setTheme(theme:WindowTheme, ?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0)
			return;

		untyped __cpp__('
			BOOL useDark = ({1} == 1);

			DwmSetWindowAttribute(
				(HWND)(intptr_t){0},
				20,
				&useDark,
				sizeof(useDark)
			);
		', hwnd, theme);
	}

	private static function getWindowHandle(?title:String = ""):Int
	{
		if (title == null || title == "")
			title = openfl.Lib.application.window.title;

		return
			untyped __cpp__('(intptr_t)(FindWindowW(NULL, (const wchar_t*){0}.wc_str()) != NULL ? FindWindowW(NULL, (const wchar_t*){0}.wc_str()) : GetForegroundWindow())',
			title);
	}
}
#end
