//TODO: add CIQ settings

using Toybox.System as Sys;
import Toybox.Math;

class powerEstimator {

	private const GRAVITATIONAL_CONST = 9.8067;
	private const AIR_DENSITY =  1.22601;
	private const DRIVETRAIN_LOSS = .02;
	
	private const WEIGHT_RIDER = 62;
	private const WEIGHT_BIKE = 9;
	private const CRR = .004;
	private const FRONTAL_AREA = .4;
	private const DRAG_COEFFICIENT = .9;
	
	private var startElevation; //m
	private var startDistance; //m
	private var startTimer; //ms
	
	private var currentElev; //m
	private var currentDist; //m
	private var currentTimer; //ms
	
	public function initialize() {
		self.startDistance = 0.0;
		self.startTimer = 0.0;
	}
	
	function estimate() {
		if(self.currentDist == null) { //avoiding application crash before activity start
			self.currentDist = 0;
		}
		
		var lapElev = self.currentElev - self.startElevation; //m
		var lapDist = self.currentDist - self.startDistance; //m
		var lapTimer = (self.currentTimer - self.startTimer) / 1000; //s
		
		//lapDist = 10 * lapTimer; //only for simulating purposes, setting a constant velocity of 36 km/h
		if(lapDist != 0 and lapTimer != 0) {
			var lapSlope = lapElev / lapDist; //% as decimal
			var lapSpeed = lapDist/lapTimer; //m/s
			
			var resistance = gravitationalForce(lapSlope) + rollingResistance(lapSlope) + airResistance(lapSpeed);
			var power = (resistance * lapSpeed) * (1 + DRIVETRAIN_LOSS);
			
			if(power < 0) { //negative power means "braking", but showing this would only awake confusion
				return 0;
			}
			return Math.round(power).toLong(); //converting to non-decimal value just cuts off at the decimal point, thus rounding first
		}
		
		return "--";
	}
	
	function reset() {
		self.startElevation = self.currentElev;
		self.startDistance = self.currentDist;
		self.startTimer = self.currentTimer;
	}
	
	//-----------------------------------------------------------------------------------------------
	
	function gravitationalForce(slope) {
		var gradientFactor = Math.sin(Math.atan(slope));
		var force = GRAVITATIONAL_CONST * gradientFactor * (WEIGHT_RIDER + WEIGHT_BIKE);
		
		return force;
	}
	
	function rollingResistance(slope) {
		var gradientFactor = Math.cos(Math.atan(slope));
		var force = GRAVITATIONAL_CONST * gradientFactor * (WEIGHT_RIDER + WEIGHT_BIKE) * CRR;
		
		return force;
	}
	
	function airResistance(velocity) {
		var cda = FRONTAL_AREA * DRAG_COEFFICIENT;
		var force = .5 * cda * AIR_DENSITY * Math.pow(velocity, 2);
		
		return force;
	}
	
	
	//-----------------------------------------------------------------------------------------------
	
	public function setStartElevation(elev) {
		self.startElevation = elev;
	}
	
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