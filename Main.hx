package ;
import morn.core.components.ScrollBar;
import morn.core.components.Slider;
import morn.core.components.Button;
import morn.App;
import openfl.display.Sprite;
class Main extends Sprite{
    public function new() {
        super();
        #if (debug && cpp1)
        new debugger.Local(true);
        #end
        App.Init(stage);
        var box:View_Test=new View_Test();
        box.showBorder();
        addChild(box);
    }
}