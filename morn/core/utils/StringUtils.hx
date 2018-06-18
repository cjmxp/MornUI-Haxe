package morn.core.utils;
import openfl.geom.Rectangle;
class StringUtils {
    public function new() {
    }
    public static function fillArray(arr:Dynamic,str:String):Dynamic
    {
        var temp:Dynamic = arr.concat([]);
        if(str!="" && str!=null){
            var a:Array<String> = str.split(",");
            var n:Int = Std.int(Math.min(temp.length, a.length));
            for (i in 0...n) {
                if (Std.is(temp[i],Int)){
                    temp[i] = Std.parseInt(a[i]);
                }else if (Std.is(temp[i],Float)){
                    temp[i] = Std.parseFloat(a[i]);
                }
            }
        }
        return temp;
    }
    /**转换Rectangle为逗号间隔的字符串*/
    public static function rectToString(rect:Rectangle):String {
        if (rect!=null) {
            return rect.x + "," + rect.y + "," + rect.width + "," + rect.height;
        }
        return null;
    }
}
