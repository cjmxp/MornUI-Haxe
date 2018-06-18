package morn.core.components;
class VScrollBar extends ScrollBar {
    public function new(skin:String = null) {
        super(skin);
    }
    private override function initialize():Void {
        _slider.direction = ScrollBar.VERTICAL;
        super.initialize();
    }
}
