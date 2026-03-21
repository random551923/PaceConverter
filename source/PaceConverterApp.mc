import Toybox.Application;
import Toybox.WatchUi;

class PaceConverterApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state) {
    }

    // onStop() is called when your application is exiting
    function onStop(state) {
    }

    // Return the initial view and delegate of your application here
    function getInitialView() {
        var view = new PaceConverterView();
        var delegate = new PaceConverterDelegate(view);
        return [ view, delegate ];
    }
}

function getApp() {
    return Application.getApp();
}