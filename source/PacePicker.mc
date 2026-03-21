import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

// --- 3. CUSTOM NUMBER FACTORY ---
class NumberFactory extends WatchUi.PickerFactory {
    var start, stop, step;

    function initialize(iStart, iStop, iStep) {
        PickerFactory.initialize();
        start = iStart;
        stop = iStop;
        step = iStep;
    }

    function getDrawable(index, selected) {
        // FR255s safe fonts: Medium for selected, Small for others
        var font = selected ? Graphics.FONT_MEDIUM : Graphics.FONT_SMALL;
        var color = selected ? Graphics.COLOR_ORANGE : Graphics.COLOR_WHITE;

        return new WatchUi.Text({
            :text => Lang.format("$1$", [getValue(index)]),
            :color => color,
            :font => font,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });
    }

    function getValue(index) {
        return start + (index * step);
    }

    function getSize() {
        return (stop - start) / step + 1;
    }
}

// --- 4. PACE PICKER (Timer Style) ---
class PacePicker extends WatchUi.Picker {
    function initialize() {
        var title = new WatchUi.Text({
            :text=>"Set Pace", 
            :locX=>WatchUi.LAYOUT_HALIGN_CENTER, 
            :locY=>WatchUi.LAYOUT_VALIGN_BOTTOM, 
            :color=>Graphics.COLOR_LT_GRAY
        });

        var minFactory = new NumberFactory(1, 20, 1);
        var secFactory = new NumberFactory(0, 59, 1);
        
        var separator = new WatchUi.Text({
            :text=>":", 
            :font=>Graphics.FONT_MEDIUM, 
            :color=>Graphics.COLOR_ORANGE,
            :locX => WatchUi.LAYOUT_HALIGN_CENTER,
            :locY => WatchUi.LAYOUT_VALIGN_CENTER
        });

        Picker.initialize({
            :title=>title,
            :pattern=>[minFactory, separator, secFactory],
            // Use current pace as the default starting position
            :defaults=>[AppConfig.globalPaceMin - 1, 0, AppConfig.globalPaceSec]
        });
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Draw selection highlight lines
        var cy = dc.getHeight() / 2;
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(2);
        dc.drawLine(0, cy - 22, dc.getWidth(), cy - 22);
        dc.drawLine(0, cy + 22, dc.getWidth(), cy + 22);

        Picker.onUpdate(dc);
    }
}

// --- 5. PICKER DELEGATE (The Start/Back Logic) ---
class PacePickerDelegate extends WatchUi.PickerDelegate {
    function initialize() { PickerDelegate.initialize(); }

    function onAccept(values) {
        // Explicitly cast to Number to fix "PolyType" error
        if (values[0] != null) {
            AppConfig.globalPaceMin = values[0].toNumber();
        }
        if (values[2] != null) {
            AppConfig.globalPaceSec = values[2].toNumber();
        }

        // Close Picker and Settings Menu
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); 
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        
        WatchUi.requestUpdate();
        return true;
    }

    function onCancel() {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}