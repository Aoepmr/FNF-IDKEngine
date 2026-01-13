package funkin.backend.windows;

import funkin.backend.windows.*;

// Helper class for windows functions

#if windows
class WinAPI {

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

    public static function setMousePosition(x:Int, y:Int):Void {
        MouseController.setPosition(x, y);
    }

    public static function setWindowTheme(theme:WindowTheme, ?title:String = ""):Void {
        WindowController.setTheme(theme, title);
    }

}
#end