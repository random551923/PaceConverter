import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Application;
import Toybox.Application.Storage;

class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        if (item.getId() == :id_pace) {
            // Push the custom Pace Picker
            var pacePicker = new PacePicker();
            WatchUi.pushView(
                pacePicker,
                new PacePickerDelegate(pacePicker),
                WatchUi.SLIDE_LEFT
            );
        } else if (item.getId() == :id_units) {
            var unitMenu = new WatchUi.Menu2({ :title => "Select Unit" });

            // Loop through UNIT_MODELS for "Label - Suffix"
            for (var i = 0; i < AppConfig.UNIT_MODELS.size(); i++) {
                var u = AppConfig.UNIT_MODELS[i];
                var displayName = u[:label] + " - " + u[:suffix];
                unitMenu.addItem(
                    new WatchUi.MenuItem(displayName, null, i, {})
                );
            }
            WatchUi.pushView(
                unitMenu,
                new UnitSelectionDelegate(),
                WatchUi.SLIDE_LEFT
            );
        }
    }

    
    function onBack() {
        // This closes the current Settings Menu and returns to the PaceConverterView
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

class UnitSelectionDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) {
        AppConfig.currentUnitIndex = item.getId();
        Storage.setValue("unitIdx", AppConfig.currentUnitIndex);

        // Pop twice to return to main split screen immediately
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);

        WatchUi.requestUpdate();
    }
}
