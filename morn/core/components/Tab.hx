package morn.core.components;
/**Tab标签，默认selectedIndex=-1*/
import openfl.display.DisplayObject;
class Tab extends Group{
    /**横向的*/
    public static var HORIZENTAL:String = "horizontal";
    /**纵向的*/
    public static var VERTICAL:String = "vertical";
    public function new(labels:String = null, skin:String = null) {
        super(labels, skin);
        _direction = HORIZENTAL;
    }
    override private function createItem(skin:String, label:String):DisplayObject {
        return new Button(skin, label);
    }
    override private function changeLabels():Void {
        if (_items!=null) {
            var left:Float = 0.0;
            for (i in 0..._items.length) {
                var btn:Button = cast(_items[i],Button);
                if(btn!=null){
                    if (_skin!=null)btn.skin = _skin;
                    if (_labelColors!=null)btn.labelColors = _labelColors;
                    if (_labelStroke!=null)btn.labelStroke = _labelStroke;
                    if (_labelSize!=null)btn.labelSize = _labelSize;
                    if (_labelBold!=null)btn.labelBold = _labelBold;
                    if (_labelMargin!=null)btn.labelMargin = _labelMargin;
                    if (_direction == HORIZENTAL) {
                        btn.y = 0;
                        btn.x = left;
                        left += btn.width + _space;
                    } else {
                        btn.x = 0;
                        btn.y = left;
                        left += btn.height + _space;
                    }
                }
            }
        }
    }
}
