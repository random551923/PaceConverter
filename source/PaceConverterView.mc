import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class PaceConverterView extends WatchUi.View {
    var scrollOffset = 0; 
    var lastPaceMin = -1;
    var lastPaceSec = -1;
    var lastUnitIndex = -1;
    var lastScrollOffset = -1;

    function initialize() { View.initialize(); }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        var unit = AppConfig.UNIT_MODELS[AppConfig.currentUnitIndex];
        var totalPaceInSec = (AppConfig.globalPaceMin * 60) + AppConfig.globalPaceSec;

        lastPaceMin = AppConfig.globalPaceMin;
        lastPaceSec = AppConfig.globalPaceSec;
        lastUnitIndex = AppConfig.currentUnitIndex;
        lastScrollOffset = scrollOffset;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Header
        dc.setColor(AppConfig.PRIMARY_COLOR, Graphics.COLOR_TRANSPARENT);
        var paceStr = Lang.format("$1$:$2$ /$3$", [
            AppConfig.globalPaceMin, 
            AppConfig.globalPaceSec.format("%02d"), 
            unit[:suffix]
        ]);
        dc.drawText(width/2, height * 0.15, Graphics.FONT_LARGE, paceStr, Graphics.TEXT_JUSTIFY_CENTER);

        // Splits Table
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var yStart = height * 0.35;
        var spacing = height * 0.11;
        var maxRows = 5;
        
        var tableFont = Graphics.FONT_SMALL; 
        var centerX = width / 2;
        var columnGap = 10; // CONSTANT gap in pixels

        for (var i = 0; i < maxRows; i++) {
            var distIndex = scrollOffset + i;
            if (distIndex >= AppConfig.DISTANCES.size()) {
                break;
            }
            
            var dist = AppConfig.DISTANCES[distIndex];
            var split = (dist.toFloat() / 1000.0) * totalPaceInSec * unit[:mult];
            
            var distStr;
            if (dist >= 1000) {
                distStr = (dist / 1000.0).format("%.1f") + "km"; // Removed colon to save space
            } else {
                distStr = dist + "m";
            }
            
            var timeStr = split.format("%.1f") + "s";

            // DRAWING LOGIC:
            // 1. Distance: Right-aligned to (Center - half gap)
            dc.drawText(centerX - columnGap, yStart + (i * spacing), tableFont, distStr+":", Graphics.TEXT_JUSTIFY_RIGHT);
            
            // 3. Split Time: Left-aligned to (Center + half gap)
            dc.drawText(centerX + columnGap, yStart + (i * spacing), tableFont, timeStr, Graphics.TEXT_JUSTIFY_LEFT);
        }
    }

    function scrollUp() {
        if (scrollOffset < AppConfig.DISTANCES.size() - 5) {
            scrollOffset = scrollOffset + 1;
        }
    }

    function scrollDown() {
        if (scrollOffset > 0) {
            scrollOffset = scrollOffset - 1;
        }
    }
}