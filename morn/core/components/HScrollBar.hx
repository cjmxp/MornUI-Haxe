package morn.core.components;
class HScrollBar extends ScrollBar {
    public function new(skin:String = null) {
        super(skin);
    }
    private override function initialize():Void {
        _slider.direction = ScrollBar.HORIZONTAL;
        super.initialize();
    }
}
