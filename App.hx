package ;
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



    public static var FPS(default, never):Int = 60;//默认FPS
    public static var defaultSizeGrid(default, never):String = "0,0,0,0,0";//默认九宫格
    public static var smoothing(default, never):Bool = false;//默认图片不平滑

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
}
