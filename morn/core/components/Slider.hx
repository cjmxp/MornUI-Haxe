package morn.core.components;
import openfl.events.Event;
import openfl.geom.Rectangle;
import openfl.events.MouseEvent;
import morn.core.handlers.Handler;
class Slider extends Component {
    /**水平移动*/
    public static var HORIZONTAL(default, never):String = "horizontal";
    /**垂直移动*/
    public static var VERTICAL(default, never):String = "vertical";
    private var _allowBackClick:Bool=false;
    private var _max:Float = 100.0;
    private var _min:Float = 0.0;
    private var _tick:Float = 1.0;
    private var _value:Float = 0.0;
    private var _direction:String = VERTICAL;
    private var _skin:String=null;
    private var _back:Image=null;
    private var _bar:Button=null;
    private var _label:Label=null;
    private var _showLabel:Bool = true;
    private var _changeHandler:Handler=null;
    private var _changeValue:Handler=null;
    public function new(skin:String = null) {
        super();
        this._changeValue=new Handler(changeValue.bind());
        this.skin = skin;
    }
    private override function preinitialize():Void {
        mouseChildren = true;
    }

    private override function createChildren():Void {
        _back = new Image();
        _bar = new Button();
        _label = new Label();
        addChild(_back);
        addChild(_bar);
        addChild(_label);
    }

    private override function initialize():Void {
        _bar.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
        _back.sizeGrid = _bar.sizeGrid = "4,4,4,4";
        allowBackClick = true;
    }
    private function onButtonMouseDown(e:MouseEvent):Void {
        App.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        App.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        if (_direction == VERTICAL) {
            _bar.startDrag(false, new Rectangle(_bar.x, 0, 0, height - _bar.height));
        } else {
            _bar.startDrag(false, new Rectangle(0, _bar.y, width - _bar.width, 0));
        }
        //显示提示
        showValueText();
    }
    private function showValueText():Void {
        if (_showLabel) {
            _label.text = _value + "";
            if (_direction == VERTICAL) {
                _label.x = _bar.x + 20;
                _label.y = (_bar.height - _label.textHeight) * 0.5 + _bar.y;
            } else {
                _label.y = _bar.y - 20;
                _label.x = (_bar.width - _label.textWidth) * 0.5 + _bar.x;
            }
        }
    }
    private function hideValueText():Void {
        _label.text = "";
    }
    private function onStageMouseUp(e:MouseEvent):Void {
        App.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        App.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        _bar.stopDrag();
        hideValueText();
    }

    private function onStageMouseMove(e:MouseEvent):Void {
        var oldValue:Float = _value;
        if (_direction == VERTICAL) {
            _value = _bar.y / (height - _bar.height) * (_max - _min) + _min;
        } else {
            _value = _bar.x / (width - _bar.width) * (_max - _min) + _min;
        }
        _value = Math.round(_value / _tick) * _tick;
        if (_value != oldValue) {
            showValueText();
            sendChangeEvent();
        }
    }

    private function sendChangeEvent():Void {
        sendEvent(Event.CHANGE);
        if (_changeHandler != null) {
            _changeHandler.Function(_value);
        }
    }

