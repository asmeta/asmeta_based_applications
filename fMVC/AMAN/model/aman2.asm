// ABZ 2023 - fMVC

asm aman2

import StandardLibrary
import CTLLibrary
import TimeLibrary
//import aman1_wom
import aman1

signature:
	// DOMAINS
	domain Minutes subsetof Integer
	domain Hours subsetof Integer

	// FUNCTIONS
	derived currentTimeMins: Integer
	derived currentTimeHours: Integer
	derived zoomChanged: Boolean
	
	controlled timeShown: TimeSlot -> Minutes
	controlled lastTimeUpdated : Minutes
	controlled mins : Minutes
	controlled hours : Hours
	
definitions:
	
	// DOMAIN DEFINITIONS
	domain Hours = {0 : 23}
	domain Minutes = {0 : 59}
	
	// FUNCTION DEFINITIONS		
	// Minutes
	function currentTimeMins =
		// note: the division of integers restun a real in asmeta
		rtoi(mCurrTimeSecs / 60) mod 60
		// x integer division idiv(mCurrTimeSecs idiv 60) mod 60
		
	// Hours
	function currentTimeHours = 
		rtoi(mCurrTimeSecs / 3600) mod 24
		
	// Zoom changed (true or undef like the other actions)
	function zoomChanged =
		if zoom != zoomValue then true else undef endif
	
	// Update the current time
	rule r_update_time = 
		par
			mins := currentTimeMins
			hours := currentTimeHours
		endpar
		
	// Update the times shown in the timeline
	rule r_update_time_shown =
		par
			forall $t in TimeSlot do
				timeShown($t) := mod(currentTimeMins + $t + 1, 60)
			// If times have been shifted, shift all the airplanes too
			if lastTimeUpdated != currentTimeMins then
				par
					lastTimeUpdated := currentTimeMins
					forall $a in Airplane do r_moveDown[$a, false, 1]
					forall $time in TimeSlot with $time > 0 do blocked($time - 1) := blocked($time) 
				endpar
			endif
		endpar
		
	// INVARIANTS
	invariant inv_action over timeToLock, zoomChanged, action: 
		(timeToLock != undef implies (zoomChanged=undef and action=undef)) and 
		(zoomChanged != undef implies (timeToLock=undef and action=undef)) and 
		(action != undef implies (timeToLock=undef and zoomChanged=undef)) 
	
	
	// MAIN RULE
	main rule r_Main =
		par		
			// Update GUI
			if not isUndef(timeToLock) then r_update_lock[] endif
			if not isUndef(zoom) then r_update_zoom[] endif
			r_update_time[]
			r_update_time_shown[]
			
			// Move airplanes
			//if toString(selectedAirplane) != "undef" then
			if selectedAirplane != undef then
				if action = UP then r_moveUp[selectedAirplane, true, numMoves] else
				if action = DOWN then r_moveDown[selectedAirplane, true, numMoves] else
				if action = HOLD then r_hold[selectedAirplane] endif endif endif 
			endif
		endpar

// INITIAL STATE
default init s0:
	function landingSequence($t in TimeSlot) = if $t = 5 then fr1988 else
										   if $t = 2 then u21748 else
										   if $t = 18 then fr1989 else
										   if $t = 35 then u21749 else
										   undef endif endif endif endif
	function zoomValue = 30
	function action = undef
	function selectedAirplane = undef
	function timeShown($t in TimeSlot) = ($t + 1)
	function lastTimeUpdated = currentTimeMins
	function statusOutput($t in Airplane) = if $t = fr1988 then UNSTABLE else if $t = u21748 then FREEZE else STABLE endif endif	
	function landingSequenceColor($t in TimeSlot) = if $t = 5 then YELLOW else
												if $t = 2 then CYAN else
												WHITE
												endif endif
		// The following definition should be used
		//color(statusOutput(landingSequence($t)))
	function blocked($t in TimeSlot) = if $t = 6 then true else false endif
	function mins = 0
	function hours = 0
	
