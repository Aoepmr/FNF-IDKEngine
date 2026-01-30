package funkin.backend.windows;

// W.I.P (bro actually everything here is W.I.P)

#if(cpp && windows)
@:headerCode('
#include <windows.h>
#include <hxcpp.h>
#include <dwmapi.h>
')
#end

class WindowController
{
	#if(cpp && windows)
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



	public static function enableBlurBehind(?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0) return;

		untyped __cpp__('
			HWND target = (HWND)(intptr_t){0};

			DWM_BLURBEHIND bb;
			ZeroMemory(&bb, sizeof(bb));

			bb.dwFlags = DWM_BB_ENABLE;
			bb.fEnable = TRUE;
			bb.hRgnBlur = NULL;

			DwmEnableBlurBehindWindow(target, &bb);
		', hwnd);
	}

	public static function setLayered(?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0) return;

		untyped __cpp__('
			HWND target = (HWND)(intptr_t){0};

			LONG_PTR ex = GetWindowLongPtrW(target, GWL_EXSTYLE);
			ex |= WS_EX_LAYERED;
			SetWindowLongPtrW(target, GWL_EXSTYLE, ex);
		', hwnd);
	}



	public static function fakeDesktop(?title:String = ""):Void
	{
		var hwnd = getWindowHandle(title);
		if (hwnd == 0) return;

		untyped __cpp__('
			HWND target = (HWND)(intptr_t){0};

			LONG_PTR style = GetWindowLongPtrW(target, GWL_STYLE);
			style &= ~(WS_CAPTION | WS_THICKFRAME | WS_SYSMENU);
			style |= WS_POPUP | WS_VISIBLE;
			SetWindowLongPtrW(target, GWL_STYLE, style);

			LONG_PTR ex = GetWindowLongPtrW(target, GWL_EXSTYLE);
			ex |= WS_EX_TOOLWINDOW | WS_EX_LAYERED | WS_EX_TRANSPARENT;
			SetWindowLongPtrW(target, GWL_EXSTYLE, ex);

			SetWindowPos(
				target,
				HWND_BOTTOM,
				0, 0, 0, 0,
				SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW | SWP_NOACTIVATE
			);

			ShowWindow(target, SW_SHOW);
		', hwnd);
	}

	// TO DO: Wind a better
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

