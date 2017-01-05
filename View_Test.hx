package ;
import haxe.Json;
import morn.core.components.View;
class View_Test extends View{
    private static var uiView:Xml = Xml.parse('<View width="600" height="400">
    <HSlider skin="png.comp.hslider" x="10" y="150" width="100"/>
    <CheckBox label="label" skin="png.comp.checkbox" x="50" y="8"/>
    <Button label="label" skin="png.comp.tab" x="293" y="8"/>
    <Image skin="png.comp.tab" x="438" y="8"/>
    <Label text="label" x="382" y="12"/>
    </View>');
    //private static var uiView:Dynamic=Json.parse('{"type":"View","child":[{"type":"Button","props":{"y":"8","skin":"assets/button.png","label":"label","x":"293"}},{"type":"Image","props":{"y":"8","skin":"assets/button.png","x":"438"}},{"type":"Label","props":{"y":"12","text":"label","x":"382"}}],"props":{"height":"400","width":"600"}}');

    public function new() {
        super();
    }
    private override function createChildren():Void {
        super.createChildren();
        createView(uiView);
    }
}