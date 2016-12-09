package ;
import morn.App;
import morn.core.components.TextInput;
import openfl.display.Sprite;

class Main extends Sprite{
    public function new() {
        super();
        #if (debug && cpp1)
        new debugger.Local(true);
        #end
        App.Init(stage);
        var img:TextInput=new TextInput("button","assets/textinput.png");
        addChild(img);
    }
}