// ABZ 2023 - fMVC
// first version of AMAN
// - make use of undef instead of NONE for actions
// - search returns undef when a airplane is not found
// - search is defined with a case instead of a recursive function

asm aman0_undefNoRecSearch

import StandardLibrary
import CTLLibrary
//import LTLLibrary
export *

signature:
	// DOMAINS
	domain TimeSlot subsetof Integer
	domain ZoomValue subsetof Integer
	abstract domain Airplane
	enum domain Status = {UNSTABLE, STABLE, FREEZE}
	enum domain Color = {YELLOW, CYAN, WHITE}
	enum domain PTCOAction = {UP, DOWN, NONE, HOLD}
	
	// FUNCTIONS
	// Landing sequence: it should be bijective partially defined
	controlled landingSequence: TimeSlot -> Airplane
	
	// The status shown on the interface
	controlled statusOutput: Airplane -> Status  
	
	// Interaction with the GUI
	monitored zoom: ZoomValue	
	monitored selectedAirplane : Airplane
	monitored action: PTCOAction
	monitored timeToLock: TimeSlot
	
	controlled blocked: TimeSlot -> Boolean	
	controlled zoomValue : ZoomValue
	controlled landingSequenceColor: TimeSlot -> Color
	
	// NON Recursive function
	static search: Airplane -> TimeSlot
	// Function checking whether an airplane can be moved in the new position
	static canBeMovedUp: Airplane -> Boolean
	static canBeMovedDown: Airplane -> Boolean
	
	static fr1988: Airplane
	static u21748: Airplane
	static fr1989: Airplane
	static u21749: Airplane
	 
definitions:
	
	// DOMAIN DEFINITIONS
	domain TimeSlot = {0 : 10}
	domain ZoomValue = {15 : 45}
	
	// FUNCTION DEFINITIONS
	// The function searches the airplane with the specified landing time
	// return undef if $a is not found in the landing sequence
	function search($a in Airplane) = 
		if landingSequence(0) = $a then 0 else 
		if landingSequence(1) = $a then 1 else 
		if landingSequence(2) = $a then 2 else 
		if landingSequence(3) = $a then 3 else 
		if landingSequence(4) = $a then 4 else 
		if landingSequence(5) = $a then 5 else 
		if landingSequence(6) = $a then 6 else 
		if landingSequence(7) = $a then 7 else 
		if landingSequence(8) = $a then 8 else 
		if landingSequence(9) = $a then 9 else 
		if landingSequence(10) = $a then 10 else 
		undef 
		endif endif endif endif endif endif endif endif endif endif endif
	
	function canBeMovedUp($airplane in Airplane) =
		let ($currentLT = search($airplane)) in
		// if it is not in the sequence, it cannot be moved
//		if $currentLT = undef then false else
		if isUndef($currentLT) then false else
// check that all the four slots up are undef (free)
			if ($currentLT + 1) <= 10 then if not isUndef(landingSequence($currentLT + 1)) then false
			else if ($currentLT + 2) <= 10 then if not isUndef(landingSequence($currentLT + 2)) then false
			else if ($currentLT + 3) <= 10 then if not isUndef(landingSequence($currentLT + 3)) then false
			else if ($currentLT + 4) <= 10 then if not isUndef(landingSequence($currentLT + 4)) then false 
			else true endif endif endif endif endif endif endif endif
		endif endlet 
		
	function canBeMovedDown($airplane in Airplane) =
		let ($currentLT = search($airplane)) in
//			if $currentLT = undef then false else
			if isUndef($currentLT) then false else
			if $currentLT  >= 1 then
			if not isUndef(landingSequence($currentLT - 1)) then false
				else  
					if ($currentLT - 2) >= 0 then 
						if not isUndef(landingSequence($currentLT - 2)) then false
						else 
							if ($currentLT - 3) >= 0 then 
								if not isUndef(landingSequence($currentLT - 3)) then false
								else 
									if ($currentLT - 4) >= 0 then 
										if not isUndef(landingSequence($currentLT - 4)) then false 
										else true endif 
									else true endif 
								endif 
							else true endif 
						endif
					else true endif endif endif 
			endif
		endlet
	

	// RULE DEFINITIONS
	// the PLAN ATCo decides to move up an airplane
	rule r_moveUp($a in Airplane, $manual in Boolean) =
		let ($currentLT = search($a)) in
//		if $currentLT != undef then
		if not isUndef($currentLT) then
		if $currentLT < 10 then
			let ($blk = blocked($currentLT + 1)) in
				if $currentLT < zoomValue and not $blk and canBeMovedUp($a) then 
				par  
					landingSequence($currentLT + 1):= $a
					landingSequence($currentLT):= undef
					landingSequenceColor($currentLT + 1) := landingSequenceColor($currentLT)
					landingSequenceColor($currentLT) := WHITE
				endpar 
				endif 
			endlet
		endif endif endlet 
			
	// the PLAN ATCo decides to move down an airplane
	rule r_moveDown($a in Airplane, $manual in Boolean) =
		let ($currentLT = search($a)) in
