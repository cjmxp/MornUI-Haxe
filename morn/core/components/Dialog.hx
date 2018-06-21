package morn.core.components;
import morn.core.utils.StringUtils;
import openfl.events.MouseEvent;
import openfl.display.DisplayObject;
import morn.core.handlers.Handler;
import openfl.geom.Rectangle;
class Dialog extends View{
    public static var CLOSE(default, never):String = "close";
    public static var CANCEL(default, never):String = "cancel";
    public static var SURE(default, never):String = "sure";
    public static var NO(default, never):String = "no";
    public static var OK(default, never):String = "ok";
    public static var YES(default, never):String = "yes";

    private var _dragArea:Rectangle;
    private var _popupCenter:Bool = true;
    private var _closeHandler:Handler;
    public function new() {
        super();
    }
    private override  function initialize():Void {
        var dragTarget:DisplayObject = getChildByName("drag");
        if (dragTarget!=null) {
            dragArea = dragTarget.x + "," + dragTarget.y + "," + dragTarget.width + "," + dragTarget.height;
            removeElement(dragTarget);
        }
        addEventListener(MouseEvent.CLICK, onClick);
    }
    /**默认按钮处理*/
    private function onClick(e:MouseEvent):Void {
        if(Std.is(e.target,Button)){
            var btn:Button = cast(e.target,Button);
            if (btn!=null) {
                switch (btn.name) {
                    case CLOSE | CANCEL | SURE | NO | OK | YES:
                        close(btn.name);
                }
            }
        }
    }
    /**显示对话框(非模式窗口)
	* @param closeOther 是否关闭其他对话框*/
    public function show(closeOther:Bool = false):Void {
        App.dialog.show(this, closeOther);
    }
    /**显示对话框(模式窗口)
	* @param closeOther 是否关闭其他对话框*/
    public function popup(closeOther:Bool = false):Void {
        App.dialog.popup(this, closeOther);
    }
    /**关闭对话框*/
    public function close(type:String = null):Void {
        App.dialog.close(this);
        if (_closeHandler != null) {
            _closeHandler.Function(type);
        }
    }
    /**拖动区域(格式:x:Number=0, y:Number=0, width:Number=0, height:Number=0)*/
    public var dragArea(get,set):String;
    private function get_dragArea():String {
        return StringUtils.rectToString(_dragArea);
    }
    private function set_dragArea(value:String):String {
        if (value!=null && value!="") {
            var a:Array<Int> = StringUtils.fillArray([0, 0, 0, 0], value);
            _dragArea = new Rectangle(a[0], a[1], a[2], a[3]);
            addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        } else {
            _dragArea = null;
            removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        }
        return value;
    }
    private function onMouseDown(e:MouseEvent):Void {
        if (_dragArea.contains(mouseX, mouseY)) {
            App.drag.doDrag(this);
        }
    }
    /**是否弹出*/
    public var isPopup(get,never):Bool;
    private function get_isPopup():Bool {
        return parent != null;
    }
    /**是否居中弹出*/
    public var popupCenter(get,set):Bool;
    private function get_popupCenter():Bool {
        return _popupCenter;
    }
    private function set_popupCenter(value:Bool):Bool {
        _popupCenter = value;
        return value;
    }

    /**关闭回调(返回按钮名称name:String)*/
    public var closeHandler(get,set):Handler;
    private function get_closeHandler():Handler {
        return _closeHandler;
    }
    private function set_closeHandler(value:Handler):Handler {
        _closeHandler = value;
        return value;
    }
}
