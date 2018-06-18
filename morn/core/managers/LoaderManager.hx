package morn.core.managers;
import morn.core.handlers.Handler;
import openfl.events.EventDispatcher;
class LoaderManager extends EventDispatcher {
    public function new() {
        super();
    }
    /**加载*/
    public function load(url:String,type:Int,complete:Handler = null,progress:Handler = null, error:Handler = null,isCacheContent:Bool = true):Void
    {

    }
    public function loadBMD(url:String,type:Int,complete:Handler = null,progress:Handler = null, error:Handler = null,isCacheContent:Bool = true){

    }
    public function clearResLoaded(url:String):Void
    {

    }
}
