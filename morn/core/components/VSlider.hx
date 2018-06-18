package morn.core.components;
class VSlider extends Slider {
    public function new(skin:String =null) {
        super(skin);
        direction = Slider.VERTICAL;
    }
}
