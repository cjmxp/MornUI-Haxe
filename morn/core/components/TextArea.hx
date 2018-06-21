package morn.core.components;
/**文本域*/
import morn.core.handlers.Handler;
import morn.core.events.UIEvent;
import openfl.events.Event;
class TextArea extends TextInput {
    private var _vScrollBar:VScrollBar=null;
    private var _hScrollBar:HScrollBar=null;
    private var _changeScroll:Handler=null;
    public function new(text:String = "") {
        this._changeScroll=new Handler(changeScroll.bind());
        super(text);
    }
    /**销毁*/
    override public function dispose():Void {
        super.dispose();
        if(_vScrollBar!=null)_vScrollBar.dispose();
        if(_hScrollBar!=null)_hScrollBar.dispose();
        _vScrollBar = null;
        _hScrollBar = null;
    }
    override private function initialize():Void {
        super.initialize();
        width = 180;
        height = 150;
        _textField.wordWrap = true;
        _textField.multiline = true;
        _textField.addEventListener(Event.SCROLL, onTextFieldScroll);
    }
    #if flash
    @:setter(width)
    override private function set_width(value:Float):Void {
        super.width = value;
        callLater(_changeScroll);
    }
    @:setter(height)
    override private function set_height(value:Float):Void {
        super.height = value;
        callLater(_changeScroll);
    }
    #else
    override private function set_width(value:Float):Float {
        super.width = value;
        callLater(_changeScroll);
        return value;
    }
    override private function set_height(value:Float):Float {
        super.height = value;
        callLater(_changeScroll);
        return value;
    }
    #end
    private function onTextFieldScroll(e:Event):Void {
        changeScroll();
        sendEvent(UIEvent.SCROLL);
    }
    /**垂直滚动条皮肤(兼容老版本，建议使用vScrollBarSkin)*/
    public var scrollBarSkin(get,set):String;
    private function get_scrollBarSkin():String {
        return _vScrollBar!=null ? _vScrollBar.skin : null;
    }
    private function set_scrollBarSkin(value:String):String {
        vScrollBarSkin = value;
        return value;
    }
    /**垂直滚动条皮肤*/
    public var vScrollBarSkin(get,set):String;
    private function get_vScrollBarSkin():String {
        return _vScrollBar!=null ? _vScrollBar.skin : null;
    }
    private function set_vScrollBarSkin(value:String):String {
        if (_vScrollBar == null) {
            _vScrollBar = new VScrollBar();
            addChild(_vScrollBar);
            _vScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
            _vScrollBar.target = _textField;
            callLater(_changeScroll);
        }
        _vScrollBar.skin = value;
        return value;
    }
    /**水平滚动条皮肤*/
    public var hScrollBarSkin(get,set):String;
    private function get_hScrollBarSkin():String {
        return _hScrollBar!=null ? _hScrollBar.skin : null;
    }
    private function set_hScrollBarSkin(value:String):String {
        if (_hScrollBar == null) {
            _hScrollBar = new HScrollBar();
            addChild(_hScrollBar);
            _hScrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
            _hScrollBar.mouseWheelEnable = false;
            _hScrollBar.target = _textField;
            callLater(_changeScroll);
        }
        _hScrollBar.skin = value;
        return value;
    }
    /**垂直滚动条实体，(兼容老版本，建议用vScrollBar)*/
    public var scrollBar(get,never):VScrollBar;
    private function get_scrollBar():VScrollBar {
        return _vScrollBar;
    }
    /**垂直滚动条实体*/
    public var vScrollBar(get,never):VScrollBar;
    private function get_vScrollBar():VScrollBar {
        return _vScrollBar;
    }
    /**水平滚动条实体*/
    public var hScrollBar(get,never):HScrollBar;
    private function get_hScrollBar():HScrollBar {
        return _hScrollBar;
    }
    /**垂直滚动最大值*/
    public var maxScrollV(get,never):Int;
    private function get_maxScrollV():Int {
        return _textField.maxScrollV;
    }
    /**垂直滚动值*/
    public var scrollV(get,never):Int;
    private function get_scrollV():Int {
        return _textField.scrollV;
    }
    /**水平滚动最大值*/
    public var maxScrollH(get,never):Int;
    private function get_maxScrollH():Int {
        return _textField.maxScrollH;
    }
    /**水平滚动值*/
    public var scrollH(get,never):Int;
    private function get_scrollH():Int {
        return _textField.scrollH;
    }
    private function onScrollBarChange(e:Event):Void {
        if (e.currentTarget == _vScrollBar) {
            if (_textField.scrollV != _vScrollBar.value) {
                _textField.removeEventListener(Event.SCROLL, onTextFieldScroll);
                _textField.scrollV = Std.int(_vScrollBar.value);
                _textField.addEventListener(Event.SCROLL, onTextFieldScroll);
                sendEvent(UIEvent.SCROLL);
            }
        } else {
            if (_textField.scrollH != _hScrollBar.value) {
                _textField.removeEventListener(Event.SCROLL, onTextFieldScroll);
                _textField.scrollH = Std.int(_hScrollBar.value);
                _textField.addEventListener(Event.SCROLL, onTextFieldScroll);
                sendEvent(UIEvent.SCROLL);
            }
        }
    }
    override private function changeText():Void {
        super.changeText();
        if(_textField.scrollV==_textField.maxScrollV-1)_textField.scrollV=_textField.maxScrollV;
        changeScroll();
    }
    private function changeScroll():Void {
        var vShow:Bool = _vScrollBar!=null && _textField.maxScrollV > 1?true:false;
        var hShow:Bool = _hScrollBar!=null && _textField.maxScrollH > 0?true:false;
        var showWidth:Float = vShow ? _width - _vScrollBar.width : _width;
        var showHeight:Float = hShow ? _height - _hScrollBar.height : _height;
        _textField.width = showWidth - _margin[0] - _margin[2];
        _textField.height = showHeight - _margin[1] - _margin[3];
        if (_vScrollBar!=null) {
            _vScrollBar.x = _width - _vScrollBar.width - _margin[2];
            _vScrollBar.y = _margin[1];
            _vScrollBar.height = _height - (hShow ? _hScrollBar.height : 0) - _margin[1] - _margin[3];
            _vScrollBar.scrollSize = 1;
            _vScrollBar.thumbPercent = (_textField.numLines - _textField.maxScrollV + 1) / _textField.numLines;
            _vScrollBar.setScroll(1, _textField.maxScrollV, _textField.scrollV);
        }
        if (_hScrollBar!=null) {
            _hScrollBar.x = _margin[0];
            _hScrollBar.y = _height - _hScrollBar.height - _margin[3];
            _hScrollBar.width = _width - (vShow ? _vScrollBar.width : 0) - _margin[0] - _margin[2];
            _hScrollBar.scrollSize = Math.max(showWidth * 0.033, 1);
            _hScrollBar.thumbPercent = showWidth / Math.max(_textField.textWidth, showWidth);
            _hScrollBar.setScroll(0, maxScrollH, scrollH);
        }
    }
    /**滚动到某个位置，单位是行*/
    public function scrollTo(line:Int):Void {
        commitMeasure();
        _textField.scrollV = line;
    }
}
