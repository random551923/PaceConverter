import Toybox.Graphics;

module AppConfig {
    var currentUnitIndex = 0;
    var globalPaceMin = 4;
    var globalPaceSec = 0;

    const PRIMARY_COLOR = Graphics.COLOR_ORANGE;

    const UNIT_MODELS = [
        { :label => "Kilometers", :suffix => "km", :mult => 1.0 },
        { :label => "Miles", :suffix => "mi", :mult => 1.60934 },
    ];

    const DISTANCES = [100, 200, 400, 800, 1000, 1200, 1500, 1600, 2000];

    // These are now just the DEFAULTS
    const DEFAULT_DISTANCES = [100, 200, 400, 800, 1200, 1500, 1600, 2000];
    
    // This will hold the list actually being used by the View
    var activeDistances = [];
}
