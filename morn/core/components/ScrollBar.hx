package morn.core.components;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.display.InteractiveObject;
import morn.core.handlers.Handler;
class ScrollBar extends Component {
    /**水平移动*/
    public static var HORIZONTAL(default, never):String = "horizontal";
    /**垂直移动*/
    public static var VERTICAL(default, never):String = "vertical";
    private var _scrollSize:Float = 1.0;
    private var _skin:String=null;
    private var _upButton:Button=null;
    private var _downButton:Button=null;
    private var _slider:Slider=null;
    private var _changeHandler:Handler=null;
    private var _slide:Handler=null;
    private var _startLoop:Handler=null;
    private var _changeScrollBar:Handler=null;
    private var _tweenMove:Handler=null;
    private var _thumbPercent:Float = 1;
    private var _target:InteractiveObject=null;
    private var _touchScrollEnable:Bool = App.touchScrollEnable;
    private var _mouseWheelEnable:Bool = App.mouseWheelEnable;
    private var _lastPoint:Point=null;
    private var _lastOffset:Float = 0.0;
    private var _autoHide:Bool = true;
    private var _showButtons:Bool = true;
    private var _scaleBar:Bool = true;

    public function new(skin:String = null) {
        super();
        this._slide=new Handler(null);
        this._startLoop=new Handler(null);
        this._changeScrollBar=new Handler(changeScrollBar.bind());
        this._tweenMove=new Handler(tweenMove.bind());
        this.skin = skin;
    }
    private override  function preinitialize():Void {
        mouseChildren = true;
    }

    private override function createChildren():Void {
        _slider = new Slider();
        _upButton = new Button();
        _downButton = new Button();
        addChild(_slider);
        addChild(_upButton);
        addChild(_downButton);
    }

    override private function initialize():Void {
        _slider.showLabel = false;
        _slider.addEventListener(Event.CHANGE, onSliderChange);
        _slider.setSlider(0, 0, 0);
        _upButton.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
        _downButton.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
    }

    private function onSliderChange(e:Event):Void {
        sendEvent(Event.CHANGE);
        if (_changeHandler != null) {
            _changeHandler.Function(value);
        }
    }

    private function onButtonMouseDown(e:MouseEvent):Void {
        var isUp:Bool = e.currentTarget == _upButton;
        slide(isUp);
        _startLoop.Function=startLoop.bind(isUp);
        App.timer.doOnce(App.scrollBarDelayTime, _startLoop, isUp);
        App.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
    }

    private function startLoop(isUp:Bool):Void {
        _slide.Function=slide.bind(isUp);
        App.timer.doFrameLoop(1, _slide, isUp);
    }

    private function slide(isUp:Bool):Void {
        if (isUp) {
            value -= _scrollSize;
        } else {
            value += _scrollSize;
        }
    }
    private function onStageMouseUp(e:MouseEvent):Void {
        App.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        App.timer.clearTimer(startLoop);
        App.timer.clearTimer(slide);
    }
    /**皮肤*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _skin;
    }
    private function set_skin(value:String):String {
        if (_skin != value && value!=null) {
            _skin = value;
            _slider.skin = _skin;
            _upButton.skin = _skin + "$up";
            _downButton.skin = _skin + "$down";
            callLater(_changeScrollBar);
        }
        return _skin;
    }
    private function changeScrollBar():Void {
        _upButton.visible = _showButtons;
        _downButton.visible = _showButtons;
        if (_slider.direction == VERTICAL) {
            _slider.y = _upButton.height;
        } else {
            _slider.x = _upButton.width;
        }
        resetPositions();
    }
    override private function changeSize():Void {
        super.changeSize();
        resetPositions();
    }
    private function resetPositions():Void {
        if (_slider.direction == VERTICAL) {
            _slider.height = height - (_upButton.height*2);
            _slider.y=_upButton.height;
            _downButton.y = _slider.y + _slider.height;
            _contentWidth = _slider.width;
            _contentHeight = _downButton.y + _downButton.height;
        } else {
            _slider.width = width - (_upButton.width*2);
            _slider.x=_upButton.width;
            _downButton.x = _slider.x + _slider.width;
            _contentWidth = _downButton.x + _downButton.width;
            _contentHeight = _slider.height;
        }
    }

    /**设置滚动条*/
    public function setScroll(min:Float, max:Float, value:Float):Void {
        exeCallLater(_changeSize);
        _slider.setSlider(min, max, value);
        _upButton.disabled = max <= 0;
        _downButton.disabled = max <= 0;
        _slider.bar.visible = max > 0;
        visible = !(_autoHide && max <= min);
    }
    /**最大滚动位置*/
    public var max(get,set):Float;
    private function get_max():Float {
        return _slider.max;
    }
    private function set_max(value:Float):Float {
        _slider.max = value;
        return value;

    }

    /**最小滚动位置*/
    public var min(get,set):Float;
    private function get_min():Float {
        return _slider.min;
    }
    private function set_min(value:Float):Float {
        _slider.min = value;
        return value;
    }

    /**当前滚动位置*/
    public var value(get,set):Float;
    private function get_value():Float {
        return _slider.value;
    }
    private function set_value(value:Float):Float {
        _slider.value = value;
        return value;
    }

    /**滚动方向*/
    public var direction(get,set):String;
    private function get_direction():String {
        return _slider.direction;
    }
    private function set_direction(value:String):String {
        _slider.direction = value;
        return value;
    }

