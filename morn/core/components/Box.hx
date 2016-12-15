package morn.core.components;
import openfl.display.DisplayObject;
class Box extends Component implements IBox {
    public function new() {
        super();
    }
    private override function preinitialize():Void
    {
        mouseChildren = true;
    }
    /**添加显示对象*/
    public function addElement(element:DisplayObject, x:Float, y:Float):Void {
        element.x = x;
        element.y = y;
        addChild(element);
    }
    /**增加显示对象到index层*/
    public function addElementAt(element:DisplayObject, index:Int, x:Float, y:Float):Void {
        element.x = x;
        element.y = y;
        addChildAt(element, index);
    }
    /**批量增加显示对象*/
    public function addElements(elements:Array<DisplayObject>):Void {
        for(i in 0...elements.length){
            var item:DisplayObject = elements[i];
            if(item!=null){
                addChild(item);
            }
        }
    }
    /**删除子显示对象，子对象为空或者不包含子对象时不抛出异常*/
    public function removeElement(element:DisplayObject):Void {
        if (element!=null && element.parent==this) {
            removeChild(element);
        }
    }
    /**删除所有子显示对象
	* @param except 例外的对象(不会被删除)*/
    public function removeAllChild(except:DisplayObject = null):Void {
        var len:Int=numChildren-1;
        while(len>0){
            if (except != getChildAt(len)) {
                removeChildAt(len);
            }
            len--;
        }
    }
    /**增加显示对象到某对象上面
    @param element 要插入的对象
	@param compare 参考的对象*/
    public function insertAbove(element:DisplayObject, compare:DisplayObject):Void {
        removeElement(element);
        var index:Int = getChildIndex(compare);
        index=Std.int(Math.min(index + 1, numChildren));
        addChildAt(element, index);
    }
    /**增加显示对象到某对象下面
	@param element 要插入的对象
	@param compare 参考的对象*/
    public function insertBelow(element:DisplayObject, compare:DisplayObject):Void {
        removeElement(element);
        var index:Int = getChildIndex(compare);
        index=Std.int(Math.max(index, 0));
        addChildAt(element, index);
    }
     private override function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        var fields:Array<Dynamic> = Reflect.fields(_dataSource);
        for (name in fields) {
            var value:Dynamic = Reflect.field(_dataSource, name);
            var comp:Dynamic = getChildByName(name);
            if(comp!=null && Std.is(comp,Component)){
                comp.dataSource=value;
            }else{
                if (Reflect.hasField(this, name)) {
                    Reflect.setField(this, name, value);
                }
            }
        }
         return value;
    }
}
