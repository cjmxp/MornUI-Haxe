package morn.core.managers;
import morn.core.utils.BitmapUtils;
import openfl.Assets;
import openfl.display.BitmapData;
class AssetManager {
    public function new() {
    }
    public function hasAsset(url:String):Bool{
        //#if flash

       // #else

        return Assets.exists(fmt(url));
       // #end
    }
    /**获取资源*/
    public function getAsset(name:String):Dynamic
    {
        return null;
    }
    /**获取位图数据*/
    public function getBitmapData(url:String, useCache:Bool = true):BitmapData
    {
       // #if flash

        //#else
        return Assets.getBitmapData(fmt(url),useCache);
       // #end

    }
    public function disposeBitmapData(url:String):Void
    {

    }
    /**获取切片资源*/
    public function getClips(url:String, xNum:Int, yNum:Int, cache:Bool = true, source:BitmapData = null):Array<BitmapData> {
        var clips:Array<BitmapData>=[];
        if(hasAsset(url)){
            if (source==null) {
                source=getBitmapData(url);
            }
            clips = BitmapUtils.createClips(source, xNum, yNum);
        }
        return clips;
    }
    private function fmt(url:String):String{
        var arr:Array<String>=url.split(".");
        var type:String="";
        if(arr.length>1){
            type = arr[0];
            arr = arr.slice(1);
        }
        return "assets/"+arr.join("/")+"."+type;
    }
}
