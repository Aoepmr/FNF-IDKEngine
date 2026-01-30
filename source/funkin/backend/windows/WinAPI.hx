package funkin.backend.windows;


#if(cpp && windows)
import funkin.backend.windows.*;
import funkin.backend.windows.WindowThemeManager.WindowTheme;
#end

class WinAPI {
    #if(cpp && windows)
    public static function hideWindow(?title:String = ""):Void {
        WindowController.hide(title);
    }

    public static function showWindow(?title:String = ""):Void {
        WindowController.show(title);
    }

    public static function setWindowOnTop(?title:String = ""):Void {
        WindowController.setOnTop(title);
    }

    public static function unsetWindowOnTop(?title:String = ""):Void {
        WindowController.unsetOnTop(title);
    }

    public static function forceWindowFocus(?title:String = ""):Void {
        WindowController.forceFocus(title);
    }

    public static function setWindowTheme(theme:WindowTheme, ?title:String = ""):Void {
        WindowThemeManager.setTheme(theme, title);
    }

    public static function getSystemTheme():WindowTheme {
        return WindowThemeManager.getDefaultTheme();
    }

    public static function themeFromString(string:String):WindowTheme {
        return WindowTheme.fromString(string);
    }

    public static function sendWindowToDesktop(?title:String = ""):Void {
        //lime.app.Application.current.window.borderless = true;
        WindowController.fakeDesktop(title);
    }

    public static function setWindowLayered(?title:String = ""):Void {
        WindowController.setLayered(title);
    }

    public static function enableWindowBlur(?title:String = ""):Void {
        WindowController.enableBlurBehind(title);
    }
    #end
}