    /**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
    public var sizeGrid(get,set):String;
    private function get_sizeGrid():String {
        return _slider.sizeGrid;
    }
    private function set_sizeGrid(value:String):String {
        _slider.sizeGrid = value;
        return value;
    }

    /**点击按钮滚动量*/
    public var scrollSize(get,set):Float;
    private function get_scrollSize():Float {
        return _scrollSize;
    }
    private function set_scrollSize(value:Float):Float {
        _scrollSize = value;
        return value;
    }

    public override function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Float)  || Std.is(value,String)) {
            this.value = Std.parseFloat(Std.string(value));
        } else {
            super.dataSource = value;
        }
        return value;
    }
    /**滑条长度比例(0-1)*/
    public var thumbPercent(get,set):Float;
    private function get_thumbPercent():Float {
        return _thumbPercent;
    }
    private function set_thumbPercent(value:Float):Float {
        exeCallLater(_changeSize);
        _thumbPercent = value;
        if (_scaleBar) {
            if (_slider.direction == VERTICAL) {
                _slider.bar.height = Math.max(_slider.height * value, App.scrollBarMinNum);
            } else {
                _slider.bar.width = Math.max(_slider.width * value, App.scrollBarMinNum);
            }
        }
        return value;
    }

    /**滚动对象*/
    public var target(get,set):InteractiveObject;
    private function get_target():InteractiveObject {
        return _target;
    }
    private function set_target(value:InteractiveObject):InteractiveObject {
        if (_target!=null) {
            _target.removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
            _target.removeEventListener(MouseEvent.MOUSE_DOWN, onTargetMouseDown);
        }
        _target = value;
        if(value!=null){
            if (_mouseWheelEnable) {
                _target.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
            }
            if (_touchScrollEnable) {
                _target.addEventListener(MouseEvent.MOUSE_DOWN, onTargetMouseDown);
            }
        }
        return _target;
    }

    /**是否触摸滚动，默认为true*/
    public var touchScrollEnable(get,set):Bool;
    private function get_touchScrollEnable():Bool {
        return _touchScrollEnable;
    }
    private function set_touchScrollEnable(value:Bool):Bool {
        _touchScrollEnable = value;
        target = _target;
        return value;
    }

    /**是否滚轮滚动，默认为true*/
    public var mouseWheelEnable(get,set):Bool;
    private function get_mouseWheelEnable():Bool {
        return _mouseWheelEnable;
    }
    private function set_mouseWheelEnable(value:Bool):Bool {
        _mouseWheelEnable = value;
        target = _target;
        return value;
    }

    /**是否自动隐藏滚动条(无需滚动时)，默认为true*/
    public var autoHide(get,set):Bool;
    private function get_autoHide():Bool {
        return _autoHide;
    }
    private function set_autoHide(value:Bool):Bool {
        _autoHide = value;
        return value;
    }

    /**是否显示按钮，默认为true*/
    public var showButtons(get,set):Bool;
    private function get_showButtons():Bool {
        return _showButtons;
    }
    private function set_showButtons(value:Bool):Bool {
        _showButtons = value;
        return value;
    }

    /**滚动变化时回调，回传value参数*/
    public var changeHandler(get,set):Handler;
    private function get_changeHandler():Handler {
        return _changeHandler;
    }
    private function set_changeHandler(value:Handler):Handler {
        _changeHandler = value;
        return value;
    }

    /**是否缩放滑条*/
    public var scaleBar(get,set):Bool;
    private function get_scaleBar():Bool {
        return _scaleBar;
    }
    private function set_scaleBar(value:Bool):Bool {
        _scaleBar = value;
        return value;
    }
    private function onTargetMouseDown(e:MouseEvent):Void {
        App.timer.clearTimer(tweenMove);
        if(Std.is(e.target,DisplayObject)){
            if (!this.contains(cast(e.target,DisplayObject))) {
                App.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp2);
                App.stage.addEventListener(Event.ENTER_FRAME, onStageEnterFrame);
                _lastPoint = new Point(App.stage.mouseX, App.stage.mouseY);
            }
        }
    }
    private function onStageEnterFrame(e:Event):Void {
        _lastOffset = _slider.direction == VERTICAL ? App.stage.mouseY - _lastPoint.y : App.stage.mouseX - _lastPoint.x;
        if (Math.abs(_lastOffset) >= 1) {
            _lastPoint.x = App.stage.mouseX;
            _lastPoint.y = App.stage.mouseY;
            value -= _lastOffset;
        }
    }
    private function onStageMouseUp2(e:MouseEvent):Void {
        App.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp2);
        App.stage.removeEventListener(Event.ENTER_FRAME, onStageEnterFrame);
        _lastOffset = _slider.direction == VERTICAL ? App.stage.mouseY - _lastPoint.y : App.stage.mouseX - _lastPoint.x;
        if (Math.abs(_lastOffset) > 50) {
            _lastOffset = _lastOffset > 0 ? 50 : -50;
        }
        App.timer.doFrameLoop(1, _tweenMove);
    }
    private function tweenMove():Void {
        _lastOffset = _lastOffset * 0.92;
        value -= _lastOffset;
        if (Math.abs(_lastOffset) < 0.5) {
            App.timer.clearTimer(tweenMove);
        }
    }

    private function onMouseWheel(e:MouseEvent):Void {
        value += (e.delta < 0 ? 3 : -3) * _scrollSize;
        if (value < max && value > min) {
            e.stopPropagation();
        }
    }

    /**销毁*/
    public override function dispose():Void {
        super.dispose();
        if(_upButton!=null) _upButton.dispose();
        if(_downButton!=null) _downButton.dispose();
        if(_slider!=null) _slider.dispose();
        _upButton = null;
        _downButton = null;
        _slider = null;
        _changeHandler = null;
        _target = null;
        _lastPoint = null;
    }
}
