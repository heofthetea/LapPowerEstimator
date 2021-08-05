//TODO: add power estimation algorithm
//TODO: add CIQ settings

using Toybox.System as Sys;

import Toybox.Activity;

class powerEstimator {

	private var startElevation; // metres
	private var startDistance; // metres
	private var startTimer; // milliseconds
	
	private var currentElev; // metres
	private var currentDist; // metres
	private var currentTimer; // milliseconds
	
	public function initialize() {
		self.startElevation = 0.0;
		self.startDistance = 0.0;
		self.startTimer = 0.0;
		
	}
	
	function estimate() {
		if(self.currentDist == null) {
			self.currentDist = 0;
		}
		
		Sys.println(self.currentElev);
		Sys.println(self.currentDist);
		Sys.println(self.currentTimer + "\n");
		
		var lapElev = self.currentElev - self.startElevation; // metres
		var lapDist = self.currentDist - self.startDistance; // metres
		var lapTimer = (self.currentTimer - self.startTimer) / 1000; // seconds
		
		if(lapDist != 0 and lapTimer != 0) {
			var lapSlope = lapElev / lapDist; // percent as decimal
			var lapSpeed = (lapDist * 1000) / (lapTimer * 3600); // km/h
			
			//TODO: only estimate power here
		}
		
		return lapTimer;
	}
	
	function reset() {
		self.startElevation = currentElev;
		self.startDistance = currentDist;
		self.startTimer = currentTimer;
	}
	
	//-----------------------------------------------------------------------------------------------
	
	function rollingResistance() {}
	
	function airResistance() {}
	
	function gravity() {}
	
	//-----------------------------------------------------------------------------------------------
	
	
	public function setElev(elev) {
		self.currentElev = elev;
	}
	
	public function setDist(dist) {
		self.currentDist = dist;
	}
	
	public function setTimer(time) {
		self.currentTimer = time;
	}

}