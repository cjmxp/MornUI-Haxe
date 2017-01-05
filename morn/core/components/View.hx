package morn.core.components;
class View extends Box {
    /**存储UI配置数据(用于加载模式)*/
    public static var uiMap:Dynamic = {};
    //private static var uiClassMap:Dynamic = {"Box": Box, "Button": Button, "CheckBox": CheckBox, "Clip": Clip, "ComboBox": ComboBox, "Component": Component, "Container": Container, "FrameClip": FrameClip, "HScrollBar": HScrollBar, "HSlider": HSlider, "Image": Image, "Label": Label, "LinkButton": LinkButton, "List": List, "Panel": Panel, "ProgressBar": ProgressBar, "RadioButton": RadioButton, "RadioGroup": RadioGroup, "ScrollBar": ScrollBar, "Slider": Slider, "Tab": Tab, "TextArea": TextArea, "TextInput": TextInput, "View": View, "ViewStack": ViewStack, "VScrollBar": VScrollBar, "VSlider": VSlider, "HBox": HBox, "VBox": VBox, "Tree": Tree};
    /**标准UI控件*/
    private static var uiClassMap(default, never):Dynamic={Box:Box,LayoutBox:LayoutBox,Group:Group,Button:Button,LinkButton:LinkButton,CheckBox:CheckBox,Clip:Clip,Image:Image,Label:Label,TextInput:TextInput,HSlider:HSlider};
    private static var viewClassMap:Dynamic = {};
    public function new() {
        super();
    }
    private function createView(uiView:Dynamic):Void {
        createComp(uiView, this, this);
    }
    /**加载UI(用于加载模式)*/
    private function loadUI(path:String):Void {

        //var uiView:Object = uiMap[path];
        //if (uiView) {
        //    createView(uiView);
       // }
    }
    /** 根据UI数据实例组件
     * @param	uiView UI数据
     * @param	comp 组件本体，如果为空，会新创建一个
     * @param	view 组件所在的视图实例，用来注册var全局变量，为空则不注册*/
    public static function createComp(uiView:Dynamic, comp:Component = null, view:View = null):Component {
        if (Std.is(uiView,Xml)) {
            var xml:Xml=cast(uiView,Xml);
            return createCompByXML(xml.nodeType==Xml.Document?xml.firstElement():xml, comp, view);
        } else {
            return createCompByJSON(uiView, comp, view);
        }
    }
    private static function createCompByJSON(json:Dynamic, comp:Component = null, view:View = null):Component {
        comp = comp!=null? comp:getCompInstanceByJSON(json);
        comp.comJSON = json;
        if(json.child!=null){
            for(i in 0...json.child.length){
                if (Std.is(comp,IRender) && json.child[i].props.name == "render") {
                    cast(comp,IRender).itemRender = json.child[i];
                } else {
                    comp.addChild(createCompByJSON(json.child[i], null, view));
                }
            }
        }
        if (json.props!=null){
            var keys:Array<String>=Reflect.fields(json.props);
            for(i in 0...keys.length) {
                var value:String=Std.string(Reflect.field(json.props,keys[i]));
                setCompValue(comp, keys[i], value, view);
            }
        }
        if (Std.is(comp,IItem)) {
            cast(comp,IItem).initItems();
        }
        return comp;
    }
    private static function createCompByXML(xml:Xml, comp:Component = null, view:View = null):Component {
        comp = comp!=null? comp: getCompInstanceByXML(xml);
        comp.comXml = xml;
        for (child in xml.elements()) {
            if (Std.is(comp,IRender) && child.get("name") == "render") {
                cast(comp,IRender).itemRender = child;
            } else {
                comp.addChild(createComp(child, null, view));
            }
        }
        for (att in xml.attributes()) {
            setCompValue(comp, att, xml.get(att),view);
        }
        if (Std.is(comp,IItem)) {
            cast(comp,IItem).initItems();
        }
        return comp;
    }
    private static function setCompValue(comp:Component, prop:String, value:String, view:View = null):Void {

        if (prop == "var" && view!=null){
            Reflect.setProperty(view,value,comp);
        }else{
            switch(prop){
                case "width":
                    comp.width=Std.parseFloat(value);
                case "height":
                    comp.height=Std.parseFloat(value);
                default:
                    Reflect.setProperty(comp,prop,(value == "true" ? true : (value == "false" ? false : value)));
            }

        }
    }
    /**获得组件实例*/
    private static function getCompInstanceByJSON(json:Dynamic):Component {
        var runtime:String = Reflect.hasField(json,"props") ? Reflect.field(json.props,"runtime") : "";
        var compClass:Dynamic = (runtime!="" && runtime!=null) ? Reflect.field(viewClassMap,runtime):Reflect.field(uiClassMap,json.type);
        return compClass!=null ? Type.createInstance(compClass,[]) : null;
    }
    /**获得组件实例*/
    private static function getCompInstanceByXML(xml:Xml):Component {
        var runtime:String = xml.get("runtime");
        var compClass:Dynamic = (runtime!="" && runtime!=null) ? Reflect.field(viewClassMap,runtime):Reflect.field(uiClassMap,xml.nodeName);
        return compClass!=null ? Type.createInstance(compClass,[]) : null;
    }
    /**重新创建组件(通过修改组件的数据，实现动态更改UI视图)
	* @param comp 需要重新生成的组件 comp为null时，重新创建整个视图*/
    public function reCreate(comp:Component = null):Void {
        comp = comp==null? this:comp;
        var dataSource:Dynamic = comp.dataSource;
        if (Std.is(comp,Box)) {
            cast(comp,Box).removeAllChild();
        }
        createComp(comp.comJSON==null?comp.comXml:comp.comJSON, comp, this);
        comp.dataSource = dataSource;
    }
    /**注册组件(用于扩展组件及修改组件对应关系)*/
    public static function registerComponent(key:String, compClass:Dynamic):Void {
       Reflect.setField(uiClassMap,key,compClass);
    }
    /**注册runtime解析*/
    public static function registerViewRuntime(key:String, compClass:Dynamic):Void {
        Reflect.setField(viewClassMap,key,compClass);
    }
}
