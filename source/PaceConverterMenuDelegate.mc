import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.Lang;

// 1. MAIN SETTINGS MENU DELEGATE
class SettingsMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();

        // PATH 1: Edit Pace (Using your existing PacePicker)
        if (id == :id_pace) {
            var pacePicker = new PacePicker();
            WatchUi.pushView(
                pacePicker,
                new PacePickerDelegate(pacePicker),
                WatchUi.SLIDE_LEFT
            );
        }

        // PATH 2: Add New Distance (Using the new Custom Picker)
        else if (id == :id_add_dist) {
            var distPicker = new DistancePicker();
            WatchUi.pushView(
                distPicker,
                new DistancePickerDelegate(distPicker),
                WatchUi.SLIDE_LEFT
            );
        }

        // PATH 3: Edit Distance List (Delete)
        else if (id == :id_edit_list) {
            var editMenu = new WatchUi.Menu2({ :title => "Remove items" });
            var dists = AppConfig.activeDistances as Array<Number>;

            for (var i = 0; i < dists.size(); i++) {
                var d = dists[i] as Number;
                var label =
                    d >= 1000 ? (d / 1000.0).format("%.1f") + "km" : d + "m";
                // We use the index 'i' as the ID for deletion
                editMenu.addItem(
                    new WatchUi.MenuItem(label, "Tap to Remove", i, {})
                );
            }
            WatchUi.pushView(
                editMenu,
                new ManageDistancesDelegate(),
                WatchUi.SLIDE_LEFT
            );
        }

        // PATH 4: Restore App To Defaults Values
        else if (id == :id_restore_defaults) {
            AppConfig.activeDistances = AppConfig.DEFAULT_DISTANCES;
            AppConfig.currentUnitIndex = AppConfig.DEFAULT_UNIT_INDEX;
            AppConfig.globalPaceMin = AppConfig.DEFAULT_PACE_MIN;
            AppConfig.globalPaceSec = AppConfig.DEFAULT_PACE_SEC;

            WatchUi.popView(WatchUi.SLIDE_DOWN);
        }
    }

    function onBack() as Void {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}

// 2. MANAGE DISTANCES DELEGATE (Logic for Deleting)
class ManageDistancesDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var id = item.getId();
        if (id instanceof Number) {
            var dists = AppConfig.activeDistances as Array<Number>;
            var index = id as Number;

            // Remove the selected distance from the array
            if (index >= 0 && index < dists.size()) {
                dists.remove(dists[index]);
                Storage.setValue("userDistances", dists);
            }

            // Refresh the screen: Pop back to the main settings menu
            // WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);

            // 2. Remove the item from the Menu2 UI immediately
            // We get the current view (the menu) and find where this item is
            var currentMenu = WatchUi.getCurrentView()[0] as WatchUi.Menu2;
            if (currentMenu != null) {
                var idx = currentMenu.findItemById(id);
                if (idx != -1) {
                    currentMenu.deleteItem(idx);
                }
            }

            // 3. Optional: If the menu is now empty, you might want to pop back
            if (dists.size() == 0) {
                WatchUi.popView(WatchUi.SLIDE_RIGHT);
            } else {
                WatchUi.requestUpdate();
            }
        }
    }
}

// 3. UNIT SELECTION DELEGATE (If you decide to add unit switching back later)
class UnitSelectionDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as WatchUi.MenuItem) as Void {
        var unitId = item.getId() as Number;
        AppConfig.currentUnitIndex = unitId;
        Storage.setValue("unitIdx", unitId);

        // Return to main screen
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}
