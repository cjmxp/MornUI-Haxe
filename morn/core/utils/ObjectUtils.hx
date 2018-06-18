package morn.core.utils;
import flash.display.BitmapData;
import openfl.display.Bitmap;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.filters.BitmapFilter;
import openfl.display.DisplayObject;
class ObjectUtils {
    public function new() {
    }
    /**让显示对象变成灰色*/
    public static function gray(traget:DisplayObject, isGray:Bool = true):Void {

    }
    /**获得实际文本*/
    private static var _tf:TextField = new TextField();
    public static function getTextField(format:TextFormat, text:String = "Test"):TextField {
        _tf.autoSize = "left";
        _tf.defaultTextFormat = format;
        _tf.text = text;
        return _tf;
    }
    /**添加滤镜*/
    public static function addFilter(target:DisplayObject, filter:BitmapFilter):Void {
        var filters:Array<BitmapFilter> = target.filters!=null? target.filters:[];
        filters.push(filter);
        target.filters = filters;
    }
    /**清除滤镜*/
    public static function clearFilter(target:DisplayObject, filterType:Dynamic):Void {
        var filters:Array<BitmapFilter> = target.filters;
        if (filters != null && filters.length > 0){
            var i:Int = filters.length - 1;
            while(i>=0) {
                var filter:Dynamic = filters[i];
                if (Std.is(filter,filterType)) {
                    filters.splice(i, 1);
                }
                i--;
            }
            target.filters = filters;
        }
    }
    /**创建位图*/
    public static function createBitmap(width:Int, height:Int, color:UInt = 0, alpha:Float = 1):Bitmap {
        var bitmap:Bitmap = new Bitmap(new BitmapData(1, 1, false, color));
        bitmap.alpha = alpha;
        bitmap.width = width;
        bitmap.height = height;
        return bitmap;
    }
}
