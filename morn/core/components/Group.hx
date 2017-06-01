package morn.core.components;
import openfl.events.Event;
import openfl.display.DisplayObject;
import morn.core.handlers.Handler;
class Group extends Box implements IItem {
    private var _items:Array<ISelect>=null;
    private var _selectHandler:Handler=null;
    private var _changeLabels:Handler=null;
    private var _selectedIndex:Int = -1;
    private var _skin:String=null;
    private var _labels:String=null;
    private var _labelColors:String=null;
    private var _labelStroke:String=null;
    private var _labelSize:Dynamic=null;
    private var _labelBold:Dynamic=null;
    private var _labelMargin:String=null;
    private var _direction:String=null;
    private var _space:Float = 0;
    public function new(labels:String = null, skin:String = null) {
        super();
        this.skin = skin;
        this.labels = labels;
        this._changeLabels=new Handler(changeLabels.bind());
    }
    /**增加项，返回索引id
	* @param autoLayOut 是否自动布局，如果为true，会根据direction和space属性计算item的位置*/
    public function addItem(item:ISelect, autoLayOut:Bool = true):Int {
        var display:DisplayObject = cast(item,DisplayObject);
        var index:Int = _items.length;
        display.name = "item" + index;
        addChild(display);
        initItems();
        if (autoLayOut && index > 0) {
            var preItem:DisplayObject = cast(_items[index - 1],DisplayObject);
            if (_direction == "horizontal") {
                display.x = preItem.x + preItem.width + _space;
            } else {
                display.y = preItem.y + preItem.height + _space;
            }
        }
        return index;
    }
    /**删除项
	* @param autoLayOut 是否自动布局，如果为true，会根据direction和space属性计算item的位置*/
    public function delItem(item:ISelect, autoLayOut:Bool = true):Void {
        var index:Int = _items.indexOf(item);
        if (index != -1) {
            var display:DisplayObject = cast(item,DisplayObject);
            removeChild(display);
            for(i in (index + 1)..._items.length){
                var child:DisplayObject = cast(_items[i],DisplayObject);
                child.name = "item" + (i - 1);
                if (autoLayOut) {
                    if (_direction == "horizontal") {
                        child.x -= display.width + _space;
                    } else {
                        child.y -= display.height + _space;
                    }
                }
            }
            initItems();
            if (_selectedIndex > -1) {
                selectedIndex = _selectedIndex < _items.length ? _selectedIndex : (_selectedIndex - 1);
            }
        }
    }
    /**初始化*/
    public function initItems():Void {
        _items = new Array<ISelect>();
        var temp:Dynamic;
        var item:ISelect;
        for (i in 0...5000) {
            temp = getChildByName("item" + i);
            if(temp==null) {
                break;
            }
            item=cast(temp,ISelect);
            _items.push(item);
            item.selected = (i == _selectedIndex);
            item.clickHandler = new Handler(itemClick.bind(i));
        }
    }
    private function itemClick(index:Int):Void {
        selectedIndex = index;
    }
    /**所选按钮的索引，默认为-1*/
    public var selectedIndex(get,set):Int;
    private function get_selectedIndex():Int {
        return _selectedIndex;
    }
    private function set_selectedIndex(value:Int):Int {
        value = Std.int(value);
        if (_selectedIndex != value) {
            setSelect(_selectedIndex, false);
            _selectedIndex = value;
            setSelect(_selectedIndex, true);
            sendEvent(Event.CHANGE);
            //兼容老版本
            sendEvent(Event.SELECT);
            if (_selectHandler != null) {
                _selectHandler.Function(_selectedIndex);
            }
        }
        return value;
    }
    private function setSelect(index:Int, selected:Bool):Void {
        if (_items!=null && index > -1 && index < _items.length) {
            _items[index].selected = selected;
        }
    }
    /**选择被改变时执行的处理器(默认返回参数index:int)*/
    public var selectHandler(get,set):Handler;
    private function get_selectHandler():Handler {
        return _selectHandler;
    }
    private function set_selectHandler(value:Handler):Handler {
        _selectHandler = value;
        return value;
    }
    /**皮肤*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _skin;
    }
    private function set_skin(value:String):String {
        if (_skin != value) {
            _skin = value;
            callLater(_changeLabels);
        }
        return value;
    }
    /**标签集合*/
    public var labels(get,set):String;
    private function get_labels():String {
        return _labels;
    }
    private function set_labels(value:String):String {
        if (_labels != value) {
            _labels = value;
            removeAllChild();
            callLater(_changeLabels);
            if (_labels!=null && _labels!="") {
                var a:Array<String> = App.lang.getLang(_labels).split(",");
                for (i in 0...a.length) {
                    var item:DisplayObject = createItem(_skin, a[i]);
                    item.name = "item" + i;
                    addChild(item);
                }
            }
            initItems();
        }
        return value;
    }
    private function createItem(skin:String, label:String):DisplayObject {
        return null;
    }
    /**按钮标签颜色(格式:upColor,overColor,downColor,disableColor)*/
    public var labelColors(get,set):String;
    private function get_labelColors():String {
        return _labelColors;
    }
    private function set_labelColors(value:String):String {
        if (_labelColors != value) {
            _labelColors = value;
            callLater(_changeLabels);
        }
        return value;
    }
    /**按钮标签描边(格式:color,alpha,blurX,blurY,strength,quality)*/
    public var labelStroke(get,set):String;
    private function get_labelStroke():String {
        return _labelStroke;
    }
    private function set_labelStroke(value:String):String {
        if (_labelStroke != value) {
            _labelStroke = value;
            callLater(_changeLabels);
        }
        return value;
    }
    /**按钮标签大小*/
    public var labelSize(get,set):Dynamic;
    private function get_labelSize():Dynamic {
        return _labelSize;
    }
    private function set_labelSize(value:Dynamic):Dynamic {
        if (_labelSize != value) {
            _labelSize = value;
            callLater(_changeLabels);
        }
        return value;
    }
    /**按钮标签粗细*/
    public var labelBold(get,set):Dynamic;
    private function get_labelBold():Dynamic {
        return _labelBold;
    }
    private function set_labelBold(value:Dynamic):Dynamic {
        if (_labelBold != value) {
            _labelBold = value;
            callLater(_changeLabels);
        }
        return value;
    }
    /**按钮标签边距(格式:左边距,上边距,右边距,下边距)*/
    public var labelMargin(get,set):String;
    private function get_labelMargin():String {
        return _labelMargin;
    }
    private function set_labelMargin(value:String):String {
        if (_labelMargin != value) {
            _labelMargin = value;
            callLater(_changeLabels);
        }
        return value;
    }
    /**布局方向*/
    public var direction(get,set):String;
    private function get_direction():String {
        return _direction;
    }
    private function set_direction(value:String):String {
        _direction = value;
        callLater(_changeLabels);
        return value;
    }
    /**间隔*/
    public var space(get,set):Float;
    private function get_space():Float {
        return _space;
    }
    private function set_space(value:Float):Float {
        value = Std.parseFloat(Std.string(value));
        _space = value;
        callLater(_changeLabels);
        return value;
    }
    private function changeLabels():Void {
    }

    /**按钮集合*/
    public var items(get,never):Array<ISelect>;
    public function get_items():Array<ISelect> {
        return _items;
    }
    /**选择项*/
    public var selection(get,set):ISelect;
    private function get_selection():ISelect {
        return _selectedIndex > -1 && _selectedIndex < _items.length ? _items[_selectedIndex] : null;
    }
    private function set_selection(value:ISelect):ISelect {
        selectedIndex = _items.indexOf(value);
        return value;
    }

    override public function commitMeasure():Void {
        exeCallLater(_changeLabels);
    }

    override public function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Int)  || Std.is(value,String)) {
            selectedIndex = Std.parseInt(Std.string(value));
        } else if (Std.is(value,Array)) {
            labels = value.join(",");
        } else {
            super.dataSource = value;
        }
        return value;
    }

    /**销毁*/
    override public function dispose():Void {
        super.dispose();
        if (_items!=null) {
            _items=[];
        }
        _items = null;
        _selectHandler = null;
    }
}
