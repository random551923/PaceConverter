import Toybox.Application;
import Toybox.WatchUi;

class PaceConverterApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

   
    function onStart(state) {
        var savedMin = Storage.getValue("paceMin");
        var savedSec = Storage.getValue("paceSec");
        var savedUnit = Storage.getValue("unitIdx");

        if (savedMin != null) {
            AppConfig.globalPaceMin = savedMin;
        }
        if (savedSec != null) {
            AppConfig.globalPaceSec = savedSec;
        }
        if (savedUnit != null) {
            AppConfig.currentUnitIndex = savedUnit;
        }
    }

    function onStop(state) {
        Storage.setValue("paceMin", AppConfig.globalPaceMin);
        Storage.setValue("paceSec", AppConfig.globalPaceSec);
        Storage.setValue("unitIdx", AppConfig.currentUnitIndex);
    }

    function getInitialView() {
        var view = new PaceConverterView();
        var delegate = new PaceConverterDelegate(view);
        return [view, delegate];
    }
}

function getApp() {
    return Application.getApp();
}
