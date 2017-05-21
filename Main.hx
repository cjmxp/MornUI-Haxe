package ;
import sys.io.FileOutput;
import sys.io.File;
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
        var f:FileOutput = File.write("c:/cjmxp.json",true);
        f.writeString("随分展翅");
        f.close();
        App.Init(stage);
        var box:View_Test=new View_Test();
        box.showBorder();
        addChild(box);
    }
}