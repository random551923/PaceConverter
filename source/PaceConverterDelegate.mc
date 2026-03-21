import Toybox.WatchUi;

class PaceConverterDelegate extends WatchUi.BehaviorDelegate {
    function initialize(view) { BehaviorDelegate.initialize(); }

    function onMenu() {
        var menu = new WatchUi.Menu2({:title=>"Settings"});
        var unit = AppConfig.UNIT_MODELS[AppConfig.currentUnitIndex];
        var paceStr = AppConfig.globalPaceMin + ":" + AppConfig.globalPaceSec.format("%02d");

        // 1. Pace First
        menu.addItem(new WatchUi.MenuItem("Pace", paceStr + " /" + unit[:suffix], :id_pace, {}));
        // 2. Units Second
        menu.addItem(new WatchUi.MenuItem("Units", unit[:label], :id_units, {}));

        WatchUi.pushView(menu, new SettingsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}