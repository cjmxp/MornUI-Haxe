package morn.core.components;
import morn.core.utils.ObjectUtils;
import morn.core.events.UIEvent;
import openfl.display.InteractiveObject;
import openfl.display.Shape;
import flash.events.MouseEvent;
import openfl.events.Event;
import morn.core.handlers.Handler;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
class Component extends Sprite implements IComponent {
    private var _width:Float = Math.NaN;
    private var _height:Float = Math.NaN;
    private var _contentWidth:Float = 0.00000;
    private var _contentHeight:Float = 0.00000;
    private var _disabled:Bool = false;
    private var _tag:Dynamic = null;
    private var _comXml:Xml  = null;
    private var _comJSON:Dynamic  = null;
    private var _dataSource:Dynamic  = null;
    private var _toolTip:Dynamic  = null;
    private var _mouseChildren:Bool = false;
    private var _top:Float = Math.NaN;
    private var _bottom:Float = Math.NaN;
    private var _left:Float = Math.NaN;
    private var _right:Float = Math.NaN;
    private var _centerX:Float = Math.NaN;
    private var _centerY:Float = Math.NaN;
    private var _layOutEnabled:Bool = false;
    private var _resetPosition:Handler = null;
    private var _sendEvent:Handler = null;
    private var _changeSize:Handler = null;


    public function new() {
        super();
        super.x=0;
        super.y=0;
        _resetPosition = new Handler(resetPosition.bind());
        _sendEvent = new Handler(sendEvent.bind(UIEvent.MOVE));
        _changeSize = new Handler(changeSize.bind());
        mouseChildren = tabEnabled = tabChildren = false;
        preinitialize();
        createChildren();
        initialize();
        init();

    }
    private function init():Void {

    }
    /**预初始化，在此可以修改属性默认值*/

    private function preinitialize():Void {

    }

    /**在此创建组件子对象*/

    private function createChildren():Void {

    }

    /**初始化，在此子对象已被创建，可以对子对象进行修改*/

    private function initialize():Void {

    }
    /**延迟调用，在组件被显示在屏幕之前调用*/

    public function callLater(fn:Handler):Void {
        App.render.callLater(fn);
    }
    /**立即执行延迟调用*/
    public function delayCallLater(fn:Handler,delay:Int):Void {
        App.render.delayCallLater(fn,delay);
    }
    /**立即执行延迟调用*/
    public function exeCallLater(fn:Handler):Void {
        App.render.exeCallLater(fn);
    }
    /**派发事件，data为事件携带数据*/

    public function sendEvent(type:String, data:Dynamic = null):Void {
        if (hasEventListener(type)) {
            dispatchEvent(new UIEvent(type, data));
        }
    }

    /**从父容器删除自己，如已经被删除不会抛出异常*/

    public function remove():Void {
        if (parent != null) {
            parent.removeChild(this);
        }
    }

    /**根据名字删除子对象，如找不到不会抛出异常*/

    public function removeChildByName(name:String):Void {
        var display:DisplayObject = getChildByName(name);
        if (display != null) {
            removeChild(display);
        }
    }
    /**设置组件位置*/

    public function setPosition(x:Float, y:Float):Void {
        this.x = x;
        this.y = y;
    }
    public var measureHeight(get,null):Float;
    private function get_measureHeight():Float {
        commitMeasure();
        var max:Float = 0;
        var i:Int = numChildren - 1;
        while(i>0){
            var comp:DisplayObject = getChildAt(i);
            if (comp.visible) {
                max = Math.max(comp.y + comp.height * comp.scaleY, max);
            }
            i--;
        }
        return max;
    }

    #if flash

    /**获取X坐标*/
    @:getter(x)
    private function get_x():Float {
        exeCallLater(_resetPosition);
        return super.x;
    }
    @:setter(x)
    private function set_x(value:Float):Void {
        super.x = value;
        callLater(_sendEvent);
    }
    /**获取Y坐标*/
    @:getter(y)
    private function get_y():Float {
        exeCallLater(_resetPosition);
        return super.y;
    }
    @:setter(y)
    private function set_y(value:Float):Void {
        super.y = value;
        callLater(_sendEvent);
    }

    /**宽度(值为NaN时，宽度为自适应大小)*/
    @:getter(width)
    private function get_width():Float {
        exeCallLater(_resetPosition);
        if (!Math.isNaN(_width)) {
            return _width;
        } else if (_contentWidth != 0.00000) {
            return _contentWidth;
        } else {
            return measureWidth;
        }
        return 0;
    }
    @:setter(width)
    private function set_width(value:Float):Void {
        if (_width != value) {
            _width = value;
            callLater(_changeSize);
            if (_layOutEnabled) {
                callLater(_resetPosition);
            }
        }
    }

