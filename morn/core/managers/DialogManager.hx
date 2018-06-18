package morn.core.managers;
import openfl.display.Sprite;
import openfl.display.Bitmap;
import openfl.events.Event;
import morn.core.components.Dialog;
import morn.core.utils.ObjectUtils;
import morn.core.components.Box;

class DialogManager extends Sprite {
    private var _box:Box = new Box();
    private var _mask:Box = new Box();
    private var _maskBg:Sprite = new Sprite();
    public function new() {
        super();
        addChild(_box);
        _mask.addChild(_maskBg);
        _maskBg.addChild(ObjectUtils.createBitmap(10, 10, 0, 0.4));
        addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }
    private function onAddedToStage(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        stage.addEventListener(Event.RESIZE, onResize);
        onResize(null);
    }
    private function onResize(e:Event):Void {
        _box.width = _mask.width = stage.stageWidth;
        _box.height = _mask.height = stage.stageHeight;
        var item:Dialog;
        var i:Int = _box.numChildren - 1;
        var temp:Dynamic;
        while(i>-1){
            temp=_mask.getChildAt(i);
            if(Std.is(temp,Dialog)){
                item = cast(_box.getChildAt(i),Dialog);
                if (item.popupCenter) {
                    item.x = (stage.stageWidth - item.width) * 0.5;
                    item.y = (stage.stageHeight - item.height) * 0.5;
                }
            }
            i--;
        }
        i = _mask.numChildren - 1;
        while(i>-1){
            temp=_mask.getChildAt(i);
            if (Std.is(temp,Dialog)) {
                item = cast(_mask.getChildAt(i),Dialog);
                if (item.popupCenter) {
                    item.x = (stage.stageWidth - item.width) * 0.5;
                    item.y = (stage.stageHeight - item.height) * 0.5;
                }
            } else {
                var bitmap:Bitmap = cast(_maskBg.getChildAt(0),Bitmap);
                bitmap.width = stage.stageWidth;
                bitmap.height = stage.stageHeight;
            }
            i--;
        }
    }
    /**显示对话框(非模式窗口) @param closeOther 是否关闭其他对话框*/
    public function show(dialog:Dialog, closeOther:Bool = false):Void {
        if (closeOther) {
            _box.removeAllChild();
        }
        if (dialog.popupCenter) {
            dialog.x = (stage.stageWidth - dialog.width) * 0.5;
            dialog.y = (stage.stageHeight - dialog.height) * 0.5;
        }
        _box.addChild(dialog);
    }
    /**显示对话框(模式窗口) @param closeOther 是否关闭其他对话框*/
    public function popup(dialog:Dialog, closeOther:Bool = false):Void {
        if (closeOther) {
            _mask.removeAllChild(_maskBg);
        }
        if (dialog.popupCenter) {
            dialog.x = (stage.stageWidth - dialog.width) * 0.5;
            dialog.y = (stage.stageHeight - dialog.height) * 0.5;
        }
        _mask.addChild(dialog);
        _mask.swapChildrenAt(_mask.getChildIndex(_maskBg), _mask.numChildren - 2);
        addChild(_mask);
    }
    /**删除对话框*/
    public function close(dialog:Dialog):Void {
        dialog.remove();
        if (_mask.numChildren > 1) {
            _mask.swapChildrenAt(_mask.getChildIndex(_maskBg), _mask.numChildren - 2);
        } else {
            _mask.remove();
        }
    }
    /**删除所有对话框*/
    public function closeAll():Void {
        _box.removeAllChild();
        _mask.removeAllChild(_maskBg);
        _mask.remove();
    }
}
