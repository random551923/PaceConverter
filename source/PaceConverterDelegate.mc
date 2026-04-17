import Toybox.WatchUi;

class PaceConverterDelegate extends WatchUi.BehaviorDelegate {
    var view;

    function initialize(paceView) { 
        BehaviorDelegate.initialize();
        view = paceView;
    }

    function onNextPage() { // UP button - scroll up in the distance table
        view.scrollUp();
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPage() { // DOWN button - scroll down in the distance table
        view.scrollDown();
        WatchUi.requestUpdate();
        return true;
    }
    function onMenu() {
        var menu = new WatchUi.Menu2({:title=>"Settings"});
        var unit = AppConfig.UNIT_MODELS[AppConfig.currentUnitIndex];
        
        // This line ensures we get the LATEST saved pace every time the menu opens
        var paceStr = AppConfig.globalPaceMin + ":" + AppConfig.globalPaceSec.format("%02d");

        menu.addItem(new WatchUi.MenuItem("Pace", paceStr + " /" + unit[:suffix], :id_pace, {}));
        menu.addItem(new WatchUi.MenuItem("Units", unit[:label], :id_units, {}));

        WatchUi.pushView(menu, new SettingsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}