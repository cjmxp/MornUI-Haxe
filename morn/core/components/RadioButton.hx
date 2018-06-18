package morn.core.components;
import openfl.events.MouseEvent;
class RadioButton extends Button {
    private var _value:Dynamic;
    public function new(skin:String = null, label:String = "") {
        super(skin, label);
    }
    /**销毁*/
    override public function dispose():Void {
        super.dispose();
        _value = null;
    }
    override private function preinitialize():Void {
        super.preinitialize();
        _toggle = false;
        _autoSize = false;
    }
    override private function initialize():Void {
        super.initialize();
        _btnLabel.autoSize = "left";
        addEventListener(MouseEvent.CLICK, onClick);
    }
    override private function changeLabelSize():Void {
        exeCallLater(_changeClips);
        _btnLabel.x = _bitmap.width + _labelMargin[0];
        _btnLabel.y = (_bitmap.height - _btnLabel.height) * 0.5 + _labelMargin[1];
    }
    override public function commitMeasure():Void {
        exeCallLater(_changeLabelSize);
    }
    private function onClick(e:MouseEvent):Void {
        selected = true;
    }
    /**组件关联的可选用户定义值*/
    public var value(get,set):Dynamic;
    private function get_value():Dynamic {
        return _value != null ? _value : label;
    }
    private function set_value(obj:Dynamic):Dynamic {
        _value = obj;
        return _value;
    }
}
