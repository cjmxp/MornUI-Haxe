package ;

import morn.core.components.Clip;
import openfl.display.Sprite;
class Main extends Sprite{
    public function new() {
        super();
        #if (debug && cpp1)
        new debugger.Local(true);
        #end
        App.Init(stage);
        var img:Clip=new Clip();
        img.url="assets/select.png";
        img.clipX=2;
        img.clipY=2;
        addChild(img);
    }
}
