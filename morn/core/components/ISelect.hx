package morn.core.components;
import morn.core.handlers.Handler;
interface ISelect {
    var selected(get,set):Bool;
    var clickHandler(get,set):Handler;
}
