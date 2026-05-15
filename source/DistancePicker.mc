import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.Application.Storage;

class DistancePicker extends WatchUi.View {
    var km = 1;
    var decaMeters = 0; // 0 to 95 (increments of 5, where each unit = 10m)
    var focusOnKm = true;

    function initialize() {
        View.initialize();
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerY = height / 2;

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height * 0.12, Graphics.FONT_XTINY, "SET DISTANCE", Graphics.TEXT_JUSTIFY_CENTER);

        var mainFont = Graphics.FONT_NUMBER_MEDIUM;
        var shadowFont = Graphics.FONT_XTINY; 
        var spacing = dc.getTextWidthInPixels("00", mainFont) / 2 + 12;
        var vOffset = 32; 

        // Wheel calculations
        // KM moves by 1
        var nextK = (km + 1 > 99) ? 0 : km + 1;
        var prevK = (km - 1 < 0) ? 99 : km - 1;
        
        // Decameters move by 5
        var nextD = (decaMeters + 5 > 95) ? 0 : decaMeters + 5;
        var prevD = (decaMeters - 5 < 0) ? 95 : decaMeters - 5;

        // KM Column (Left)
        if (focusOnKm) {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2 - spacing, centerY - vOffset, shadowFont, nextK.format("%02d"), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(width/2 - spacing, centerY + vOffset, shadowFont, prevK.format("%02d"), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(AppConfig.PRIMARY_COLOR, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(width/2 - spacing, centerY, mainFont, km.format("%02d"), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);

        // The Separator Dot
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, centerY, mainFont, ".", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Decameters Column (Right)
        if (!focusOnKm) {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2 + spacing, centerY - vOffset, shadowFont, nextD.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(width/2 + spacing, centerY + vOffset, shadowFont, prevD.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(AppConfig.PRIMARY_COLOR, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(width/2 + spacing, centerY, mainFont, decaMeters.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        var subLabel = focusOnKm ? "KILOMETERS" : "METERS";
        dc.drawText(width / 2, height * 0.88, Graphics.FONT_XTINY, subLabel, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function adjust(amount) {
        if (focusOnKm) {
            km += amount;
            if (km > 99) { km = 0; }
            if (km < 0) { km = 99; }
        } else {
            // Apply a jump of 5 (e.g., 0, 5, 10... 95)
            decaMeters += (amount * 5);
            if (decaMeters > 95) { decaMeters = 0; }
            if (decaMeters < 0) { decaMeters = 95; }
        }
    }

    function toggleFocus() {
        focusOnKm = !focusOnKm;
    }
}

class DistancePickerDelegate extends WatchUi.BehaviorDelegate {
    var view;
    var scrollTimer;
    var startDelayTimer;
    var scrollDir = 0;

    function initialize(v) {
        BehaviorDelegate.initialize();
        view = v;
        scrollTimer = new Timer.Timer();
        startDelayTimer = new Timer.Timer();
    }

    function onPreviousPage() { 
        view.adjust(1);
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPage() { 
        view.adjust(-1);
        WatchUi.requestUpdate();
        return true;
    }

    function onKeyPressed(evt) {
        var key = evt.getKey();
        if (key == WatchUi.KEY_UP) {
            scrollDir = 1;
            startDelayTimer.start(method(:startScrolling), 250, false);
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            scrollDir = -1;
            startDelayTimer.start(method(:startScrolling), 250, false);
            return true;
        }
        return false;
    }

    function onKeyReleased(evt) {
        startDelayTimer.stop();
        scrollTimer.stop();
        return true;
    }

    function startScrolling() {
        scrollTimer.start(method(:onTimerTick), 100, true);
    }

    function onTimerTick() {
        view.adjust(scrollDir);
        WatchUi.requestUpdate();
    }

    function onSelect() {
        if (view.focusOnKm) {
            view.toggleFocus();
            WatchUi.requestUpdate();
        } else {
            saveAndExit();
        }
        return true;
    }

    function onBack() {
        if (!view.focusOnKm) {
            view.toggleFocus();
            WatchUi.requestUpdate();
            return true;
        }
        return false; 
    }

    function saveAndExit() {

        scrollTimer.stop();
        startDelayTimer.stop();

        var totalMeters = (view.km * 1000) + (view.decaMeters * 10);
        if (totalMeters > 0) {
            var dists = AppConfig.activeDistances as Array<Number>;
            dists.add(totalMeters);
            Storage.setValue("userDistances", dists);
        }

        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }

}