package morn.core.components;
import morn.core.handlers.Handler;
import openfl.events.Event;
import openfl.display.DisplayObject;
class LayoutBox extends Box {
    private var _space:Float = 0;
    private var _align:String = "none";
    private var _maxX:Float = 0;
    private var _maxY:Float = 0;
    private var _changeItems:Handler;
    public function new() {
        super();
        _changeItems=new Handler(changeItems.bind());
    }
    override public function addChild(child:DisplayObject):DisplayObject {
        setChild(child);
        child.addEventListener(Event.RESIZE, onResize);
        callLater(_changeItems);
        return super.addChild(child);
    }
    private function setChild(child:DisplayObject):Void {
        if (Std.is(child,Component)) {
            if (child.x == 0) {
                child.x = ++_maxX;
            }
            if (child.y == 0) {
                child.y = ++_maxY;
            }
        }
    }
    private function onResize(e:Event):Void {
        callLater(_changeItems);
    }
    override public function addChildAt(child:DisplayObject, index:Int):DisplayObject {
        setChild(child);
        child.addEventListener(Event.RESIZE, onResize);
        callLater(_changeItems);
        return super.addChildAt(child, index);
    }
    override public function removeChild(child:DisplayObject):DisplayObject {
        child.removeEventListener(Event.RESIZE, onResize);
        callLater(_changeItems);
        return super.removeChild(child);
    }
    override public function removeChildAt(index:Int):DisplayObject {
        getChildAt(index).removeEventListener(Event.RESIZE, onResize);
        callLater(_changeItems);
        return super.removeChildAt(index);
    }
    override public function commitMeasure():Void {
        exeCallLater(_changeItems);
    }
    /**刷新*/
    public function refresh():Void {
        callLater(_changeItems);
    }
    private function changeItems():Void {
    }
    /**子对象的间隔*/
    public var space(get,set):Float;
    private function get_space():Float {
        return _space;
    }
    private function set_space(value:Float):Float {
        _space = value;
        callLater(_changeItems);
        return value;
    }
    /**子对象对齐方式*/
    public var align(get,set):String;
    private function get_align():String {
        return _align;
    }
    private function set_align(value:String):String {
        _align = value;
        callLater(_changeItems);
        return value;
    }
}
