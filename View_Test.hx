package ;
import haxe.Json;
import morn.core.components.View;
class View_Test extends View{
    private static var uiView:Xml = Xml.parse('<View width="600" height="400">
			  <Panel x="9" y="12" width="123" height="129">
			    <Image skin="png.comp.image" x="0" y="0"/>
			  </Panel>
			  <HScrollBar skin="png.comp.hscroll" x="147" y="16" width="74" height="17"/>
			  <CheckBox label="label" skin="png.comp.checkbox" x="242" y="14"/>
			  <Button label="label" skin="png.comp.button" x="293" y="8"/>
			  <HSlider skin="png.comp.hslider" x="148" y="45"/>
			  <Image skin="png.comp.image" x="438" y="8"/>
			  <Label text="label" x="382" y="12"/>
			  <VScrollBar skin="png.comp.vscroll" x="147" y="65" width="17" height="65"/>
			  <List x="168" y="61" repeatX="1" repeatY="10" width="92" spaceY="2" vScrollBarSkin="png.comp.vscroll" height="238">
			    <Box name="render" x="0" y="0" width="75" height="22">
			      <Button label="label" skin="png.comp.button" x="0" y="0" width="75" height="22" name="text"/>
			    </Box>
			  </List>
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