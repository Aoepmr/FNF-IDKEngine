package funkin.backend.windows;

#if windows
@:headerCode('
#include <windows.h>
#include <hxcpp.h>
')

class MouseController {

    //Set mouse pos
    public static function setPosition(x:Int, y:Int):Void {
        untyped __cpp__("SetCursorPos(x, y)");
    }


}
#end


//Funny mouse controller