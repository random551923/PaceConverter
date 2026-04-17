import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;

class PacePicker extends WatchUi.View {
    var minutes;
    var seconds;
    var focusOnMinutes = true;

    function initialize() {
        View.initialize();
        minutes = (AppConfig.globalPaceMin != null) ? AppConfig.globalPaceMin : 5;
        seconds = (AppConfig.globalPaceSec != null) ? AppConfig.globalPaceSec : 0;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerY = height / 2;

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height * 0.12, Graphics.FONT_XTINY, "SET PACE", Graphics.TEXT_JUSTIFY_CENTER);

        var mainFont = Graphics.FONT_NUMBER_MEDIUM;
        var shadowFont = Graphics.FONT_XTINY; 
        var spacing = dc.getTextWidthInPixels("00", mainFont) / 2 + 12;
        var vOffset = 32; 

        // Calculation for the "Wheel" display
        var nextM = (minutes + 1 > 20) ? 1 : minutes + 1;
        var prevM = (minutes - 1 < 1) ? 20 : minutes - 1;
        var nextS = (seconds + 1 > 59) ? 0 : seconds + 1;
        var prevS = (seconds - 1 < 0) ? 59 : seconds - 1;

        // Minutes Column
        if (focusOnMinutes) {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            // Show the higher number above, lower number below
            dc.drawText(width/2 - spacing, centerY - vOffset, shadowFont, nextM.format("%02d"), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(width/2 - spacing, centerY + vOffset, shadowFont, prevM.format("%02d"), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(AppConfig.PRIMARY_COLOR, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(width/2 - spacing, centerY, mainFont, minutes.format("%02d"), Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, centerY, mainFont, ":", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Seconds Column
        if (!focusOnMinutes) {
            dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
            dc.drawText(width/2 + spacing, centerY - vOffset, shadowFont, nextS.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.drawText(width/2 + spacing, centerY + vOffset, shadowFont, prevS.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
            dc.setColor(AppConfig.PRIMARY_COLOR, Graphics.COLOR_TRANSPARENT);
        } else {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        }
        dc.drawText(width/2 + spacing, centerY, mainFont, seconds.format("%02d"), Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height * 0.88, Graphics.FONT_XTINY, focusOnMinutes ? "MINUTES" : "SECONDS", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function adjust(amount) {
        if (focusOnMinutes) {
            minutes += amount;
            if (minutes > 20) { minutes = 1; }
            if (minutes < 1) { minutes = 20; }
        } else {
            seconds += amount;
            if (seconds > 59) { seconds = 0; }
            if (seconds < 0) { seconds = 59; }
        }
    }

    function toggleFocus() {
        focusOnMinutes = !focusOnMinutes;
    }
}

class PacePickerDelegate extends WatchUi.BehaviorDelegate {
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

    // SWAPPED: onPreviousPage is usually the TOP button on Garmin
    function onPreviousPage() { 
        view.adjust(1); // Increase
        WatchUi.requestUpdate();
        return true;
    }

    // SWAPPED: onNextPage is usually the BOTTOM button on Garmin
    function onNextPage() { 
        view.adjust(-1); // Decrease
        WatchUi.requestUpdate();
        return true;
    }

    function onKeyPressed(evt) {
        var key = evt.getKey();
        if (key == WatchUi.KEY_UP) {
            scrollDir = 1; // Increase
            startDelayTimer.start(method(:startScrolling), 250, false);
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            scrollDir = -1; // Decrease
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
        scrollTimer.start(method(:onTimerTick), 140, true);
    }

    function onTimerTick() {
        view.adjust(scrollDir);
        WatchUi.requestUpdate();
    }

    function onSelect() {
        if (view.focusOnMinutes) {
            view.toggleFocus();
            WatchUi.requestUpdate();
        } else {
            saveAndExit();
        }
        return true;
    }

    function onBack() {
        if (!view.focusOnMinutes) {
            view.toggleFocus();
            WatchUi.requestUpdate();
            return true;
        }
        return false; 
    }

    function saveAndExit() {
        scrollTimer.stop();
        startDelayTimer.stop();
        AppConfig.globalPaceMin = view.minutes;
        AppConfig.globalPaceSec = view.seconds;
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
    }
}