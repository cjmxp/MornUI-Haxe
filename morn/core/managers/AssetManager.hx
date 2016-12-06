package morn.core.managers;
import openfl.display.BitmapData;
class AssetManager {
    public function new() {
    }
    public function hasAsset(url:String):Bool{
        return false;
    }
    /**获取资源*/
    public function getAsset(name:String):Dynamic
    {
        return null;
    }
    /**获取位图数据*/
    public function getBitmapData(url:String):BitmapData
    {
        return null;
    }
    public function disposeBitmapData(url:String):Void
    {

    }

}
