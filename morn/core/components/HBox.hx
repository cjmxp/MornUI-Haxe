package morn.core.components;
class HBox extends LayoutBox {
    public static var NONE:String = "none";
    public static var TOP:String = "top";
    public static var MIDDLE:String = "middle";
    public static var BOTTOM:String = "bottom";
    public function new() {
        super();
    }
    private function sortOn(a:Component,b:Component):Int{
        return Std.int(a.x-b.x);
    }
    override private function changeItems():Void {
        var items:Array<Component> = [];
        var maxHeight:Float = 0.0;
        for (i in 0...numChildren) {
            var item:Component = cast(getChildAt(i),Component) ;
            if (item!=null) {
                items.push(item);
                maxHeight = Math.max(maxHeight, item.displayHeight);
            }
        }
        items.sort(this.sortOn);
        var left:Float = 0.0;
        for(item in items) {
            item.x = _maxX = left;
            left += item.displayWidth + _space;
            if (_align == TOP) {
                item.y = 0;
            } else if (_align == MIDDLE) {
                item.y = (maxHeight - item.displayHeight) * 0.5;
            } else if (_align == BOTTOM) {
                item.y = maxHeight - item.displayHeight;
            }
        }
        changeSize();
    }
}
