import Toybox.WatchUi;

class PaceConverterDelegate extends WatchUi.BehaviorDelegate {
    var view;

    function initialize(paceView) { 
        BehaviorDelegate.initialize();
        view = paceView;
    }

    // UP button - Scroll table up
    function onNextPage() { 
        view.scrollUp();
        WatchUi.requestUpdate();
        return true;
    }

    // DOWN button - Scroll table down
    function onPreviousPage() { 
        view.scrollDown();
        WatchUi.requestUpdate();
        return true;
    }

    // MENU button (or tapping the dots) - Open Settings
    function onMenu() {
        // Create the main settings menu
        var menu = new WatchUi.Menu2({:title=>"Settings"});
        
        // Prepare current unit and pace string for the sub-label
        var unit = AppConfig.UNIT_MODELS[AppConfig.currentUnitIndex];
        var paceStr = AppConfig.globalPaceMin + ":" + AppConfig.globalPaceSec.format("%02d");

        menu.addItem(new WatchUi.MenuItem(
            "Pace", 
            paceStr + " /" + unit[:suffix], 
            :id_pace, 
            {}
        ));
        
        menu.addItem(new WatchUi.MenuItem(
            "Add New Distance", 
            null, 
            :id_add_dist, 
            {}
        ));
        
        menu.addItem(new WatchUi.MenuItem(
            "Remove Distance",
            null, 
            :id_edit_list, 
            {}
        ));

        menu.addItem(new WatchUi.MenuItem(
            "Restore Defaults",
            null, 
            :id_restore_defaults, 
            {}
        ));

        // Push the menu view with the Delegate located in PaceConverterMenuDelegate.mc
        WatchUi.pushView(menu, new SettingsMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    // Select button (Start/Stop) can also trigger the menu if preferred
    function onSelect() {
        return onMenu();
    }
}