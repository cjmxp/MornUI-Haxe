package morn.core.utils;
class StringUtils {
    public function new() {
    }
    public static function fillArray(arr:Array<Int>,str:String):Array<Int>
    {
        var temp:Array<Int> = arr.concat([]);
        if(str!="" && str!=null){
            var a:Array<String> = str.split(",");
            var n:Int = Std.int(Math.min(temp.length, a.length));
            for (i in 0...n) {
                temp[i] = Std.parseInt(a[i]);
            }
        }
        return temp;
    }
}
