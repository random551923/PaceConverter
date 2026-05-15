import Toybox.Graphics;

module AppConfig {
    

    const PRIMARY_COLOR = Graphics.COLOR_ORANGE;

    const UNIT_MODELS = [
        { :label => "Kilometers", :suffix => "km", :mult => 1.0 },
        { :label => "Miles", :suffix => "mi", :mult => 1.60934 },
    ];
   
    const DEFAULT_DISTANCES = [100, 200, 400, 800, 1200, 1500, 1600, 2000];
    const DEFAULT_UNIT_INDEX = 0;
    const DEFAULT_PACE_MIN = 4;
    const DEFAULT_PACE_SEC = 0;

    // This will hold the list actually being used by the View
    var activeDistances = DEFAULT_DISTANCES;
    var currentUnitIndex = DEFAULT_UNIT_INDEX;
    var globalPaceMin = DEFAULT_PACE_MIN;
    var globalPaceSec = DEFAULT_PACE_SEC;
}