    /**高度(值为NaN时，高度为自适应大小)*/
    @:getter(height)
    private function get_height():Float {
        exeCallLater(_resetPosition);
        if (!Math.isNaN(_height)) {
            return _height;
        } else if (_contentHeight != 0.00000) {
            return _contentHeight;
        } else {
            return measureHeight;
        }
        return 0;
    }
    @:setter(height)
    private function set_height(value:Float):Void {
        if (_height != value) {
            _height = value;
            callLater(_changeSize);
            if (_layOutEnabled) {
                callLater(_resetPosition);
            }
        }
    }
    @:setter(scaleX)
    private function set_scaleX(value:Float):Void {
        super.scaleX = value;
        callLater(_changeSize);
    }
    @:setter(scaleY)
    private function set_scaleY(value:Float):Void {
        super.scaleY = value;
        callLater(_changeSize);
    }
    @:setter(mouseChildren)
    private function set_mouseChildren(value:Bool):Void {
        _mouseChildren = value;
        super.mouseChildren = value;
    }
    @:setter(doubleClickEnabled)
    private function set_doubleClickEnabled(value:Bool):Void {
        super.doubleClickEnabled = value;
        var i:Int = numChildren - 1;
        while (i > 0) {
            var display:Dynamic = getChildAt(i);
            if (display != null && Std.is(display, InteractiveObject)) {
                display.doubleClickEnabled = value;
            }
            i--;
        }
    }

    #else

    /**获取X坐标*/

    private override function get_x():Float {
        exeCallLater(_resetPosition);
        return super.x;
    }

    /**获取Y坐标*/

    private override function get_y():Float {
        exeCallLater(_resetPosition);
        return super.y;
    }

    private override function set_x(value:Float):Float {
        super.x = value;
        callLater(_sendEvent);
        return value;
    }

    private override function set_y(value:Float):Float {
        super.y = value;
        callLater(_sendEvent);
        return value;
    }
    /**宽度(值为NaN时，宽度为自适应大小)*/

    private override function get_width():Float {
        exeCallLater(_resetPosition);
        if (!Math.isNaN(_width)) {
            return _width;
        } else if (_contentWidth != 0) {
            return _contentWidth;
        } else {
            return measureWidth;
        }
        return 0;
    }
    private override function set_width(value:Float):Float {
        if (_width != value) {
            _width = value;
            callLater(_changeSize);
            if (_layOutEnabled) {
                callLater(_resetPosition);
            }
        }
        return value;
    }
    /**高度(值为NaN时，高度为自适应大小)*/
    private override function get_height():Float {
        exeCallLater(_resetPosition);
        if (!Math.isNaN(_height)) {
            return _height;
        } else if (_contentHeight != 0) {
            return _contentHeight;
        } else {
            return measureHeight;
        }
        return 0;
    }
    private override function set_height(value:Float):Float {
        if (_height != value) {
            _height = value;
            callLater(_changeSize);
            if (_layOutEnabled) {
                callLater(_resetPosition);
            }
        }
        return value;
    }
    private override function set_scaleX(value:Float):Float {
        super.scaleX = value;
        callLater(_changeSize);
        return value;
    }

    private override function set_scaleY(value:Float):Float {
        super.scaleY = value;
        callLater(_changeSize);
        return value;
    }

    @:setter(mouseChildren)
    private function set_mouseChildren(value:Bool):Bool {
        _mouseChildren = this.mouseChildren = value;
        return value;
    }

    @:setter(doubleClickEnabled)
    private function set_doubleClickEnabled(value:Bool):Bool {
        this.doubleClickEnabled = value;
        var i:Int = numChildren - 1;
        while (i > 0) {
            var display:Dynamic = getChildAt(i);
            if (display != null && Std.is(display, InteractiveObject)) {
                display.doubleClickEnabled = value;
            }
            i--;
        }
        return value;
    }
    #end

    /**显示的宽度(width * scaleX)*/
    public var displayWidth(get, null):Float;

    private function get_displayWidth():Float {
        return width * scaleX;
    }
    /**显示的高度(height * scaleY)*/
    public var displayHeight(get, null):Float;

    private function get_displayHeight():Float {
        return height * scaleY;
    }
    public var measureWidth(get, null):Float;

