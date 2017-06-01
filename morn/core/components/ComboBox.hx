package morn.core.components;
import openfl.display.Graphics;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.text.TextFormat;
import morn.core.utils.ObjectUtils;
import morn.core.utils.StringUtils;
import openfl.events.Event;
import openfl.events.MouseEvent;
import morn.core.handlers.Handler;
class ComboBox extends Component {
    /**向上方向*/
    public static var UP:String = "up";
    /**向下方向*/
    public static var DOWN:String = "down";
    private var _visibleNum:Int = 6;
    private var _button:Button=null;
    private var _list:List=null;
    private var _isOpen:Bool=false;
    private var _scrollBar:VScrollBar=null;
    private var _itemColors:Array<UInt> = App.comboBoxItemColors;
    private var _itemSize:Int = App.fontSize;
    private var _labels:Array<Dynamic> = [];
    private var _selectedIndex:Int = -1;
    private var _selectHandler:Handler=null;
    private var _itemHeight:Float=Math.NaN;
    private var _listHeight:Float=Math.NaN;
    private var _changeOpen:Handler=null;
    private var _changeList:Handler=null;
    private var _changeItem:Handler=null;
    public function new(skin:String = null, labels:String = null) {
        _changeOpen=new Handler(changeOpen.bind());
        _changeList=new Handler(changeList.bind());
        _changeItem=new Handler(changeItem.bind());
        super();
        if(skin!=null) this.skin = skin;
        if(labels!=null) this.labels = labels;
    }
    /**销毁*/
    override public function dispose():Void {
        super.dispose();
        if(_button!=null) _button.dispose();
        if(_list!=null) _list.dispose();
        if(_scrollBar!=null) _scrollBar.dispose();
        _button = null;
        _list = null;
        _scrollBar = null;
        _itemColors = null;
        _labels = null;
        _selectHandler = null;
    }
    override private function preinitialize():Void {
        mouseChildren = true;
    }
    override private function createChildren():Void {
        _button = new Button();
        addChild(_button);
        _list = new List();
        _list.mouseHandler = new Handler(onlistItemMouse.bind());
        _scrollBar = new VScrollBar();
        _list.addChild(_scrollBar);
    }
    override private function initialize():Void {
        _button.btnLabel.align = "left";
        _button.labelMargin = "5";
        _button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
        _list.addEventListener(Event.CHANGE, onListChange);
        _scrollBar.name = "scrollBar";
        _scrollBar.y = 1;
    }
    private function onButtonMouseDown(e:MouseEvent):Void {
        callLater(_changeOpen);
    }

