package morn.core.managers;
import morn.core.events.DragEvent;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.display.DisplayObject;
import openfl.display.Sprite;
class DragManager {
    private var _dragInitiator:DisplayObject;
    private var _dragImage:Sprite;
    private var _data:Dynamic;
    public function new() {
    }
    /**开始拖动
     * @param dragInitiator 拖动的源对象
     * @param dragImage 显示拖动的图片，如果为null，则是源对象本身
     * @param data 拖动传递的数据
     * @param offset 鼠标居拖动图片的偏移*/
    public function doDrag(dragInitiator:Sprite, dragImage:Sprite = null, data:Dynamic = null, offset:Point = null):Void {
        _dragInitiator = dragInitiator;
        _dragImage = dragImage!=null ? dragImage : dragInitiator;
        _data = data;
        if (_dragImage != _dragInitiator) {
            if (_dragImage.parent!=null) {
                App.stage.addChild(_dragImage);
            }
            offset = offset!=null? offset : new Point();
            var p:Point = _dragImage.globalToLocal(new Point(App.stage.mouseX, App.stage.mouseY));
            _dragImage.x = p.x - offset.x;
            _dragImage.y = p.y - offset.y;
            _dragImage.visible = false;
        }
        App.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        App.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
    }
    /**放置把拖动条拖出显示区域*/
    private function onStageMouseMove(e:MouseEvent):Void {
        if (!_dragImage.visible) {
            _dragImage.visible = true;
            _dragImage.startDrag();
            _dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_START, _dragInitiator, _data));
        }
        if (e.stageX <= 0 || e.stageX >= App.stage.stageWidth || e.stageY <= 0 || e.stageY >= App.stage.stageHeight) {
            _dragImage.stopDrag();
        } else {
            _dragImage.startDrag();
        }
    }
    private function onStageMouseUp(e:Event):Void {
        App.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        App.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        _dragImage.stopDrag();
        var dropTarget:DisplayObject = getDropTarget(_dragImage.dropTarget);
        if (dropTarget!=null) {
            dropTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_DROP, _dragInitiator, _data));
        }
        _dragInitiator.dispatchEvent(new DragEvent(DragEvent.DRAG_COMPLETE, _dragInitiator, _data));
        if (_dragInitiator != _dragImage && _dragImage.parent!=null) {
            _dragImage.parent.removeChild(_dragImage);
        }
        _dragInitiator = null;
        _data = null;
        _dragImage = null;
    }
    private function getDropTarget(value:DisplayObject):DisplayObject {
        while (value!=null) {
            if (value.hasEventListener(DragEvent.DRAG_DROP)) {
                return value;
            }
            value = value.parent;
        }
        return null;
    }
}
