import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class PaceConverterView extends WatchUi.View {
    var scrollOffset = 0;
    var lastPaceMin = -1;
    var lastPaceSec = -1;
    var lastUnitIndex = -1;
    var lastScrollOffset = -1;

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        var width = dc.getWidth();
        var height = dc.getHeight();

        var unit = AppConfig.UNIT_MODELS[AppConfig.currentUnitIndex];
        var totalPaceInSec =
            AppConfig.globalPaceMin * 60 + AppConfig.globalPaceSec;

        lastPaceMin = AppConfig.globalPaceMin;
        lastPaceSec = AppConfig.globalPaceSec;
        lastUnitIndex = AppConfig.currentUnitIndex;
        lastScrollOffset = scrollOffset;

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // 1. Draw the "Beautiful" Menu Indicator
        drawMenuIndicator(dc, width, height);

        // Header
        dc.setColor(AppConfig.PRIMARY_COLOR, Graphics.COLOR_TRANSPARENT);
        var paceStr = Lang.format("$1$:$2$ /$3$", [
            AppConfig.globalPaceMin,
            AppConfig.globalPaceSec.format("%02d"),
            unit[:suffix],
        ]);
        dc.drawText(
            width / 2,
            height * 0.15,
            Graphics.FONT_LARGE,
            paceStr,
            Graphics.TEXT_JUSTIFY_CENTER
        );

        // Splits Table
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var yStart = height * 0.35;
        var spacing = height * 0.11;
        var maxRows = 5;

        var tableFont = Graphics.FONT_SMALL;
        var centerX = width / 2;
        var columnGap = 10; // CONSTANT gap in pixels

        // Get the active distances array
        var dists = AppConfig.activeDistances as Array<Number>;

        for (var i = 0; i < maxRows; i++) {
            var distIndex = scrollOffset + i;
            if (distIndex >= dists.size()) {
                break;
            }

            var dist = dists[distIndex] as Number;
            var split =
                (dist.toFloat() / 1000.0) * totalPaceInSec * unit[:mult];

            var distStr;
            if (dist >= 1000) {
                distStr = (dist / 1000.0).format("%.2f") + "km";
            } else {
                distStr = dist + "m";
            }

            // Format time as H:MM:SS, M:SS, or S.S
            var timeStr;
            if (split >= 3600) {
                // Hours logic
                var h = (split / 3600).toNumber();
                var m = ((split.toNumber() % 3600) / 60).toNumber();
                var s = split.toNumber() % 60;
                timeStr =
                    h + ":" + m.format("%02d") + ":" + s.format("%02d") + "h";
            } else if (split >= 60) {
                // Minutes logic
                var m = (split / 60).toNumber();
                var s = split.toNumber() % 60;
                timeStr = m + ":" + s.format("%02d") + "m";
            } else {
                // Seconds logic
                timeStr = split.format("%.1f") + "s";
            }

            // DRAWING LOGIC:
            dc.drawText(
                centerX - columnGap,
                yStart + i * spacing,
                tableFont,
                distStr + ":",
                Graphics.TEXT_JUSTIFY_RIGHT
            );
            dc.drawText(
                centerX + columnGap,
                yStart + i * spacing,
                tableFont,
                timeStr,
                Graphics.TEXT_JUSTIFY_LEFT
            );
        }
    }

    function drawMenuIndicator(dc, width, height) {
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        if (dc has :setAntiAlias) {
            dc.setAntiAlias(true);
        }

        var dotRadius = 2;
        var dotSpacing = 7.5;

        var isRound =
            System.getDeviceSettings().screenShape == System.SCREEN_SHAPE_ROUND;
        var xOffset = isRound ? 12 : 6;

        var xPos = xOffset;
        var yPos = height / 2;

        dc.fillCircle(xPos, yPos - dotSpacing, dotRadius);
        dc.fillCircle(xPos, yPos, dotRadius);
        dc.fillCircle(xPos, yPos + dotSpacing, dotRadius);

        if (isRound) {
            dc.setPenWidth(2);
            var radius = width / 2 - 4;
            var centerX = width / 2;
            var centerY = height / 2;
            dc.drawArc(
                centerX,
                centerY,
                radius,
                Graphics.ARC_CLOCKWISE,
                191,
                169
            );
        }

        if (dc has :setAntiAlias) {
            dc.setAntiAlias(false);
        }
    }

    function scrollUp() {
        var dists = AppConfig.activeDistances as Array<Number>;
        if (scrollOffset < dists.size() - 5) {
            scrollOffset = scrollOffset + 1;
        }
    }

    function scrollDown() {
        if (scrollOffset > 0) {
            scrollOffset = scrollOffset - 1;
        }
    }
}
