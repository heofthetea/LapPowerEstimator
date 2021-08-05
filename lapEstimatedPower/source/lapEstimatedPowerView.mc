import Toybox.Activity;
import Toybox.Lang;
import Toybox.Time;
import Toybox.WatchUi;

class lapEstimatedPowerView extends WatchUi.SimpleDataField {
	
	private var estimator;
	
    function initialize() {
        SimpleDataField.initialize();
        label = "Lap Power";
        
        self.estimator = new powerEstimator();
    }

    // The given info object contains all the current workout information. Calculate a value and return it in this method.
    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
    	estimator.setElev(info.altitude);
    	estimator.setDist(info.elapsedDistance);
    	estimator.setTimer(info.timerTime);
    	
    	var time = estimator.estimate();
    	
        return time;
    }
    
    function onTimerLap() {
    	estimator.reset();
    }

}