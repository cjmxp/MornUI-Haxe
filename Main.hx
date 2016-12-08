package ;
import morn.App;
import morn.core.components.Button;
import openfl.display.Sprite;

class Main extends Sprite{
    public function new() {
        super();
        #if (debug && cpp1)
        new debugger.Local(true);
        #end
        App.Init(stage);
        var img:Button=new Button("assets/button.png","button");
        img.setSize(60,30);
        addChild(img);
    }
}