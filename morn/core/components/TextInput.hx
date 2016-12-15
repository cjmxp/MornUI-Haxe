package morn.core.components;
import openfl.events.TextEvent;
import openfl.events.Event;
import openfl.text.TextFieldType;
class TextInput extends Label {
    public function new(text:String = "", skin:String = null) {
        super(text, skin);
    }
    private override function initialize():Void {
        super.initialize();
        trace(Type.resolveClass("Label"));
        mouseChildren = true;
        width = 128;
        height = 22;
        selectable = true;
        _textField.type = TextFieldType.INPUT;
        _textField.autoSize = "none";
        _textField.addEventListener(Event.CHANGE, onTextFieldChange);
        _textField.addEventListener(TextEvent.TEXT_INPUT, onTextFieldTextInput);
    }
    private function onTextFieldTextInput(e:TextEvent):Void {
        dispatchEvent(e);
    }
    private function onTextFieldChange(e:Event):Void {
        text = _isHtml ? _textField.htmlText : _textField.text;
        e.stopPropagation();
    }
    /**指示用户可以输入到控件的字符集*/
    public var restrict(get,set):String;
    private function get_restrict():String {
        return _textField.restrict;
    }
    private function set_restrict(value:String):String {
        _textField.restrict = value;
        return value;
    }

    /**是否可编辑*/
    public var editable(get,set):Bool;
    private function get_editable():Bool {
        return _textField.type == TextFieldType.INPUT;
    }
    private function set_editable(value:Bool):Bool {
        _textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
        return value;
    }
    /**最多可包含的字符数*/
    public var maxChars(get,set):Int;
    private function get_maxChars():Int {
        return _textField.maxChars;
    }
    private function set_maxChars(value:Int):Int {
        _textField.maxChars = value;
        return value;
    }
}