// TODO smv wants the function and not the comparison with undef
//		if $currentLT != undef then  
//		if isDef($currentLT) then
		if not isUndef($currentLT) then
			let ($blk = blocked($currentLT - 1)) in
			// The function is called by AMAN -> It is ok to execute without checking anything
			if ($currentLT <= 0 and not $manual) then
				par
					landingSequence($currentLT):= undef
					landingSequenceColor($currentLT) := WHITE
				endpar
			else
				if ($currentLT-1) >= 0 and not $blk and not $manual then
				par
					landingSequence($currentLT - 1):= $a
					landingSequence($currentLT):= undef
					landingSequenceColor($currentLT - 1) := landingSequenceColor($currentLT)
					landingSequenceColor($currentLT) := WHITE
				endpar				
				else if $currentLT > 0 and not $blk and canBeMovedDown($a) then 
				par  
					landingSequence($currentLT - 1):= $a
					landingSequence($currentLT):= undef
					landingSequenceColor($currentLT - 1) := landingSequenceColor($currentLT)
					landingSequenceColor($currentLT) := WHITE
				endpar endif endif endif endlet endif endlet
						
	// the PLAN ATCo decides to put an airplane on hold -> The airplane has to be removed 
	// from the landing sequence and the color of the corresponding cell is set to white
	rule r_hold($a in Airplane) = 
		let ($currentLT = search($a)) in
//		if $currentLT != undef then
		if not isUndef($currentLT) then
			par
				landingSequence($currentLT) := undef
				landingSequenceColor($currentLT) := WHITE
			endpar
			endif endlet
		
	// Update the zoom value shown on the GUI
	rule r_update_zoom = 
		if zoom < 15 then zoomValue := 15
		else if zoom > 45 then zoomValue := 45
		else if mod(zoom, 5) = 0 then 
		zoomValue := zoom endif endif endif
		
	// Update the locks depending on user input
	rule r_update_lock =
		if not isUndef(timeToLock) then
			if isUndef(landingSequence(timeToLock)) then blocked(timeToLock) := not (blocked(timeToLock)) endif endif
			     
	// INVARIANTS AND PROPERTIES
//	// REQ16: The zoom value cannot be bigger than 45 and smaller than 15
//	LTLSPEC g(zoomValue >= 15 and zoomValue<=45)
//	// REQ19: The value displayed next to the zoom slider must belong to the list of seven acceptable values for the zoom 
//	LTLSPEC g(zoomValue = 15 or zoomValue = 20 or zoomValue = 25 or zoomValue = 30 or zoomValue = 35 or zoomValue = 40 or zoomValue = 45)  
//	// REQ5: Aircraft labels should not overlap
//	LTLSPEC (forall $t1 in Airplane, $t2 in Airplane with g(($t1 != $t2 and search($t1, 0) != -1 and search($t2, 0) != -1 and not isUndef(search($t1, 0)) and not isUndef(search($t2, 0))) implies ((search($t1, 0)-search($t2, 0)>=3) or (search($t1, 0)-search($t2, 0)<=-3))))
//	// REQ6: An aircraft label cannot be moved into a blocked time period;
//	LTLSPEC (forall $a in Airplane, $t in TimeSlot with g(search($a, 0) = $t implies not blocked($t)))
//	// REQ15: The HOLD button must be available only when one aircraft label is selected
//	LTLSPEC (forall $a in Airplane, $t in TimeSlot with g(search($a, 0) = $t and isUndef(selectedAirplane) and action = HOLD implies x(search($a, 0) = $t)))
//	// REQ3: Planes can be moved earlier or later on the timeline
//	LTLSPEC (forall $a in Airplane, $t in TimeSlot with g(search($a) = $t and selectedAirplane=$a and action = UP and canBeMovedUp($a) implies x(search($a) = $t + 1)))
//	LTLSPEC (forall $a in Airplane, $t in TimeSlot with g(search($a, 0) = $t and selectedAirplane=$a and action = DOWN and canBeMovedDown($a) implies x(search($a, 0) = ($t - 1))))
	// REQ4: Planes can be put on hold by the PLAN ATCo
//	LTLSPEC (forall $a in Airplane, $t in TimeSlot with g(search($a, 0) = $t and selectedAirplane=$a and action = HOLD implies x(isUndef(landingSequence($t)))))	

	// MAIN RULE
	main rule r_Main =
		par		
			// Update GUI
			if action = NONE then r_update_lock[] endif
			r_update_zoom[]
			
			// Move airplanes
			// why not forall airplane in with selected do ....
			if selectedAirplane = fr1988 then
				if action = UP then r_moveUp[fr1988, true] else
				if action = DOWN then r_moveDown[fr1988, true] else
				if action = HOLD then r_hold[fr1988] endif endif endif 
			endif
			if selectedAirplane = u21748 then
				if action = UP then r_moveUp[u21748, true] else
				if action = DOWN then r_moveDown[u21748, true] else
				if action = HOLD then r_hold[u21748] endif endif endif 
			endif
			if selectedAirplane = fr1989 then
				if action = UP then r_moveUp[fr1989, true] else
				if action = DOWN then r_moveDown[fr1989, true] else
				if action = HOLD then r_hold[fr1989] endif endif endif 
			endif
			if selectedAirplane = u21749 then
				if action = UP then r_moveUp[u21749, true] else
				if action = DOWN then r_moveDown[u21749, true] else
				if action = HOLD then r_hold[u21749] endif endif endif 
			endif
		endpar

// INITIAL STATE
default init s0:
	function landingSequence($t in TimeSlot) = if $t = 5 then fr1988 else
										   	   if $t = 2 then u21748 else 
										   	   undef endif endif
	function zoomValue = 30
	function action = NONE
	function selectedAirplane = undef
	function statusOutput($t in Airplane) = if $t = fr1988 then UNSTABLE else if $t = u21748 then FREEZE else STABLE endif endif	
	function landingSequenceColor($t in TimeSlot) = if $t = 5 then YELLOW else
												if $t = 2 then CYAN else
												WHITE
												endif endif
	function blocked($t in TimeSlot) = if $t = 6 then true else false endif
	