    private function get_measureWidth():Float {
        commitMeasure();
        var max:Float = 0;
        var i:Int = numChildren - 1;
        while (i > 0) {
            var comp:DisplayObject = getChildAt(i);
            if (comp != null && comp.visible) {
                max = Math.max(comp.x + comp.width * comp.scaleX, max);
            }
            i--;
        }
        return max;
    }
    /**缩放比例(等同于同时设置scaleX，scaleY)*/
    public var scale(get, set):Float;

    private function set_scale(value:Float):Float {
        scaleX = scaleY = value;
        return value;
    }

    private function get_scale():Float {
        return scaleX;
    }
    /**执行影响宽高的延迟函数*/

    public function commitMeasure():Void {
    }

    private function changeSize():Void {
        sendEvent(Event.RESIZE);
    }

    /**设置组件大小*/

    public function setSize(width:Float, height:Float):Void {
        this.width = width;
        this.height = height;
    }
    /**是否禁用*/
    public var disabled(get, set):Bool;

    private function get_disabled():Bool {
        return _disabled;
    }

    private function set_disabled(value:Bool):Bool {
        if (_disabled != value) {
            _disabled = value;
            mouseEnabled = !value;
            this.mouseChildren = value ? false : _mouseChildren;
            ObjectUtils.gray(this, _disabled);
        }
        return value;
    }
    /**标签(冗余字段，可以用来储存数据)*/
    public var tag(get, set):Dynamic;

    private function get_tag():Dynamic {
        return _tag;
    }

    private function set_tag(value:Dynamic):Dynamic {
        _tag = value;
        return value;
    }


    /**显示边框*/

    public function showBorder(color:UInt = 0xff0000):Void {
        removeChildByName("border");
        var border:Shape = new Shape();
        border.name = "border";
        border.graphics.lineStyle(1, color);
        border.graphics.drawRect(0, 0, width, height);
        border.graphics.endFill();
        addChild(border);
    }

    /**组件的XML类型数据结构*/
    public var comXml(get, set):Xml;

    private function get_comXml():Xml {
        return _comXml;
    }

    private function set_comXml(value:Xml):Xml {
        _comXml = value;
        return value;
    }

    /**组件的JSON类型数据结构*/
    public var comJSON(get, set):Dynamic;

    private function get_comJSON():Dynamic {
        return _comJSON;
    }

    private function set_comJSON(value:Dynamic):Dynamic {
        _comJSON = value;
        return value;
    }
    /**数据赋值，通过对UI赋值来控制UI显示逻辑
     * 简单赋值会更改组件的默认属性，使用大括号可以指定组件的任意属性进行赋值
     * @example label1和checkbox1分别为组件实例的name属性
     * <listing version="3.0">
     * //默认属性赋值(更改了label1的text属性，更改checkbox1的selected属性)
     * dataSource = {label1: "改变了label", checkbox1: true}
     * //任意属性赋值
     * dataSource = {label2: {text:"改变了label",size:14}, checkbox2: {selected:true,x:10}}
     * </listing>*/
    public var dataSource(get, set):Dynamic;

    private function get_dataSource():Dynamic {
        return _dataSource;
    }

