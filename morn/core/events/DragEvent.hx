package morn.core.events;
import openfl.display.DisplayObject;
import openfl.events.Event;
class DragEvent extends Event {
    public static var DRAG_START(default, never):String = "dragStart";
    public static var DRAG_DROP(default, never):String = "dragDrop";
    public static var DRAG_COMPLETE(default, never):String = "dragComplete";
    private var _data:Dynamic;
    private var _dragInitiator:DisplayObject;
    public function new(type:String, dragInitiator:DisplayObject = null, data:Dynamic = null, bubbles:Bool = true, cancelable:Bool = false) {
        super(type, bubbles, cancelable);
        _dragInitiator = dragInitiator;
        _data = data;
    }
    /**拖动的源对象*/
    public var dragInitiator(get,set):DisplayObject;
    private function get_dragInitiator():DisplayObject {
        return _dragInitiator;
    }
    private function set_dragInitiator(value:DisplayObject):DisplayObject {
        _dragInitiator = value;
        return value;
    }
    /**拖动传递的数据*/
    public var data(get,set):Dynamic;
    private function get_data():Dynamic {
        return _data;
    }
    private function set_data(value:Dynamic):Dynamic {
        _data = value;
        return value;
    }
    public override function clone():Event {
        return new DragEvent(type, _dragInitiator, _data, bubbles, cancelable);
    }
}
