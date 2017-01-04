package morn.core.components;
import openfl.display.Sprite;
import openfl.geom.Rectangle;
import openfl.display.Graphics;
import morn.core.handlers.Handler;
import openfl.events.Event;
import openfl.display.DisplayObject;
class Panel extends Box implements IContent {
    private var _content:Box;
    private var _vScrollBar:VScrollBar=null;
    private var _hScrollBar:HScrollBar=null;
    private var _changeScroll:Handler=null;
    public function new() {
        super();
        width = 100;
        height = 100;
    }
    private override function createChildren():Void {
        _content = new Box();
        super.addChild(_content);
    }

    public override function addChild(child:DisplayObject):DisplayObject {
        child.addEventListener(Event.RESIZE, onResize);
        callLater(_changeScroll);
        return _content.addChild(child);
    }
    private function onResize(e:Event):Void {
        callLater(_changeScroll);
    }
    public override function addChildAt(child:DisplayObject, index:Int):DisplayObject {
        child.addEventListener(Event.RESIZE, onResize);
        callLater(_changeScroll);
        return _content.addChildAt(child, index);
    }

    public override function removeChild(child:DisplayObject):DisplayObject {
        child.removeEventListener(Event.RESIZE, onResize);
        callLater(_changeScroll);
        return _content.removeChild(child);
    }

    public override function removeChildAt(index:Int):DisplayObject {
        getChildAt(index).removeEventListener(Event.RESIZE, onResize);
        callLater(_changeScroll);
        return _content.removeChildAt(index);
    }
    public override function removeAllChild(except:DisplayObject = null):Void {
        var i:Int = _content.numChildren - 1;
        while (i>-1) {
            if (except != _content.getChildAt(i)) {
                _content.removeChildAt(i);
            }
            i--;
        }
        callLater(_changeScroll);
    }
    override public function getChildAt(index:Int):DisplayObject {
        return _content.getChildAt(index);
    }

    override public function getChildByName(name:String):DisplayObject {
        return _content.getChildByName(name);
    }

    override public function getChildIndex(child:DisplayObject):Int {
        return _content.getChildIndex(child);
    }

    private function changeScroll():Void {
        var contentW:Float = contentWidth;
        var contentH:Float = contentHeight;
        var vShow:Bool = (_vScrollBar!=null && contentH > _height)?true:false;
        var hShow:Bool = (_hScrollBar!=null && contentW > _width)?true:false;
        var showWidth:Float = vShow ? _width - _vScrollBar.width : _width;
        var showHeight:Float = hShow ? _height - _hScrollBar.height : _height;
        setContentSize(showWidth, showHeight);
        if (_vScrollBar!=null) {
            _vScrollBar.x = _width - _vScrollBar.width;
            _vScrollBar.y = 0;
            _vScrollBar.height = _height - (hShow ? _hScrollBar.height : 0);
            _vScrollBar.scrollSize = Math.max(_height * 0.033, 1);
            _vScrollBar.thumbPercent = showHeight / contentH;
            _vScrollBar.setScroll(0, contentH - showHeight, _vScrollBar.value);
        }
        if (_hScrollBar!=null) {
            _hScrollBar.x = 0;
            _hScrollBar.y = _height - _hScrollBar.height;
            _hScrollBar.width = _width - (vShow ? _vScrollBar.width : 0);
            _hScrollBar.scrollSize = Math.max(_width * 0.033, 1);
            _hScrollBar.thumbPercent = showWidth / contentW;
            _hScrollBar.setScroll(0, contentW - showWidth, _hScrollBar.value);
        }
    }
    public var contentWidth(get,never):Float;
    private function get_contentWidth():Float {
        var max:Float = 0;
        var i:Int = _content.numChildren - 1;
        while (i > -1) {
            var comp:DisplayObject = _content.getChildAt(i);
            max = Math.max(comp.x + comp.width * comp.scaleX, max);
            i--;
        }
        return max;
    }
    public var contentHeight(get,never):Float;
    private function get_contentHeight():Float {
        var max:Float = 0;
        var i:Int = _content.numChildren - 1;
        while (i > -1) {
            var comp:DisplayObject = _content.getChildAt(i);
            max = Math.max(comp.y + comp.height * comp.scaleY, max);
            i--;
        }
        return max;
    }

