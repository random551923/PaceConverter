import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class PaceConverterView extends WatchUi.View {
    var scrollOffset = 0; // Track scroll position in distance table
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

        // Only render if something changed (battery optimization)
        if (lastPaceMin == AppConfig.globalPaceMin && 
            lastPaceSec == AppConfig.globalPaceSec && 
            lastUnitIndex == AppConfig.currentUnitIndex && 
            lastScrollOffset == scrollOffset) {
            return; // Nothing changed, skip rendering
        }
        
        lastPaceMin = AppConfig.globalPaceMin;
        lastPaceSec = AppConfig.globalPaceSec;
        lastUnitIndex = AppConfig.currentUnitIndex;
        lastScrollOffset = scrollOffset;

        // Now clear the screen for rendering
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // Header: Current Pace (e.g., 4:00 /km)
        dc.setColor(AppConfig.PRIMARY_COLOR, Graphics.COLOR_TRANSPARENT);
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
        var maxRows = 5;

        for (var i = 0; i < maxRows; i++) {
            var distIndex = scrollOffset + i;
            // Stop at the end, don't loop
            if (distIndex >= AppConfig.DISTANCES.size()) {
                break;
            }
            
            var dist = AppConfig.DISTANCES[distIndex];
            var split = (dist.toFloat() / 1000.0) * totalPaceInSec * unit[:mult];
            
            // Format distance: show KM for distances >= 1000m, otherwise meters
            var distStr;
            if (dist >= 1000) {
                distStr = (dist / 1000.0).format("%.1f") + "km:";
            } else {
                distStr = dist + "m:";
            }
            
            dc.drawText(width * 0.15, yStart + (i * spacing), Graphics.FONT_TINY, distStr, Graphics.TEXT_JUSTIFY_LEFT);
            dc.drawText(width * 0.85, yStart + (i * spacing), Graphics.FONT_TINY, split.format("%.1f") + "s", Graphics.TEXT_JUSTIFY_RIGHT);
        }
    }

    function scrollUp() {
        // Stop at the end, don't loop
        if (scrollOffset < AppConfig.DISTANCES.size() - 5) {
            scrollOffset = scrollOffset + 1;
        }
    }

    function scrollDown() {
        // Don't go past the beginning
        if (scrollOffset > 0) {
            scrollOffset = scrollOffset - 1;
        }
    }
}