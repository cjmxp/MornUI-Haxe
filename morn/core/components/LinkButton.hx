package morn.core.components;
class LinkButton extends Button {
    public function new(label:String = "") {
        super(null,label);
    }
    private override function preinitialize():Void
    {
        super.preinitialize();
        _labelColors = App.linkLabelColors;
        _autoSize = false;
        buttonMode = true;
    }
    private override function initialize():Void {
        super.initialize();
        _btnLabel.underline = true;
        _btnLabel.autoSize = "left";
        _btnLabel.mouseEnabled=true;
    }
    private override function changeLabelSize():Void {
    }
}
