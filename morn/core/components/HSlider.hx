package morn.core.components;
class HSlider extends Slider {
    /**水平滚动条*/
    public function new(skin:String = null) {
        super(skin);
        direction = Slider.HORIZONTAL;
    }
}
