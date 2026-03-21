import Toybox.WatchUi;

// --- 1. THE MAIN SETTINGS MENU ---
class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() { Menu2InputDelegate.initialize(); }

    function onSelect(item) {
        if (item.getId() == :id_units) {
            var unitMenu = new WatchUi.Menu2({:title=>"Select Unit"});
            // Loop through models to create "Label - Suffix"
            for (var i = 0; i < AppConfig.UNIT_MODELS.size(); i++) {
                var u = AppConfig.UNIT_MODELS[i];
                unitMenu.addItem(new WatchUi.MenuItem(u[:label] + " - " + u[:suffix], null, i, {}));
            }
            WatchUi.pushView(unitMenu, new UnitSelectionDelegate(), WatchUi.SLIDE_LEFT);

        } else if (item.getId() == :id_pace) {
            var paceMenu = new WatchUi.Menu2({:title=>"Adjust Pace"});
            paceMenu.addItem(new WatchUi.MenuItem("+5 Seconds", "", :plus, {}));
            paceMenu.addItem(new WatchUi.MenuItem("-5 Seconds", "", :minus, {}));
            WatchUi.pushView(paceMenu, new PaceAdjustDelegate(), WatchUi.SLIDE_LEFT);
        }
    }
}

// --- 2. THE UNIT PICKER (AUTO-CLOSES) ---
class UnitSelectionDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() { Menu2InputDelegate.initialize(); }

    function onSelect(item) {
        AppConfig.currentUnitIndex = item.getId();
        
        // Pop the Unit Menu
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); 
        // Pop the Settings Menu to go back to main screen
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        
        WatchUi.requestUpdate();
    }
}

// --- 3. THE PACE ADJUSTER ---
class PaceAdjustDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() { Menu2InputDelegate.initialize(); }

    function onSelect(item) {
        var total = (AppConfig.globalPaceMin * 60) + AppConfig.globalPaceSec;
        total += (item.getId() == :plus) ? 5 : -5;
        
        if (total < 30) { total = 30; }
        AppConfig.globalPaceMin = total / 60;
        AppConfig.globalPaceSec = total % 60;
        
        WatchUi.requestUpdate(); 
    }
}