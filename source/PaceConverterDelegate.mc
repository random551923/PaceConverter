import Toybox.WatchUi;

class PaceConverterDelegate extends WatchUi.BehaviorDelegate {
    function initialize(view) {
        BehaviorDelegate.initialize();
    }

    // This triggers when the user presses the Menu button
    function onMenu() {
        var menu = new WatchUi.Menu2({:title=>"Settings"});
        
        var unit = AppConfig.UNIT_MODELS[AppConfig.currentUnitIndex];
        var paceStr = AppConfig.globalPaceMin + ":" + AppConfig.globalPaceSec.format("%02d");

        // The "Sub-label" shows the current value in the menu
        menu.addItem(new WatchUi.MenuItem("Units", unit[:label], :id_units, {}));
        menu.addItem(new WatchUi.MenuItem("Pace", paceStr + " /" + unit[:suffix], :id_pace, {}));

        // We push the specialized Menu Delegate here
        WatchUi.pushView(menu, new SettingsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }
}