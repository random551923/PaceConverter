import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class PaceConverterView extends WatchUi.View {
    function initialize() { View.initialize(); }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        
        var unit = AppConfig.UNIT_MODELS[AppConfig.currentUnitIndex];
        var totalPaceInSec = (AppConfig.globalPaceMin * 60) + AppConfig.globalPaceSec;

        // Header: Current Pace (e.g., 4:00 /km)
        dc.setColor(Graphics.COLOR_ORANGE, Graphics.COLOR_TRANSPARENT);
        var paceStr = Lang.format("$1$:$2$ /$3$", [
            AppConfig.globalPaceMin, 
            AppConfig.globalPaceSec.format("%02d"), 
            unit[:suffix]
        ]);
        dc.drawText(width/2, height * 0.15, Graphics.FONT_MEDIUM, paceStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Splits Table
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var yStart = height * 0.35;
        var spacing = height * 0.11;

        for (var i = 0; i < 5; i++) {
            var dist = AppConfig.TRACK_DISTANCES[i];
            var split = (dist.toFloat() / 1000.0) * totalPaceInSec * unit[:mult];
            
            dc.drawText(width * 0.25, yStart + (i * spacing), Graphics.FONT_TINY, dist + "m:", Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(width * 0.75, yStart + (i * spacing), Graphics.FONT_TINY, split.format("%.1f") + "s", Graphics.TEXT_JUSTIFY_RIGHT);
        }
    }
}