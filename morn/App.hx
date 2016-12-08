package morn;
import haxe.Timer;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import morn.core.managers.LangManager;
import morn.core.managers.TipManager;
import morn.core.managers.DialogManager;
import morn.core.managers.RenderManager;
import morn.core.managers.TimerManager;
import morn.core.managers.LoaderManager;
import morn.core.managers.AssetManager;
import openfl.display.Stage;
class App {

    /**默认FPS*/
    public static var FPS(default, never):Int = 60;
    /**默认九宫格信息[左边距,上边距,右边距,下边距,是否重复填充]*/
    public static var defaultSizeGrid(default, never):Array<Int> = [4, 4, 4, 4, 0];
    //-----------------文本-----------------
    /**字体名称*/
    public static var fontName(default, never):String = "Arial";
    /**字体大小*/
    public static var fontSize(default, never):Int = 12;
    /**是否是嵌入字体*/
    public static var embedFonts(default, never):Bool = false;
    //-----------------Label-----------------
    /**标签颜色*/
    public static var labelColor(default, never):UInt = 0x000000;
    /**标签描边[color,alpha,blurX,blurY,strength,quality]*/
    public static var labelStroke(default, never):Array<Float> = [0x170702, 0.8, 2, 2, 10, 1];
    /**按钮标签边缘[左距离,上距离,又距离,下距离]*/
    public static var labelMargin(default, never):Array<Int> = [0, 0, 0, 0];
    //-----------------Button-----------------
    /**按钮皮肤的状态数，支持1,2,3三种状态值*/
    public static var buttonStateNum(default, never):Int = 3;
    /**按钮标签颜色[upColor,overColor,downColor,disableColor]*/
    public static var buttonLabelColors(default, never):Array<UInt> = [0x32556b, 0x32556b, 0x32556b, 0xC0C0C0];
    /**按钮标签边缘[左距离,上距离,又距离,下距离]*/
    public static var buttonLabelMargin(default, never):Array<Int> = [0, 0, 0, 0];
    //-----------------LinkButton-----------------
    /**连接标签颜色[upColor,overColor,downColor,disableColor]*/
    public static var linkLabelColors(default, never):Array<Int> = [0x0080C0, 0xFF8000, 0x800000, 0xC0C0C0];
    //-----------------ComboBox-----------------
    /**下拉框项颜色[overBgColor,overLabelColor,outLabelColor,borderColor,bgColor]*/
    public static var comboBoxItemColors(default, never):Array<UInt> = [0x5e95b6, 0xffffff, 0x000000, 0x8fa4b1, 0xffffff];
    /**单元格大小*/
    public static var comboBoxItemHeight(default, never):Int = 22;
    //-----------------ScrollBar-----------------
    /**滚动条最小值*/
    public static var scrollBarMinNum(default, never):Int = 15;
    /**长按按钮，等待时间，使其可激活连续滚动*/
    public static var scrollBarDelayTime(default, never):Int = 500;
    //-----------------DefaultToolTip-----------------
    /**默认鼠标提示文本颜色*/
    public static var tipTextColor(default, never):UInt = 0x000000;
    /**默认鼠标提示边框颜色*/
    public static var tipBorderColor(default, never):UInt = 0xC0C0C0;
    /**默认鼠标提示背景颜色*/
    public static var tipBgColor(default, never):UInt = 0xFFFFFF;

    /**默认图片是否平滑处理*/
    public static var smoothing(default, never):Bool = false;
    /**动画默认播放间隔*/
    public static var MOVIE_INTERVAL(default, never):Int = 100;
    /**===========================================================================**/
    /**全局stage引用*/
    public static var stage:Stage;
    /**资源管理器*/
    public static var asset:AssetManager = new AssetManager();
    /**加载管理器*/
    public static var loader:LoaderManager = new LoaderManager();
    /**时钟管理器*/
    public static var timer:TimerManager = new TimerManager();
    /**渲染管理器*/
    public static var render:RenderManager = new RenderManager();
    /**对话框管理器*/
    public static var dialog:DialogManager = new DialogManager();
    /**提示管理器*/
    public static var tip:TipManager = new TipManager();
    /**拖动管理器*/
    //public static var drag:DragManager = new DragManager();
    ///**语言管理器*/
    public static var lang:LangManager = new LangManager();

    public static function Init(_root:Stage):Void{
        stage=_root;
        stage.frameRate=FPS;
        stage.scaleMode=StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        stage.stageFocusRect = false;
        stage.tabChildren = false;
        stage.addChild(dialog);
        stage.addChild(tip);


    }
    public static function getTimer():Int
    {
        return Math.round(Timer.stamp()*1000);
    }

}
