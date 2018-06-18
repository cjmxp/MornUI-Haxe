package morn.core.components;
import morn.core.utils.StringUtils;
import morn.core.events.UIEvent;
import openfl.display.BitmapData;
import morn.core.handlers.Handler;
class Image extends Component {
    private var _bitmap:AutoBitmap = null;
    private var _url:String = null;
    private var _setBitmapData:Handler = null;
    public function new(url:String=null) {
        super();
        _url = url;
        _setBitmapData = new Handler(setBitmapData.bind(_,_));
    }
    private override  function createChildren():Void {
        _bitmap = new AutoBitmap();
        addChild(_bitmap);
    }
    /**图片地址，如果值为已加载资源，会马上显示，否则会先加载后显示，加载后图片会自动进行缓存
	* 举例：url="png.comp.bg" 或者 url="assets/img/face.png"*/
    public var url(get,set):String;
    private function get_url():String {
        return _url;
    }
    private function set_url(value:String):String {
        if (_url != value) {
            _url = value;
            if (value!="" && _url!=null) {
                if (App.asset.hasAsset(_url)) {
                    bitmapData = App.asset.getBitmapData(_url);
                } else {
                    App.loader.loadBMD(_url, 1, _setBitmapData);
                }
            } else {
                bitmapData = null;
            }
        }
        return value;
    }
    /**图片地址，等同于url*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _url;
    }
    private function set_skin(value:String):String {
        if(_url!=value && value!=null){
            url = value;
        }
        return value;
    }
    /**源位图数据*/
    public var bitmapData(get,set):BitmapData;
    private function get_bitmapData():BitmapData {
        return _bitmap.bitmapData;
    }
    private function set_bitmapData(value:BitmapData):BitmapData {
        if (value!=null) {
            _contentWidth = value.width;
            _contentHeight = value.height;
        }
        _bitmap.bitmapData = value;
        sendEvent(UIEvent.IMAGE_LOADED);
        return value;
    }
    private function setBitmapData(url:String, bmd:BitmapData):Void {
        if (url == _url) {
            bitmapData = bmd;
        }
    }
    #if flash
    @:setter(width)
    private override  function set_width(value:Float):Void {
        super.width = value;
        _bitmap.width = width;
    }
    @:setter(height)
    private override  function set_height(value:Float):Void {
        super.height = value;
        _bitmap.height = height;
    }
    #else
    private override function set_width(value:Float):Float {
        super.width = value;
        _bitmap.width = width;
        return value;
    }
    private override function set_height(value:Float):Float {
        super.height = value;
        _bitmap.height = height;
        return value;
    }
    #end
    /**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
    public var sizeGrid(get,set):String;
    private function get_sizeGrid():String {
        if (_bitmap.sizeGrid!=null) {
            return _bitmap.sizeGrid.join(",");
        }
        return null;
    }
    private function set_sizeGrid(value:String):String {
        _bitmap.sizeGrid = StringUtils.fillArray(App.defaultSizeGrid, value);
        return value;
    }
    /**位图控件实例*/
    public var bitmap(get,never):AutoBitmap;
    private function get_bitmap():AutoBitmap {
        return _bitmap;
    }
    /**是否对位图进行平滑处理*/
    public var smoothing(get,set):Bool;
    private function get_smoothing():Bool {
        return _bitmap.smoothing;
    }
    private function set_smoothing(value:Bool):Bool {
        _bitmap.smoothing = value;
        return value;
    }
    /**X锚点，值为0-1*/
    public var anchorX(get,set):Float;
    private function get_anchorX():Float {
        return _bitmap.anchorX;
    }

    private function set_anchorX(value:Float):Float {
        _bitmap.anchorX = value;
        return value;
    }

    /**Y锚点，值为0-1*/
    public var anchorY(get,set):Float;
    private function get_anchorY():Float {
        return _bitmap.anchorY;
    }
    private function set_anchorY(value:Float):Float {
        _bitmap.anchorY = value;
        return value;
    }
    private override function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if(Std.is(value,String)) {
            url = Std.string(value);
        } else {
            super.dataSource = value;
        }
        return value;
    }
    /**销毁资源，从位图缓存中销毁掉
	* @param	clearFromLoader 是否同时删除加载缓存*/
    public function destory(clearFromLoader:Bool = false):Void {
        App.asset.disposeBitmapData(_url);
        if (clearFromLoader) {
            App.loader.clearResLoaded(_url);
        }
        dispose();
    }

    /**销毁*/
    public override function dispose():Void {
        super.dispose();
        if(_bitmap!=null) _bitmap.dispose();
        _bitmap = null;
        _url="";
    }
}
