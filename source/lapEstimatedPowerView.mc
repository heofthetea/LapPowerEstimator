using Toybox.System as Sys;
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

    function compute(info as Activity.Info) as Numeric or Duration or String or Null {
    	if(info.timerTime < 1000) {
    		estimator.setStartElevation(info.altitude);
    	}
    	estimator.setElev(info.altitude);
    	estimator.setDist(info.elapsedDistance);
    	estimator.setTimer(info.timerTime);
    	
    	var power = estimator.estimate();
    	
        return power;
    }
    
    function onTimerLap() {
    	//Sys.println("new Lap");
    	estimator.reset();
    }

}