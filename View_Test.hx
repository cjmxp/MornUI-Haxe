package ;
import haxe.Json;
import morn.core.components.View;
class View_Test extends View{
    private static var uiView:Xml = Xml.parse('<View width="600" height="400">
			  <Panel x="9" y="12" width="123" height="129" vScrollBarSkin="png.comp.vscroll" hScrollBarSkin="png.comp.hscroll">
			    <Image skin="png.comp.image"/>
			  </Panel>
			  <HScrollBar skin="png.comp.hscroll" x="147" y="16" width="74" height="17"/>
			  <CheckBox label="label" skin="png.comp.checkbox" x="242" y="14"/>
			  <Button label="label" skin="png.comp.button" x="293" y="8"/>
			  <HSlider skin="png.comp.hslider" x="148" y="45"/>
			  <Image skin="png.comp.image" x="438" y="8"/>
			  <Label text="label" x="382" y="12"/>
			  <VScrollBar skin="png.comp.vscroll" x="147" y="65" width="17" height="65"/>
			  <List x="168" y="61" repeatX="1" repeatY="10" spaceY="2" vScrollBarSkin="png.comp.vscroll" height="239" width="93">
			    <Box name="render" x="0" y="0" width="75" height="22">
			      <Button label="label" skin="png.comp.button" x="0" y="0" width="75" height="22" name="text"/>
			    </Box>
			  </List>
			  <Clip skin="png.comp.clip_num" x="267" y="44" clipX="10" clipY="1" index="0" autoPlay="true"/>
			  <ComboBox labels="label1,label2" skin="png.comp.combobox" x="267" y="72" scrollBarSkin="png.comp.vscroll" selectedIndex="0" width="86"/>
			  <ProgressBar skin="png.comp.progress" x="300" y="54" value="0.2" width="106" height="14"/>
			  <RadioButton label="label" skin="png.comp.radio" x="266" y="97"/>
			  <RadioGroup labels="group1,group2,group3" skin="png.comp.radiogroup" x="265" y="117"/>
			  <HBox x="283" y="158" align="top">
			    <Label text="1" y="16"/>
			    <Label text="2" x="21" width="10" height="18"/>
			    <Label text="3" x="51" y="18" width="10" height="18"/>
			  </HBox>
			  <VBox x="279" y="183" align="left">
			    <Label text="1" y="16"/>
			    <Label text="2" x="21" width="10" height="18"/>
			    <Label text="3" x="51" y="18" width="10" height="18"/>
			  </VBox>
			  <TextArea text="TextArea" skin="png.comp.textarea" x="8" y="192" width="118" height="121" align="left" vScrollBarSkin="png.comp.vscroll"/>
			  <Tab labels="label1,label2" skin="png.comp.tab" x="7" y="156" direction="horizontal"/>
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