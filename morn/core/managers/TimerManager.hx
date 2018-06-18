package morn.core.managers;
import morn.core.handlers.TimerHandler;
import morn.core.handlers.Handler;
import openfl.events.Event;
import openfl.utils.Dictionary;
import openfl.display.Shape;
class TimerManager {
    private var _shape:Shape = new Shape();
    private var _pool:Array<TimerHandler> = new Array<TimerHandler>();
    private var _handlers:Dictionary<{}, TimerHandler> = new Dictionary(true);
    private var _currTimer:Int = 0;
    private var _currFrame:Int = 0;
    private var _count:Int = 0;
    private var _index:Int = 0;
    public function new() {
        _shape.addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }
    private function onEnterFrame(e:Event):Void
    {
        _currFrame++;
        _currTimer = App.getTimer();
        for (key in _handlers) {
            var handler:TimerHandler = _handlers.get(key);
            var t:Int = handler.userFrame? _currFrame : _currTimer;
            if (t >= handler.exeTime) {
                var method:Handler = handler.method;
                if (handler.repeat) {
                    while (t >= handler.exeTime && _handlers.exists(key) && handler.repeat) {
                        handler.exeTime += handler.delay;
                        method.Function();
                    }
                } else {
                    clearTimer(key);
                    method.Function();
                }
            }
        }
    }
    private function create(useFrame:Bool, repeat:Bool, delay:Int, method:Handler, cover:Bool = true):Dynamic {
        var key:Dynamic;
        if (cover) {
            //先删除相同函数的计时
            clearTimer(method);
            key = method;
        } else {
           key = _index++;
        }
        //如果执行时间小于1，直接执行
        if (delay < 1) {
            method.Function();
            return -1;
        }
        var handler:TimerHandler = _pool.length > 0 ? _pool.pop() : new TimerHandler();
        handler.userFrame = useFrame;
        handler.repeat = repeat;
        handler.delay = delay;
        handler.method = method;
        handler.exeTime = delay + (useFrame ? _currFrame : _currTimer);
        _handlers.set(key,handler);
        _count++;
        return key;
    }
    /**定时执行一次
     * @param	delay  延迟时间(单位毫秒)
     * @param	method 结束时的回调方法
     * @param	args   回调参数
     * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
     * @return  cover=true时返回回调函数本身，cover=false时，返回唯一ID，均用来作为clearTimer的参数*/
    public function doOnce(delay:Int, method:Handler,  cover:Bool = true):Dynamic {
        return create(false, false, delay, method, cover);
    }
    /**定时重复执行
    * @param	delay  延迟时间(单位毫秒)
    * @param	method 结束时的回调方法
    * @param	args   回调参数
    * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
    * @return  cover=true时返回回调函数本身，cover=false时，返回唯一ID，均用来作为clearTimer的参数*/
    public function doLoop(delay:Int, method:Handler, cover:Bool = true):Dynamic {
        return create(false, true, delay, method, cover);
    }
    /**定时执行一次(基于帧率)
    * @param	delay  延迟时间(单位为帧)
    * @param	method 结束时的回调方法
    * @param	args   回调参数
    * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
    * @return  cover=true时返回回调函数本身，cover=false时，返回唯一ID，均用来作为clearTimer的参数*/
    public function doFrameOnce(delay:Int, method:Handler, cover:Bool = true):Dynamic {
        return create(true, false, delay, method, cover);
    }
    /**定时重复执行(基于帧率)
    * @param	delay  延迟时间(单位为帧)
    * @param	method 结束时的回调方法
    * @param	args   回调参数
    * @param	cover  是否覆盖(true:同方法多次计时，后者覆盖前者。false:同方法多次计时，不相互覆盖)
    * @return  cover=true时返回回调函数本身，否则返回唯一ID，均用来作为clearTimer的参数*/
    public function doFrameLoop(delay:Int, method:Handler, cover:Bool = true):Dynamic {
        return create(true, true, delay, method, cover);
    }
    /**定时器执行数量*/
    @:getter(count)
    public function get_count():Int {
        return _count;
    }
    /**清理定时器
    * @param	method 创建时的cover=true时method为回调函数本身，否则method为返回的唯一ID
    */
    public function clearTimer(method:Dynamic):Void {
        /*[IF-FLASH]*/var handler:TimerHandler = _handlers.get(method);
        if (handler != null) {
            _handlers.remove(method);
            handler.clear();
            _pool.push(handler);
            _count--;
        }
    }
}
