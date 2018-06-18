package morn.core.handlers;
class TimerHandler {
    public function new() {
    }
    /**执行间隔*/
    public var delay:Int;
    /**是否重复执行*/
    public var repeat:Bool;
    /**是否用帧率*/
    public var userFrame:Bool;
    /**执行时间*/
    public var exeTime:Int;
    /**处理方法*/
    public var method:Handler;
    /**清理*/
    public function clear():Void {
        delay=0;
        repeat=false;
        userFrame=false;
        exeTime=0;
        method = null;
    }
}