    private function setContentSize(width:Float, height:Float):Void {
        var g:Graphics = graphics;
        g.clear();
        g.beginFill(0xffff00, 0);
        g.drawRect(0, 0, width, height);
        g.endFill();
        _content.width = width;
        _content.height = height;
        _content.scrollRect = new Rectangle(0, 0, width, height);
    }
    #if flash
    @:getter(numChildren)
    private function get_numChildren():Int {
        return _content.numChildren;
    }
    @:setter(width)
    private function set_width(value:Float):Void {
        super.width = value;
        callLater(_changeScroll);
    }
    @:setter(height)
    private function set_height(value:Float):Void {
        super.height = value;
        callLater(_changeScroll);
    }
    #else
    private override function get_numChildren():Int {
        return _content.numChildren;
    }
    private override  function set_width(value:Float):Float {
        super.width = value;
        callLater(_changeScroll);
        return value;
    }
    private override function set_height(value:Float):Float {
        super.height = value;
        callLater(_changeScroll);
        return value;
    }
    #end
    /**垂直滚动条皮肤*/
    public var vScrollBarSkin(get,set):String;
    private function get_vScrollBarSkin():String {
        return _vScrollBar!=null?_vScrollBar.skin:null;
    }
    private function set_vScrollBarSkin(value:String):String {
        if (_vScrollBar == null) {
            _vScrollBar = new VScrollBar()
            super.addChild(_vScrollBar);
            _vScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
            _vScrollBar.target = this;
            callLater(_changeScroll);
        }
        _vScrollBar.skin = value;
        return value;
    }
    /**水平滚动条皮肤*/
    public var hScrollBarSkin(get,set):String;
    private function get_hScrollBarSkin():String {
        return _hScrollBar!=null?_hScrollBar.skin:null;
    }
    private function set_hScrollBarSkin(value:String):String {
        if (_hScrollBar == null) {
            _hScrollBar = new HScrollBar()
            super.addChild(_hScrollBar);
            _hScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
            _hScrollBar.mouseWheelEnable = false;
            _hScrollBar.target = this;
            callLater(_changeScroll);
        }
        _hScrollBar.skin = value;
    }
    /**垂直滚动条*/
    public var vScrollBar(get,never):ScrollBar;
    private function get_vScrollBar():ScrollBar {
        return _vScrollBar;
    }

    /**水平滚动条*/
    public var hScrollBar(get,never):ScrollBar;
    private function get_hScrollBar():ScrollBar {
        return _hScrollBar;
    }
    /**内容容器*/
    private function get_content():Sprite {
        return _content;
    }
    private function onScrollBarChange(e:Event):Void {
        var rect:Rectangle = _content.scrollRect;
        if (rect!=null && Std.is(e.currentTarget,ScrollBar)) {
            var scroll:ScrollBar = cast(e.currentTarget,ScrollBar) ;
            var start:Int = Math.round(scroll.value);
            scroll.direction == ScrollBar.VERTICAL ? rect.y = start : rect.x = start;
            _content.scrollRect = rect;
        }
    }
    override public function commitMeasure():Void {
        exeCallLater(_changeScroll);
    }

    /**滚动到某个位置*/
    public function scrollTo(x:Float = 0, y:Float = 0):Void {
        commitMeasure();
        if (vScrollBar!=null) {
            vScrollBar.value = y;
        }
        if (hScrollBar!=null) {
            hScrollBar.value = x;
        }
    }

    public function refresh():Void {
        changeScroll();
    }
    
    /**销毁*/
    public override function dispose():Void {
        super.dispose();
        if(_content!=null) _content.dispose();
        if(_vScrollBar!=null) _vScrollBar.dispose();
        if(_hScrollBar!=null) _hScrollBar.dispose();
        _content = null;
        _vScrollBar = null;
        _hScrollBar = null;
    }
}