import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Application.Storage;

class PaceConverterApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
        // Load Pace & Units
        var savedMin = Storage.getValue("paceMin");
        var savedSec = Storage.getValue("paceSec");
        var savedUnit = Storage.getValue("unitIdx");

        if (savedMin != null) { AppConfig.globalPaceMin = savedMin; }
        if (savedSec != null) { AppConfig.globalPaceSec = savedSec; }
        if (savedUnit != null) { AppConfig.currentUnitIndex = savedUnit; }

        // Load or Initialize Distance List
        var savedDistances = Storage.getValue("userDistances");
        if (savedDistances) {
            AppConfig.activeDistances = savedDistances;
        }
    }

    function onStop(state) {
        Storage.setValue("paceMin", AppConfig.globalPaceMin);
        Storage.setValue("paceSec", AppConfig.globalPaceSec);
        Storage.setValue("unitIdx", AppConfig.currentUnitIndex);
        Storage.setValue("userDistances", AppConfig.activeDistances);
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