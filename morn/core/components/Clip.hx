package morn.core.components;
import morn.core.events.UIEvent;
import morn.core.utils.StringUtils;
import openfl.display.BitmapData;
import openfl.events.Event;
import morn.core.handlers.Handler;
class Clip extends Component {
    private var _autoStopAtRemoved:Bool = true;
    private var _bitmap:AutoBitmap = null;
    private var _clipX:Int = 1;
    private var _clipY:Int = 1;
    private var _clipWidth:Float = Math.NaN;
    private var _clipHeight:Float = Math.NaN;
    private var _url:String = null;
    private var _autoPlay:Bool = false;
    private var _interval:Int = App.MOVIE_INTERVAL;
    private var _from:Int = -1;
    private var _to:Int = -1;
    private var _complete:Handler = null;
    private var _isPlaying:Bool = null;
    private var _changeClip:Handler = null;
    private var _loop:Handler = null;
    public function new(url:String = null, clipX:Int = 1, clipY:Int = 1) {
        super();
        _clipX = clipX;
        _clipY = clipY;
        this._changeClip = new Handler(changeClip.bind());
        this._loop = new Handler(loop.bind());
        this.url = url;
    }
    private override function createChildren():Void {
        _bitmap = new AutoBitmap();
        addChild(_bitmap);
    }
    private override function initialize():Void {
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
    }
    private function onAddedToStage(e:Event):Void {
        if (_autoPlay) {
            play();
        }
    }
    private function onRemovedFromStage(e:Event):Void {
        if (_autoStopAtRemoved) {
            stop();
        }
    }
    /**位图剪辑地址，如果值为已加载资源，会马上显示，否则会先加载后显示
	* 举例：url="png.comp.clip" 或者 url="assets/img/clip.png"*/
    public var url(get,set):String;
    private function get_url():String {
        return _url;
    }
    private function set_url(value:String):String {
        if (_url != value && value!=null) {
            _url = value;
            callLater(_changeClip);
        }
        return value;
    }
    /**图片地址，等同于url*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _url;
    }
    private function set_skin(value:String):String {
        url = value;
        return value;
    }
    /**切片X轴数量*/
    public var clipX(get,set):Int;
    private function get_clipX():Int {
        return _clipX;
    }
    private function set_clipX(value:Int):Int {
        if (_clipX != value) {
            _clipX = value;
            callLater(_changeClip);
        }
        return value;
    }
    /**切片Y轴数量*/
    public var clipY(get,set):Int;
    private function get_clipY():Int {
        return _clipY;
    }
    private function set_clipY(value:Int):Int {
        if (_clipY != value) {
            _clipY = value;
            callLater(_changeClip);
        }
        return value;
    }
    /**单切片宽度，同时设置优先级高于clipX*/
    public var clipWidth(get,set):Float;
    private function get_clipWidth():Float {
        return _clipWidth;
    }
    private function set_clipWidth(value:Float):Float {
        _clipWidth = value;
        callLater(_changeClip);
        return _clipWidth;
    }
    /**单切片高度，同时设置优先级高于clipY*/
    public var clipHeight(get,set):Float;
    private function get_clipHeight():Float {
        return _clipHeight;
    }
    private function set_clipHeight(value:Float):Float {
        _clipHeight = value;
        callLater(_changeClip);
        return value;
    }
    private function changeClip():Void {
        if (App.asset.hasAsset(_url)) {
            loadComplete(_url, false, App.asset.getBitmapData(_url, false));
        } else {
            App.loader.loadBMD(_url, 1, new Handler(loadComplete.bind(_url, true,_)));
        }
    }
    private function loadComplete(url:String, isLoad:Bool, bmd:BitmapData):Void {
        if (url == _url && bmd !=null) {
            if (!Math.isNaN(_clipWidth)) {
                _clipX = Math.ceil(bmd.width / _clipWidth);
            }
            if (!Math.isNaN(_clipHeight)) {
                _clipY = Math.ceil(bmd.height / _clipHeight);
            }
            clips = App.asset.getClips(url, _clipX, _clipY, true, isLoad ? bmd.clone() : bmd);
        }
    }
    /**源位图数据*/
    public var clips(get,set):Array<BitmapData>;
    private function get_clips():Array<BitmapData> {
        return _bitmap.clips;
    }
    private function set_clips(value:Array<BitmapData>):Array<BitmapData> {
        if (value !=null) {
            _bitmap.clips = value;
            _contentWidth = _bitmap.width;
            _contentHeight = _bitmap.height;
        }
        sendEvent(UIEvent.IMAGE_LOADED);
        return value;
    }
    #if flash
    @:setter(width)
    private override function set_width(value:Float):Void {
        super.width = value;
        _bitmap.width = value;
    }
    @:setter(height)
    private override function set_height(value:Float):Void {
        super.height = value;
        _bitmap.height = value;
    }
    #else
    private override function set_width(value:Float):Float {
        super.width = value;
        _bitmap.width = value;
        return value;
    }
    public override function set_height(value:Float):Float {
        super.height = value;
        _bitmap.height = value;
        return value;
    }
    #end

