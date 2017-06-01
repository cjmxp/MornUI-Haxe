package morn.core.components;
import morn.core.utils.StringUtils;
import openfl.events.Event;
import morn.core.utils.ObjectUtils;
import openfl.events.MouseEvent;
import morn.core.handlers.Handler;
class Button extends Component implements ISelect {
    private static var stateMap:Dynamic = {rollOver: 1, rollOut: 0, mouseDown: 2, mouseUp: 1, selected: 2};
    private var _bitmap:AutoBitmap = null;
    private var _btnLabel:Label = null;
    private var _labelColors:Array<UInt> = App.buttonLabelColors;
    private var _labelMargin:Array<Int> = App.buttonLabelMargin;
    private var _state:Int = 0;
    private var _toggle:Bool = false;
    private var _selected:Bool = false;
    private var _skin:String = "";
    private var _autoSize:Bool = true;
    private var _stateNum:Int = App.buttonStateNum;
    private var _clickHandler:Handler = null;
    private var _changeState:Handler = null;
    private var _changeClips:Handler = null;
    private var _changeLabelSize:Handler= null;

    public function new(skin:String = null, label:String = "") {
        super();
        this._changeState=new Handler(changeState.bind());
        this._changeClips=new Handler(changeClips.bind());
        this._changeLabelSize=new Handler(changeLabelSize.bind());
        if(skin!=null)this.skin=skin;
        if(label!=null)this.label = label;
    }
    private override function createChildren():Void {
        _bitmap = new AutoBitmap();
        _btnLabel = new Label();
        addChild(_bitmap);
        addChild(_btnLabel);
    }
    private override function initialize():Void {
        _btnLabel.align = "center";
        addEventListener(MouseEvent.ROLL_OVER, onMouse);
        addEventListener(MouseEvent.ROLL_OUT, onMouse);
        addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
        addEventListener(MouseEvent.MOUSE_UP, onMouse);
        addEventListener(MouseEvent.CLICK, onMouse);
        _bitmap.sizeGrid = App.defaultSizeGrid;
    }
    private function onMouse(e:MouseEvent):Void {
        if ((_toggle == false && _selected) || _disabled) {
            return;
        }
        if (e.type == MouseEvent.CLICK) {
            if (_toggle) {
                selected = !_selected;
            }
            if (_clickHandler!=null) {
                _clickHandler.Function();
            }
            return;
        }
        if (_selected == false) {
            state = Reflect.field(stateMap,e.type);
        }
    }
    /**按钮标签*/
    public var label(get,set):String;
    private function get_label():String {
        return _btnLabel.text;
    }
    private function set_label(value:String):String {
        if (_btnLabel.text != value) {
            _btnLabel.text = value;
            callLater(_changeState);
        }
        return value;
    }
    /**皮肤，支持单态，两态和三态，用stateNum属性设置*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _skin;
    }
    private function set_skin(value:String):String {
        if (_skin != value && value!=null) {
            _skin = value;
            callLater(_changeClips);
            callLater(_changeLabelSize);
        }
        return value;
    }
    private function changeClips():Void {
        _bitmap.clips = App.asset.getClips(_skin, 1, _stateNum);
        if (_autoSize) {
            _contentWidth = _bitmap.width;
            _contentHeight = _bitmap.height;
        }
    }
    public override function commitMeasure():Void {
        exeCallLater(_changeClips);
    }
    private function changeLabelSize():Void {
        exeCallLater(_changeClips);
        _btnLabel.width = width - _labelMargin[0] - _labelMargin[2];
        _btnLabel.height = ObjectUtils.getTextField(_btnLabel.format).height;
        _btnLabel.x = _labelMargin[0];
        _btnLabel.y = (height - _btnLabel.height) * 0.5 + _labelMargin[1] - _labelMargin[3];
    }
    /**是否是选择状态*/
    public var selected(get,set):Bool;
    private function get_selected():Bool {
        return _selected;
    }
    private function set_selected(value:Bool):Bool {
        if (_selected != value) {
            _selected = value;
            state = _selected ? stateMap.selected : stateMap.rollOut;
            sendEvent(Event.CHANGE);
            //兼容老版本
            sendEvent(Event.SELECT);
        }
        return value;
    }
    public var state(get,set):Int;
    private function get_state():Int {
        return _state;
    }
    private function set_state(value:Int):Int {
        _state = value;
        callLater(_changeState);
        return value;
    }
    private function changeState():Void {
        var index:Int = _state;
        if (_stateNum == 2) {
            index = index < 2 ? index : 1;
        } else if (_stateNum == 1) {
            index = 0;
        }
        _bitmap.index = index;
        _btnLabel.color = _labelColors[_state];
    }
    /**是否是切换状态*/
    public var toggle(get,set):Bool;
    private function get_toggle():Bool {
        return _toggle;
    }
    private function set_toggle(value:Bool):Bool {
        _toggle = value;
        return value;
    }
    private override function set_disabled(value:Bool):Bool {
        if (_disabled != value) {
            state = _selected ? stateMap.selected : stateMap.rollOut;
            super.disabled = value;
        }
        return value;
    }
    /**按钮标签颜色(格式:upColor,overColor,downColor,disableColor)*/
    public var labelColors(get,set):String;
    private function get_labelColors():String {
        return _labelColors.toString();
    }
    private function set_labelColors(value:String):String {
        _labelColors = StringUtils.fillArray(_labelColors, value);
        callLater(_changeState);
        return value;
    }
    /**按钮标签边距(格式:左边距,上边距,右边距,下边距)*/
    public var labelMargin(get,set):String;
    private function get_labelMargin():String {
        return _labelMargin.toString();
    }
    private function set_labelMargin(value:String):String {
        _labelMargin = StringUtils.fillArray(_labelMargin, value);
        callLater(_changeLabelSize);
        return value;
    }
    /**按钮标签描边(格式:color,alpha,blurX,blurY,strength,quality)*/
    public var labelStroke(get,set):String;
    private function get_labelStroke():String {
        return _btnLabel.stroke;
    }
    private function set_labelStroke(value:String):String {
        _btnLabel.stroke = value;
        return value;
    }
    /**按钮标签大小*/
    public var labelSize(get,set):Dynamic;
    private function get_labelSize():Dynamic {
        return _btnLabel.size;
    }
    private function set_labelSize(value:Dynamic):Dynamic {
        _btnLabel.size = value;
        callLater(_changeLabelSize);
        return value;
    }
    /**按钮标签粗细*/
    public var labelBold(get,set):Dynamic;
    private function get_labelBold():Dynamic {
        return _btnLabel.bold;
    }
    private function set_labelBold(value:Dynamic):Dynamic {
        _btnLabel.bold = value;
        callLater(_changeLabelSize);
        return value;
    }
    /**字间距*/
    public var letterSpacing(get,set):Dynamic;
    private function get_letterSpacing():Dynamic {
        return _btnLabel.letterSpacing;
    }
    private function set_letterSpacing(value:Dynamic):Dynamic {
        _btnLabel.letterSpacing = value;
        callLater(_changeLabelSize);
        return value;
    }
    /**按钮标签字体*/
    public var labelFont(get,set):String;
    private function get_labelFont():String {
        return _btnLabel.font;
    }
    private function set_labelFont(value:String):String {
        _btnLabel.font = value;
        callLater(_changeLabelSize);
        return value;
    }
    /**点击处理器(无默认参数)*/
    public var clickHandler(get,set):Handler;
    private function get_clickHandler():Handler {
        return _clickHandler;
    }
    private function set_clickHandler(value:Handler):Handler {
        _clickHandler = value;
        return value;
    }
    /**按钮标签控件*/
    public var btnLabel(get,never):Label;
    private function get_btnLabel():Label {
        return _btnLabel;
    }
    /**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
    public var sizeGrid(get,set):String;
    private function get_sizeGrid():String {
        if (_bitmap.sizeGrid!=null) {
            return _bitmap.sizeGrid.join(",");
        }
        return null;
    }
    private function set_sizeGrid(value:String):String {
        _bitmap.sizeGrid = StringUtils.fillArray(App.defaultSizeGrid, value);
        return value;
    }

    #if flash
    @:setter(width)
    private override function set_width(value:Float):Void {
        super.width = value;
        if (_autoSize) {
            _bitmap.width = value;
        }
        callLater(_changeLabelSize);
    }
    @:setter(height)
    private  override function set_height(value:Float):Void {
        super.height = value;
        if (_autoSize) {
            _bitmap.height = value;
        }
        callLater(_changeLabelSize);
    }
    #else
    private override function set_width(value:Float):Float {
        super.width = value;
        if (_autoSize) {
            _bitmap.width = value;
        }
        callLater(_changeLabelSize);
        return value;
    }
    private override function set_height(value:Float):Float {
        super.height = value;
        if (_autoSize) {
            _bitmap.height = value;
        }
        callLater(_changeLabelSize);
        return value;
    }

    #end
    override public function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Float) || Std.is(value,String)) {
            label = Std.string(value);
        } else {
            super.dataSource = value;
        }
        return value;
    }

    /**皮肤的状态数，支持单态，两态和三态按钮，分别对应1,2,3值，默认是三态*/
    public var stateNum(get,set):Int;
    private function get_stateNum():Int {
        return _stateNum;
    }
    private function set_stateNum(value:Int):Int {
        if (_stateNum != value) {
            _stateNum = value < 1 ? 1 : value > 3 ? 3 : value;
            callLater(_changeClips);
        }
        return value;
    }
    /**销毁*/
    public override function dispose():Void {
        super.dispose();
        if(_bitmap!=null)_bitmap.dispose();
        if(_btnLabel!=null)_btnLabel.dispose();
        _bitmap = null;
        _btnLabel = null;
        _clickHandler = null;
        _labelColors = null;
        _labelMargin = null;
    }
}
