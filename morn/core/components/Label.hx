package morn.core.components;
import openfl.filters.GlowFilter;
import morn.core.utils.StringUtils;
import morn.core.utils.ObjectUtils;
import morn.core.handlers.Handler;
import openfl.events.Event;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextField;
class Label extends Component {
    private var _textField:TextField = null;
    private var _format:TextFormat = null;
    private var _text:String = "";
    private var _isHtml:Bool = false;
    private var _stroke:String = null;
    private var _skin:String = null;
    private var _bitmap:AutoBitmap = null;
    private var _margin:Array<Int> = App.labelMargin;
    private var _changeText:Handler = null;
    public function new(text:String = "", skin:String = null) {
        super();
        _changeText=new Handler(changeText.bind());
        this.text = text;
        this.skin = skin;
    }
    private override function preinitialize():Void {
        mouseEnabled = false;
    }

    private override function createChildren():Void {
        addChild(_bitmap = new AutoBitmap());
        addChild(_textField = new TextField());
    }

    private override function initialize():Void {
        _format = _textField.defaultTextFormat;
        _format.font = App.fontName;
        _format.size = App.fontSize;
        _format.color = App.labelColor;
        _textField.selectable = false;
        _textField.autoSize = TextFieldAutoSize.LEFT;
        _textField.embedFonts = App.embedFonts;
        _bitmap.sizeGrid = App.defaultSizeGrid;
    }
    /**显示的文本*/
    public var text(get,set):String;
    private function get_text():String {
        return _text;
    }
    private function set_text(value:String):String {
        if (_text != value && value!=null) {
            _text = value.split("\\n").join("\n");
            //callLater(changeText);
            changeText();
            sendEvent(Event.CHANGE);
        }
        return value;
    }
    /**Html文本*/
    public var htmlText(get,set):String;
    private function get_htmlText():String {
        return _text;
    }
    private function set_htmlText(value:String):String {
        _isHtml = true;
        text = value;
        return value;
    }
    private function changeText():Void {
        _textField.defaultTextFormat = _format;
        _isHtml ? _textField.htmlText = App.lang.getLang(_text) : _textField.text = App.lang.getLang(_text);
    }
    private override function changeSize():Void {
        if (!Math.isNaN(_width)) {
            _textField.autoSize = TextFieldAutoSize.NONE;
            _textField.width = _width - _margin[0] - _margin[2];
            if (Math.isNaN(_height) && wordWrap) {
                _textField.autoSize = TextFieldAutoSize.LEFT;
            } else {
                _height = Math.isNaN(_height) ? 18 : _height;
                _textField.height = _height - _margin[1] - _margin[3];
            }
        } else {
            _width = _height = Math.NaN;
            _textField.autoSize = TextFieldAutoSize.LEFT;
        }
        super.changeSize();
    }
    /**是否是html格式*/
    public var isHtml(get,set):Bool;
    private function get_isHtml():Bool {
        return _isHtml;
    }
    private function set_isHtml(value:Bool):Bool {
        if (_isHtml != value) {
            _isHtml = value;
            callLater(_changeText);
        }
        return value;
    }
    /**描边(格式:color,alpha,blurX,blurY,strength,quality)*/
    public var stroke(get,set):String;
    private function get_stroke():String {
        return _stroke;
    }
    private function set_stroke(value:String):String {
        if (_stroke != value) {
            _stroke = value;
            ObjectUtils.clearFilter(_textField, GlowFilter);
            if (_stroke!=null) {
                var a:Array<Float> = StringUtils.fillArray(App.labelStroke, _stroke);
                ObjectUtils.addFilter(_textField, new GlowFilter(Std.int(a[0]), a[1], a[2], a[3], a[4], Std.int(a[5])));
            }
        }
        return value;
    }
    /**是否是多行*/
    public var multiline(get,set):Bool;
    private function get_multiline():Bool {
        return _textField.multiline;
    }
    private function set_multiline(value:Bool):Bool {
        _textField.multiline = value;
        return value;
    }
    /**是否是密码*/
    public var asPassword(get,set):Bool;
    private function get_asPassword():Bool {
        return _textField.displayAsPassword;
    }
    private function set_asPassword(value:Bool):Bool {
        _textField.displayAsPassword = value;
        return value;
    }
    /**宽高是否自适应*/
    public var autoSize(get,set):String;
    private function get_autoSize():String {
        return _textField.autoSize;
    }
    private function set_autoSize(value:String):String {
        _textField.autoSize = value;
        return value;
    }
    /**是否自动换行*/
    public var wordWrap(get,set):Bool;
    private function get_wordWrap():Bool {
        return _textField.wordWrap;
    }
    private function set_wordWrap(value:Bool):Bool {
        _textField.wordWrap = value;
        return value;
    }
    /**是否可选*/
    public var selectable(get,set):Bool;
    private function get_selectable():Bool {
        return _textField.selectable;
    }
    private function set_selectable(value:Bool):Bool {
        _textField.selectable = value;
        mouseEnabled = value;
        return value;
    }
    /**是否具有背景填充*/
    public var background(get,set):Bool;
    private function get_background():Bool {
        return _textField.background;
    }
    private function set_background(value:Bool):Bool {
        _textField.background = value;
        return value;
    }
    /**文本字段背景的颜色*/
    public var backgroundColor(get,set):UInt;
    private function get_backgroundColor():UInt {
        return _textField.backgroundColor;
    }
    private function set_backgroundColor(value:UInt):UInt {
        _textField.backgroundColor = value;
        return value;
    }
    /**字体颜色*/
    public var color(get,set):Dynamic;
    private function get_color():Dynamic {
        return _format.color;
    }
    private function set_color(value:Dynamic):Dynamic {
        _format.color = value;
        callLater(_changeText);
        return value;
    }
    /**字体类型*/
    public var font(get,set):String;
    private function get_font():String {
        return _format.font;
    }
    private function set_font(value:String):String {
        _format.font = value;
        callLater(_changeText);
        return value;
    }
    /**对齐方式*/
    public var align(get,set):String;
    private function get_align():String {
        return _format.align;
    }
    private function set_align(value:String):String {
        _format.align = value;
        callLater(_changeText);
        return value;
    }
    /**粗体类型*/
    public var bold(get,set):Dynamic;
    private function get_bold():Dynamic {
        return _format.bold;
    }
    private function set_bold(value:Dynamic):Dynamic {
        _format.bold = value;
        callLater(_changeText);
        return value;
    }
    /**垂直间距*/
    public var leading(get,set):Dynamic;
    private function get_leading():Dynamic {
        return _format.leading;
    }
    private function set_leading(value:Dynamic):Dynamic {
        _format.leading = value;
        callLater(_changeText);
        return value;
    }
    /**第一个字符的缩进*/
    public var indent(get,set):Dynamic;
    private function get_indent():Dynamic {
        return _format.indent;
    }
    private function set_indent(value:Dynamic):Dynamic {
        _format.indent = value;
        callLater(_changeText);
        return value;
    }
    /**字体大小*/
    public var size(get,set):Dynamic;
    private function get_size():Dynamic {
        return _format.size;
    }
    private function set_size(value:Dynamic):Dynamic {
        _format.size = value;
        callLater(_changeText);
        return value;
    }
    /**下划线类型*/
    public var underline(get,set):Dynamic;
    private function get_underline():Dynamic {
        return _format.underline;
    }
    private function set_underline(value:Dynamic):Dynamic {
        _format.underline = value;
        callLater(_changeText);
        return value;
    }
        /**字间距*/
    public var letterSpacing(get,set):Dynamic;
    private function get_letterSpacing():Dynamic {
        return _format.letterSpacing;
    }
    private function set_letterSpacing(value:Dynamic):Dynamic {
        _format.letterSpacing = value;
        callLater(_changeText);
        return value;
    }
    /**边距(格式:左边距,上边距,右边距,下边距)*/
    public var margin(get,set):String;
    private function get_margin():String {
        return _margin.join(",");
    }
    private function set_margin(value:String):String {
        _margin = StringUtils.fillArray(_margin, value);
        _textField.x = _margin[0];
        _textField.y = _margin[1];
        callLater(_changeSize);
        return value;
    }
    /**是否嵌入*/
    public var embedFonts(get,set):Bool;
    private function get_embedFonts():Bool {
        return _textField.embedFonts;
    }
    private function set_embedFonts(value:Bool):Bool {
        _textField.embedFonts = value;
        return value;
    }
    /**格式*/
    public var format(get,set):TextFormat;
    private function get_format():TextFormat {
        return _format;
    }
    private function set_format(value:TextFormat):TextFormat {
        _format = value;
        callLater(_changeText);
        return value;
    }
    /**文本控件实体*/
    @:getter(textField)
    public function get_textField():TextField {
        return _textField;
    }
    /**将指定的字符串追加到文本的末尾*/
    public function appendText(newText:String):Void {
        text += newText;
    }
    /**皮肤*/
    public var skin(get,set):String;
    private function get_skin():String {
        return _skin;
    }
    private function set_skin(value:String):String {
        if (_skin != value) {
            if(App.asset.hasAsset(value)){
                _skin = value;
                _bitmap.bitmapData = App.asset.getBitmapData(value);
                if (_bitmap.bitmapData!=null) {
                    _contentWidth = _bitmap.bitmapData.width;
                    _contentHeight = _bitmap.bitmapData.height;
                }
            }
        }
        return value;
    }
    /**九宫格信息，格式：左边距,上边距,右边距,下边距,是否重复填充(值为0或1)，例如：4,4,4,4,1*/
    public var sizeGrid(get,set):String;
    private function get_sizeGrid():String {
        return _bitmap.sizeGrid.join(",");
    }
    private function set_sizeGrid(value:String):String {
        _bitmap.sizeGrid = StringUtils.fillArray(App.defaultSizeGrid, value);
        return value;
    }
    override public function commitMeasure():Void {
        exeCallLater(_changeText);
        exeCallLater(_changeSize);
    }
    #if flash
    @:getter(width)
    private override function get_width():Float {
        if (!Math.isNaN(_width) || (_skin!=null && _skin!="") || _text!=null) {
            return super.width;
        }
        return 0;
    }
    @:setter(width)
    private override  function set_width(value:Float):Void {
        super.width = value;
        _bitmap.width = value;
    }
    @:getter(height)
    private override function get_height():Float {
        if (!Math.isNaN(_height) || (_skin!=null && _skin!="") || _text!=null) {
            return super.height;
        }
        return 0;
    }
    @:setter(height)
    private override function set_height(value:Float):Void {
        super.height = value;
        _bitmap.height = value;
    }
    #else
    override public function get_width():Float {
        if (!Math.isNaN(_width) || (_skin!=null && _skin!="") || _text!=null) {
            return super.width;
        }
        return 0;
    }
    override public function set_width(value:Float):Float {
        super.width = value;
        _bitmap.width = value;
        return value;
    }
    override public function get_height():Float {
        if (!Math.isNaN(_height) || (_skin!=null && _skin!="") || _text!=null) {
            return super.height;
        }
        return 0;
    }
    override public function set_height(value:Float):Float {
        super.height = value;
        _bitmap.height = value;
        return value;
    }
    #end
    override public function set_dataSource(value:Dynamic):Dynamic {
        _dataSource = value;
        if (Std.is(value,Float)|| Std.is(value,String)) {
            text = Std.string(value);
        } else {
            super.dataSource = value;
        }
        return value;
    }
    /**销毁*/
    public override function dispose():Void {
        super.dispose();
        if(_bitmap!=null) _bitmap.dispose();
        _textField = null;
        _format = null;
        _bitmap = null;
        _margin = null;
        _skin = "";
    }
}