    private function onListChange(e:Event):Void {
        selectedIndex = _list.selectedIndex;
    }
    public var skin(get,set):String;
    /**皮肤*/
    private function get_skin():String {
        return _button.skin;
    }
    private function set_skin(value:String):String {
        if (_button.skin != value) {
            _button.skin = value;
            _contentWidth = _button.width;
            _contentHeight = _button.height;
            callLater(_changeList);
        }
        return _button.skin;
    }
    private function changeList():Void {
        var labelWidth:Float = width - 2;
        var labelColor:Float = _itemColors[2];
        _itemHeight = ObjectUtils.getTextField(new TextFormat(App.fontName, _itemSize)).height + 3;
        _list.itemRender = Xml.parse("<Box width='" + labelWidth + "' height='" + Std.string(_itemHeight+1) + "'><Label mouseEnabled='true' name='label' width='" + labelWidth + "' size='" + _itemSize + "' height='" + _itemHeight + "' color='" + labelColor + "' x='2'/></Box>");
        _list.repeatX=1;
        _list.repeatY = _visibleNum;
        _scrollBar.x = width - _scrollBar.width - 1;
        _list.refresh();
    }
    private function onlistItemMouse(e:MouseEvent, index:Int):Void {
        var type:String = e.type;
        if (type == MouseEvent.CLICK || type == MouseEvent.ROLL_OVER || type == MouseEvent.ROLL_OUT) {
            var box:Box = _list.getCell(index);
            var label:Label = cast(box.getChildByName("label"),Label);
            if(label!=null){
                if (type == MouseEvent.ROLL_OVER) {
                    label.background = true;
                    label.backgroundColor = _itemColors[0];
                    label.color = _itemColors[1];
                } else {
                    label.background = false;
                    label.color = _itemColors[2];
                }
            }
            if (type == MouseEvent.CLICK) {
                isOpen = false;
            }
        }
    }
    private function changeOpen():Void {
        isOpen = !_isOpen;
    }
    #if flash
    @:setter(width)
    override private function set_width(value:Float):Void {
        super.width = value;
        _button.width = _width;
        callLater(_changeItem);
        callLater(_changeList);
    }
    @:setter(height)
    override private function set_height(value:Float):Void {
        super.height = value;
        _button.height = _height;
    }
    #else
    override private function set_width(value:Float):Float {
        super.width = value;
        _button.width = _width;
        callLater(_changeItem);
        callLater(_changeList);
        return value;
    }
    override private function set_height(value:Float):Float {
        super.height = value;
        _button.height = _height;
        return value;
    }
    #end
    /**标签集合*/
    public var labels(get,set):String;
    private function get_labels():String {
        return _labels.join(",");
    }
    private function set_labels(value:String):String {
        if (_labels.length>0) {
            selectedIndex = -1;
        }
        if (value!=null && value!="") {
            _labels = value.split(",");
        } else {
            _labels=[];
        }
        callLater(_changeItem);
        return value;
    }
    private function changeItem():Void {
        //赋值之前需要先初始化列表
        exeCallLater(_changeList);
        //显示边框
        _listHeight = _labels.length > 0 ? Math.min(_visibleNum, _labels.length) * _itemHeight : _itemHeight;
        _scrollBar.height = _listHeight - 2;
        //填充背景
        var g:Graphics = _list.graphics;
        g.clear();
        #if flash
        g.lineStyle(1.0, _itemColors[3]);
        g.beginFill(_itemColors[4]);
        g.drawRect(0.0, 0.0, width-1, _listHeight+2);
        #else
        g.lineStyle(1.0, _itemColors[3]);
        g.beginFill(_itemColors[4]);
        g.drawRect(1.0, 0.0, width-2, _listHeight+2);
        #end
        g.endFill();
        //填充数据
        var a:Array<Dynamic> = [];
        for (i in 0..._labels.length) {
            a.push({label: _labels[i]});
        }
        _list.array = a;
        //重新设置selectindex
        var index:Int = _selectedIndex;
        _selectedIndex = -2;
        selectedIndex = index;
    }
    /**选择索引*/
    public var selectedIndex(get,set):Int;
    private function get_selectedIndex():Int {
        return _selectedIndex;
    }
    private function set_selectedIndex(value:Int):Int {
        if (_selectedIndex != value) {
            _list.selectedIndex = value;
            _selectedIndex = value;
            _button.label = selectedLabel;
            sendEvent(Event.CHANGE);
            //兼容老版本
            sendEvent(Event.SELECT);
            if (_selectHandler != null) {
                _selectHandler.Function(_selectedIndex);
            }
        }
        return _selectedIndex;
    }
    /**选择被改变时执行的处理器(默认返回参数index:int)*/
    public var selectHandler(get,set):Handler;
    private function get_selectHandler():Handler {
        return _selectHandler;
    }
    private function set_selectHandler(value:Handler):Handler {
        _selectHandler = value;
        return _selectHandler;
    }
    /**选择标签*/
    public var selectedLabel(get,set):String;
    private function get_selectedLabel():String {
        return _selectedIndex > -1 && _selectedIndex < _labels.length ? _labels[_selectedIndex] : null;
    }
    private function set_selectedLabel(value:String):String {
        selectedIndex = _labels.indexOf(value);
        return value;
    }
    /**可见项数量*/
    public var visibleNum(get,set):Int;
    private function get_visibleNum():Int {
        return _visibleNum;
    }
    private function set_visibleNum(value:Int):Int {
        _visibleNum = value;
        callLater(_changeList);
        return _visibleNum;
    }
    /**项颜色(格式:overBgColor,overLabelColor,outLableColor,borderColor,bgColor)*/
    public var itemColors(get,set):String;
    private function get_itemColors():String {
        return _itemColors.join(",");
    }
    private function set_itemColors(value:String):String {
        _itemColors = StringUtils.fillArray(_itemColors, value);
        callLater(_changeList);
        return value;
    }
    /**项字体大小*/
    public var itemSize(get,set):Int;
    private function get_itemSize():Int {
        return _itemSize;
    }
    private function set_itemSize(value:Int):Int {
        _itemSize = value;
        callLater(_changeList);
        return value;
    }
    /**是否打开*/
    public var isOpen(get,set):Bool;
    private function get_isOpen():Bool {
        return _isOpen;
    }
    private function set_isOpen(value:Bool):Bool {
        if (_isOpen != value) {
            _isOpen = value;
            _button.selected = _isOpen;
            if (_isOpen) {
                _list.setPosition(0, _button.height);
                this.addChild(_list);
                App.stage.addEventListener(MouseEvent.MOUSE_DOWN, removeList);
                //处理定位
                _list.scrollTo((_selectedIndex + _visibleNum) < _list.length ? _selectedIndex : _list.length - _visibleNum);
            } else {
                _list.remove();
                App.stage.removeEventListener(MouseEvent.MOUSE_DOWN, removeList);
            }
        }
        return _isOpen;
    }
    private function removeList(e:Event):Void {
        if (e == null || (!_button.contains(cast(e.target,DisplayObject)) && !_list.contains(cast(e.target,DisplayObject)))) {
            isOpen = false;
        }
    }
    /**滚动条皮肤*/
    public var scrollBarSkin(get,set):String;
    private function get_scrollBarSkin():String {
        return _scrollBar.skin;
    }
    private function set_scrollBarSkin(value:String):String {
        _scrollBar.skin = value;
        return value;
    }
    /**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
    public var sizeGrid(get,set):String;
    private function get_sizeGrid():String {
        return _button.sizeGrid;
    }
    private function set_sizeGrid(value:String):String {
        _button.sizeGrid = value;
        return value;
    }
    /**滚动条*/
    public var scrollBar(get,never):VScrollBar;
    private function get_scrollBar():VScrollBar {
        return _scrollBar;
    }