    private override function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Int) || Std.is(value,String)) {
            frame = Std.parseInt(Std.string(value));
        } else {
            super.dataSource = value;
        }
        return value;
    }

    public override function commitMeasure():Void {
        exeCallLater(_changeClip);
    }
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
    /**当前帧*/
    public var frame(get,set):Int;
    private function get_frame():Int {
        return _bitmap.index;
    }
    private function set_frame(value:Int):Int {
        _bitmap.index = value;
        sendEvent(UIEvent.FRAME_CHANGED);
        if(_bitmap.index == _to){
            stop();
            _to = -1;
            if (_complete != null) {
                var handler:Handler = _complete;
                _complete = null;
                handler.Function();
            }
        }
        return value;
    }
    /**当前帧，等同于frame*/
    public var index(get,set):Int;
    private function get_index():Int {
        return _bitmap.index;
    }
    private function set_index(value:Int):Int {
        frame = value;
        return value;
    }
    /**切片帧的总数*/
    @:getter(totalFrame)
    private function get_totalFrame():Int {
        exeCallLater(_changeClip);
        return _bitmap.clips!=null ? _bitmap.clips.length : 0;
    }
    /**从显示列表删除后是否自动停止播放*/
    public var autoStopAtRemoved(get,set):Bool;
    private function get_autoStopAtRemoved():Bool {
        return _autoStopAtRemoved;
    }
    private function set_autoStopAtRemoved(value:Bool):Bool {
        _autoStopAtRemoved = value;
        return value;
    }
    /**自动播放*/
    public var autoPlay(get,set):Bool;
    private function get_autoPlay():Bool {
        return _autoPlay;
    }
    private function set_autoPlay(value:Bool):Bool {
        if (_autoPlay != value) {
            _autoPlay = value;
            _autoPlay ? play() : stop();
        }
        return value;
    }
    /**动画播放间隔(单位毫秒)*/
    public var interval(get,set):Int;
    private function get_interval():Int {
        return _interval;
    }
    private function set_interval(value:Int):Int {
        if (_interval != value) {
            _interval = value;
            if (_isPlaying) {
                play();
            }
        }
        return value;
    }
    /**是否正在播放*/
    public var isPlaying(get,set):Bool;
    private function get_isPlaying():Bool {
        return _isPlaying;
    }
    private function set_isPlaying(value:Bool):Bool {
        _isPlaying = value;
        return value;
    }
    /**开始播放*/
    public function play():Void {
            _isPlaying = true;
            frame = _bitmap.index;
            App.timer.doLoop(_interval, _loop);
    }
    /**停止播放*/
    public function stop():Void {
        App.timer.clearTimer(_loop);
        _isPlaying = false;
    }
    private function loop():Void {
        frame++;
    }
    /**从指定的位置播放*/
    public function gotoAndPlay(frame:Int):Void {
        this.frame = frame;
        play();
    }
    /**跳到指定位置并停止*/
    public function gotoAndStop(frame:Int):Void {
        stop();
        this.frame = frame;
    }
    /**从某帧播放到某帧，播放结束发送事件
	* @param from 开始帧(为-1时默认为第一帧)
	* @param to 结束帧(为-1时默认为最后一帧) */
    public function playFromTo(from:Int = -1, to:Int = -1, complete:Handler = null):Void {
        _from = from == -1 ? 0 : from;
        _to = to == -1 ? _clipX * _clipY - 1 : to;
        _complete = complete;
        gotoAndPlay(_from);
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
    /**位图实体*/
    @:getter(bitmap)
    private function get_bitmap():AutoBitmap {
        return _bitmap;
    }
    /**销毁资源
	* @param	clearFromLoader 是否同时删除加载缓存*/
    public function destroy(clearFromLoader:Bool = false):Void {
        dispose();
    }
    /**销毁*/
     public override function dispose():Void {
        super.dispose();
        if(_bitmap!=null)_bitmap.dispose();
        _bitmap = null;
        _complete = null;
        _url="";
    }
}
