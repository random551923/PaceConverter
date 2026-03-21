import Toybox.Application;
import Toybox.WatchUi;

class PaceConverterApp extends Application.AppBase {
    function initialize() { AppBase.initialize(); }

    function getInitialView() {
        var view = new PaceConverterView();
        return [ view, new PaceConverterDelegate(view) ];
    }
}