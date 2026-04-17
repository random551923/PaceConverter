import Toybox.WatchUi;
import Toybox.Graphics;
import Toybox.Lang;

class PacePicker extends WatchUi.View {
    var minutes;
    var seconds;
    var focusOnMinutes = true; // true = mins, false = secs

    function initialize() {
        View.initialize();
        // Start with current global values
        minutes = AppConfig.globalPaceMin;
        seconds = AppConfig.globalPaceSec;
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        // 1. Draw Title
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height * 0.2, Graphics.FONT_XTINY, "SET PACE", Graphics.TEXT_JUSTIFY_CENTER);

        // 2. Prepare Time Strings
        var minStr = minutes.format("%02d");
        var secStr = seconds.format("%02d");

        // 3. Draw the Time (Center)
        // We split them to color the focused one differently
        var font = Graphics.FONT_NUMBER_MEDIUM;
        var spacing = dc.getTextWidthInPixels("00", font) / 2 + 5;

        // Draw Minutes
        dc.setColor(focusOnMinutes ? AppConfig.PRIMARY_COLOR : Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2 - spacing, height/2, font, minStr, Graphics.TEXT_JUSTIFY_RIGHT | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw Separator
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2, height/2, font, ":", Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Draw Seconds
        dc.setColor(!focusOnMinutes ? AppConfig.PRIMARY_COLOR : Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width/2 + spacing, height/2, font, secStr, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);

        // 4. Instructions at bottom
        dc.setColor(Graphics.COLOR_DK_GRAY, Graphics.COLOR_TRANSPARENT);
        var hint = focusOnMinutes ? "Set Minutes" : "Set Seconds";
        dc.drawText(width / 2, height * 0.8, Graphics.FONT_XTINY, hint, Graphics.TEXT_JUSTIFY_CENTER);
    }

    // Adjustment logic with Looping
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

    function initialize(v) {
        BehaviorDelegate.initialize();
        view = v;
    }

    function onNextPage() { // UP button
        view.adjust(-1);
        WatchUi.requestUpdate();
        return true;
    }

    function onNextPageHold() { // UP button HELD (faster decrease)
        view.adjust(-5);
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPage() { // DOWN button
        view.adjust(1);
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPageHold() { // DOWN button HELD (faster increase)
        view.adjust(5);
        WatchUi.requestUpdate();
        return true;
    }

    function onSelect() { // START button
        if (view.focusOnMinutes) {
            view.toggleFocus();
            WatchUi.requestUpdate();
        } else {
            // If already on seconds, START acts as "Confirm"
            saveAndExit();
        }
        return true;
    }

    function onBack() { // BACK button
        if (!view.focusOnMinutes) {
            // If on seconds, move back to minutes
            view.toggleFocus();
            WatchUi.requestUpdate();
            return true;
        }
        // If on minutes, BACK exits without saving (or saves and exits)
        return false; 
    }

    function saveAndExit() {
        AppConfig.globalPaceMin = view.minutes;
        AppConfig.globalPaceSec = view.seconds;
        
        // Pop the Picker AND the Menu to go back to the main list
        WatchUi.popView(WatchUi.SLIDE_IMMEDIATE); // Close Picker
        WatchUi.popView(WatchUi.SLIDE_RIGHT);     // Close Settings Menu
        WatchUi.requestUpdate();
    }
}