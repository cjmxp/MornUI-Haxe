package morn.core.managers;
import haxe.Timer;
import haxe.ds.ObjectMap;
import morn.core.events.UIEvent;
import openfl.events.Event;
import morn.core.handlers.Handler;
class RenderManager {
    private var _methods:ObjectMap<Handler,Bool> = new ObjectMap();
    private var _flag:Bool = false;
    private var index:Int=0;
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
        var methods:Array<Handler>=[];
        while(i.hasNext()){
            methods.push(i.next());
        }
        methods.sort(sortOn);
        for(i in 0...methods.length){
            exeCallLater(methods[i]);
        }
    }
    private function sortOn(a:Handler,b:Handler):Int{
        return a.Id-b.Id;
    }
    public function callLater(fn:Handler):Void{
        if(!_methods.exists(fn)){
            fn.Id=index;
            _methods.set(fn,false);
            index++;
            if(index>65530)index=0;
            invalidate();
        }
    }
    public function delayCallLater(fn:Handler,delay:Int):Void{
        if(!_methods.exists(fn)){
            fn.Id=65534;
            _methods.set(fn,false);
            Timer.delay(function():Void{
                exeCallLater(fn);
            },delay);
        }
    }

    public function exeCallLater(fn:Handler):Void{
        if(_methods.exists(fn)){
            _methods.remove(fn);
            fn.Function();
        }
    }

}
