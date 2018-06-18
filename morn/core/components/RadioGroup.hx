package morn.core.components;
/**单选按钮组，默认selectedIndex=-1*/
import openfl.display.DisplayObject;
class RadioGroup extends Group {
    /**横向的*/
    public static var HORIZENTAL:String = "horizontal";
    /**纵向的*/
    public static var VERTICAL:String = "vertical";
    public function new(labels:String = null, skin:String = null) {
        super(labels, skin);
        _direction = HORIZENTAL;
    }
    override private function createItem(skin:String, label:String):DisplayObject {
        return new RadioButton(skin, label);
    }
    override private function changeLabels():Void {
        if (_items!=null) {
            var left:Float = 0.0;
            for (i in 0..._items.length) {
                var radio:RadioButton = cast(_items[i],RadioButton);
                if(radio!=null){
                    if(_skin!=null)radio.skin = _skin;
                    if(_labelColors!=null) radio.labelColors = _labelColors;
                    if(_labelStroke!=null)radio.labelStroke = _labelStroke;
                    if(_labelSize!=null) radio.labelSize = _labelSize;
                    if(_labelBold!=null) radio.labelBold = _labelBold;
                    if(_labelMargin!=null)radio.labelMargin = _labelMargin;
                    if(_direction == HORIZENTAL) {
                        radio.y = 0;
                        radio.x = left;
                        left += radio.width + _space;
                    } else {
                        radio.x = 0;
                        radio.y = left;
                        left += radio.height + _space;
                    }
                }
            }
        }
    }
}
