package morn.core.events;
import flash.events.Event;
class UIEvent extends Event {
    //-----------------Component-----------------
    /**移动组件*/
    public static var MOVE(default, never):String = "move";
    /**更新完毕*/
    public static var RENDER_COMPLETED(default, never):String = "renderCompleted";
        /**显示鼠标提示*/
    public static var SHOW_TIP(default, never):String = "showTip";
        /**隐藏鼠标提示*/
    public static var HIDE_TIP(default, never):String = "hideTip";
        //-----------------Image-----------------
        /**图片加载完毕*/
    public static var IMAGE_LOADED(default, never):String = "imageLoaded";
        //-----------------TextArea-----------------
        /**滚动*/
    public static var SCROLL(default, never):String = "scroll";
        //-----------------FrameClip-----------------
        /**帧跳动*/
    public static var FRAME_CHANGED(default, never):String = "frameChanged";
        //-----------------List-----------------
        /**项渲染*/
    public static var ITEM_RENDER(default, never):String = "listRender";

    public var data(get,set):Dynamic;

    private var _data:Dynamic;

    public function new(type:String,data:Dynamic, bubbles:Bool = false, cancelable:Bool = false) {
        super(type, bubbles, cancelable);
        _data = data;
    }
    /**事件数据*/
    public function get_data():Dynamic {
        return _data;
    }
    public function set_data(value:Dynamic):Dynamic {
        _data = value;
        return _data;
    }
    override public function clone():Event {
        return new UIEvent(type, _data, bubbles, cancelable);
    }
}