    /**皮肤*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _skin;
    }
    private function set_skin(value:String):String {
        if (_skin != value) {
            _skin = value;
            _back.url = _skin;
            _bar.skin = _skin + "$bar";
            _contentWidth = _back.width;
            _contentHeight = _back.height;
            setBarPoint();
        }
        return value;
    }
    private override function changeSize():Void {
        super.changeSize();
        _back.width = width;
        _back.height = height;
        setBarPoint();
    }
    private function setBarPoint():Void {
        if (_direction == VERTICAL) {
            _bar.x = (_back.width - _bar.width) * 0.5;
        } else {
            _bar.y = (_back.height - _bar.height)* 0.5;
        }
    }
    /**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
    public var sizeGrid(get,set):String;
    private function get_sizeGrid():String {
        return _back.sizeGrid;
    }
    private function set_sizeGrid(value:String):String {
        _back.sizeGrid = value;
        _bar.sizeGrid = value;
        return value;
    }

    private function changeValue():Void {
        _value = Math.round(_value / _tick) * _tick;
        _value = _value > _max ? _max : _value < _min ? _min : _value;
        if (_direction == VERTICAL) {
            _bar.y = (_value - _min) / (_max - _min) * (height - _bar.height);
        } else {
            _bar.x = (_value - _min) / (_max - _min) * (width - _bar.width);
        }
    }
    /**设置滑动条*/
    public function setSlider(min:Float, max:Float, value:Float):Void {
        _value = -1;
        _min = min;
        _max = max > min ? max : min;
        this.value = value < min ? min : value > max ? max : value;
    }
    /**刻度值，默认值为1*/
    public var tick(get,set):Float;
    private function get_tick():Float {
        return _tick;
    }
    private function set_tick(value:Float):Float {
        _tick = value;
        callLater(_changeValue);
        return _tick;
    }
    /**滑块上允许的最大值*/
    public var max(get,set):Float;
    private function get_max():Float {
        return _max;
    }
    private function set_max(value:Float):Float {
        if (_max != value) {
            _max = value;
            callLater(_changeValue);
        }
        return _max;
    }
    /**滑块上允许的最小值*/
    public var min(get,set):Float;
    private function get_min():Float {
        return _min;
    }
    private function set_min(value:Float):Float {
        if (_min != value) {
            _min = value;
            callLater(_changeValue);
        }
        return _min;
    }
    /**当前值*/
    public var value(get,set):Float;
    private function get_value():Float {
        return _value;
    }
    private function set_value(num:Float):Float {
        if (_value != num) {
            _value = num;
            //callLater(changeValue);
            //callLater(sendChangeEvent);
            changeValue();
            sendChangeEvent();
        }
        return _value;
    }
    /**滑动方向*/
    public var direction(get,set):String;
    private function get_direction():String {
        return _direction;
    }
    private function set_direction(value:String):String {
        _direction = value;
        return _direction;
    }
    /**是否显示标签*/
    public var showLabel(get,set):Bool;
    private function get_showLabel():Bool {
        return _showLabel;
    }
    private function set_showLabel(value:Bool):Bool {
        _showLabel = value;
        return _showLabel;
    }
    /**允许点击后面*/
    public var allowBackClick(get,set):Bool;
    private function get_allowBackClick():Bool {
        return _allowBackClick;
    }
    private function set_allowBackClick(value:Bool):Bool {
        if (_allowBackClick != value) {
            _allowBackClick = value;
            if (_allowBackClick) {
                _back.addEventListener(MouseEvent.MOUSE_DOWN, onBackBoxMouseDown);
            } else {
                _back.removeEventListener(MouseEvent.MOUSE_DOWN, onBackBoxMouseDown);
            }
        }
        return _allowBackClick;
    }
    private function onBackBoxMouseDown(e:MouseEvent):Void {
        if (_direction == VERTICAL) {
            value = _back.mouseY / (height - _bar.height) * (_max - _min) + _min;
        } else {
            value = _back.mouseX / (width - _bar.width) * (_max - _min) + _min;
        }
    }
    public override function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Float) || Std.is(value,String)) {
            this.value = Std.parseFloat(Std.string(value));
        } else {
            super.dataSource = value;
        }
        return value;
    }
    /**控制按钮*/
    public var bar(get,never):Button;
    private function get_bar():Button {
        return _bar;
    }

    /**数据变化处理器*/
    public var changeHandler(get,set):Handler;
    private function get_changeHandler():Handler {
        return _changeHandler;
    }
    private function set_changeHandler(value:Handler):Handler {
        _changeHandler = value;
        return _changeHandler;
    }
    /**销毁*/
    public override function dispose():Void {
        super.dispose();
        if(_back!=null)_back.dispose();
        if(_bar!=null)_bar.dispose();
        if(_label!=null)_label.dispose();
        _back = null;
        _bar = null;
        _label = null;
        _changeHandler = null;
    }
}
