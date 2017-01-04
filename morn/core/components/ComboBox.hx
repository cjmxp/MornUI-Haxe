package morn.core.components;
import openfl.events.Event;
import openfl.events.MouseEvent;
import morn.core.handlers.Handler;
class ComboBox extends Component {
    /**向上方向*/
    public static var UP(get,never):String = "up";
    /**向下方向*/
    public static var DOWN(get,never):String = "down";
    private var _visibleNum:Int = 6;
    private var _button:Button=null;
    private var _list:List=null;
    private var _isOpen:Bool=false;
    private var _scrollBar:VScrollBar=null;
    private var _itemColors:Array = App.comboBoxItemColors;
    private var _itemSize:Int = App.fontSize;
    private var _labels:Array<String> = [];
    private var _selectedIndex:Int = -1;
    private var _selectHandler:Handler=null;
    private var _itemHeight:Float=0.0;
    private var _listHeight:Float=0.0;
    public function new(skin:String = null, labels:String = null) {
        super();
        this.skin = skin;
        this.labels = labels;
    }
    private override function preinitialize():Void {
        mouseChildren = true;
    }

    private override function createChildren():Void {
        addChild(_button = new Button());
        _list = new List();
        _list.mouseHandler = new Handler(onlistItemMouse);
        _scrollBar = new VScrollBar();
        _list.addChild(_scrollBar);
    }

    private override function initialize():Void {
        _button.btnLabel.align = "left";
        _button.labelMargin = "5";
        _button.addEventListener(MouseEvent.MOUSE_DOWN, onButtonMouseDown);
        _list.addEventListener(Event.CHANGE, onListChange);
        _scrollBar.name = "scrollBar";
        _scrollBar.y = 1;
    }
    private function onButtonMouseDown(e:MouseEvent):Void {
        callLater(changeOpen);
    }

    private function onListChange(e:Event):Void {
        selectedIndex = _list.selectedIndex;
    }

    /**皮肤*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _button.skin;
    }
    private function set_skin(value:String):String {
        if (_button.skin != value) {
            _button.skin = value;
            _contentWidth = _button.width;
            _contentHeight = _button.height;
            callLater(changeList);
        }
        return value;
    }

    /**销毁*/
    public override function dispose():Void {
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
}
