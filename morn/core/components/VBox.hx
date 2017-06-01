package morn.core.components;
/**VBox容器*/
class VBox extends LayoutBox {
    public static var NONE:String = "none";
    public static var LEFT:String = "left";
    public static var CENTER:String = "center";
    public static var RIGHT:String = "right";
    public function new() {
        super();
    }
    private function sortOn(a:Component,b:Component):Int{
        return Std.int(a.y-b.y);
    }
    override private function changeItems():Void {
        var items:Array<Component> = [];
        var maxWidth:Float = 0.0;
        for (i in 0...numChildren) {
            var item:Component = cast(getChildAt(i),Component);
            if (item!=null) {
                items.push(item);
                maxWidth = Math.max(maxWidth, item.displayWidth);
            }
        }
        items.sort(this.sortOn);
        var top:Float = 0.0;
        for(item in items) {
            item.y = _maxY = top;
            top += item.displayHeight + _space;
            if (_align == LEFT) {
                item.x = 0;
            } else if (_align == CENTER) {
                item.x = (maxWidth - item.displayWidth) * 0.5;
            } else if (_align == RIGHT) {
                item.x = maxWidth - item.displayWidth;
            }
        }
        changeSize();
    }
}
