package morn.core.components;
class CheckBox extends Button {
    public function new(skin:String = null, label:String = "") {
        super(skin, label);
    }
    private override function preinitialize():Void {
        super.preinitialize();
        _toggle = true;
        _autoSize = false;
    }

    private override function initialize():Void {
        super.initialize();
        _btnLabel.autoSize = "left";
    }
    private override  function changeLabelSize():Void {
        exeCallLater(_changeClips);
        trace(_bitmap.height ,_btnLabel.height);
        _btnLabel.x = _bitmap.width + _labelMargin[0];
        _btnLabel.y = (_bitmap.height - _btnLabel.textHeight) * 0.5 + _labelMargin[1];
    }
    public override function commitMeasure():Void {
        exeCallLater(_changeLabelSize);
    }
    override public function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Bool)) {
            selected = value;
        } else if (Std.is(value,String)) {
            selected = value == "true"?true:false;
        } else {
            super.dataSource = value;
        }
        return value;
    }
}
