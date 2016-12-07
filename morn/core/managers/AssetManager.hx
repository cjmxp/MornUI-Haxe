package morn.core.managers;
import openfl.Assets;
import openfl.display.BitmapData;
class AssetManager {
    public function new() {
    }
    public function hasAsset(url:String):Bool{
        //#if flash

       // #else

        return Assets.exists(url);
       // #end
    }
    /**获取资源*/
    public function getAsset(name:String):Dynamic
    {
        return null;
    }
    /**获取位图数据*/
    public function getBitmapData(url:String):BitmapData
    {
       // #if flash

        //#else
        return Assets.getBitmapData(url);
       // #end

    }
    public function disposeBitmapData(url:String):Void
    {

    }
}