    /**按钮实体*/
    public var button(get,never):Button;
    private function get_button():Button {
        return _button;
    }

    /**list实体*/
    public var list(get,never):List;
    private function get_list():List {
        return _list;
    }
    override private function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Int) || Std.is(value,String)) {
            selectedIndex = Std.parseInt(Std.string(value));
        } else if (Std.is(value,Array)) {
            labels = cast(value,Array<Dynamic>).join(",");
        } else {
            super.dataSource = value;
        }
        return value;
    }
    /**标签颜色(格式:upColor,overColor,downColor,disableColor)*/
    public var labelColors(get,set):String;
    private function get_labelColors():String {
        return _button.labelColors;
    }
    private function set_labelColors(value:String):String {
        _button.labelColors = value;
        return value;
    }
    /**按钮标签边距(格式:左边距,上边距,右边距,下边距)*/
    public var labelMargin(get,set):String;
    private function get_labelMargin():String {
        return _button.btnLabel.margin;
    }
    private function set_labelMargin(value:String):String {
        _button.btnLabel.margin = value;
        return value;
    }
    /**按钮标签描边(格式:color,alpha,blurX,blurY,strength,quality)*/
    public var labelStroke(get,set):String;
    private function get_labelStroke():String {
        return _button.btnLabel.stroke;
    }
    private function set_labelStroke(value:String):String {
        _button.btnLabel.stroke = value;
        return value;
    }
    /**按钮标签大小*/
    public var labelSize(get,set):Dynamic;
    private function get_labelSize():Dynamic {
        return _button.btnLabel.size;
    }
    private function set_labelSize(value:Dynamic):Dynamic {
        _button.btnLabel.size = value;
        return value;
    }
    /**按钮标签粗细*/
    public var labelBold(get,set):Dynamic;
    private function get_labelBold():Dynamic {
        return _button.btnLabel.bold;
    }
    private function set_labelBold(value:Dynamic):Dynamic {
        _button.btnLabel.bold = value;
        return value;
    }
    /**按钮标签字体*/
    public var labelFont(get,set):String;
    private function get_labelFont():String {
        return _button.btnLabel.font;
    }
    private function set_labelFont(value:String):String {
        _button.btnLabel.font = value;
        return value;
    }
    /**按钮状态数，支持单态，两态和三态按钮，分别对应1,2,3值，默认是三态*/
    public var stateNum(get,set):Int;
    private function get_stateNum():Int {
        return _button.stateNum;
    }
    private function set_stateNum(value:Int):Int {
        _button.stateNum = value;
        return value;
    }
}