    private function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        var fields:Array<Dynamic> = Reflect.fields(_dataSource);
        for (name in fields) {
            var value:Dynamic = Reflect.field(_dataSource, name);
            if (Reflect.hasField(this, name)) {
                Reflect.setField(this, name, value);
            }
        }
        return value;
    }
    /**鼠标提示
     * 可以赋值为文本及函数，以实现自定义样式的鼠标提示和参数携带等
     * @example 下面例子展示了三种鼠标提示
     * <listing version="3.0">
     *	private var _testTips:TestTipsUI = new TestTipsUI();
     *	private function testTips():void {
     *		//简单鼠标提示
     *		btn2.toolTip = "这里是鼠标提示&lt;b&gt;粗体&lt;/b&gt;&lt;br&gt;换行";
     *		//自定义的鼠标提示
     *		btn1.toolTip = showTips1;
     *		//带参数的自定义鼠标提示
     *		clip.toolTip = new Handler(showTips2, ["clip"]);
     *	}
     *	private function showTips1():void {
     *		_testTips.label.text = "这里是按钮[" + btn1.label + "]";
     *		App.tip.addChild(_testTips);
     *	}
     *	private function showTips2(name:String):void {
     *		_testTips.label.text = "这里是" + name;
     *		App.tip.addChild(_testTips);
     *	}
     * </listing>*/
    public var toolTip(get, set):Dynamic;

    private function get_toolTip():Dynamic {
        return _toolTip;
    }

    private function set_toolTip(value:Dynamic):Dynamic {
        if (_toolTip != value) {
            _toolTip = value;
            if (value != null) {
                addEventListener(MouseEvent.ROLL_OVER, onRollMouse);
                addEventListener(MouseEvent.ROLL_OUT, onRollMouse);
            } else {
                removeEventListener(MouseEvent.ROLL_OVER, onRollMouse);
                removeEventListener(MouseEvent.ROLL_OUT, onRollMouse);
            }
        }
        return value;
    }

    private function onRollMouse(e:MouseEvent):Void {
        dispatchEvent(new UIEvent(e.type == MouseEvent.ROLL_OVER ? UIEvent.SHOW_TIP : UIEvent.HIDE_TIP, _toolTip, true));
    }

    /**居父容器顶部的距离*/
    public var top(get, set):Float;

    private function get_top():Float {
        return _top;
    }

    private function set_top(value:Float):Float {
        _top = value;
        layOutEnabled = true;
        return value;
    }

    /**居父容器底部的距离*/
    public var bottom(get, set):Float;

    private function get_bottom():Float {
        return _bottom;
    }

    private function set_bottom(value:Float):Float {
        _bottom = value;
        layOutEnabled = true;
        return value;
    }

    /**居父容器左边的距离*/
    public var left(get, set):Float;

    private function get_left():Float {
        return _left;
    }

    private function set_left(value:Float):Float {
        _left = value;
        layOutEnabled = true;
        return value;
    }

    /**居父容器右边的距离*/
    public var right(get, set):Float;

    private function get_right():Float {
        return _right;
    }

    private function set_right(value:Float):Float {
        _right = value;
        layOutEnabled = true;
        return value;
    }

    /**居父容器水平居中位置的偏移*/
    public var centerX(get, set):Float;

    private function get_centerX():Float {
        return _centerX;
    }

    private function set_centerX(value:Float):Float {
        _centerX = value;
        layOutEnabled = true;
        return value;
    }

    /**居父容器垂直居中位置的偏移*/
    public var centerY(get, set):Float;

    private function get_centerY():Float {
        return _centerY;
    }

    private function set_centerY(value:Float):Float {
        _centerY = value;
        layOutEnabled = true;
        return value;
    }
    public var layOutEnabled(null, set):Bool;

    private function set_layOutEnabled(value:Bool):Bool {
        if (_layOutEnabled != value) {
            _layOutEnabled = value;
            addEventListener(Event.ADDED, onAdded);
            addEventListener(Event.REMOVED, onRemoved);
        }
        callLater(_resetPosition);
        return value;
    }

    private function onRemoved(e:Event):Void {
        if (e.target == this) {
            parent.removeEventListener(Event.RESIZE, onCompResize);
        }
    }

    private function onAdded(e:Event):Void {
        if (e.target == this) {
            parent.addEventListener(Event.RESIZE, onCompResize);
            callLater(_resetPosition);
        }
    }

    private function onCompResize(e:Event):Void {
        callLater(_resetPosition);
    }
    /**重置位置*/

    private function resetPosition():Void {
        if (parent != null) {
            if (!Math.isNaN(_centerX)) {
                x = Std.int((parent.width - displayWidth) * 0.5 + _centerX);
            } else if (!Math.isNaN(_left)) {
                x = _left;
                if (!Math.isNaN(_right)) {
                    width = (parent.width - _left - _right) / scaleX;
                }
            } else if (!Math.isNaN(_right)) {
                x = parent.width - displayWidth - _right;
            }
            if (!Math.isNaN(_centerY)) {
                y = Std.int((parent.height - displayHeight) * 0.5 + _centerY);
            } else if (!Math.isNaN(_top)) {
                y = _top;
                if (!Math.isNaN(_bottom)) {
                    height = (parent.height - _top - _bottom) / scaleY;
                }
            } else if (!Math.isNaN(_bottom)) {
                y = parent.height - displayHeight - _bottom;
            }
        }
    }

    public override function addChild(child:DisplayObject):DisplayObject {
        if (doubleClickEnabled && Std.is(child, InteractiveObject)) {
            var c:Dynamic = child;
            c.doubleClickEnabled = true;
        }
        return super.addChild(child);
    }

    public override function addChildAt(child:DisplayObject, index:Int):DisplayObject {
        if (doubleClickEnabled && Std.is(child, InteractiveObject)) {
            var c:Dynamic = child;
            c.doubleClickEnabled = true;
        }
        return super.addChildAt(child, index);
    }

    /**销毁*/

    public function dispose():Void {
        _tag = null;
        _comXml = null;
        _comJSON = null;
        _dataSource = null;
        _toolTip = null;
    }
}
