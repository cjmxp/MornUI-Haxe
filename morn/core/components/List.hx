package morn.core.components;
import morn.core.events.DragEvent;
import morn.core.events.UIEvent;
import openfl.geom.Rectangle;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.display.Graphics;
import morn.core.handlers.Handler;
class List extends Box implements IRender implements IItem {
    private var _content:Box=null;
    private var _scrollBar:ScrollBar=null;
    private var _itemRender:Dynamic=null;
    private var _repeatX:Int = 0;
    private var _repeatY:Int = 0;
    private var _repeatX2:Int = 0;
    private var _repeatY2:Int = 0;
    private var _spaceX:Int = 0;
    private var _spaceY:Int = 0;
    private var _cells:Array<Box> = new Array<Box>();
    private var _array:Array<Dynamic> = null;
    private var _startIndex:Int = 0;
    private var _selectedIndex:Int = -1;
    private var _selectHandler:Handler;
    private var _renderHandler:Handler;
    private var _mouseHandler:Handler;
    private var _renderItems:Handler;
    private var _changeCells:Handler;
    private var _page:Int = 0;
    private var _totalPage:Int = 0;
    private var _selectEnable:Bool = true;
    private var _isVerticalLayout:Bool = true;
    private var _cellSize:Float = 20.0;
    public function new() {
        super();
        _renderItems=new Handler(renderItems.bind());
        _changeCells=new Handler(changeCells.bind());
    }
    public override function dispose():Void {
        super.dispose();
        if(_content!=null) _content.dispose();
        if(_scrollBar!=null) _scrollBar.dispose();
        _content = null;
        _scrollBar = null;
        _itemRender = null;
        _cells = null;
        _array = null;
        _selectHandler = null;
        _renderHandler = null;
        _mouseHandler = null;
    }
    override public function createChildren():Void {
        _content = new Box();
        addChild(_content);
    }
    override public function removeChild(child:DisplayObject):DisplayObject {
        return child != _content ? super.removeChild(child) : null;
    }
    override public function removeChildAt(index:Int):DisplayObject {
        return getChildAt(index) != _content ? super.removeChildAt(index) : null;
    }
    /**内容容器*/
    public var content(get,never):Box;
    private function get_content():Box {
        return _content;
    }
    /**滚动条*/
    public var scrollBar(get,set):ScrollBar;
    private function get_scrollBar():ScrollBar {
        return _scrollBar;
    }
    private function set_scrollBar(value:ScrollBar):ScrollBar {
        if (_scrollBar != value) {
            if(_scrollBar!=null)_scrollBar.removeEventListener(Event.CHANGE, onScrollBarChange);
            _scrollBar = value;
            if (value!=null) {
                addChild(_scrollBar);
                _scrollBar.target = this;
                _scrollBar.addEventListener(Event.CHANGE, onScrollBarChange);
                _isVerticalLayout = _scrollBar.direction == ScrollBar.VERTICAL;
            }
        }
        return _scrollBar;
    }
    /**单元格渲染器，可以设置为XML或类对象*/
    public var itemRender(get,set):Dynamic;
    private function get_itemRender():Dynamic {
        return _itemRender;
    }
    private function set_itemRender(value:Dynamic):Dynamic {
        _itemRender = value;
        callLater(_changeCells);
        array=[{text:"1"},{text:"2"},{text:"3"},{text:"4"},{text:"5"},{text:"6"},{text:"7"},{text:"8"},{text:"9"},{text:"10"},{text:"11"},{text:"12"},{text:"13"}];
        return _itemRender;
    }
    /**X方向单元格数量*/
    public var repeatX(get,set):Int;
    private function get_repeatX():Int {
        return _repeatX > 0 ? _repeatX : _repeatX2 > 0 ? _repeatX2 : 1;
    }
    private function set_repeatX(value:Int):Int {
        _repeatX = Std.int(value);
        callLater(_changeCells);
        return _repeatX;
    }
    /**Y方向单元格数量*/
    public var repeatY(get,set):Int;
    private function get_repeatY():Int {
        return _repeatY > 0 ? _repeatY : _repeatY2 > 0 ? _repeatY2 : 1;
    }
    private function set_repeatY(value:Int):Int {
        _repeatY = Std.int(value);
        callLater(_changeCells);
        return _repeatY;
    }
    /**X方向单元格间隔*/
    public var spaceX(get,set):Int;
    private function get_spaceX():Int {
        return _spaceX;
    }
    private function set_spaceX(value:Int):Int {
        _spaceX = Std.int(value);
        callLater(_changeCells);
        return _spaceX;
    }
    /**Y方向单元格间隔*/
    public var spaceY(get,set):Int;
    private function get_spaceY():Int {
        return _spaceY;
    }
    private function set_spaceY(value:Int):Int {
        _spaceY = Std.int(value);
        callLater(_changeCells);
        return _spaceY;
    }
    private function changeCells():Void {
        var cell:Box=null;
        if (_itemRender!=null) {
            //销毁老单元格
            for(i in 0..._cells.length){
                cell= _cells[i];
                cell.removeEventListener(MouseEvent.CLICK, onCellMouse);
                cell.removeEventListener(MouseEvent.ROLL_OVER, onCellMouse);
                cell.removeEventListener(MouseEvent.ROLL_OUT, onCellMouse);
                cell.removeEventListener(MouseEvent.MOUSE_DOWN, onCellMouse);
                cell.removeEventListener(MouseEvent.MOUSE_UP, onCellMouse);
                cell.remove();
            }
            _cells=_cells.splice(0,-1);
            //获取滚动条
            if(getChildByName("scrollBar")!=null){
                scrollBar = cast(getChildByName("scrollBar"),ScrollBar);
            }
            //自适应宽高
            cell = createItem();

            var cellWidth:Float = cell.width + _spaceX;
            if (_repeatX < 1 && !Math.isNaN(_width)) {
                _repeatX2 = Math.round(_width / cellWidth);
            }
            var cellHeight:Float = cell.height + _spaceY;
            if (_repeatY < 1 && !Math.isNaN(_height)) {
                _repeatY2 = Math.round(_height / cellHeight);
            }
            var listWidth:Float = Math.isNaN(_width) ? (cellWidth * repeatX - _spaceX) : _width;
            var listHeight:Float = Math.isNaN(_height) ? (cellHeight * repeatY - _spaceY) : _height;
            _cellSize = _isVerticalLayout ? cellHeight : cellWidth;

            if (_isVerticalLayout && _scrollBar!=null) {
                _scrollBar.height = listHeight;
            } else if (!_isVerticalLayout && _scrollBar!=null) {
                _scrollBar.width = listWidth;
            }
            setContentSize(listWidth, listHeight);
            //创建新单元格
            var numX:Int = _isVerticalLayout ? repeatX : repeatY;
            var numY:Int = (_isVerticalLayout ? repeatY : repeatX) + (_scrollBar!=null ? 1 : 0);
            for (k in 0...numY) {
                for (l in 0...numX) {
                    cell = createItem();
                    cell.x = (_isVerticalLayout ? l : k) * (_spaceX + cell.width);
                    cell.y = (_isVerticalLayout ? k : l) * (_spaceY + cell.height);
                    cell.name = "item" + (k * numX + l);
                    _content.addChild(cell);
                    addCell(cell);
                }
            }
            if (_array!=null) {
                array = _array;
                exeCallLater(_renderItems);
            }
        }
    }
    private function createItem():Box {
        if(Std.is(_itemRender,Class)){
            return cast(Type.createInstance(_itemRender,[]),Box);
        }
        return  cast(View.createComp(_itemRender),Box);
    }
    private function addCell(cell:Box):Void {
        cell.addEventListener(MouseEvent.CLICK, onCellMouse);
        cell.addEventListener(MouseEvent.ROLL_OVER, onCellMouse);
        cell.addEventListener(MouseEvent.ROLL_OUT, onCellMouse);
        cell.addEventListener(MouseEvent.MOUSE_DOWN, onCellMouse);
        cell.addEventListener(MouseEvent.MOUSE_UP, onCellMouse);
        _cells.push(cell);
    }
    public function initItems():Void {
        if (_itemRender==null) {
            var i:Int=0;
            while(true){
                if(getChildByName("item" + i)==null)break;
                var cell:Box = cast(getChildByName("item" + i),Box);
                if (cell!=null) {
                    addCell(cell);
                    i++;
                    continue;
                }
                break;
            }
        }
    }
    #if flash
    @:setter(width)
    override private function set_width(value:Float):Void {
        super.width = value;
        callLater(_changeCells);
    }
    @:setter(height)
    override private function set_height(value:Float):Void {
        super.height = value;
        callLater(_changeCells);
    }
    #else
    override private function set_width(value:Float):Float {
        super.width = value;
        callLater(_changeCells);
        return value;
    }
    override private function set_height(value:Float):Float {
        super.height = value;
        callLater(_changeCells);
        return value;
    }
    #end
    /**设置可视区域大小*/
    public function setContentSize(width:Float, height:Float):Void {
        /*var g:Graphics = graphics;
        g.clear();
        g.beginFill(0xff0000, 1);
        g.drawRect(0, 0, width, height);
        g.endFill();*/
        _content.width = width;
        _content.height = height;
        if (_scrollBar!=null) {
            _content.scrollRect = new Rectangle(0, 0, width, height);
        }
    }
    private function onCellMouse(e:MouseEvent):Void {
        var cell:Box = cast(e.currentTarget,Box);
        var index:Int = _startIndex + _cells.indexOf(cell);
        if (e.type == MouseEvent.CLICK || e.type == MouseEvent.ROLL_OVER || e.type == MouseEvent.ROLL_OUT) {
            if (e.type == MouseEvent.CLICK) {
                if (_selectEnable) {
                    selectedIndex = index;
                } else {
                    changeCellState(cell, true, 0);
                }
            } else if (_selectedIndex != index) {
                changeCellState(cell, e.type == MouseEvent.ROLL_OVER, 0);
            }
        }
        if (_mouseHandler != null) {
            _mouseHandler.Function(e, index);
        }
    }
    private function changeCellState(cell:Box, visable:Bool, frame:Int):Void {
        if(cell.getChildByName("selectBox")!=null){
            var selectBox:Clip = cast(cell.getChildByName("selectBox"),Clip);
            if (selectBox!=null) {
                selectBox.visible = visable;
                selectBox.frame = frame;
            }
        }
    }
    private function onScrollBarChange(e:Event):Void {
        if(!_scrollBar.visible)return;
        exeCallLater(_changeCells);
        var rect:Rectangle = _content.scrollRect;
        var scrollValue:Float = _scrollBar.value;
        if(Math.isNaN(scrollValue)){
            _scrollBar.value = 0;
            return;
        }
        var index:Int = Std.int(scrollValue / _cellSize) * (_isVerticalLayout ? repeatX : repeatY);
        if (index != _startIndex) {
            startIndex = index;
        }
        if (_isVerticalLayout) {
            rect.y = scrollValue % _cellSize;
        } else {
            rect.x = scrollValue % _cellSize;
        }
        _content.scrollRect = rect;
    }
    /**是否可以选中，默认为true*/
    public var selectEnable(get,set):Bool;
    private function get_selectEnable():Bool {
        return _selectEnable;
    }
    private function set_selectEnable(value:Bool):Bool {
        _selectEnable = value;
        return _selectEnable;
    }
    /**选择索引*/
    public var selectedIndex(get,set):Int;
    private function get_selectedIndex():Int {
        return _selectedIndex;
    }
    private function set_selectedIndex(value:Int):Int {
        value=Std.int(value);
        if (_selectedIndex != value) {
            _selectedIndex = value;
            changeSelectStatus();
            sendEvent(Event.CHANGE);
            //兼容老版本
            sendEvent(Event.SELECT);
            if (_selectHandler != null) {
                _selectHandler.Function(value);
            }
        }
        return _selectedIndex;
    }
    private function changeSelectStatus():Void {
        for (i in 0..._cells.length) {
            changeCellState(_cells[i], _selectedIndex == _startIndex + i, 1);
        }
    }
    /**选中单元格数据源*/
    public var selectedItem(get,set):Dynamic;
    private function get_selectedItem():Dynamic {
        return _selectedIndex != -1 ? _array[_selectedIndex] : null;
    }
    private function set_selectedItem(value:Dynamic):Dynamic {
        selectedIndex = _array.indexOf(value);
        return selectedIndex;
    }
    /**选择单元格组件*/
    public var selection(get,set):Box;
    private function get_selection():Box {
        return getCell(_selectedIndex);
    }
    private function set_selection(value:Box):Box {
        selectedIndex = _startIndex + _cells.indexOf(value);
        return value;
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
    /**单元格渲染处理器(默认返回参数cell:Box,index:int)*/
    public var renderHandler(get,set):Handler;
    private function get_renderHandler():Handler {
        return _renderHandler;
    }
    private function set_renderHandler(value:Handler):Handler {
        _renderHandler = value;
        return _renderHandler;
    }
    /**单元格鼠标事件处理器(默认返回参数e:MouseEvent,index:int)*/
    public var mouseHandler(get,set):Handler;
    private function get_mouseHandler():Handler {
        return _mouseHandler;
    }
    private function set_mouseHandler(value:Handler):Handler {
        _mouseHandler = value;
        return _mouseHandler;
    }
    /**开始索引*/
    public var startIndex(get,set):Int;
    private function get_startIndex():Int {
        return _startIndex;
    }
    private function set_startIndex(value:Int):Int {
        value=Std.int(value);
        _startIndex = value > 0 ? value : 0;
        callLater(_renderItems);
        return _startIndex;
    }
    private function renderItems():Void {
        for (i in 0..._cells.length) {
            renderItem(_cells[i], _startIndex + i);
        }
        changeSelectStatus();
    }
    private function renderItem(cell:Box, index:Int):Void {
        if (_array!=null && index < _array.length) {
            cell.visible = true;
            cell.dataSource = _array[index];
        } else {
            cell.visible = false;
            cell.dataSource = null;
        }
        sendEvent(UIEvent.ITEM_RENDER, [cell, index]);
        if (_renderHandler != null) {
            _renderHandler.Function(cell, index);
        }
    }
    /**列表数据源*/
    public var array(get,set):Array<Dynamic>;
    private function get_array():Array<Dynamic> {
        return _array;
    }
    private function set_array(value:Array<Dynamic>):Array<Dynamic> {
        _array = value;
        if(value ==null){
            _array = new Array<Dynamic>();
        }
        var length:Int = _array.length;
        _totalPage = Math.ceil(length / (repeatX * repeatY));
        //重设selectedIndex
        _selectedIndex = _selectedIndex < length ? _selectedIndex : length - 1;
        //重设startIndex
        startIndex = _startIndex;
        //重设滚动条
        if (_scrollBar!=null) {
            //自动隐藏滚动条
            var numX:Int = _isVerticalLayout ? repeatX : repeatY;
            var numY:Int = _isVerticalLayout ? repeatY : repeatX;
            var lineCount:Int = Math.ceil(length / numX);
            _scrollBar.visible = _totalPage > 1;
            if (_scrollBar.visible) {
                _scrollBar.scrollSize = _cellSize;
                _scrollBar.thumbPercent = numY / lineCount;
                _scrollBar.setScroll(0, (lineCount - numY) * _cellSize , _startIndex / numX * _cellSize);
            } else {
                _scrollBar.setScroll(0, 0, 0);
            }
        }
        exeCallLater(_changeCells);
        return _array;
    }
    /**最大分页数*/
    public var totalPage(get,set):Int;
    private function get_totalPage():Int {
        return _totalPage;
    }
    private function set_totalPage(value:Int):Int {
        _totalPage = Std.int(value);
        return _totalPage;
    }
    /**当前页码*/
    public var page(get,set):Int;
    private function get_page():Int {
        return _page;
    }
    private function set_page(value:Int):Int {
        _page = Std.int(value);
        if (_array!=null) {
            _page = value > 0 ? value : 0;
            _page = _page < _totalPage ? _page : _totalPage - 1;
            startIndex = _page * repeatX * repeatY;
        }
        return _page;
    }
    /**列表数据总数*/
    public var length(get,never):Int;
    private function get_length():Int {
        if(_array!=null) return _array.length;
        return 0;
    }
    override private function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if(Std.is(value,Int) || Std.is(value,String)) {
            selectedIndex = Std.parseInt(value);
        } else if (Std.is(value,Array)) {
            array = cast(value,Array<Dynamic>);
        } else {
            super.dataSource = value;
        }
        return _dataSource;
    }
    /**单元格集合*/
    public var cells(get,never):Array<Box>;
    private function get_cells():Array<Box> {
        exeCallLater(_changeCells);
        return _cells;
    }
    /**滚动条皮肤*/
    public var vScrollBarSkin(get,set):String;
    private function get_vScrollBarSkin():String {
        return _scrollBar!=null?_scrollBar.skin:null;
    }
    private function set_vScrollBarSkin(value:String):String {
        removeChildByName("scrollBar");
        var scrollBar:ScrollBar = new VScrollBar();
        scrollBar.name = "scrollBar";
        scrollBar.right = 0;
        scrollBar.skin = value;
        addChild(scrollBar);
        callLater(_changeCells);
        return value;
    }
    /**滚动条皮肤*/
    public var hScrollBarSkin(get,set):String;
    private function get_hScrollBarSkin():String {
        return _scrollBar!=null?_scrollBar.skin:null;
    }
    private function set_hScrollBarSkin(value:String):String {
        removeChildByName("scrollBar");
        var scrollBar:ScrollBar = new HScrollBar();
        scrollBar.name = "scrollBar";
        scrollBar.bottom = 0;
        scrollBar.skin = value;
        addChild(scrollBar);
        callLater(_changeCells);
        return value;
    }
    override public function commitMeasure():Void {
        exeCallLater(_changeCells);
    }
    /**刷新列表*/
    public function refresh():Void {
        array = _array;
    }
    /**获取单元格数据源*/
    public function getItem(index:Int):Dynamic {
        if (index > -1 && index < _array.length) {
            return _array[index];
        }
        return null;
    }
    /**修改单元格数据源*/
    public function changeItem(index:Int, source:Dynamic):Void {
        if (index > -1 && index < _array.length) {
            _array[index] = source;
            //如果是可视范围，则重新渲染
            if (index >= _startIndex && index < _startIndex + _cells.length) {
                renderItem(getCell(index), index);
            }
        }
    }
    /**添加单元格数据源*/
    public function addItem(souce:Dynamic):Void {
        _array.push(souce);
        array = _array;
    }
    /**添加单元格数据源*/
    public function addItemAt(souce:Dynamic, index:Int):Void {
        _array.insert(index,souce);
        array = _array;
    }
    /**删除单元格数据源*/
    public function deleteItem(index:Int):Void {
        _array.splice(index, 1);
        array = _array;
    }
    /**获取单元格*/
    public function getCell(index:Int):Box {
        exeCallLater(_changeCells);
        if (index > -1 && _cells!=null) {
            return _cells[(index - _startIndex) % _cells.length];
        }
        return null;
    }
    /**滚动到某个索引位置*/
    public function scrollTo(index:Int):Void {
        startIndex = index;
        if (_scrollBar!=null) {
            var numX:Int = _isVerticalLayout ? repeatX : repeatY;
            _scrollBar.value = (index / numX) * _cellSize;
        }
    }
    /**获取list内拖动结束位置的索引*/
    public function getDropIndex(e:DragEvent):Int {
        var target:DisplayObject = e.data.dropTarget;
        for (i in  0..._cells.length) {
            if (_cells[i].contains(target)) {
                return _startIndex + i;
            }
        }
        return -1;
    }
}
