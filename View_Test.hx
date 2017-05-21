package ;
import haxe.Json;
import morn.core.components.View;
class View_Test extends View{
    private static var uiView:Xml = Xml.parse('<View width="600" height="400">
			  <HSlider skin="png.comp.hslider" x="40" y="47" width="138" height="6"/>
			  <HScrollBar skin="png.comp.hscroll" x="33" y="70" width="149" height="17"/>
			  <VScrollBar skin="png.comp.vscroll" x="33" y="92" width="17" height="136"/>
			  <Image skin="png.comp.image" x="257" y="36"/>
			  <Button label="label" skin="png.comp.button" x="425" y="61"/>
			  <TextInput text="TextInput" skin="png.comp.textinput" x="65" y="108" width="146"/>
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