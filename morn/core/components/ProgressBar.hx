package morn.core.components;
import openfl.events.Event;
import morn.core.handlers.Handler;
class ProgressBar extends Component {
    private var _bg:Image=null;
    private var _bar:Image=null;
    private var _skin:String=null;
    private var _value:Float = 0.5;
    private var _label:String=null;
    private var _barLabel:Label=null;
    private var _changeHandler:Handler=null;
    private var _changeLabelPoint:Handler=null;
    private var _changeValue:Handler=null;

    public function new(skin:String = null) {
        this._changeLabelPoint=new Handler(changeLabelPoint.bind());
        this._changeValue=new Handler(changeValue.bind());
        super();
        this.skin = skin;
    }
    /**销毁*/
    override public function dispose():Void {
        super.dispose();
        if(_bg!=null)_bg.dispose();
        if(_bar!=null)_bar.dispose();
        if(_barLabel!=null)_barLabel.dispose();
        _bg = null;
        _bar = null;
        _barLabel = null;
        _changeHandler = null;
    }
    override private function createChildren():Void {
        _bg = new Image();
        _bar = new Image();
        _barLabel = new Label();
        addChild(_bg);
        addChild(_bar);
        addChild(_barLabel);
    }

    override private function initialize():Void {
        _barLabel.width = 200;
        _barLabel.height = 18;
        _barLabel.align = "center";
        _barLabel.stroke = "0x004080";
        _barLabel.color = 0xffffff;
    }
    /**皮肤*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _skin;
    }
    private function set_skin(value:String):String {
        if (_skin != value) {
            _skin = value;
            _bg.url = _skin;
            _bar.url = _skin + "$bar";
            _contentWidth = _bg.width;
            _contentHeight = _bg.height;
            callLater(_changeLabelPoint);
            callLater(_changeValue);
        }
        return _skin;
    }
    private function changeLabelPoint():Void {
        _barLabel.x = (width - _barLabel.width) * 0.5;
        _barLabel.y = (height - _barLabel.height) * 0.5 - 2;
    }
    /**当前值(0-1)*/
    public var value(get,set):Float;
    private function get_value():Float {
        return _value;
    }
    private function set_value(num:Float):Float {
        if (_value != num) {
            num = num > 1 ? 1 : num < 0 ? 0 : num;
            _value = num;
            callLater(_changeValue);
            sendEvent(Event.CHANGE);
            if (_changeHandler != null) {
                _changeHandler.Function(num);
            }
        }
        return _value;
    }
    private function changeValue():Void {
        if (sizeGrid!=null && sizeGrid!="" ) {
            var grid:Array<Dynamic> = sizeGrid.split(",");
            var left:Float = Std.parseFloat(grid[0]);
            var right:Float = Std.parseFloat(grid[2]);
            var max:Float = width - left - right;
            var sw:Float = max * _value;
            _bar.width = left + right + sw;
            _bar.visible = _bar.width > left + right;
        } else {
            _bar.width = width * _value;
        }
    }
    /**标签*/
    public var label(get,set):String;
    private function get_label():String {
        return _label;
    }
    private function set_label(value:String):String {
        if (_label != value) {
            _label = value;
            _barLabel.text = _label;
        }
        return _label;
    }
    /**进度条*/
    public var bar(get,never):Image;
    private function get_bar():Image {
        return _bar;
    }

    /**标签实体*/
    public var barLabel(get,never):Label;
    private function get_barLabel():Label {
        return _barLabel;
    }
    /**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
    public var sizeGrid(get,set):String;
    private function get_sizeGrid():String {
        return _bg.sizeGrid;
    }
    private function set_sizeGrid(value:String):String {
        _bg.sizeGrid = value;
        _bar.sizeGrid = value;
        return value;
    }
    #if flash
    @:setter(width)
    private override function set_width(value:Float):Void {
        super.width = value;
        _bg.width = _width;
        _barLabel.width = _width;
        callLater(_changeLabelPoint);
        callLater(_changeValue);
    }
    @:setter(height)
    private override function set_height(value:Float):Void {
        super.height = value;
        _bg.height = _height;
        _bar.height = _height;
        callLater(_changeLabelPoint);
    }
    #else
    override public function set_width(value:Float):Float {
        super.width = value;
        _bg.width = _width;
        _barLabel.width = _width;
        callLater(_changeLabelPoint);
        callLater(_changeValue);
        return value;
    }
    override public function set_height(value:Float):Float {
        super.height = value;
        _bg.height = _height;
        _bar.height = _height;
        callLater(_changeLabelPoint);
        return value;
    }
    #end
    override public function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Float) || Std.is(value,String)) {
            this.value = Std.parseFloat(Std.string(value));
        } else {
            super.dataSource = value;
        }
        return _dataSource;
    }
}
