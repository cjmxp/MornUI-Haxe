package morn.core.managers;
import haxe.ds.ObjectMap;
import morn.core.events.UIEvent;
import openfl.events.Event;
import morn.core.handlers.Handler;
class RenderManager {
    private var _methods:ObjectMap<Handler,Bool> = new ObjectMap();
    private var _flag:Bool = false;
    public function new() {
    }
    private function invalidate():Void {
        if (!_flag && App.stage!=null) {
            //render有一定几率无法触发，这里加上保险处理
            App.stage.addEventListener(Event.ENTER_FRAME, onValidate);
            App.stage.addEventListener(Event.RENDER, onValidate);
            App.stage.invalidate();
            _flag = true;
        }
    }

    private function onValidate(e:Event):Void {
        _flag = false;
        App.stage.removeEventListener(Event.RENDER, onValidate);
        App.stage.removeEventListener(Event.ENTER_FRAME, onValidate);
        renderAll();
        App.stage.dispatchEvent(new Event(UIEvent.RENDER_COMPLETED));
    }
    /**执行所有延迟调用*/
    public function renderAll():Void {
        var i:Iterator<Handler> = _methods.keys();
        while(i.hasNext()){
            exeCallLater(i.next());
        }
    }
    public function callLater(fn:Handler):Void{
        if(_methods.exists(fn)==false){
            _methods.set(fn,true);
            invalidate();
        }
    }
    public function exeCallLater(fn:Handler):Void{
        if(_methods.exists(fn)==true){
            _methods.remove(fn);
            fn.Function();
        }
    }

}
